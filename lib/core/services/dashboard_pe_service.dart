import 'package:posyandu_mob/core/Api/ApiClient.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/PemeriksaanKehamilan.dart';
import 'package:posyandu_mob/core/models/GrafikPengunjung.dart';

class DashboardService {
  final _api = ApiClient();

  Future<GrafikPemeriksaan?> fetchGrafik() async {
    final response = await _api.dio.get('/dashboard/grafik');
    if (response.statusCode == 200) {
      return GrafikPemeriksaan.fromJson(response.data);
    }
    return null;
  }

  Future<List<PemeriksaanKehamilan>> fetchRiwayat({
    required Map<int, String> namaIbuMap,
    required Map<int, String> waktuMap,
  }) async {
    final response = await _api.dio.get('/dashboard/riwayat');
    if (response.statusCode == 200 && response.data['data'] != null) {
      final List<dynamic> data = response.data['data'];
      for (var item in data) {
        if (item['id'] != null) {
          final id = item['id'];
          if (item['nama_ibu'] != null) namaIbuMap[id] = item['nama_ibu'];
          if (item['waktu'] != null) waktuMap[id] = item['waktu'];
        }
      }
      return data.map((json) => PemeriksaanKehamilan.fromJson(json)).toList();
    }
    return [];
  }
}
