import 'package:flutter/material.dart';
import 'package:posyandu_mob/core/models/Jadwal.dart';
import 'package:posyandu_mob/core/services/jadwalKader_service.dart';

class JadwalkaderViewmodel extends ChangeNotifier {
  final JadwalkaderService _service = JadwalkaderService();
  List<Jadwal> _jadwalList = [];

  List<Jadwal> get jadwalList => _jadwalList;

  Future<void> loadJadwal() async {
    try {
      _jadwalList = await _service.getAllJadwal();
      notifyListeners();
    } catch (e, stacktrace) {
      print("Error saat loadJadwal: $e");
      print("Stacktrace: $stacktrace");
      rethrow; // Agar error bisa ditangkap di FutureBuilder
    }
  }

  Future<void> addJadwal(Jadwal jadwal) async {
    try {
      await _service.createJadwal(jadwal);
      await loadJadwal(); // Muat ulang dari server agar konsisten
    } catch (e) {
      print("Gagal menambahkan jadwal: $e");
      rethrow;
    }
  }

  Future<void> updateJadwal(Jadwal jadwal) async {
    try {
      await _service.updateJadwal(jadwal);
      await loadJadwal(); // Refresh data
    } catch (e) {
      print("Gagal mengupdate jadwal: $e");
      rethrow;
    }
  }

  Future<void> deleteJadwal(int id) async {
    try {
      await _service.deleteJadwal(id);
      await loadJadwal(); // Refresh data
    } catch (e) {
      print("Gagal menghapus jadwal: $e");
      rethrow;
    }
  }
}
