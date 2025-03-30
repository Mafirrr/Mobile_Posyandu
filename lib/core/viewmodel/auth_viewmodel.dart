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

  AuthViewModel() {
    loadUser();
  }

  Future<void> loadUser() async {
    _isLoading = true;
    notifyListeners();

    _user = await _getUser();

    if (_user == null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AuthService.userKey);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<dynamic> _getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final String? userData = prefs.getString(AuthService.userKey);

    if (userData != null) {
      final Map<String, dynamic> userMap = jsonDecode(userData);
      return userMap;
    }
    return null;
  }

  Future<bool> login(String nik, String password) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    dynamic user = await _authService.login(nik, password);
    _isLoading = false;

    if (user != null) {
      _user = user;
      notifyListeners();
      return true;
    }
    notifyListeners();
    return false;
  }

  Future<void> logout() async {
    await _authService.logout();
    notifyListeners();
  }
}
