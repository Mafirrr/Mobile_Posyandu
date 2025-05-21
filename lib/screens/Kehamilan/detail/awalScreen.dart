import 'package:flutter/material.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/PemeriksaanAwal.dart';

class AwalScreen extends StatelessWidget {
  final PemeriksaanAwal data;

  const AwalScreen({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String displayValue(dynamic value) {
      if (value == null) return '-';
      if (value is String && value.isEmpty) return '-';
      return value.toString();
    }

    String displayList(List<String>? list) {
      if (list == null || list.isEmpty) return '-';
      return list.join(', ');
    }

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

    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: displayData.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        entry.key,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      entry.value,
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
