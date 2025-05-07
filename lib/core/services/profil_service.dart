import 'package:dio/dio.dart';
import 'package:posyandu_mob/core/Api/ApiClient.dart';
import 'package:posyandu_mob/core/database/UserDatabase.dart';
import 'package:posyandu_mob/core/models/Anggota.dart';

class ProfilService {
  final _db = UserDatabase.instance;
  final _api = ApiClient();

  Future<dynamic> getAnggota() async {
    try {
      int? id = await getID();
      await _api.setToken();
      final response = await _api.dio.get("/user/$id");

      final responseData = response.data;
      final userData = responseData['user'];

      if (responseData['role'] == 'anggota') {
        return Anggota.fromJson(userData);
      } else {
        // return Petugas.fromJson(userData);
        return null;
      }
    } on DioException catch (e) {
      return null;
    }
  }

  Future<Response> updateAnggota(Anggota anggota) async {
    try {
      _api.setToken();

      int localUpdateResult = await _db.update(anggota);
      if (localUpdateResult == 0) {
        return Response(
          requestOptions: RequestOptions(path: ' '),
          statusCode: 400,
          statusMessage: "Gagal memperbarui data lokal.",
        );
      }

      final response = await _api.dio.put(
        "/profile/update",
        data: anggota.toJson(),
      );

      return response;
    } on DioException catch (e) {
      return Response(
        requestOptions: RequestOptions(path: ' '),
        statusCode: 202,
        statusMessage: "Gagal Mengupdate: ${e.message}",
      );
    }
  }

  Future<Response> checkImage() async {
    try {
      final id = await getID();
      final response = await _api.dio.post(
        '/image',
        data: {
          "id": id,
        },
      );

      return response;
    } on DioException catch (e) {
      return Response(
        requestOptions: RequestOptions(path: ' '),
        statusCode: 404,
        statusMessage: "Gambar Tidak ada",
      );
    }
  }

  Future<int?> getID() async {
    final db = await UserDatabase.instance;
    dynamic userData = await db.readUser();

    if (userData != null) {
      return userData.anggota.id;
    }
    return null;
  }
}
