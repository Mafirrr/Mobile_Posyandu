import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:posyandu_mob/core/models/Anggota.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilService {
  static const String userKey = "user";
  static const String tokenKey = "token";
  final String baseUrl = "http://127.0.0.1:8000/api";

  Future<dynamic> getAnggota() async {
    try {
      int? id = await getID();
      String? token = await _getToken();
      if (token == null) {
        print("ID kosong");
        return null;
      }
      final response = await http.get(
        Uri.parse("$baseUrl/user/$id"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final userData = responseData['user'];

        if (responseData['role'] == 'anggota') {
          return Anggota.fromJson(userData);
        } else {
          // return Petugas.fromJson(responseData['user']);
        }
      }

      return print("gagal dapat");
    } catch (e) {
      print("Error getAnggota: $e");
      return null;
    }
  }

  Future<bool> updateAnggota(Anggota anggota) async {
    final token = await _getToken(); // ambil token dari SharedPreferences
    final response = await http.put(
      Uri.parse('$baseUrl/profile/update'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(anggota.toJson()),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print("Gagal update profil: ${response.body}");
      return false;
    }
  }

  Future<int?> getID() async {
    final prefs = await SharedPreferences.getInstance();
    String? userData = prefs.getString(userKey);

    if (userData != null) {
      final Map<String, dynamic> userMap = jsonDecode(userData);
      return userMap['id'] ?? null;
    }
    return null;
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(ProfilService.tokenKey);
  }
}
