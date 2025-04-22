import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:posyandu_mob/core/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  dynamic _user;

  bool get isLoading => _isLoading;
  dynamic get user => _user;
  bool get isLoggedIn => _user != null;

  AuthViewModel() {
    loadUser();
  }

  Future<void> loadUser() async {
    _setLoading(true);

    final prefs = await SharedPreferences.getInstance();
    final String? userData = prefs.getString(AuthService.userKey);

    if (userData != null) {
      try {
        _user = jsonDecode(userData);
      } catch (e) {
        print("Gagal decode user data: $e");
        _user = null;
        await prefs.remove(AuthService.userKey);
      }
    } else {
      _user = null;
    }

    _setLoading(false);
  }

  Future<bool> login(String nik, String password) async {
    _setLoading(true);

    final user = await _authService.login(nik, password);
    _setLoading(false);

    if (user != null) {
      _user = user;
      notifyListeners();
      return true;
    }

    return false;
  }

  Future<void> logout(BuildContext context) async {
    _setLoading(true);

    final response = await _authService.logoutUser();

    if (response != null && response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AuthService.userKey);
      await prefs.remove(AuthService.tokenKey);
      _user = null;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response?.data ?? 'Logout failed. Please try again.'),
          duration: const Duration(seconds: 10),
        ),
      );
    }

    _setLoading(false);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<bool> changePassword(String phone, String password) async {
    _setLoading(true);

    final response = await _authService.changePassword(phone, password);

    _setLoading(false);

    if (response != null && response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
