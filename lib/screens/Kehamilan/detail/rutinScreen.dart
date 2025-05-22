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

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTextField('ID Pemeriksaan', displayData['ID Pemeriksaan']!),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                    child: buildTextField(
                        'Berat Badan', displayData['Berat Badan']!)),
                const SizedBox(width: 10),
                Expanded(
                    child: buildTextField(
                        'Tinggi Rahim', displayData['Tinggi Rahim']!)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                    child: buildTextField('Tekanan Darah Sistol',
                        displayData['Tekanan Darah Sistol']!)),
                const SizedBox(width: 10),
                Expanded(
                    child: buildTextField('Tekanan Darah Diastol',
                        displayData['Tekanan Darah Diastol']!)),
              ],
            ),
            const SizedBox(height: 10),
            buildTextField('Letak dan Denyut Nadi Bayi',
                displayData['Letak dan Denyut Nadi Bayi']!),
            const SizedBox(height: 10),
            buildTextField(
                'Lingkar Lengan Atas', displayData['Lingkar Lengan Atas']!),
            const SizedBox(height: 10),
            buildTextField('Protein Urin', displayData['Protein Urin']!),
            const SizedBox(height: 10),
            buildTextField(
                'Tablet Tambah Darah', displayData['Tablet Tambah Darah']!),
            const SizedBox(height: 10),
            buildTextField('Konseling', displayData['Konseling']!),
            const SizedBox(height: 10),
            buildTextField('Skrining Dokter', displayData['Skrining Dokter']!),
            const SizedBox(height: 10),
            buildTextField(
                'Tes Lab Gula Darah', displayData['Tes Lab Gula Darah']!),
            const SizedBox(height: 10),
            buildTextField(
                'Tanggal Pemeriksaan', displayData['Tanggal Pemeriksaan']!),
          ],
        ),
      ),
    );
  }
}
