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

  Widget buildTextField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        initialValue: value,
        style: const TextStyle(color: Colors.black),
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: displayData.entries.map((entry) {
            return buildTextField(entry.key, entry.value);
          }).toList(),
        ),
      ),
    );
  }
}
