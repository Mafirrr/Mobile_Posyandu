import 'package:dio/dio.dart';
import 'package:posyandu_mob/core/Api/ApiClient.dart';

class AnggotaService {
  final ApiClient _apiClient = ApiClient();

  Future<List<dynamic>> getAll() async {
    await _apiClient.setToken();
    final response = await _apiClient.dio.get('/anggota');
    return response.data;
  }

  Future<dynamic> getById(String id) async {
    await _apiClient.setToken();
    final response = await _apiClient.dio.get('/anggota/$id');
    return response.data;
  }

  Future<Map<String, dynamic>> create(Map<String, dynamic> data) async {
    await _apiClient.setToken();

    try {
      final response = await _apiClient.dio.post('/anggota', data: data);

      if (response.statusCode == 201) {
        return response.data; // kembalikan data anggota dari server
      } else {
        throw Exception('Gagal membuat anggota');
      }
    } on DioException catch (e) {
      print("Error response: ${e.response?.data}");
      rethrow;
    }
  }

  Future<dynamic> update(String id, Map<String, dynamic> data) async {
    await _apiClient.setToken();
    final response = await _apiClient.dio.put('/anggota/$id', data: data);
    return response.data;
  }

  Future<void> delete(String id) async {
    await _apiClient.setToken();
    await _apiClient.dio.delete('/anggota/$id');
  }
}
