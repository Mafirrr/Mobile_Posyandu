import 'package:flutter/material.dart';
import 'package:posyandu_mob/core/database/UserDatabase.dart';
import 'package:posyandu_mob/core/models/Kehamilan.dart';
import 'package:posyandu_mob/core/services/KehamilanService.dart';
import 'package:posyandu_mob/screens/Kehamilan/detailKehamilan.dart';

class ListKehamilanPage extends StatefulWidget {
  const ListKehamilanPage({Key? key}) : super(key: key);

  @override
  State<ListKehamilanPage> createState() => _ListKehamilanPageState();
}

class _ListKehamilanPageState extends State<ListKehamilanPage> {
  final userDatabase = UserDatabase();
  String? nama;
  bool isLoading = true;
  late List<Kehamilan> kehamilanData = [];

  @override
  void initState() {
    super.initState();
    _getUser();
    _loadKehamilanData();
  }

  Future<void> _loadKehamilanData() async {
    try {
      final pemeriksaanService = KehamilanService();

      List<Kehamilan> localData = await userDatabase.getAllKehamilan();
      if (localData.isNotEmpty) {
        setState(() {
          kehamilanData = localData;
          isLoading = false;
        });
      } else {
        List<Kehamilan> remoteData = await pemeriksaanService.dataKehamilan();
        setState(() {
          kehamilanData = remoteData;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint("Error load kehamilan data: $e");
    }
  }

  Future<void> _getUser() async {
    dynamic user = await userDatabase.readUser();

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
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 77, 129, 231),
                  Colors.white,
                ],
                stops: [0.0, 0.3],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 24),
                  const Text(
                    "Pemeriksaan Kehamilan",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildWelcomeMessage(),
                  const SizedBox(height: 24),
                  const SizedBox(height: 24),
                  Expanded(
                    child: isLoading
                        ? _buildLoading()
                        : kehamilanData.isEmpty
                            ? _buildEmptyState()
                            : _buildList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeMessage() {
    String displayName = nama != null && nama!.isNotEmpty ? nama! : 'Ibu';
    return Center(
      child: Text(
        'Halo, $displayName! Pantau perkembangan kehamilanmu di sini.',
        style: TextStyle(
          fontSize: 14,
          color: const Color.fromARGB(255, 34, 34, 34),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          CircularProgressIndicator(
            color: Color(0xFF325CA8),
          ),
          SizedBox(height: 16),
          Text(
            'Memuat data kehamilan...',
            style: TextStyle(color: Colors.black54, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.pregnant_woman,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          const Text(
            'Belum ada data kehamilan',
            style: TextStyle(
              fontSize: 18,
              color: Colors.black54,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Mulai rekam pemeriksaan kehamilanmu agar dapat memantau perkembangan dengan mudah.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black45),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              _loadKehamilanData();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Muat ulang'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF325CA8),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      itemCount: kehamilanData.length,
      itemBuilder: (context, index) {
        var item = kehamilanData[index];
        return _buildCard(
          status: item.status,
          title: item.label,
          description: "Lihat detail Pemeriksaan ${item.label}mu.",
          id: item.id,
        );
      },
    );
  }

  Widget _buildCard({
    required String status,
    required String title,
    required String description,
    required int id,
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
                                  builder: (context) => DetailPemeriksaan(
                                    label: title,
                                    id: id,
                                  ),
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
