import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
        if (role == "petugas") {
          return null;
        } else {
          user = Anggota.fromJson(data['user']);
        }

        if (user != null) {
          await _saveUser(user, role, token);
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
    await UserDatabase.instance.create(user, role, token);
  }
}
