import 'package:dio/dio.dart';
import 'package:posyandu_mob/core/Api/ApiClient.dart';
import 'package:posyandu_mob/core/models/GrafikBB.dart';

class GrafikService {
  final ApiClient _apiClient = ApiClient();

  Future<List<Grafik>> getBeratBadanById(String id) async {
    try {
      await _apiClient.setToken();
      final response = await _apiClient.dio.get('/getbb/$id');

      // API mengembalikan object tunggal, bukan array
      // Jadi kita wrap dalam List
      final Map<String, dynamic> data = response.data;
      final Grafik grafik = Grafik.fromJson(data);

      return [grafik];
    } catch (e) {
      print('Error fetching grafik data: $e');
      rethrow;
    }
  }
}