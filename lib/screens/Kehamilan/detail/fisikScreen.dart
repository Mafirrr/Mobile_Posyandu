import 'package:flutter/material.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/PemeriksaanFisik.dart';

class FisikScreen extends StatelessWidget {
  final PemeriksaanFisik data;

  const FisikScreen({Key? key, required this.data}) : super(key: key);

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
