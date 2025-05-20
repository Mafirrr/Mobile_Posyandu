import 'package:flutter/material.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/PemeriksaanKhusus.dart';

class KhususScreen extends StatelessWidget {
  final PemeriksaanKhusus data;

  const KhususScreen({Key? key, required this.data}) : super(key: key);

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
