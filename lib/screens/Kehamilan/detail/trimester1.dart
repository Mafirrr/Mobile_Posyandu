import 'package:flutter/material.dart';
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
  String? _selectedItem = "Pemeriksaan Rutin";
  late Map<String, int?> pemeriksaanMap;
  bool isLoading = true;

  List<String> pemeriksaanList = [
    'Pemeriksaan Rutin',
    'Pemeriksaan Awal',
    'Pemeriksaan Fisik',
    'Pemeriksaan Khusus',
    'Skrining Kesehatan Jiwa',
    'Pemeriksaan Laboratorium',
    'Pemeriksaan Usg',
  ];

  _dataPemeriksaan() async {
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
  void initState() {
    super.initState();
    pemeriksaanMap = {
      for (int i = 0; i < pemeriksaanList.length; i++) pemeriksaanList[i]: i,
    };
    _dataPemeriksaan();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          value: _selectedItem,
          hint: const Text('Pilih pemeriksaan'),
          items: pemeriksaanList.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedItem = value;
            });
          },
        ),
        const SizedBox(height: 20),
        isLoading
            ? const Center(child: CircularProgressIndicator())
            : _selectedItem != null
                ? _getDetailScreen(_selectedItem!)!
                : const Center(child: Text("Belum ada data pemeriksaan.")),
      ],
    );
  }

  Widget _getDetailScreen(String selected) {
    switch (selected) {
      case 'Pemeriksaan Rutin':
        if (rutin == null)
          return const Text('Data Pemeriksaan Rutin belum tersedia');
        return RutinScreen(data: rutin!);
      case 'Pemeriksaan Khusus':
        if (khusus == null)
          return const Text('Data Pemeriksaan Khusus belum tersedia');
        return KhususScreen(data: khusus!);
      case 'Pemeriksaan Fisik':
        if (fisik == null)
          return const Text('Data Pemeriksaan Fisik belum tersedia');
        return FisikScreen(data: fisik!);
      case 'Pemeriksaan Awal':
        if (awal == null)
          return const Text('Data Pemeriksaan Awal belum tersedia');
        return AwalScreen(data: awal!);
      case 'Skrining Kesehatan Jiwa':
        return SkriningScreen(
          data: skrining!,
        );
      case 'Pemeriksaan Laboratorium':
        if (lab == null)
          return const Text('Data Pemeriksaan Lab belum tersedia');
        return LabTrimester1Screen(data: lab!);
      case 'Pemeriksaan Usg':
        if (usg == null)
          return const Text('Data Pemeriksaan USG belum tersedia');
        return UsgTrimester1Screen(data: usg!);
      default:
        return const Text('Pilihan tidak dikenal.');
    }
  }
}
