import 'package:posyandu_mob/core/Api/ApiClient.dart';
import 'package:posyandu_mob/core/models/Kategori.dart';

class KategoriService {
  final _api = ApiClient();

  Future<List<Kategori>> fetchKategori() async {
    _api.clearToken();
    final response = await _api.dio.get('/kategori');

    if (response.statusCode == 200) {
      final data = response.data;
      final List kategoriList = data['kategori'];

      return kategoriList.map((json) => Kategori.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat kategori');
    }
  }
}
