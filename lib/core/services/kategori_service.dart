// services/artikel_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:posyandu_mob/core/models/Kategori.dart';

class KategoriService {
  final String _baseUrl = 'http://10.0.2.2:8000/api';

  Future<List<Kategori>> fetchKategori() async {
    final response = await http.get(Uri.parse('$_baseUrl/kategori'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List kategoriList = data['kategori'];

      return kategoriList.map((json) => Kategori.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat kategori');
    }
  }
}
