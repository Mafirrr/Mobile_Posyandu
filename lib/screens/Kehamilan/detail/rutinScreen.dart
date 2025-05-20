import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/PemeriksaanRutin.dart';

class RutinScreen extends StatelessWidget {
  final PemeriksaanRutin data;

  const RutinScreen({Key? key, required this.data}) : super(key: key);

  String formatTanggalIndonesia(String isoDate) {
    DateTime date = DateTime.parse(isoDate);
    return DateFormat("d MMMM yyyy", "id_ID").format(date);
  }

  @override
  Widget build(BuildContext context) {
    final displayData = {
      'ID Pemeriksaan': data.id.toString(),
      'Berat Badan': data.beratBadan?.toString() ?? '-',
      'Tinggi Rahim': data.tinggiRahim ?? '-',
      'Tekanan Darah Sistol': data.tekananDarahSistol?.toString() ?? '-',
      'Tekanan Darah Diastol': data.tekananDarahDiastol?.toString() ?? '-',
      'Letak dan Denyut Nadi Bayi': data.letakDanDenyutNadiBayi ?? '-',
      'Lingkar Lengan Atas': data.lingkarLenganAtas?.toString() ?? '-',
      'Protein Urin': data.proteinUrin?.toString() ?? '-',
      'Tablet Tambah Darah': data.tabletTambahDarah ?? '-',
      'Konseling': data.konseling ?? '-',
      'Skrining Dokter': data.skriningDokter ?? '-',
      'Tes Lab Gula Darah': data.tesLabGulaDarah?.toString() ?? '-',
      'Tanggal Pemeriksaan': data.created_at != null
          ? formatTanggalIndonesia(data.created_at.toString())
          : '-',
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
