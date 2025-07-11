import 'package:dio/dio.dart';
import 'package:posyandu_mob/core/database/UserDatabase.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  late final Dio dio;

  ApiClient._internal() {
    dio = Dio(BaseOptions(
      baseUrl: "http://192.168.43.73/api",
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
    ));
  }

  Future<void> setToken() async {
    final user = await UserDatabase().readUser();

    if (user != null && user.token.isNotEmpty) {
      dio.options.headers["Authorization"] = "Bearer ${user.token}";
    }
  }

  void clearToken() {
    dio.options.headers.remove("Authorization");
  }
}
