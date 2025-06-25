import 'package:flutter/material.dart';

class DetailNifasScreen extends StatelessWidget {
  const DetailNifasScreen({Key? key}) : super(key: key);

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
              _buildItem("Bagian KF", "KF2"),
              _buildItem("Periksa Payudara (ASI)", "Normal"),
              _buildItem("Periksa Pendarahan", "Tidak Ada"),
              _buildItem("Periksa Jalan Lahir", "Bersih"),
              _buildItem("Vitamin A", "Diberikan"),
              _buildItem("KB Pasca Melahirkan", "Pil"),
              _buildItem("Skrining Kesehatan Jiwa", "Normal"),
              _buildItem("Konseling", "Ibu mendapat edukasi ASI"),
              _buildItem("Tata Laksana Kasus", "Tidak ada tindakan khusus"),
              _buildItem("Kesimpulan", "Ibu dan bayi sehat"),
              _buildItem("Keadaan Ibu", "Sehat"),
              _buildItem("Keadaan Bayi", "Sehat"),
              _buildItem("Masalah Nifas", "-"),
            ],
          ),
        ),
      ),
    );
  }
}
