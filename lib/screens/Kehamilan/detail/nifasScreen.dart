import 'package:flutter/material.dart';
import 'DetailNifasScreen.dart';

class NifasScreen extends StatelessWidget {
  const NifasScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> dummyList = [
      {"id": 1, "tanggal": "2025-06-01"},
      {"id": 2, "tanggal": "2025-06-15"},
      {"id": 3, "tanggal": "2025-06-25"},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Daftar Pemeriksaan Nifas")),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: dummyList.map((item) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6EEFF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        item["tanggal"],
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text("ID Pemeriksaan: ${item["id"]}"),
                      trailing: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF4D81E7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4D81E7),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: const Icon(Icons.visibility),
                        label: const Text('Lihat Detail'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const DetailNifasScreen(),
                            ),
                          );
                        },
                      ),
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
