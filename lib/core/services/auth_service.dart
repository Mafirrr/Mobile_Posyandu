import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:posyandu_mob/core/Api/ApiClient.dart';
import 'package:posyandu_mob/core/database/UserDatabase.dart';
import 'package:posyandu_mob/core/models/Anggota.dart';

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

        user = Anggota.fromJson(data['user']);

        if (user != null) {
          await _saveUser(user, role, token);
          String? fcmToken = await FirebaseMessaging.instance.getToken();
          if (fcmToken != null) {
            await updateFcmToken(fcmToken, token);
          }

          return user;
        }
      }

      return null;
    } on DioException catch (e) {
      throw Exception("Dio error: ${e.response?.data ?? e.message}");
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

  Future<Response?> changePassword(String identifier) async {
    try {
      _api.setToken();
      final response = await _api.dio.post(
        "/lupa-password",
        data: {
          "identifier": identifier,
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

      if (response.statusCode != 200) {
        throw ("Gagal update FCM token: ${response.data}");
      }
    } catch (e) {
      throw ("Error saat update FCM token: $e");
    }
  }

  Future<Response> sendOtpToEmail(String email) async {
    try {
      _api.setToken();
      final response = await _api.dio.post(
        "/send-otp",
        data: {
          "email": email,
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

  Future<Response> verifyOtp(String identifer, String otp, int id) async {
    try {
      _api.setToken();

      final response = await _api.dio.post(
        "/verify-otp",
        data: {
          "otp": otp,
          "user_id": id,
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

  Future<Response> resetPass({
    required String identifier,
    required String password,
    String? otp,
  }) async {
    try {
      _api.setToken();
      final response = await _api.dio.post(
        "/resetPass",
        data: {
          "identifier": identifier,
          "otp": otp,
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
}
