import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posyandu_mob/core/database/PemeriksaanDatabase.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/LabTrimester3.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/PemeriksaanFisik.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/PemeriksaanRutin.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/RencanaKonsultasi.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/SkriningKesehatan.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/Trimester3.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/UsgTrimester3.dart';
import 'package:posyandu_mob/screens/Kehamilan/detail/fisikScreen.dart';
import 'package:posyandu_mob/screens/Kehamilan/detail/labTrimester3Screen.dart';
import 'package:posyandu_mob/screens/Kehamilan/detail/rencanaKonsultasiScreen.dart';
import 'package:posyandu_mob/screens/Kehamilan/detail/rutinScreen.dart';
import 'package:posyandu_mob/screens/Kehamilan/detail/skriningScreen.dart';
import 'package:posyandu_mob/screens/Kehamilan/detail/usgTrimester3Screen.dart';

class Trimester3Screen extends StatefulWidget {
  final List<int> pemeriksaanIds;
  const Trimester3Screen({Key? key, required this.pemeriksaanIds})
      : super(key: key);

  @override
  _Trimester3ScreenState createState() => _Trimester3ScreenState();
}

class _Trimester3ScreenState extends State<Trimester3Screen> {
  final _db = Pemeriksaandatabase();

  List<Trimester3> pemeriksaanList = [];
  bool isLoading = true;

  Map<String, bool> expandedMap = {
    'Pemeriksaan Rutin': false,
    'Pemeriksaan Fisik': false,
    'Skrining Kesehatan Jiwa': false,
    'Pemeriksaan Laboratorium': false,
    'Pemeriksaan Usg': false,
    'Rencana Konsultasi': false,
  };

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final result = await _db.getTrimester3ByIds(widget.pemeriksaanIds);
    setState(() {
      pemeriksaanList = result;
      isLoading = false;
    });
  }

  String formatTanggalIndonesia(String isoDate) {
    DateTime date = DateTime.parse(isoDate);
    return DateFormat("d MMMM yyyy", "id_ID").format(date);
  }

  Widget _buildPemeriksaanCard(
      String title, Widget child, String id, String tanggal) {
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
              title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Id pemeriksaan: $id'),
                Text('Tanggal pemeriksaan: $tanggal'),
              ],
            ),
            trailing: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF4D81E7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                icon: Icon(
                  expandedMap[title]!
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    expandedMap[title] = !expandedMap[title]!;
                  });
                },
              ),
            ),
          ),
          if (expandedMap[title]!)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: child,
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (pemeriksaanList.isEmpty) {
      return const Scaffold(
          body: Center(child: Text("Belum ada data pemeriksaan.")));
    }

    final pemeriksaan = pemeriksaanList[0];
    final id = pemeriksaan.id.toString();
    final tanggal = pemeriksaan.created_at != null
        ? formatTanggalIndonesia(pemeriksaan.created_at!.split('T')[0])
        : "-";

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _buildPemeriksaanCard(
              'Pemeriksaan Rutin',
              pemeriksaan.pemeriksaanRutin != null
                  ? RutinScreen(data: pemeriksaan.pemeriksaanRutin!)
                  : const Text('Data Pemeriksaan Rutin belum tersedia'),
              id,
              tanggal,
            ),
            _buildPemeriksaanCard(
              'Pemeriksaan Fisik',
              pemeriksaan.pemeriksaanFisik != null
                  ? FisikScreen(data: pemeriksaan.pemeriksaanFisik!)
                  : const Text('Data Pemeriksaan Fisik belum tersedia'),
              id,
              tanggal,
            ),
            _buildPemeriksaanCard(
              'Skrining Kesehatan Jiwa',
              pemeriksaan.skriningKesehatan != null
                  ? SkriningScreen(data: pemeriksaan.skriningKesehatan!)
                  : const Text('Data Skrining Kesehatan belum tersedia'),
              id,
              tanggal,
            ),
            _buildPemeriksaanCard(
              'Pemeriksaan Laboratorium',
              pemeriksaan.labTrimester3 != null
                  ? LabTrimester3Screen(data: pemeriksaan.labTrimester3!)
                  : const Text('Data Pemeriksaan Laboratorium belum tersedia'),
              id,
              tanggal,
            ),
            _buildPemeriksaanCard(
              'Pemeriksaan Usg',
              pemeriksaan.usgTrimester3 != null
                  ? UsgTrimester3Screen(data: pemeriksaan.usgTrimester3!)
                  : const Text('Data Pemeriksaan USG belum tersedia'),
              id,
              tanggal,
            ),
            _buildPemeriksaanCard(
              'Rencana Konsultasi',
              pemeriksaan.rencanaKonsultasi != null
                  ? RencanaKonsultasiScreen(
                      data: pemeriksaan.rencanaKonsultasi!)
                  : const Text('Data Rencana Konsultasi belum tersedia'),
              id,
              tanggal,
            ),
          ],
        ),
      ),
    );
  }
}
