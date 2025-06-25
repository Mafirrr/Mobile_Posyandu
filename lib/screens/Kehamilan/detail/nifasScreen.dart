import 'package:flutter/material.dart';
import 'package:posyandu_mob/core/database/PemeriksaanDatabase.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/Nifas.dart';
import 'DetailNifasScreen.dart';

class NifasScreen extends StatefulWidget {
  final List<int> pemeriksaanIds;
  const NifasScreen({Key? key, required this.pemeriksaanIds}) : super(key: key);

  @override
  _NifasScreenState createState() => _NifasScreenState();
}

class _NifasScreenState extends State<NifasScreen> {
  final _db = Pemeriksaandatabase();

  List<Nifas> pemeriksaanList = [];
  bool isLoading = true;

  Map<int, bool> expandedMap = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final result = await _db.getNifasByIds(widget.pemeriksaanIds);
    setState(() {
      pemeriksaanList = result;
      expandedMap = {for (var p in pemeriksaanList) p.id!: false};
      isLoading = false;
    });
  }

  String formatTanggalIndonesia(String isoDate) {
    DateTime date = DateTime.parse(isoDate);
    return "${date.day} ${_bulanIndonesia(date.month)} ${date.year}";
  }

  String _bulanIndonesia(int month) {
    const bulan = [
      '',
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    return bulan[month];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Daftar Pemeriksaan Nifas")),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: pemeriksaanList.map((item) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6EEFF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                formatTanggalIndonesia(item.createdAt!),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              Text("ID Pemeriksaan: ${item.id}"),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF4D81E7),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                expandedMap[item.id!] =
                                    !(expandedMap[item.id!] ?? false);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xFF4D81E7),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: const Icon(Icons.visibility, color: Colors.white),
                        label: const Text(
                          'Lihat Detail',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailNifasScreen(data: item),
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
