import 'dart:io';
import 'package:flutter/material.dart';
import 'package:posyandu_mob/core/models/Anggota.dart';
import 'package:posyandu_mob/core/services/profil_service.dart';

class ProfilViewModel extends ChangeNotifier {
  final ProfilService _profilService = ProfilService();
  Anggota? _anggota;
  bool _isLoading = false;

  Anggota? get anggota => _anggota;
  bool get isLoading => _isLoading;

  Future<bool> updateProfil(Anggota anggota) async {
    try {
      _setLoading(true);

      final update = await _profilService.updateAnggota(anggota);
      _setLoading(false);

      if (update.statusCode == 202) {
        return false;
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<String> checkImage() async {
    try {
      _isLoading = true;

      final response = await _profilService.checkImage();
      _isLoading = false;

      var data = response.data;
      if (response.statusCode == 200) {
        return data['url'];
      }
      return '';
    } catch (e) {
      return '';
    }
  }

  Future<String> uploadImage(File image) async {
    try {
      _isLoading = true;

      final response = await _profilService.uploadImage(image);
      _isLoading = false;

      if (response.statusCode == 200) {
        var data = response.data;
        return data['url'];
      }
      return '';
    } catch (e) {
      return '';
    }
  }
}
