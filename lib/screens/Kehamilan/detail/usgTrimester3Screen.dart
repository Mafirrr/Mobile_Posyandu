import 'package:flutter/material.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/UsgTrimester3.dart';

class UsgTrimester3Screen extends StatelessWidget {
  final UsgTrimester3 data;

  const UsgTrimester3Screen({Key? key, required this.data}) : super(key: key);

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
      'USG Trimester 3': displayValue(data.usgTrimester3),
      'Umur Kehamilan USG Trimester 3':
          displayValue(data.umurKehamilanUsgTrimester3),
      'Selisih UK USG 1 HPHT dengan Trimester 3':
          displayValue(data.selisihUkUsg1HphtDenganTrimester3),
      'Jumlah Bayi': displayValue(data.jumlahBayi),
      'Letak Bayi': displayValue(data.letakBayi),
      'Presentasi Bayi': displayValue(data.presentasiBayi),
      'Keadaan Bayi': displayValue(data.keadaanBayi),
      'DJJ': displayValue(data.djj),
      'Jumlah Cairan Ketuban': displayValue(data.jumlahCairanKetuban),
      'Lokasi Plasenta': displayValue(data.lokasiPlasenta),
      'BPD': displayValue(data.bpd),
      'BPD Sesuai Minggu': displayValue(data.bpdSesuaiMinggu),
      'HC': displayValue(data.hc),
      'HC Sesuai Minggu': displayValue(data.hcSesuaiMinggu),
      'AC': displayValue(data.ac),
      'AC Sesuai Minggu': displayValue(data.acSesuaiMinggu),
      'FL': displayValue(data.fl),
      'FL Sesuai Minggu': displayValue(data.flSesuaiMinggu),
      'EFW': displayValue(data.efw),
      'EFW Sesuai Minggu': displayValue(data.efwSesuaiMinggu),
      'Kecurigaan Temuan Abnormal': displayValue(data.kecurigaanTemuanAbnormal),
      'Keterangan': displayValue(data.keterangan),
    };

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: displayData.entries
              .map((entry) => buildTextField(entry.key, entry.value))
              .toList(),
        ),
      ),
    );
  }
}
