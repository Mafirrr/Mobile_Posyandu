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

  Widget buildDisplayItem(String label, String value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color.fromARGB(255, 255, 255, 255)),
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
  @override
  Widget build(BuildContext context) {
    final displayData = {
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

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: buildDisplayItem(
                      'Berat Badan', displayData['Berat Badan']!),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: buildDisplayItem(
                      'Tinggi Rahim', displayData['Tinggi Rahim']!),
                ),
              ],
            ),
            const SizedBox(height: 10),
            buildDisplayItem(
                'Tekanan Darah Sistol', displayData['Tekanan Darah Sistol']!),
            buildDisplayItem(
                'Tekanan Darah Diastol', displayData['Tekanan Darah Diastol']!),
            buildDisplayItem('Letak dan Denyut Nadi Bayi',
                displayData['Letak dan Denyut Nadi Bayi']!),
            buildDisplayItem(
                'Lingkar Lengan Atas', displayData['Lingkar Lengan Atas']!),
            buildDisplayItem('Protein Urin', displayData['Protein Urin']!),
            buildDisplayItem(
                'Tablet Tambah Darah', displayData['Tablet Tambah Darah']!),
            buildDisplayItem('Konseling', displayData['Konseling']!),
            buildDisplayItem(
                'Skrining Dokter', displayData['Skrining Dokter']!),
            buildDisplayItem(
                'Tes Lab Gula Darah', displayData['Tes Lab Gula Darah']!),
            buildDisplayItem(
                'Tanggal Pemeriksaan', displayData['Tanggal Pemeriksaan']!),
          ],
        ),
      ),
    );
  }
}
