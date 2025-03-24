import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:posyandu_mob/core/models/Anggota.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String userKey = "user";
  static const String tokenKey = "token";
  final String baseUrl = "http://127.0.0.1:8000/api";

  // Method untuk login
  Future<dynamic> login(String email, String password) async {
    final url = Uri.parse("$baseUrl/login");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['success']) {
        String role =
            data['user']['role']; // Assuming the API returns a 'role' field

        dynamic user;
        if (role == "admin") {
          // user = Admin.fromJson(data['user']);
        } else if (role == "petugas") {
          //handle petugas
        } else if (role == "kader") {
          //handle kader
        } else {
          user = Anggota.fromJson(data['user']);
        }

        await _saveUser(user);
        await _saveToken(data['token']);

        return user; // Return the appropriate user object
      }
    }
    return null;
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

  // Simpan user data
  Future<void> _saveUser(Anggota user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
        userKey,
        jsonEncode({
          "id": user.id,
          "name": user.nama,
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
