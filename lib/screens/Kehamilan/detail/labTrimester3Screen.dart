import 'package:flutter/material.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/LabTrimester3.dart';

class LabTrimester3Screen extends StatelessWidget {
  final LabTrimester3 data;

  const LabTrimester3Screen({Key? key, required this.data}) : super(key: key);

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
      'Protein Urin': displayValue(data.proteinUrin),
      'Protein Urin R.Tindak Lanjut': displayValue(data.proteinUrinRtl),
      'Urin Reduksi': displayValue(data.urinReduksi),
      'Urin Reduksi R.Tindak Lanjut': displayValue(data.urinReduksiRtl),
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
