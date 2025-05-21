import 'package:flutter/material.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/LabTrimester1.dart';

class LabTrimester1Screen extends StatelessWidget {
  final LabTrimester1 data;

  const LabTrimester1Screen({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String displayValue(dynamic value) {
      if (value == null) return '-';
      if (value is String && value.isEmpty) return '-';
      return value.toString();
    }

    final displayData = {
      'ID Pemeriksaan': data.id.toString(),
      'Hemoglobin': displayValue(data.hemoglobin),
      'Hemoglobin R.Tindak Lanjut': displayValue(data.hemoglobinRtl),
      'Golongan Darah & Rhesus': displayValue(data.golonganDarahDanRhesus),
      'G. Darah & Rhesus R.Tindak Lanjut ': displayValue(data.rhesusRtl),
      'Gula Darah': displayValue(data.gulaDarah),
      'Gula Darah R. Tindak Lanjut': displayValue(data.gulaDarahRtl),
      'HIV': displayValue(data.hiv),
      'Sifilis': displayValue(data.sifilis),
      'Hepatitis B': displayValue(data.hepatitisB),
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
