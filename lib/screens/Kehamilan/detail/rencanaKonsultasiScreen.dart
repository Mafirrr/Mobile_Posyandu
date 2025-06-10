import 'package:flutter/material.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/RencanaKonsultasi.dart';

class RencanaKonsultasiScreen extends StatelessWidget {
  final RencanaKonsultasi data;

  const RencanaKonsultasiScreen({super.key, required this.data});

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
        border: Border.all(color: Colors.white),
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
      'ID Pemeriksaan': data.id.toString(),
      'Rencana Konsultasi Lanjut': displayList(data.rencanaKonsultasiLanjut),
      'Rencana Proses Melahirkan': displayValue(data.rencanaProsesMelahirkan),
      'Pilihan Kontrasepsi': displayValue(data.pilihanKontrasepsi),
      'Kebutuhan Konseling': displayValue(data.kebutuhanKonseling),
    };

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: displayData.entries
              .map((entry) => buildDisplayItem(entry.key, entry.value))
              .toList(),
        ),
      ),
    );
  }
}
