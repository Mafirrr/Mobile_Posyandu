import 'package:flutter/material.dart';
import 'package:posyandu_mob/core/models/dataAnggota.dart';
import 'package:posyandu_mob/core/services/AnggotaService.dart';

class AnggotaViewModel extends ChangeNotifier {
  final AnggotaService _service = AnggotaService();

  List<dynamic> _anggotaList = [];
  List<dynamic> get anggotaList => _anggotaList;

  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  Future<void> fetchAnggota() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _anggotaList = await _service.getAll();
    } catch (e) {
      _error = e.toString();
    }

    _loading = false;
    notifyListeners();
  }

  Future<bool> addAnggota(Map<String, dynamic> data) async {
    try {
      await _service.create(data);
      await fetchAnggota();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateAnggota(String id, Map<String, dynamic> data) async {
    try {
      await _service.update(id, data);
      await fetchAnggota();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteAnggota(String id) async {
    try {
      await _service.delete(id);
      await fetchAnggota();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}
