import 'package:flutter/material.dart';
import 'package:posyandu_mob/core/services/PetugasService.dart';

class PetugasViewModel extends ChangeNotifier {
  final Petugasservice _service = Petugasservice();

  List<dynamic> _Petugasist = [];
  List<dynamic> get PetugasList => _Petugasist;

  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  Future<void> fetchPetugas() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _Petugasist = await _service.getAll();
    } catch (e) {
      _error = e.toString();
    }

    _loading = false;
    notifyListeners();
  }

  Future<bool> addPetugas(Map<String, dynamic> data) async {
    try {
      await _service.create(data);
      await fetchPetugas();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updatePetugas(String id, Map<String, dynamic> data) async {
    try {
      await _service.update(id, data);
      await fetchPetugas();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deletePetugas(String id) async {
    try {
      await _service.delete(id);
      await fetchPetugas();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}
