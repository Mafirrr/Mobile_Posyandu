import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:posyandu_mob/core/models/Anggota.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String userKey = "user";
  static const String tokenKey = "token";
  final String baseUrl = "http://127.0.0.1:8000/api";

  // Method untuk login
  Future<dynamic> login(String identifier, String password) async {
    try {
      final url = Uri.parse("$baseUrl/login");
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"identifier": identifier, "password": password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] &&
            data.containsKey('user') &&
            data.containsKey('role') &&
            data.containsKey('token')) {
          String role = data['role'];

          dynamic user;
          if (role == "petugas") {
            // user = Petugas.fromJson(data['user']); // Implementasi jika ada model Petugas
            return null;
          } else {
            user = Anggota.fromJson(data['user']);
          }

          if (user != null) {
            await _saveUser(user, role);
            await _saveToken(data['token']);
            return user;
          }
        }
      }

      return null;
    } catch (e) {
      print("Login error: $e");
      return null;
    }
  }

  // Method untuk logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      String? token = await _getToken();
      final response = await http.get(
        Uri.parse("$baseUrl/logout"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        await prefs.remove(userKey);
        await prefs.remove(tokenKey);
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  Future<void> _saveUser(Anggota user, String role) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
        userKey,
        jsonEncode({
          "id": user.id,
          "name": user.nama,
          "role": role,
        }));
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(tokenKey, token);
  }

  Future<Anggota?> getAnggota() async {
    final prefs = await SharedPreferences.getInstance();
    String? userData = prefs.getString(userKey);

    if (userData != null) {
      return Anggota.fromJson(jsonDecode(userData));
    }
    return null;
  }

  _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AuthService.tokenKey);
  }
}
