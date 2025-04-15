import 'package:flutter/material.dart';
import 'package:posyandu_mob/core/models/Anggota.dart';
import 'package:posyandu_mob/core/services/profil_service.dart';

class ProfilViewModel extends ChangeNotifier {
  final ProfilService _profilService = ProfilService();
  Anggota? _anggota;

  Anggota? get anggota => _anggota;

  Future<void> getAnggota() async {
    final result = await _profilService.getAnggota();
    if (result != null) {
      _anggota = result;
      notifyListeners();
    }
  }

  Future<bool> updateProfil(Anggota anggota) async {
    try {
      return await _profilService.updateAnggota(anggota);
    } catch (e) {
      print("Update error: $e");
      return false;
    }
  }
}
