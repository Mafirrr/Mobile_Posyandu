import 'package:dio/dio.dart';
import 'package:posyandu_mob/core/Api/ApiClient.dart';

class Petugasservice {
  final ApiClient _apiClient = ApiClient();

  Future<List<dynamic>> getAll() async {
    await _apiClient.setToken();
    final response = await _apiClient.dio.get('/petugas');
    return response.data;
  }

  Future<dynamic> getById(String id) async {
    await _apiClient.setToken();
    final response = await _apiClient.dio.get('/petugas/$id');
    return response.data;
  }

  Future<Map<String, dynamic>> create(Map<String, dynamic> data) async {
    await _apiClient.setToken();

    try {
      final response = await _apiClient.dio.post('/petugas', data: data);

      if (response.statusCode == 201) {
        return response.data; // kembalikan data anggota dari server
      } else {
        throw Exception('Gagal membuat petugas');
      }
    } on DioException catch (e) {
      print("Error response: ${e.response?.data}");
      rethrow; // lempar ulang error agar bisa ditangani di atasnya
    }
  }

  Future<dynamic> update(String id, Map<String, dynamic> data) async {
    await _apiClient.setToken();
    final response = await _apiClient.dio.put('/petugas/$id', data: data);
    return response.data;
  }

  Future<void> delete(String id) async {
    await _apiClient.setToken();
    await _apiClient.dio.delete('/petugas/$id');
  }
}
