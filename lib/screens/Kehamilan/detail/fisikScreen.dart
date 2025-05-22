import 'package:flutter/material.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/PemeriksaanFisik.dart';

class FisikScreen extends StatelessWidget {
  final PemeriksaanFisik data;

  const FisikScreen({Key? key, required this.data}) : super(key: key);

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
      'Konjungtiva': data.konjungtiva ?? '-',
      'Sklera': data.sklera ?? '-',
      'Kulit': data.kulit ?? '-',
      'Leher': data.leher ?? '-',
      'Gigi Mulut': data.gigiMulut ?? '-',
      'THT': data.tht ?? '-',
      'Jantung': data.jantung ?? '-',
      'Paru': data.paru ?? '-',
      'Perut': data.perut ?? '-',
      'Tungkai': data.tungkai ?? '-',
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
