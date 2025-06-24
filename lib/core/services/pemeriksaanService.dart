import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:posyandu_mob/core/Api/ApiClient.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/Nifas.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/PemeriksaanKehamilan.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/PemeriksaanRutin.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/Trimester3.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/Trimestr1.dart';

class PemeriksaanService {
  final _api = ApiClient();

  Future<List<Map<String, dynamic>>> fetchSuggestion(String nama) async {
    try {
      await _api.setToken();
      final response = await _api.dio.get('/anggota?nama=$nama');

      if (response.statusCode == 200) {
        final List data = response.data is String
            ? json.decode(response.data)
            : response.data;

        return data
            .map<Map<String, dynamic>>((item) => {
                  'id': item['id'],
                  'nama': item['nama'],
                })
            .toList();
      } else {
        throw Exception('Gagal memuat nama');
      }
    } on DioException catch (e) {
      print("Dio error: ${e.response?.data ?? e.message}");
      return [];
    }
  }

  Future<Response> pemeriksaanTrimester1(
      PemeriksaanKehamilan pemeriksaan, Trimestr1 trimester1) async {
    try {
      await _api.setToken();
      final response = await _api.dio.post(
        '/pemeriksaan-kehamilan',
        data: {
          "pemeriksaan_kehamilan": pemeriksaan.toJson(),
          "trimester1": trimester1.toJson(),
        },
      );

      return response;
    } on DioException catch (e) {
      throw Exception('Gagal kirim data: ${e.response?.data ?? e.message}');
    }
  }

  Future<Response> pemeriksaanTrimester2(
      PemeriksaanKehamilan pemeriksaan, PemeriksaanRutin trimester2) async {
    try {
      await _api.setToken();
      final response = await _api.dio.post(
        '/pemeriksaan-kehamilan',
        data: {
          "pemeriksaan_kehamilan": pemeriksaan.toJson(),
          "trimester2": trimester2.toJson(),
        },
      );

      return response;
    } on DioException catch (e) {
      throw Exception('Gagal kirim data: ${e.response?.data ?? e.message}');
    }
  }

  Future<Response> pemeriksaanNifas(
      PemeriksaanKehamilan pemeriksaan, Nifas nifas) async {
    try {
      await _api.setToken();
      final response = await _api.dio.post(
        '/pemeriksaan-kehamilan',
        data: {
          "pemeriksaan_kehamilan": pemeriksaan.toJson(),
          "nifas": nifas.toJson(),
        },
      );

      return response;
    } on DioException catch (e) {
      throw Exception('Gagal kirim data: ${e.response?.data ?? e.message}');
    }
  }

  Future<Response> pemeriksaanTrimester3(
      PemeriksaanKehamilan pemeriksaan, Trimester3 trimester3) async {
    try {
      await _api.setToken();
      final response = await _api.dio.post(
        '/pemeriksaan-kehamilan',
        data: {
          "pemeriksaan_kehamilan": pemeriksaan.toJson(),
          "trimester3": trimester3.toJson(),
        },
      );

      return response;
    } on DioException catch (e) {
      throw Exception('Gagal kirim data: ${e.response?.data ?? e.message}');
    }
  }
}
