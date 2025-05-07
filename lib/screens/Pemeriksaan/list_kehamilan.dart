import 'package:flutter/material.dart';
import 'package:posyandu_mob/core/database/UserDatabase.dart';
import 'package:posyandu_mob/core/services/PemeriksaanService.dart';

import 'package:posyandu_mob/screens/Pemeriksaan/detail_pemeriksaan.dart';

class ListKehamilanPage extends StatefulWidget {
  const ListKehamilanPage({Key? key}) : super(key: key);

  @override
  State<ListKehamilanPage> createState() => _ListKehamilanPageState();
}

class _ListKehamilanPageState extends State<ListKehamilanPage> {
  String? nama;
  bool isLoading = true;
  late List<Map<String, dynamic>> kehamilanData = [];

  @override
  void initState() {
    super.initState();
    _getUser();
    _loadKehamilanData();
  }

  Future<void> _loadKehamilanData() async {
    try {
      final pemeriksaanService = PemeriksaanService();
      List<Map<String, dynamic>> data =
          await pemeriksaanService.dataKehamilan();
      setState(() {
        kehamilanData = data;
      });
      isLoading = false;
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _getUser() async {
    dynamic user = await UserDatabase.instance.readUser();

    if (user != null) {
      setState(() {
        nama = user.anggota.nama ?? '';
      });
    } else {
      nama = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset(
                      'assets/images/picture.jpg',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nama ?? "nama",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const Text(
                        'Anggota Posyandu',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : kehamilanData.isEmpty
                        ? const Center(
                            child: Text(
                              'Tidak ada data kehamilan',
                              style: TextStyle(fontSize: 16), // opsional
                            ),
                          )
                        : ListView.builder(
                            itemCount: kehamilanData.length,
                            itemBuilder: (context, index) {
                              var item = kehamilanData[index];
                              return _buildCard(
                                status: item['status'],
                                title: item['label'],
                                description:
                                    "Lihat detail Pemeriksaan ${item['label']}mu.",
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required String status,
    required String title,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            blurRadius: 6,
            color: Colors.black12,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const BoxDecoration(
              color: Color(0xFF325CA8),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Text(
              status,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.radio_button_checked, color: Colors.red),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Divider(thickness: 1),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              description,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const DetailPemeriksaan(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            child: const Text(
                              'Detail',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
