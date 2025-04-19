import 'dart:convert';
import 'package:dio/dio.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:posyandu_mob/core/models/Anggota.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String userKey = "user";
  static const String tokenKey = "token";
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final Dio _dio = Dio(BaseOptions(
    baseUrl: "http://127.0.0.1:8000/api",
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {"Content-Type": "application/json"},
  ));

  Future<void> sendOtp({
    required String phoneNumber,
    required void Function(PhoneAuthCredential) onVerificationCompleted,
    required void Function(FirebaseAuthException) onVerificationFailed,
    required void Function(String, int?) onCodeSent,
    required void Function(String) onCodeAutoRetrievalTimeout,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(minutes: 3),
      verificationCompleted: onVerificationCompleted,
      verificationFailed: onVerificationFailed,
      codeSent: onCodeSent,
      codeAutoRetrievalTimeout: onCodeAutoRetrievalTimeout,
    );
  }

  Future<dynamic> login(String identifier, String password) async {
    try {
      final response = await _dio.post(
        "/login",
        data: {
          "identifier": identifier,
          "password": password,
        },
      );

      final data = response.data;

      if (data['success'] &&
          data.containsKey('user') &&
          data.containsKey('role') &&
          data.containsKey('token')) {
        String role = data['role'];

        dynamic user;
        if (role == "petugas") {
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

      return null;
    } on DioException catch (e) {
      if (e.response != null) {
        print("Dio error [${e.response?.statusCode}]: ${e.response?.data}");
      } else {
        print("Dio error: ${e.message}");
      }
      return null;
    }
  }

  Future<Response?> logoutUser() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      if (token == null) {
        return Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 500,
          statusMessage: 'Token tidak di temukan',
        );
      }

      _dio.options.headers = {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      };

      final response = await _dio.post('/logout');

      await prefs.remove('token');
      await prefs.remove('user');

      return response;
    } on DioException catch (e) {
      return Response(
        requestOptions: RequestOptions(path: ''),
        statusCode: 500,
        statusMessage:
            'Terjadi kesalahan saat logout: ${e.response?.data ?? e.message}',
      );
    }
  }

  Future<Response?> changePassword(String phone, String password) async {
    try {
      final response = await _dio.post(
        "/lupa-password",
        data: {
          "phone": phone,
          "password": password,
        },
      );

      return response;
    } on DioException catch (e) {
      return Response(
        requestOptions: RequestOptions(path: ''),
        statusCode: 500,
        statusMessage:
            'Terjadi kesalahan saat logout: ${e.response?.data ?? e.message}',
      );
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
      }),
    );
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
}
