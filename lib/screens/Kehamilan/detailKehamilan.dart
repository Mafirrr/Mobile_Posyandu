import 'package:flutter/material.dart';
import 'package:posyandu_mob/core/database/PemeriksaanDatabase.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/LabTrimester1.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/LabTrimester3.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/PemeriksaanAwal.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/PemeriksaanFisik.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/PemeriksaanKhusus.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/PemeriksaanRutin.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/RencanaKonsultasi.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/SkriningKesehatan.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/Trimester3.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/Trimestr1.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/UsgTrimester1.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/UsgTrimester3.dart';
import 'package:posyandu_mob/screens/Kehamilan/detail/Trimester2Screen.dart';
import 'package:posyandu_mob/screens/Kehamilan/detail/Trimester3Screen.dart';
import 'package:posyandu_mob/screens/Kehamilan/detail/trimester1.dart';

class DetailPemeriksaan extends StatefulWidget {
  final String label;
  final int id;
  const DetailPemeriksaan({Key? key, required this.label, required this.id})
      : super(key: key);

  @override
  _DetailPemeriksaanState createState() => _DetailPemeriksaanState();
}

class _DetailPemeriksaanState extends State<DetailPemeriksaan> {
  Trimestr1? trimester1;
  Trimester3? trimester3;
  PemeriksaanRutin? pemeriksaanRutin;
  PemeriksaanAwal? pemeriksaanAwal;
  PemeriksaanFisik? pemeriksaanFisik;
  PemeriksaanKhusus? pemeriksaanKhusus;
  LabTrimester1? labTrimester1;
  UsgTrimester1? usgTrimester1;
  LabTrimester3? labTrimester3;
  UsgTrimester3? usgTrimester3;
  RencanaKonsultasi? rencanaKonsultasi;
  SkriningKesehatan? skriningKesehatan;
  final _db = Pemeriksaandatabase();
  dynamic local;
  int? tri1;
  List<int> tri2 = [];
  List<int> tri3 = [];
  List<Map<String, dynamic>> dataList = [];
  bool isLoading = true;

  _idPemeriksaan() async {
    int? id1;
    List<int> id2 = [];
    List<int> id3 = [];

    dataList = await _db.getAllDetailPemeriksaan(widget.id);

    for (var item in dataList) {
      final jenisTrimester = item['trimester'];
      final id = item['id'];

      if (jenisTrimester == 'trimester1' || jenisTrimester == '1') {
        id1 = id;
      } else if (jenisTrimester == 'trimester2' || jenisTrimester == '2') {
        id2.add(id);
      } else if (jenisTrimester == 'trimester3' || jenisTrimester == '3') {
        id3.add(id);
      }
    }

    setState(() {
      tri1 = id1;
      tri2 = id2;
      tri3 = id3;
      isLoading = false;
    });

    if (tri1 != null) {
      _dataPemeriksaan();
    }
  }

  _dataPemeriksaan() async {
    List<dynamic> result = await _db.getTrimester1(tri1!);
    setState(() {
      local = result;
    });
  }

  @override
  void initState() {
    super.initState();
    _idPemeriksaan();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(
              kToolbarHeight + 48), 
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 77, 129, 231), 
                  Color.fromARGB(255, 255, 255, 255), 
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  SizedBox(
                    height: kToolbarHeight,
                    child: Row(
                      children: [
                        IconButton(
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Expanded(
                          child: Text(
                            widget.label,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(
                            width: 48),
                      ],
                    ),
                  ),
                  const TabBar(
                    indicatorColor: Color.fromARGB(255, 0, 0, 0),
                    labelColor: Color.fromARGB(255, 0, 0, 0),
                    unselectedLabelColor: Color.fromARGB(179, 0, 0, 0),
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    tabs: [
                      Tab(text: "Trimester 1"),
                      Tab(text: "Trimester 2"),
                      Tab(text: "Trimester 3"),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  tri1 == null
                      ? const Center(
                          child: Text('Data Trimester 1 belum tersedia'))
                      : Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Trimester1Screen(id: tri1!),
                        ),
                  tri2.isEmpty
                      ? const Center(
                          child: Text('Data Trimester 2 belum tersedia'))
                      : Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Trimester2Screen(pemeriksaanIds: tri2),
                        ),
                  tri3.isEmpty
                      ? const Center(
                          child: Text('Data Trimester 3 belum tersedia'))
                      : Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Trimester3Screen(pemeriksaanIds: tri3),
                        ),
                ],
              ),
      ),
    );
  }
}
