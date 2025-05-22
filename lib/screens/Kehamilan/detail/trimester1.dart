import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:posyandu_mob/core/database/PemeriksaanDatabase.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/LabTrimester1.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/PemeriksaanAwal.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/PemeriksaanFisik.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/PemeriksaanKhusus.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/PemeriksaanRutin.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/SkriningKesehatan.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/Trimestr1.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/UsgTrimester1.dart';
import 'package:posyandu_mob/screens/Kehamilan/detail/awalScreen.dart';
import 'package:posyandu_mob/screens/Kehamilan/detail/fisikScreen.dart';
import 'package:posyandu_mob/screens/Kehamilan/detail/khususScreen.dart';
import 'package:posyandu_mob/screens/Kehamilan/detail/labTrimester1Screen.dart';
import 'package:posyandu_mob/screens/Kehamilan/detail/rutinScreen.dart';
import 'package:posyandu_mob/screens/Kehamilan/detail/skriningScreen.dart';
import 'package:posyandu_mob/screens/Kehamilan/detail/usgTrimester1Screen.dart';

class Trimester1Screen extends StatefulWidget {
  final int id;
  const Trimester1Screen({Key? key, required this.id}) : super(key: key);

  @override
  _Trimester1State createState() => _Trimester1State();
}

class _Trimester1State extends State<Trimester1Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PemeriksaanDropdown(widget.id),
    );
  }
}

class PemeriksaanDropdown extends StatefulWidget {
  final int id;
  const PemeriksaanDropdown(this.id);

  @override
  _PemeriksaanDropdownState createState() => _PemeriksaanDropdownState();
}

class _PemeriksaanDropdownState extends State<PemeriksaanDropdown> {
  final _db = Pemeriksaandatabase();
  dynamic local;
  Trimestr1? trimestr1;
  PemeriksaanRutin? rutin;
  PemeriksaanAwal? awal;
  PemeriksaanFisik? fisik;
  PemeriksaanKhusus? khusus;
  SkriningKesehatan? skrining;
  LabTrimester1? lab;
  UsgTrimester1? usg;
  bool isLoading = true;

  Map<String, bool> expandedMap = {
    'Pemeriksaan Rutin': false,
    'Pemeriksaan Awal': false,
    'Pemeriksaan Fisik': false,
    'Pemeriksaan Khusus': false,
    'Skrining Kesehatan Jiwa': false,
    'Pemeriksaan Laboratorium': false,
    'Pemeriksaan Usg': false,
  };

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    List<Trimestr1> result = await _db.getTrimester1(widget.id);
    setState(() {
      local = result;
      if (local.isNotEmpty) {
        rutin = local[0].pemeriksaanRutin;
        awal = local[0].pemeriksaanAwal;
        fisik = local[0].pemeriksaanFisik;
        khusus = local[0].pemeriksaanKhusus;
        skrining = local[0].skriningKesehatan;
        lab = local[0].labTrimester1;
        usg = local[0].usgTrimester1;
      }
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                _buildPemeriksaanCard(
                    'Pemeriksaan Rutin',
                    rutin != null
                        ? RutinScreen(data: rutin!)
                        : const Text('Data tidak tersedia')),
                _buildPemeriksaanCard(
                    'Pemeriksaan Awal',
                    awal != null
                        ? AwalScreen(data: awal!)
                        : const Text('Data tidak tersedia')),
                _buildPemeriksaanCard(
                    'Pemeriksaan Fisik',
                    fisik != null
                        ? FisikScreen(data: fisik!)
                        : const Text('Data tidak tersedia')),
                _buildPemeriksaanCard(
                    'Pemeriksaan Khusus',
                    khusus != null
                        ? KhususScreen(data: khusus!)
                        : const Text('Data tidak tersedia')),
                _buildPemeriksaanCard(
                    'Skrining Kesehatan Jiwa',
                    skrining != null
                        ? SkriningScreen(data: skrining!)
                        : const Text('Data tidak tersedia')),
                _buildPemeriksaanCard(
                    'Pemeriksaan Laboratorium',
                    lab != null
                        ? LabTrimester1Screen(data: lab!)
                        : const Text('Data tidak tersedia')),
                _buildPemeriksaanCard(
                    'Pemeriksaan Usg',
                    usg != null
                        ? UsgTrimester1Screen(data: usg!)
                        : const Text('Data tidak tersedia')),
              ],
            ),
          );
  }

  Widget _buildPemeriksaanCard(String title, Widget child) {
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
            subtitle: Text('Id pemeriksaan: ${widget.id}'),
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
}
