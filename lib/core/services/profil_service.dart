import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:dio/dio.dart';
import 'package:posyandu_mob/core/Api/ApiClient.dart';
import 'package:posyandu_mob/core/database/UserDatabase.dart';
import 'package:posyandu_mob/core/models/Anggota.dart';
import 'package:posyandu_mob/core/models/dataAnggota.dart';

class ProfilService {
  final _db = UserDatabase();
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
      throw Exception('Error: $e');
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

  Future<Response> uploadImage(File image) async {
    try {
      int? id = await getID();

      FormData formData = FormData.fromMap({
        "id": id,
        "photo": await MultipartFile.fromFile(image.path,
            filename: image.uri.pathSegments.last),
      });

      final response = await _api.dio.post(
        '/upload-image',
        data: formData,
      );

      if (response.statusCode == 200) {
        var data = response.data;
        final Directory dir = await getApplicationDocumentsDirectory();
        final String fullPath = path.join(dir.path, "profile_image.jpeg");

        await _api.dio.download(data['url'], fullPath);

        response.data['url'] = fullPath;
      }

      return response;
    } on DioException catch (e) {
      return Response(
        requestOptions: RequestOptions(path: ' '),
        statusCode: 404,
        statusMessage: "Gagal mengupload gambar: {$e.message}",
      );
    }
  }

  Future<dynamic> getKeluarga() async {
    try {
      int? id = await getID();
      await _api.setToken();
      final response = await _api.dio.get("/user/keluarga/$id");

      final responseData = response.data;
      final userData = responseData['data'];

      return DataAnggota.fromJson(userData);
    } on DioException catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Response> updateKeluarga(DataAnggota data) async {
    try {
      _api.setToken();
      int localUpdateResult = await _db.updateKeluarga(data);
      if (localUpdateResult == 0) {
        return Response(
          requestOptions: RequestOptions(path: ' '),
          statusCode: 400,
          statusMessage: "Gagal memperbarui data lokal.",
        );
      }

      final response = await _api.dio.put(
        "/user/keluarga",
        data: data.toJson(),
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

      if (response.statusCode == 200) {
        var data = response.data;
        final Directory dir = await getApplicationDocumentsDirectory();
        final String fullPath = path.join(dir.path, "profile_image.jpeg");

        await _api.dio.download(data['url'], fullPath);

        response.data['url'] = fullPath;
      }

      return response;
    } on DioException catch (e) {
      return Response(
        requestOptions: RequestOptions(path: ''),
        statusCode: 404,
        statusMessage: "message: {$e.message}",
      );
    }
  }

  Future<int?> getID() async {
    dynamic userData = await _db.readUser();

    if (userData != null) {
      return userData.anggota.id;
    }
    return null;
  }
}
