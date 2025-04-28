import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:posyandu_mob/core/database/UserDatabase.dart';
import 'package:posyandu_mob/core/models/Anggota.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilService {
  static const String userKey = "user";
  static const String tokenKey = "token";
  final _db = UserDatabase.instance;
  final Dio _dio = Dio(BaseOptions(
    baseUrl: "http://10.0.2.2:8000/api",
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
    },
  ));

  Future<dynamic> getAnggota() async {
    try {
      int? id = await getID();
      String? token = await _getToken();
      if (token == null || id == null) {
        print("Token atau ID kosong");
        return null;
      }

      final response = await _dio.get(
        "/user/$id",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      final responseData = response.data;
      final userData = responseData['user'];

      if (responseData['role'] == 'anggota') {
        return Anggota.fromJson(userData);
      } else {
        // return Petugas.fromJson(userData);
        return null;
      }
    } catch (e) {
      print("Error getAnggota: $e");
      return null;
    }
  }

  Future<Response> updateAnggota(Anggota anggota) async {
    try {
      final token = await _getToken();

      if (token == null) {
        return Response(
            requestOptions: RequestOptions(path: ' '),
            statusCode: 500,
            statusMessage: "error saat mendapatkan token");
      }

      int localUpdateResult = await _db.update(anggota);
      if (localUpdateResult == 0) {
        return Response(
          requestOptions: RequestOptions(path: ' '),
          statusCode: 400,
          statusMessage: "Gagal memperbarui data lokal.",
        );
      }

      final response = await _dio.put(
        "/profile/update",
        data: anggota.toJson(),
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        return response;
      }
    } on DioException catch (e) {
      return Response(
        requestOptions: RequestOptions(path: ' '),
        statusCode: 202,
        statusMessage: "Gagal Mengupdate: ${e.message}",
      );
    }
  }

  Future<int?> getID() async {
    // final prefs = await SharedPreferences.getInstance();
    // String? userData = prefs.getString(userKey);

    final db = await UserDatabase.instance;
    dynamic userData = await db.readUser();

    if (userData != null) {
      return userData.anggota.id;
    }
    return null;
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }
}
