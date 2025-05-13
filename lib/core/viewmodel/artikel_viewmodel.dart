// viewmodels/artikel_viewmodel.dart
import 'package:flutter/material.dart';
import '../models/Artikel.dart';
import '../services/artikel_service.dart';

class ArtikelViewModel extends ChangeNotifier {
  final ArtikelService _artikelService = ArtikelService();
  List<Artikel> _artikels = [];
  bool _isLoading = false;

  List<Artikel> get artikels => _artikels;
  bool get isLoading => _isLoading;

  Future<void> getArtikel() async {
    _isLoading = true;
    notifyListeners();

    try {
      _artikels = await _artikelService.fetchArtikel();
    } catch (e) {
      print('Error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
