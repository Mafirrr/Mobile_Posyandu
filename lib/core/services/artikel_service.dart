// services/artikel_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/Artikel.dart';

class ArtikelService {
  final String _baseUrl = 'http://10.0.2.2:8000/api';

  Future<List<Artikel>> fetchArtikel() async {
    final response = await http.get(Uri.parse('$_baseUrl/artikel'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List artikelList = data['artikel'];

      return artikelList.map((json) => Artikel.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat artikel');
    }
  }
}
