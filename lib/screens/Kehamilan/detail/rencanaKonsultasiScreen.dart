import 'package:flutter/material.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/RencanaKonsultasi.dart';

class RencanaKonsultasiScreen extends StatelessWidget {
  final RencanaKonsultasi data;

  const RencanaKonsultasiScreen({Key? key, required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String displayValue(dynamic value) {
      if (value == null) return '-';
      if (value is String && value.isEmpty) return '-';
      return value.toString();
    }

    String displayList(List<String>? list) {
      if (list == null || list.isEmpty) return '-';
      return list.join(', ');
    }

    final displayData = {
      'ID Pemeriksaan': data.id.toString(),
      'Rencana Konsultasi Lanjut': displayList(data.rencanaKonsultasiLanjut),
      'Rencana Proses Melahirkan': displayValue(data.rencanaProsesMelahirkan),
      'Pilihan Kontrasepsi': displayValue(data.pilihanKontrasepsi),
      'Kebutuhan Konseling': displayValue(data.kebutuhanKonseling),
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
