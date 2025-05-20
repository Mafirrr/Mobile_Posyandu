import 'package:flutter/material.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/UsgTrimester1.dart';

class UsgTrimester1Screen extends StatelessWidget {
  final UsgTrimester1 data;

  const UsgTrimester1Screen({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String displayValue(dynamic value) {
      if (value == null) return '-';
      if (value is String && value.isEmpty) return '-';
      return value.toString();
    }

    final displayData = {
      'ID Pemeriksaan': data.id.toString(),
      'HPHT': displayValue(data.hpht),
      'Keteraturan Haid': displayValue(data.keteraturanHaid),
      'Umur Kehamilan Berdasar HPHT':
          displayValue(data.umurKehamilanBerdasarHpht),
      'Umur Kehamilan Berdasar USG':
          displayValue(data.umurKehamilanBerdasarkanUsg),
      'HPL Berdasar HPHT': displayValue(data.hplBerdasarkanHpht),
      'HPL Berdasar USG': displayValue(data.hplBerdasarkanUsg),
      'Jumlah Bayi': displayValue(data.jumlahBayi),
      'Jumlah GS': displayValue(data.jumlahGs),
      'Diamter GS': displayValue(data.diametesGs),
      'GS Hari': displayValue(data.gsHari),
      'GS Minggu': displayValue(data.gsMinggu),
      'CRL': displayValue(data.crl),
      'CRL Hari': displayValue(data.crlHari),
      'CRL Minggu': displayValue(data.crlMinggu),
      'Letak Produk Kehamilan': displayValue(data.letakProdukKehamilan),
      'Pulsasi Jantung': displayValue(data.pulsasiJantung),
      'Kecurigaan Temuan Abnormal': displayValue(data.kecurigaanTemuanAbnormal),
      'Keterangan': displayValue(data.keterangan),
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
