import 'package:flutter/material.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/RencanaKonsultasi.dart';

class RencanaKonsultasiScreen extends StatelessWidget {
  final RencanaKonsultasi data;

  const RencanaKonsultasiScreen({Key? key, required this.data})
      : super(key: key);

  String displayValue(dynamic value) {
    if (value == null) return '-';
    if (value is String && value.isEmpty) return '-';
    return value.toString();
  }

  String displayList(List<String>? list) {
    if (list == null || list.isEmpty) return '-';
    return list.join(', ');
  }

  Widget buildTextField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        initialValue: value,
        style: const TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black),
          border: const OutlineInputBorder(),
          disabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
        enabled: false,
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: displayData.entries
              .map((entry) => buildTextField(entry.key, entry.value))
              .toList(),
        ),
      ),
    );
  }
}
