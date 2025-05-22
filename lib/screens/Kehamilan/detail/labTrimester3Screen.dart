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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTextField('ID Pemeriksaan', displayData['ID Pemeriksaan']!),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                    child: buildTextField(
                        'Hemoglobin', displayData['Hemoglobin']!)),
                const SizedBox(width: 10),
                Expanded(
                    child: buildTextField('Hemoglobin R.Tindak Lanjut',
                        displayData['Hemoglobin R.Tindak Lanjut']!)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                    child: buildTextField(
                        'Protein Urin', displayData['Protein Urin']!)),
                const SizedBox(width: 10),
                Expanded(
                    child: buildTextField('Protein Urin R.Tindak Lanjut',
                        displayData['Protein Urin R.Tindak Lanjut']!)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                    child: buildTextField(
                        'Urin Reduksi', displayData['Urin Reduksi']!)),
                const SizedBox(width: 10),
                Expanded(
                    child: buildTextField('Urin Reduksi R.Tindak Lanjut',
                        displayData['Urin Reduksi R.Tindak Lanjut']!)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
