// viewmodels/artikel_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:posyandu_mob/core/models/Kategori.dart';
import 'package:posyandu_mob/core/services/kategori_service.dart';

class KategoriViewmodel extends ChangeNotifier {
  final KategoriService _kategoriService = KategoriService();
  List<Kategori> _kategories = [];
  bool _isLoading = false;

  List<Kategori> get kategories => _kategories;
  bool get isLoading => _isLoading;

  Future<void> getKategori() async {
    _isLoading = true;
    notifyListeners();

    try {
      _kategories = await _kategoriService.fetchKategori();
    } catch (e) {
      print('Error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
