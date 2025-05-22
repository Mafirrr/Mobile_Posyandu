import 'package:flutter/material.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/PemeriksaanAwal.dart';

class AwalScreen extends StatelessWidget {
  final PemeriksaanAwal data;

  const AwalScreen({Key? key, required this.data}) : super(key: key);

  String displayValue(dynamic value) {
    if (value == null) return '-';
    if (value is String && value.isEmpty) return '-';
    return value.toString();
  }

  String displayList(List<String>? list) {
    if (list == null || list.isEmpty) return '-';
    return list.join(', ');
  }

  Widget buildDisplayItem(String label, String value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color.fromARGB(255, 255, 255, 255)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  fontSize: 13)),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.normal)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayData = {
      'Tinggi Badan': displayValue(data.tinggiBadan),
      'Golongan Darah': displayValue(data.golonganDarah),
      'Status Imunisasi': displayValue(data.statusImunisasiTd),
      'Hemoglobin': displayValue(data.hemoglobin),
      'Riwayat Kesehatan Ibu': displayList(data.riwayatKesehatanIbuSekarang),
      'Riwayat Perilaku': displayList(data.riwayatPerilaku),
      'Riwayat Penyakit Keluarga': displayList(data.riwayatPenyakitKeluarga),
    };

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: displayData.entries
              .map((e) => buildDisplayItem(e.key, e.value))
              .toList(),
        ),
      ),
    );
  }
}
