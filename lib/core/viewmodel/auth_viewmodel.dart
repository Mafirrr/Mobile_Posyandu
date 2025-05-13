import 'package:flutter/material.dart';
import 'package:posyandu_mob/core/database/UserDatabase.dart';
import 'package:posyandu_mob/core/services/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  dynamic _user;

  bool get isLoading => _isLoading;
  dynamic get user => _user;
  bool get isLoggedIn => _user != null;

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

  Future<bool> logout(BuildContext context) async {
    _setLoading(true);
    final db = UserDatabase.instance;
    final response = await _authService.logoutUser();

    await db.logout();
    _user = null;

    if (response != null && response.statusCode == 200) {
      _setLoading(false);
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              response?.data.toString() ?? 'Logout failed. Please try again.'),
          duration: const Duration(seconds: 10),
        ),
      );
      _setLoading(false);
      return false;
    }
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
