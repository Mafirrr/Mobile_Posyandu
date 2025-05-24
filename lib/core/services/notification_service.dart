import 'package:dio/dio.dart';
import 'package:posyandu_mob/core/Api/ApiClient.dart';
import 'package:posyandu_mob/core/database/UserDatabase.dart';
import 'package:posyandu_mob/core/models/Jadwal.dart';

class NotificationService {
  final _db = UserDatabase();
  final _api = ApiClient();

  Future<bool> checkKehamilanStatus() async {
    try {
      int? id = await getID();
      if (id == null) return false;

      await _api.setToken();
      final response = await _api.dio.get("/jadwal/check/$id");

      if (response.statusCode == 200) {
        final data = response.data;
        return data['status'] == 'dalam_pemantauan';
      }
      return false;
    } on DioException catch (e) {
      print('Error checking kehamilan status: $e');
      return false;
    }
  }

  Future<List<Jadwal>> getJadwalNotifications() async {
    try {
      int? id = await getID();
      await _api.setToken();
      final response = await _api.dio.get("/jadwalnotif/$id");

      if (response.statusCode == 200) {
        final responseData = response.data;
        final List<dynamic> data     = responseData['data'] ?? responseData;
        return data.map((json) => Jadwal.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      print('Error fetching notifications: $e');
      return [];
    }
  }

  Future<int?> getID() async {
    dynamic userData = await _db.readUser();
    if (userData != null) {
      return userData.anggota.id;
    }
    return null;
  }
}