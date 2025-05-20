import 'package:flutter/material.dart';
import 'package:posyandu_mob/core/models/Jadwal.dart';
import 'package:posyandu_mob/core/services/jadwalKader_service.dart';

class JadwalkaderViewmodel extends ChangeNotifier {
  final JadwalkaderService _service = JadwalkaderService();
  List<Jadwal> _jadwalList = [];

  List<Jadwal> get jadwalList => _jadwalList;

  Future<void> loadJadwal() async {
    try {
      _jadwalList = await JadwalkaderService().getAllJadwal();
    } catch (e, stacktrace) {
      print("Error saat loadJadwal: $e");
      print("Stacktrace: $stacktrace");
      rethrow; // agar error bisa ditangkap di FutureBuilder
    }
  }

  Future<void> addJadwal(Jadwal jadwal) async {
    final newJadwal = await _service.createJadwal(jadwal);
    _jadwalList.insert(0, newJadwal);
    notifyListeners();
  }

  Future<void> updateJadwal(Jadwal jadwal) async {
    final updatedJadwal = await _service.updateJadwal(jadwal);
    final index = _jadwalList.indexWhere((j) => j.id == updatedJadwal.id);
    if (index != -1) {
      _jadwalList[index] = updatedJadwal;
      notifyListeners();
    }
  }

  Future<void> deleteJadwal(int id) async {
    await _service.deleteJadwal(id);
    _jadwalList.removeWhere((j) => j.id == id);
    notifyListeners();
  }
}
