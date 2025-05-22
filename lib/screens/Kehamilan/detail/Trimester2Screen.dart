import 'package:flutter/material.dart';

import 'package:posyandu_mob/core/database/PemeriksaanDatabase.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/PemeriksaanRutin.dart';
import 'package:posyandu_mob/screens/Kehamilan/detail/rutinScreen.dart';

class Trimester2Screen extends StatefulWidget {
  final List<int> pemeriksaanIds;
  const Trimester2Screen({Key? key, required this.pemeriksaanIds})
      : super(key: key);

  @override
  _Trimester2ScreenState createState() => _Trimester2ScreenState();
}

class _Trimester2ScreenState extends State<Trimester2Screen> {
  final _db = Pemeriksaandatabase();

  List<PemeriksaanRutin> pemeriksaanList = [];
  bool isLoading = true;

  Map<int, bool> expandedMap = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final result = await _db.getTrimester2ByIds(widget.pemeriksaanIds);
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
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (pemeriksaanList.isEmpty) {
      return const Center(child: Text("Belum ada data pemeriksaan."));
    }

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: pemeriksaanList.map((pemeriksaan) {
            bool isExpanded = expandedMap[pemeriksaan.id!] ?? false;
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
                      formatTanggalIndonesia(pemeriksaan.created_at!),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text('Id pemeriksaan: ${pemeriksaan.id}'),
                    trailing: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF4D81E7), 
                        borderRadius:
                            BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        icon: Icon(
                          isExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: Colors.white, 
                        ),
                        onPressed: () {
                          setState(() {
                            expandedMap[pemeriksaan.id!] = !isExpanded;
                          });
                        },
                      ),
                    ),
                  ),
                  if (isExpanded)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: RutinScreen(data: pemeriksaan),
                    ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
