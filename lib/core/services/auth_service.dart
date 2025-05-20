import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:posyandu_mob/core/Api/ApiClient.dart';
import 'package:posyandu_mob/core/database/UserDatabase.dart';
import 'package:posyandu_mob/core/models/Anggota.dart';
import 'package:posyandu_mob/core/models/Petugas.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _api = ApiClient();

  Future<void> sendOtp({
    required String phoneNumber,
    required void Function(PhoneAuthCredential) onVerificationCompleted,
    required void Function(FirebaseAuthException) onVerificationFailed,
    required void Function(String, int?) onCodeSent,
    required void Function(String) onCodeAutoRetrievalTimeout,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 120),
      verificationCompleted: onVerificationCompleted,
      verificationFailed: onVerificationFailed,
      codeSent: onCodeSent,
      codeAutoRetrievalTimeout: onCodeAutoRetrievalTimeout,
    );
  }

  Future<dynamic> login(String identifier, String password) async {
    try {
      _api.clearToken();
      final response = await _api.dio.post(
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
        String token = data['token'];

        dynamic user;
        if (role == "petugas") {
          user = Petugas.fromJson(data['user']);
        } else {
          user = Anggota.fromJson(data['user']);
        }

        if (user != null) {
          if (role == "petugas") {
            await _savePetugas(user, role, token);
          } else {
            await _saveUser(user, role, token);
          }
          // Ambil FCM Token
          String? fcmToken = await FirebaseMessaging.instance.getToken();
          if (fcmToken != null) {
            await updateFcmToken(fcmToken, token);
          }

          return user;
        }
      }

      return null;
    } on DioException catch (e) {
      print("Dio error: ${e.response?.data ?? e.message}");
      return null;
    }
  }

  Future<Response?> logoutUser() async {
    try {
      await _api.setToken();
      final response = await _api.dio.get('/logout');
      return response;
    } on DioException catch (e) {
      return Response(
        requestOptions: RequestOptions(path: ''),
        statusCode: 500,
        statusMessage: 'Terjadi kesalahan saat logout: ${e.response}',
      );
    }
  }

  Future<Response?> changePassword(String phone, String password) async {
    try {
      final response = await _api.dio.post(
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

  Future<void> _saveUser(Anggota user, String role, String token) async {
    await UserDatabase().create(user, role, token);
  }

  Future<void> _savePetugas(Petugas user, String role, String token) async {
    await UserDatabase().createPetugas(user, role, token);
  }

  Future<void> updateFcmToken(String fcmToken, String authToken) async {
    try {
      final response = await _api.dio.post(
        "/update_fcm_token",
        data: {"fcm_token": fcmToken},
        options: Options(headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        }),
      );

      if (response.statusCode == 200) {
        print("FCM token berhasil diupdate");
      } else {
        print("Gagal update FCM token: ${response.data}");
      }
    } catch (e) {
      print("Error saat update FCM token: $e");
    }
  }
}
