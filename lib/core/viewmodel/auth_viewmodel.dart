import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:posyandu_mob/core/models/Anggota.dart';
import 'package:posyandu_mob/core/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  dynamic _user; // Can store Admin, Petugas, Kader, or Anggota

  bool get isLoading => _isLoading;
  dynamic get user => _user;

  // Load user on app start
  Future<void> loadUser() async {
    _isLoading = true;
    notifyListeners();

    _user = await _getUser();
    _isLoading = false;
    notifyListeners();
  }

  Future<dynamic?> _getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final String? userData = prefs.getString(AuthService.userKey);

    if (userData != null) {
      final Map<String, dynamic> userMap = jsonDecode(userData);
      String role = userMap["role"];

      if (role == "admin") {
        // return Admin.fromJson(userMap);
      } else if (role == "petugas" || role == "kader") {
        // return Petugas.fromJson(userMap);
      } else {
        return Anggota.fromJson(userMap);
      }
    }
    return null;
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    dynamic user = await _authService.login(email, password);
    if (user != null) {
      _user = user;
      notifyListeners();
      return true;
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    notifyListeners();
  }
}
