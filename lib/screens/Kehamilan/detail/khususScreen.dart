import 'package:flutter/material.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/PemeriksaanKhusus.dart';

class KhususScreen extends StatelessWidget {
  final PemeriksaanKhusus data;

  const KhususScreen({Key? key, required this.data}) : super(key: key);

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
      'Porsio': data.porsio ?? '-',
      'Uretra': data.uretra ?? '-',
      'Vagina': data.vagina ?? '-',
      'Vulva': data.vulva ?? '-',
      'Fluksus': data.fluksus ?? '-',
      'Fluor': data.fluor ?? '-',
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
