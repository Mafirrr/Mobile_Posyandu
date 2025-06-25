import 'package:flutter/material.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/Nifas.dart';

class DetailNifasScreen extends StatelessWidget {
  final Nifas data;
  const DetailNifasScreen({Key? key, required this.data}) : super(key: key);

  Widget _buildItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 3,
              child: Text(label,
                  style: const TextStyle(fontWeight: FontWeight.w600))),
          const Text(" : "),
          Expanded(flex: 5, child: Text(value.isNotEmpty ? value : "-")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Pemeriksaan Nifas")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFE6EEFF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Detail Pemeriksaan Nifas",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const Divider(height: 20, thickness: 1),
              _buildItem("Bagian KF", data.bagianKf!),
              _buildItem("Periksa Payudara (ASI)", data.periksaPayudara ?? "-"),
              _buildItem("Periksa Pendarahan", data.periksaPendarahan ?? "-"),
              _buildItem("Periksa Jalan Lahir", data.periksaJalanLahir ?? "-"),
              _buildItem("Vitamin A", data.vitaminA ?? "-"),
              _buildItem("KB Pasca Melahirkan", data.kbPascaMelahirkan ?? "-"),
              _buildItem(
                  "Skrining Kesehatan Jiwa", data.skriningKesehatanJiwa ?? "-"),
              _buildItem("Konseling", data.konseling ?? "-"),
              _buildItem("Tata Laksana Kasus", data.tataLaksanaKasus ?? "-"),
              _buildItem("Kesimpulan", data.kesimpulan ?? "-"),
              _buildItem("Keadaan Ibu", data.kesimpulanIbu ?? "-"),
              _buildItem("Keadaan Bayi", data.kesimpulanBayi ?? "-"),
              _buildItem("Masalah Nifas", data.masalahNifas ?? "-"),
            ],
          ),
        ),
      ),
    );
  }
}
