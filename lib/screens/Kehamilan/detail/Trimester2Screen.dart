import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

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
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : pemeriksaanList.isEmpty
                ? const Center(child: Text("Belum ada data pemeriksaan."))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 42,
                              child: DropdownButtonFormField2<PemeriksaanRutin>(
                                isExpanded: true,
                                decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: Colors.blue,
                                      width: 1.8,
                                    ),
                                  ),
                                ),
                                hint: const Text('Pilih tanggal pemeriksaan'),
                                value: selectedPemeriksaan,
                                items: pemeriksaanList.map((item) {
                                  return DropdownMenuItem<PemeriksaanRutin>(
                                    value: item,
                                    child: Text(
                                      formatTanggalIndonesia(item.created_at!),
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedPemeriksaan = value;
                                  });
                                },
                                dropdownStyleData: DropdownStyleData(
                                  maxHeight: 300,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                menuItemStyleData: const MenuItemStyleData(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
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
