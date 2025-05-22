import 'package:flutter/material.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/UsgTrimester1.dart';

class UsgTrimester1Screen extends StatelessWidget {
  final UsgTrimester1 data;

  const UsgTrimester1Screen({Key? key, required this.data}) : super(key: key);

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
