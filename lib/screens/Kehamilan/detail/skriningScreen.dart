import 'package:flutter/material.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/SkriningKesehatan.dart';

class SkriningScreen extends StatelessWidget {
  final SkriningKesehatan data;

  const SkriningScreen({Key? key, required this.data}) : super(key: key);

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
      'Skrining Jiwa': displayValue(data.skriningJiwa),
      'Tindak Lanjut Jiwa': displayValue(data.tindakLanjutJiwa),
      'Perlu Rujukan': displayValue(data.perluRujukan),
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
