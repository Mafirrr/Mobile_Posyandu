import 'package:posyandu_mob/core/models/Jadwal.dart';
import 'package:posyandu_mob/core/Api/ApiClient.dart';

class JadwalkaderService {
  final _api = ApiClient();

  Future<List<Jadwal>> getAllJadwal() async {
    await _api.setToken();
    final response = await _api.dio.get('/jadwal');
    if (response.statusCode == 200) {
      final List data = response.data;
      return data.map((e) => Jadwal.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat jadwal dari server');
    }
  }

  Future<Jadwal> createJadwal(Jadwal jadwal) async {
    await _api.setToken();
    final response = await _api.dio.post(
      '/jadwal',
      data: jadwal.toJson(),
    );
    return Jadwal.fromJson(response.data);
  }

  Future<Jadwal> updateJadwal(Jadwal jadwal) async {
    await _api.setToken();
    final response = await _api.dio.put(
      '/jadwal/${jadwal.id}',
      data: jadwal.toJson(),
    );
    return Jadwal.fromJson(response.data);
  }

  Future<void> deleteJadwal(int id) async {
    await _api.dio.delete('/jadwal/$id');
  }
}
