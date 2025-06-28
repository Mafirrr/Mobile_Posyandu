import 'package:posyandu_mob/core/Api/ApiClient.dart';
import '../models/Artikel.dart';

class ArtikelService {
  final _api = ApiClient();
  Future<List<Artikel>> fetchArtikel() async {
    _api.setToken();
    final response = await _api.dio.get('/artikel');

    if (response.statusCode == 200) {
      final data = response.data;
      final List artikelList = data['artikel'];

      return artikelList.map((json) => Artikel.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat artikel');
    }
  }
}
