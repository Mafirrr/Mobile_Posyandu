import 'package:flutter/material.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/LabTrimester3.dart';

class LabTrimester3Screen extends StatelessWidget {
  final LabTrimester3 data;

  const LabTrimester3Screen({Key? key, required this.data}) : super(key: key);

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
      'ID Pemeriksaan': displayValue(data.id),
      'Hemoglobin': displayValue(data.hemoglobin),
      'Hemoglobin R.Tindak Lanjut': displayValue(data.hemoglobinRtl),
      'Protein Urin': displayValue(data.proteinUrin),
      'Protein Urin R.Tindak Lanjut': displayValue(data.proteinUrinRtl),
      'Urin Reduksi': displayValue(data.urinReduksi),
      'Urin Reduksi R.Tindak Lanjut': displayValue(data.urinReduksiRtl),
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
