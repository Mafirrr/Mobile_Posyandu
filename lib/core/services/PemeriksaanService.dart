import 'package:posyandu_mob/core/Api/ApiClient.dart';

class PemeriksaanService {
  final _api = ApiClient();

  Future<List<Map<String, dynamic>>> dataKehamilan() async {
    try {
      _api.clearToken();
      final response = await _api.dio.get('/kehamilan/3');

      if (response.statusCode == 200) {
        var data = response.data;
        if (data['status'] == 'success') {
          return List<Map<String, dynamic>>.from(data['data']);
        } else {
          throw Exception('Error: ${data['message']}');
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
