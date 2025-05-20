import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  PemeriksaanRutin? selectedPemeriksaan;
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

  List<PemeriksaanRutin> get filteredByTanggal {
    if (selectedTanggal == null) return [];
    return pemeriksaanList
        .where((e) => e.created_at!.startsWith(selectedTanggal!))
        .toList();
  }

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
    final result = await _db.getTrimester2ByIds(widget.pemeriksaanIds);
    setState(() {
      pemeriksaanList = result;
      if (pemeriksaanList.isNotEmpty) {
        selectedPemeriksaan = pemeriksaanList[0];
      }
      isLoading = false;
    });
  }

  Widget? _getDetailScreen(String selected, PemeriksaanRutin data) {
    switch (selected) {
      case 'Pemeriksaan Rutin':
        return RutinScreen(data: data);
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
                      DropdownButtonFormField<PemeriksaanRutin>(
                        value: selectedPemeriksaan,
                        hint: const Text('Pilih tanggal pemeriksaan'),
                        items: pemeriksaanList.map((item) {
                          return DropdownMenuItem(
                            value: item,
                            child:
                                Text(formatTanggalIndonesia(item.created_at!)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedPemeriksaan = value;
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
