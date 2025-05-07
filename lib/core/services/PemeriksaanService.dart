import 'package:posyandu_mob/core/Api/ApiClient.dart';
import 'package:posyandu_mob/core/database/UserDatabase.dart';

class PemeriksaanService {
  final _api = ApiClient();

  Future<List<Map<String, dynamic>>> dataKehamilan() async {
    try {
      _api.clearToken();
      int? id = await getID();
      final response = await _api.dio.get('/kehamilan/$id');

      if (response.statusCode == 200) {
        var data = response.data;
        if (data['status'] == 'success') {
          return List<Map<String, dynamic>>.from(data['data']);
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

  Future<int?> getID() async {
    final db = await UserDatabase.instance;
    dynamic userData = await db.readUser();

    if (userData != null) {
      return userData.anggota.id;
    }
    return null;
  }
}
