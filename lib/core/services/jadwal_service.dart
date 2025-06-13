import 'package:posyandu_mob/core/Api/ApiClient.dart';
import 'package:posyandu_mob/core/models/Jadwal.dart';

class JadwalService {
  final _api = ApiClient();

  Future<List<Jadwal>> fetchJadwal(String id) async {
    try {
      await _api.setToken();
      final response = await _api.dio.get('/jadwal_FD/$id');

      if (response.statusCode == 200) {
        final body = response.data;
        if (body['success'] && body['data'] != null) {
          if (body['data'] is List) {
            final List<dynamic> data = body['data'];
            return data.map((json) => Jadwal.fromJson(json)).toList();
          } else if (body['data'] is Map<String, dynamic>) {
            return [Jadwal.fromJson(body['data'])];
          }
        }
      }

      return [];
    } catch (e) {
      print('Error fetching jadwal data: $e');
      rethrow;
    }
  }
}