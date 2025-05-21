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
  Trimester3? selectedPemeriksaan;
  PemeriksaanRutin? rutin;
  PemeriksaanFisik? fisik;
  SkriningKesehatan? skrining;
  LabTrimester3? lab;
  UsgTrimester3? usg;
  RencanaKonsultasi? rencana;
  String? selectedJenis = "Pemeriksaan Rutin";
  bool isLoading = true;

  final List<String> jenisPemeriksaanList = [
    'Pemeriksaan Rutin',
  ];

  List<String> get uniqueTanggal {
    final seen = <String>{};
    return pemeriksaanList
        .map((e) => e.created_at!.split('T')[0])
        .where((tgl) => seen.add(tgl))
        .toList();
  }

  String? selectedTanggal;

  List<Trimester3> get filteredByTanggal {
    if (selectedTanggal == null) return [];
    return pemeriksaanList
        .where((e) => e.created_at.startsWith(selectedTanggal!))
        .toList();
  }

  List<String> pemeriksaan = [
    'Pemeriksaan Rutin',
    'Pemeriksaan Fisik',
    'Skrining Kesehatan Jiwa',
    'Pemeriksaan Laboratorium',
    'Pemeriksaan Usg',
  ];

  String formatTanggalIndonesia(String isoDate) {
    DateTime date = DateTime.parse(isoDate);
    return DateFormat("d MMMM yyyy", "id_ID").format(date);
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final result = await _db.getTrimester3ByIds(widget.pemeriksaanIds);
    setState(() {
      pemeriksaanList = result;
      if (pemeriksaanList.isNotEmpty) {
        selectedTanggal = pemeriksaanList[0].created_at.split('T')[0];
        selectedPemeriksaan = pemeriksaanList[0];
        rutin = selectedPemeriksaan!.pemeriksaanRutin;
        fisik = selectedPemeriksaan!.pemeriksaanFisik;
        skrining = selectedPemeriksaan!.skriningKesehatan;
        lab = selectedPemeriksaan!.labTrimester3;
        usg = selectedPemeriksaan!.usgTrimester3;
        rencana = selectedPemeriksaan!.rencanaKonsultasi;
      }
      isLoading = false;
    });
  }

  Widget? _getDetailScreen(String selected, Trimester3 data) {
    switch (selected) {
      case 'Pemeriksaan Rutin':
        if (rutin == null) {
          return const Text('Data Pemeriksaan Rutin belum tersedia');
        }
        return RutinScreen(data: rutin!);
      case 'Pemeriksaan Fisik':
        if (fisik == null) {
          return const Text('Data Pemeriksaan Fisik belum tersedia');
        }
        return FisikScreen(data: fisik!);
      case 'Skrining Kesehatan Jiwa':
        return SkriningScreen(
          data: skrining!,
        );
      case 'Pemeriksaan Laboratorium':
        if (lab == null) {
          return const Text('Data Pemeriksaan Lab belum tersedia');
        }
        return LabTrimester3Screen(
          data: lab!,
        );
      case 'Pemeriksaan Usg':
        if (usg == null) {
          return const Text('Data Pemeriksaan USG belum tersedia');
        }
        return UsgTrimester3Screen(
          data: usg!,
        );
      case 'Rencana Konsultasi':
        if (usg == null) {
          return const Text('Data Rencana Konsultasi belum tersedia');
        }
        return RencanaKonsultasiScreen(
          data: rencana!,
        );
      default:
        return const Text("Belum ada halaman detail untuk jenis ini.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : pemeriksaanList.isEmpty
              ? const Center(child: Text("Belum ada data pemeriksaan."))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButtonFormField<String>(
                        value: selectedJenis,
                        hint: const Text('Pilih pemeriksaan'),
                        items: pemeriksaan.map((item) {
                          return DropdownMenuItem(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedJenis = value;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        value: selectedTanggal,
                        hint: const Text('Pilih tanggal pemeriksaan'),
                        items: uniqueTanggal.map((item) {
                          return DropdownMenuItem(
                            value: item,
                            child: Text(formatTanggalIndonesia(item)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedTanggal = value;
                            final found = filteredByTanggal;
                            if (found.isNotEmpty) {
                              selectedPemeriksaan = found.first;
                              rutin = selectedPemeriksaan!.pemeriksaanRutin;
                              fisik = selectedPemeriksaan!.pemeriksaanFisik;
                              skrining = selectedPemeriksaan!.skriningKesehatan;
                              lab = selectedPemeriksaan!.labTrimester3;
                              usg = selectedPemeriksaan!.usgTrimester3;
                              rencana = selectedPemeriksaan!.rencanaKonsultasi;
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      if (selectedJenis != null && selectedPemeriksaan != null)
                        Expanded(
                          child: _getDetailScreen(
                              selectedJenis!, selectedPemeriksaan!)!,
                        )
                    ],
                  ),
                ),
    );
  }
}
