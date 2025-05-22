import 'package:flutter/material.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/LabTrimester1.dart';

class LabTrimester1Screen extends StatelessWidget {
  final LabTrimester1 data;

  const LabTrimester1Screen({Key? key, required this.data}) : super(key: key);

  String displayValue(dynamic value) {
    if (value == null) return '-';
    if (value is String && value.isEmpty) return '-';
    return value.toString();
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
      'Hemoglobin': displayValue(data.hemoglobin),
      'Hemoglobin R. Tindak Lanjut': displayValue(data.hemoglobinRtl),
      'Golongan Darah & Rhesus': displayValue(data.golonganDarahDanRhesus),
      'G. Darah & Rhesus R. Tindak Lanjut': displayValue(data.rhesusRtl),
      'Gula Darah': displayValue(data.gulaDarah),
      'Gula Darah R. Tindak Lanjut': displayValue(data.gulaDarahRtl),
      'HIV': displayValue(data.hiv),
      'Sifilis': displayValue(data.sifilis),
      'Hepatitis B': displayValue(data.hepatitisB),
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
