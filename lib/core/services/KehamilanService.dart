import 'package:posyandu_mob/core/Api/ApiClient.dart';
import 'package:posyandu_mob/core/database/PemeriksaanDatabase.dart';
import 'package:posyandu_mob/core/database/UserDatabase.dart';
import 'package:posyandu_mob/core/models/Kehamilan.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/Pemeriksaan.dart';

class KehamilanService {
  final _api = ApiClient();

  Future<List<Kehamilan>> dataKehamilan() async {
    try {
      _api.setToken();
      int? id = await getID();
      final response = await _api.dio.get('/kehamilan/$id');

      if (response.statusCode == 200) {
        var data = response.data;
        if (data['status'] == 'success') {
          List<dynamic> kehamilanJsonList = data['data'];
          List<Kehamilan> kehamilanList = kehamilanJsonList
              .map((json) => Kehamilan.fromJson(json))
              .toList();

          await _saveData(kehamilanList);

          for (var kehamilan in kehamilanList) {
            await _fetchAndSavePemeriksaan(kehamilan.id, id!);
          }

          return kehamilanList;
        } else {
          throw Exception('Error: ${data['message']}');
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> _saveData(List<Kehamilan> dataList) async {
    for (var kehamilan in dataList) {
      await UserDatabase().insertKehamilan(kehamilan);
    }
  }

  Future<void> _fetchAndSavePemeriksaan(int kehamilanId, int id) async {
    try {
      _api.setToken();
      final response = await _api.dio.get('/kehamilan/$id', queryParameters: {
        'detail': kehamilanId,
      });

      if (response.statusCode == 200) {
        var data = response.data;
        if (data['status'] == 'success') {
          final pemeriksaanData = Pemeriksaan.fromJson(data['data']);

          await Pemeriksaandatabase().insertPemeriksaan(pemeriksaanData);
        }
      }
    } catch (e, stackTrace) {
      print(
          'Gagal ambil/simpan pemeriksaan untuk kehamilanId $kehamilanId: $e');
      print('StackTrace:\n$stackTrace');
    }
  }

  Future<int?> getID() async {
    final db = await UserDatabase();
    dynamic userData = await db.readUser();

    if (userData != null) {
      return userData.anggota.id;
    }
    return null;
  }
}
