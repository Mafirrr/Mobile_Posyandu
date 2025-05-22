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
      'Tinggi Badan': data.tinggiBadan.toString(),
      'Golongan Darah': displayValue(data.golonganDarah),
      'Status Imunisasi': displayValue(data.statusImunisasiTd),
      'Hemoglobin': displayValue(data.hemoglobin),
      'Riwayat Kesehatan Ibu': displayList(data.riwayatKesehatanIbuSekarang),
      'Riwayat Perilaku': displayList(data.riwayatPerilaku),
      'Riwayat Penyakit Keluarga': displayList(data.riwayatPenyakitKeluarga),
    };

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTextField('ID Pemeriksaan', displayData['ID Pemeriksaan']!),
            const SizedBox(height: 10),
            buildTextField('Tinggi Badan', displayData['Tinggi Badan']!),
            const SizedBox(height: 10),
            buildTextField('Golongan Darah', displayData['Golongan Darah']!),
            const SizedBox(height: 10),
            buildTextField(
                'Status Imunisasi', displayData['Status Imunisasi']!),
            const SizedBox(height: 10),
            buildTextField('Hemoglobin', displayData['Hemoglobin']!),
            const SizedBox(height: 10),
            buildTextField(
                'Riwayat Kesehatan Ibu', displayData['Riwayat Kesehatan Ibu']!),
            const SizedBox(height: 10),
            buildTextField(
                'Riwayat Perilaku', displayData['Riwayat Perilaku']!),
            const SizedBox(height: 10),
            buildTextField('Riwayat Penyakit Keluarga',
                displayData['Riwayat Penyakit Keluarga']!),
          ],
        ),
      ),
    );
  }
}
