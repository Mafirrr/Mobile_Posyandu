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
import 'package:posyandu_mob/core/models/pemeriksaan/Nifas.dart';
import 'package:posyandu_mob/screens/Kehamilan/detail/Trimester2Screen.dart';
import 'package:posyandu_mob/screens/Kehamilan/detail/Trimester3Screen.dart';
import 'package:posyandu_mob/screens/Kehamilan/detail/trimester1.dart';
import 'package:posyandu_mob/screens/Kehamilan/detail/nifasScreen.dart';

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
  Nifas? nifas;

  final _db = Pemeriksaandatabase();
  dynamic local;
  int? tri1;
  List<int> tri2 = [];
  List<int> tri3 = [];
  int? nifasId;
  List<Map<String, dynamic>> dataList = [];
  bool isLoading = true;

  int selectedTrimester = 0;

  _idPemeriksaan() async {
    int? id1;
    List<int> id2 = [];
    List<int> id3 = [];
    int? nifas;

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
      } else if (jenisTrimester == 'nifas') {
        nifas = id;
      }
    }

    setState(() {
      tri1 = id1;
      tri2 = id2;
      tri3 = id3;
      nifasId = nifas;
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 77, 129, 231),
        title: Text(
          widget.label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: List.generate(4, (index) {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                selectedTrimester = index;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: selectedTrimester == index
                                    ? const Color.fromARGB(255, 77, 129, 231)
                                    : Colors.white,
                                foregroundColor: selectedTrimester == index
                                    ? Colors.white
                                    : Colors.black,
                                side: const BorderSide(
                                  color: Color.fromARGB(255, 77, 129, 231),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                )),
                            child: Text(
                                index < 3 ? 'Trimester ${index + 1}' : 'Nifas'),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      if (selectedTrimester == 0) {
                        return tri1 == null
                            ? const Center(
                                child: Text('Data Trimester 1 belum tersedia'))
                            : Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Trimester1Screen(id: tri1!),
                              );
                      } else if (selectedTrimester == 1) {
                        return tri2.isEmpty
                            ? const Center(
                                child: Text('Data Trimester 2 belum tersedia'))
                            : Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Trimester2Screen(
                                  pemeriksaanIds: tri2,
                                ),
                              );
                      } else if (selectedTrimester == 2) {
                        return tri3.isEmpty
                            ? const Center(
                                child: Text('Data Trimester 3 belum tersedia'))
                            : Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Trimester3Screen(
                                  pemeriksaanIds: tri3,
                                ),
                              );
                      } else {
                        return nifasId == null
                            ? const Center(
                                child: Text('Data Nifas belum tersedia'))
                            : Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: NifasScreen(),
                              );
                      }
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
