import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:posyandu_mob/core/database/UserDatabase.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/LabTrimester3.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/Pemeriksaan.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/PemeriksaanFisik.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/PemeriksaanKehamilan.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/PemeriksaanRutin.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/RencanaKonsultasi.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/SkriningKesehatan.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/UsgTrimester3.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/Trimester3.dart';
import 'package:posyandu_mob/core/services/AnggotaService.dart';
import 'package:posyandu_mob/core/services/pemeriksaanService.dart';
import 'package:posyandu_mob/screens/navigation/drawerKader_screen.dart';
import 'package:posyandu_mob/screens/pelayanan/pemeriksaan_screen.dart';

class Trimestr3 extends StatefulWidget {
  const Trimestr3({super.key});

  @override
  State<Trimestr3> createState() => _Trimestr3State();
}

class _Trimestr3State extends State<Trimestr3> {
  late TabController _tabController;
  int _currentStep = 0;
  final _formKeyStep1 = GlobalKey<FormState>();
  final _formKeyStep2 = GlobalKey<FormState>();
  final _formKeyStep3 = GlobalKey<FormState>();

  // State checkbox
  List<String> _selectedRiwayatKesehatan = [];
  //rutin
  final TextEditingController _tanggalPeriksaController =
      TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _tempatPeriksaController =
      TextEditingController();
  final TextEditingController _beratBadanController = TextEditingController();
  final TextEditingController _lilaController = TextEditingController();
  final TextEditingController _tekananDiastolController =
      TextEditingController();
  final TextEditingController _tekananSistolController =
      TextEditingController();
  final TextEditingController _tinggiRahimController = TextEditingController();
  final TextEditingController _denyutJantungJaninController =
      TextEditingController();
  final TextEditingController _konselingController = TextEditingController();
  final TextEditingController _skriningController = TextEditingController();
  final TextEditingController _tabletDarahController = TextEditingController();
  final TextEditingController _proteinUrinController = TextEditingController();
  final TextEditingController _testLabController = TextEditingController();

  // ini lab Trimester 3
  final TextEditingController hemoglobinController = TextEditingController();
  final TextEditingController proteinUrin = TextEditingController();
  final TextEditingController hemoglobinRtl = TextEditingController();
  final TextEditingController proteinRtl = TextEditingController();
  final TextEditingController urinReduksiRtl = TextEditingController();

// ini skrining Kesehatan Jiwa
  String? skriningJiwa;
  String? tindakLanjutJiwa;
  String? perluRujukanValue;
  bool perluRujukan = false;
  String? pilihanKontrasepsi;

//usg
  final TextEditingController _usgTrimester3 = TextEditingController();
  final TextEditingController _umurUsgTrimester1Controller =
      TextEditingController();
  final TextEditingController _umurUsgTrimester3Controller =
      TextEditingController();
  final TextEditingController _selisihUKUsgController = TextEditingController();
  final TextEditingController _jumlahBayiController = TextEditingController();
  final TextEditingController _letakBayiController = TextEditingController();
  final TextEditingController _presentasiController = TextEditingController();
  final TextEditingController _keadaanBayiController = TextEditingController();
  final TextEditingController _djjStatusController = TextEditingController();
  final TextEditingController _lokasiPlasentaController =
      TextEditingController();
  final TextEditingController _jumlahCairanController = TextEditingController();
  final TextEditingController _djjController = TextEditingController();
  final TextEditingController _sdpController = TextEditingController();
  final TextEditingController _bpdController = TextEditingController();
  final TextEditingController _hcController = TextEditingController();
  final TextEditingController _acController = TextEditingController();
  final TextEditingController _flController = TextEditingController();
  final TextEditingController _efwController = TextEditingController();
  final TextEditingController _bpdMingguController = TextEditingController();
  final TextEditingController _hcMingguController = TextEditingController();
  final TextEditingController _acMingguController = TextEditingController();
  final TextEditingController _flMingguController = TextEditingController();
  final TextEditingController _efwMingguController = TextEditingController();
  final TextEditingController _kecuigaanController = TextEditingController();
  final TextEditingController _alasanController = TextEditingController();

//rencana konsultasi
  final TextEditingController _rencanaController = TextEditingController();
  final TextEditingController _kontrasepsiController = TextEditingController();
  final TextEditingController _kebutuhanController = TextEditingController();

  int? _selectedId;
  int? _selectedIdLokasi;
  int? petugas_id;
  bool isLoading = false;
  PemeriksaanService service = PemeriksaanService();

// konseling
  String? konseling;

  String getOriginalValueFromEncodedController(
      TextEditingController controller, List<String> options) {
    final encodedValue = controller.text.trim();
    final decoded = encodedValue.replaceAll('_', ' ').toLowerCase();

    return options.firstWhere(
      (option) => option.toLowerCase() == decoded,
      orElse: () => encodedValue, // return apa adanya jika tidak cocok
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      helpText: 'Pilih Tanggal Pemeriksaan',
    );
    if (picked != null) {
      setState(() {
        _tanggalPeriksaController.text =
            DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  void _nextStep() {
    if (_currentStep == 0 && _formKeyStep1.currentState!.validate()) {
      setState(() => _currentStep++);
    }
    if (_currentStep == 1 && _formKeyStep2.currentState!.validate()) {
      setState(() => _currentStep++);
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  final _buttonRadius = BorderRadius.circular(8);
  int imunisasiSelected = -1;

  Future<List<Map<String, dynamic>>> fetchSuggestion(String nama) async {
    return await PemeriksaanService().fetchSuggestion(nama);
  }

  Future<List<Map<String, dynamic>>> fetchSuggestionLokasi(String nama) async {
    return await AnggotaService().fetchSuggestion();
  }

  Future<void> _getID() async {
    dynamic user = await UserDatabase().readUser();
    if (user != null) {
      setState(() {
        petugas_id = user.anggota.id;
      });
    }
  }

  Widget _buildSuggestionLokasi(TextEditingController controller) {
    return TypeAheadField<Map<String, dynamic>>(
      controller: controller,
      suggestionsCallback: fetchSuggestionLokasi,
      builder: (context, controller, focusNode) {
        return TextFormField(
          controller: controller,
          focusNode: focusNode,
          decoration: const InputDecoration(
            labelText: 'Cari Posyandu',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Lokasi wajib diisi';
            }
            if (_selectedId == 0) {
              return 'Silakan pilih dari daftar saran';
            }
            return null;
          },
        );
      },
      itemBuilder: (context, suggestion) {
        return ListTile(
          title: Text(suggestion['nama']),
        );
      },
      onSelected: (suggestion) {
        _tempatPeriksaController.text = suggestion['nama'];
        _selectedIdLokasi = suggestion['id'];
      },
      emptyBuilder: (context) => const Padding(
        padding: EdgeInsets.all(8),
        child: Text("Nama Posyandu tidak ditemukan"),
      ),
    );
  }

  void _saveData() async {
    if (_currentStep == 2 && !_formKeyStep3.currentState!.validate()) {
      return;
    }
    setState(() {
      isLoading = true;
    });

    try {
      await _getID();

      final pemeriksaan = PemeriksaanKehamilan(
        jenisPemeriksaan: "trimester3",
        kehamilanId: _selectedId,
        kaderId: petugas_id,
        tanggalPemeriksaan:
            DateTime.tryParse(_tanggalPeriksaController.text.trim()) ??
                DateTime.now(),
        tempatPemeriksaan: _selectedIdLokasi,
      );

      final trimester3Data = Trimester3(
        pemeriksaanRutin: PemeriksaanRutin(
          beratBadan: int.parse(_beratBadanController.text.trim()),
          tinggiRahim: _tinggiRahimController.text.trim(),
          tekananDarahSistol: int.parse(_tekananSistolController.text.trim()),
          tekananDarahDiastol: int.parse(_tekananDiastolController.text.trim()),
          letakDanDenyutNadiBayi: _denyutJantungJaninController.text.trim(),
          lingkarLenganAtas: int.parse(_lilaController.text.trim()),
          tabletTambahDarah: _tabletDarahController.text.trim(),
          konseling: _konselingController.text.trim(),
          skriningDokter: _skriningController.text.trim(),
          tesLabGulaDarah: _testLabController.text.trim(),
          proteinUrin: _proteinUrinController.text.trim(),
        ),
        skriningKesehatan: SkriningKesehatan(
          skriningJiwa: skriningJiwa,
          tindakLanjutJiwa: tindakLanjutJiwa,
          perluRujukan: perluRujukanValue,
        ),
        pemeriksaanFisik: PemeriksaanFisik(
          konjungtiva: _selectedKonjungtiva,
          sklera: _selectedSklera,
          leher: _selectedLeher,
          kulit: _selectedKulit,
          gigiMulut: _selectedGigiMulut,
          tht: _selectedTht,
          jantung: _selectedJantung,
          paru: _selectedParu,
          perut: _selectedPerut,
          tungkai: _selectedTungkai,
        ),
        usgTrimester3: UsgTrimester3(
          usgTrimester3: _usgTrimester3.text,
          umurKehamilanUsgTrimester1:
              int.parse(_umurUsgTrimester3Controller.text.trim()),
          umurKehamilanUsgTrimester3:
              int.parse(_umurUsgTrimester3Controller.text.trim()),
          selisihUkUsg1HphtDenganTrimester3:
              _selisihUKUsgController.text.trim(),
          jumlahBayi: _jumlahBayiController.text.trim(),
          letakBayi: _letakBayiController.text.trim().trim(),
          presentasiBayi: _presentasiController.text.trim(),
          keadaanBayi: _keadaanBayiController.text.trim(),
          djjStatus: _djjStatusController.text.trim(),
          lokasiPlasenta: _lokasiPlasentaController.text.trim(),
          jumlahCairanKetuban: _jumlahCairanController.text.trim(),
          bpd: double.parse(_bpdController.text.trim()),
          hc: double.parse(_hcController.text.trim()),
          ac: double.parse(_acController.text.trim()),
          fl: double.parse(_flController.text.trim()),
          efw: double.parse(_efwController.text.trim()),
          hcSesuaiMinggu: int.parse(_hcMingguController.text.trim()),
          bpdSesuaiMinggu: int.parse(_bpdMingguController.text.trim()),
          acSesuaiMinggu: int.parse(_acMingguController.text.trim()),
          flSesuaiMinggu: int.parse(_flMingguController.text.trim()),
          efwSesuaiMinggu: int.parse(_efwMingguController.text.trim()),
          kecurigaanTemuanAbnormal: _kecuigaanController.text.trim(),
          keterangan: _alasanController.text.trim(),
          djj: _djjController.text.trim(),
          sdp: _sdpController.text.trim(),
        ),
        labTrimester3: LabTrimester3(
          hemoglobin: double.parse(hemoglobinController.text.trim()),
          hemoglobinRtl: hemoglobinRtl.text.trim(),
          proteinUrin: double.parse(proteinUrin.text.trim()),
          proteinUrinRtl: proteinRtl.text.trim(),
          urinReduksi: urineReduksiValue,
          urinReduksiRtl: urinReduksiRtl.text.trim(),
        ),
        rencanaKonsultasi: RencanaKonsultasi(
          rencanaKonsultasiLanjut: _selectedRiwayatKesehatan,
          rencanaProsesMelahirkan: _rencanaController.text.trim(),
          pilihanKontrasepsi: pilihanKontrasepsi =
              getOriginalValueFromEncodedController(
            _kontrasepsiController,
            [
              "AKDR",
              "Pil",
              "Suntik",
              "Steril",
              "MAL",
              "Implan",
            ],
          ),
          kebutuhanKonseling: konseling?.toLowerCase(),
        ),
      );

      final response =
          await service.pemeriksaanTrimester3(pemeriksaan, trimester3Data);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data pemeriksaan berhasil disimpan')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const DrawerkaderScreen(
              initialScreen: PemeriksaanScreen(),
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Gagal menyimpan data: ${response.statusCode ?? 'Unknown error'}')),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildTrimester3WithSteps();
  }

  Widget _buildTrimester3WithSteps() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: () {
              switch (_currentStep) {
                case 0:
                  return _buildStep1();
                case 1:
                  return _buildStep2();
                case 2:
                  return _buildStep3();
                default:
                  return Container();
              }
            }(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              if (_currentStep > 0)
                ElevatedButton(
                  onPressed: _prevStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: _buttonRadius,
                    ),
                  ),
                  child: const Text("Sebelumnya",
                      style: TextStyle(color: Colors.white)),
                )
              else
                const SizedBox(width: 100),
              const Spacer(),
              ElevatedButton(
                onPressed: _currentStep < 2 ? _nextStep : _saveData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: _buttonRadius,
                  ),
                ),
                child: Text(
                  _currentStep < 2 ? "Lanjut" : "Simpan",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStep1() {
    return Form(
      key: _formKeyStep1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Catatan Pemeriksaan",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Text(
                "Langkah ${(_currentStep + 1).toString()} dari 3",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildSuggestion(),
          const SizedBox(height: 12),
          _buildDateField("Tanggal Periksa", _tanggalPeriksaController,
              () => _selectDate(context)),
          _buildSuggestionLokasi(_tempatPeriksaController),
          const SizedBox(height: 12),
          _buildTextFieldWithSuffix("Timbang BB", "Kg", _beratBadanController),
          _buildTextFieldWithSuffix("Lingkar Lengan", "Cm", _lilaController),
          _buildBloodPressureField(),
          _buildTextField("Tinggi Rahim", _tinggiRahimController),
          _buildTextField(
              "Denyut Jantung Janin", _denyutJantungJaninController),
          _buildTextField("Konseling", _konselingController),
          _buildTextField("Skrining Dokter", _skriningController),
          _buildTextField("Tablet Tambah Darah", _tabletDarahController),
          _buildTextField("Tes Lab Protein Urine", _proteinUrinController),
          _buildTextField("Tes Lab Gula Darah", _testLabController),
        ],
      ),
    );
  }

  //ini group fisik
  String? _selectedKonjungtiva;
  String? _selectedSklera;
  String? _selectedLeher;
  String? _selectedKulit;
  String? _selectedGigiMulut;
  String? _selectedTht;
  String? _selectedJantung;
  String? _selectedParu;
  String? _selectedPerut;
  String? _selectedTungkai;

  Widget _buildStep2() {
    return Form(
      key: _formKeyStep2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Pemeriksaan Fisik",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Text(
                "Langkah ${(_currentStep + 1).toString()} dari 3",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 20),
          pemeriksaanFisikView(),
          const SizedBox(height: 20),
          const Text(
            "USG Trimester III",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 10),
          usgTrimester3InputView(),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    final List<String> rencanaKonsultasi = [
      "Gizi",
      "Kebidanan",
      "Anak",
      "Penyakit Dalam",
      "Neurologi",
      "THT",
      "Psikiatri",
      "Lain-lain",
    ];

    return Form(
        key: _formKeyStep3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Pemeriksaan Laboratorium",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Text(
                  "Langkah ${_currentStep + 1} dari 3",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 20),
            pemeriksaanLabView(),
            const SizedBox(height: 20),
            const Text(
              "Skrining Kesehatan Jiwa",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SkriningView(),
            const SizedBox(height: 20),
            const Text(
              "Rencana Konsultasi Lanjut",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 0,
              children: rencanaKonsultasi.map((item) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width * 0.33,
                  child: CheckboxListTile(
                    value: _selectedRiwayatKesehatan.contains(item),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          _selectedRiwayatKesehatan.add(item);
                        } else {
                          _selectedRiwayatKesehatan.remove(item);
                        }
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(
                      item,
                      style: const TextStyle(fontSize: 12),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    dense: true,
                    visualDensity: VisualDensity.compact,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            const Text(
              "Rencana Proses Melahirkan",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            prosesMelahirkan(),
            const SizedBox(height: 6),
            const Text(
              "Rencana Kontrasepsi",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            rencanaKontrasepsi(),
            const SizedBox(height: 8),
            const Text(
              "Kebutuhan Konseling",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Konseling(),
          ],
        ));
  }

  String urineReduksiValue = "Negatif";

  Widget pemeriksaanLabView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // === Hemoglobin ===
        const Text("Hemoglobin",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 4),
        TextFormField(
          validator: (value) =>
              value!.isEmpty ? 'Field Tidak Boleh Kosong' : null,
          decoration: const InputDecoration(
            hintText: "Nilai",
            suffixText: "g/dL",
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          ),
          keyboardType: TextInputType.number,
          controller: hemoglobinController,
          style: const TextStyle(fontSize: 13),
        ),
        const SizedBox(height: 4),
        TextFormField(
          decoration: const InputDecoration(
            hintText: "Rencana Tindak Lanjut",
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          ),
          style: const TextStyle(fontSize: 13),
          controller: hemoglobinRtl,
        ),

        const SizedBox(height: 14),

        // === Protein Urine ===
        const Text("Protein Urine",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 4),
        TextFormField(
          validator: (value) =>
              value!.isEmpty ? 'Field Tidak Boleh Kosong' : null,
          decoration: const InputDecoration(
            hintText: "Nilai",
            suffixText: "Mg/dL",
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          ),
          keyboardType: TextInputType.number,
          controller: proteinUrin,
          style: const TextStyle(fontSize: 13),
        ),
        const SizedBox(height: 4),
        TextFormField(
          decoration: const InputDecoration(
            hintText: "Rencana Tindak Lanjut",
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          ),
          style: const TextStyle(fontSize: 13),
          controller: proteinRtl,
        ),

        const SizedBox(height: 14),

        // === Urine Reduksi ===
        const Text("Urine Reduksi",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 6),
        Table(
          border:
              TableBorder.all(color: const Color.fromARGB(255, 137, 179, 243)),
          columnWidths: const {
            0: FixedColumnWidth(90),
            1: FlexColumnWidth(),
          },
          children: [
            TableRow(
              children: [
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(6),
                  child: const Text("Nilai Urine Reduksi ",
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                ),
                Padding(
                  padding: const EdgeInsets.all(6),
                  child: Wrap(
                    spacing: 4,
                    runSpacing: 0,
                    children: ["Negatif", "+1", "+2", "+3", "+4"].map((label) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Transform.scale(
                            scale: 0.8,
                            child: Radio<String>(
                              value: label,
                              groupValue: urineReduksiValue,
                              onChanged: (val) {
                                setState(() => urineReduksiValue =
                                    val!.toLowerCase().replaceAll(' ', '_'));
                              },
                            ),
                          ),
                          Text(label, style: const TextStyle(fontSize: 12)),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            TableRow(
              children: [
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(6),
                  child: const Text("Rencana Tindak Lanjut",
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                ),
                Padding(
                  padding: const EdgeInsets.all(6),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    ),
                    style: const TextStyle(fontSize: 13),
                    controller: urinReduksiRtl,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget pemeriksaanFisikView() {
    final List<Map<String, String>> pemeriksaanFisik = [
      {"label": "Konjungtiva", "value1": "anemia", "value2": "tidak_anemia"},
      {"label": "Sklera", "value1": "ikterik", "value2": "tidak_ikterik"},
      {"label": "Leher", "value1": "normal", "value2": "tidak_normal"},
      {"label": "Kulit", "value1": "normal", "value2": "tidak_normal"},
      {"label": "Gigi Mulut", "value1": "normal", "value2": "tidak_normal"},
      {"label": "THT", "value1": "normal", "value2": "tidak_normal"},
      {"label": "Jantung", "value1": "normal", "value2": "tidak_normal"},
      {"label": "Paru", "value1": "normal", "value2": "tidak_normal"},
      {"label": "Perut", "value1": "normal", "value2": "tidak_normal"},
      {"label": "Tungkai", "value1": "normal", "value2": "tidak_normal"},
    ];

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: pemeriksaanFisik.asMap().entries.map((entry) {
        int index = entry.key;
        Map<String, String> item = entry.value;

        String label = item["label"] ?? "";
        String val1 = item["value1"] ?? "";
        String val2 = item["value2"] ?? "";

        String label1 = val1.replaceAll('_', ' ');
        String label2 = val2.replaceAll('_', ' ');

        String formattedLabel1 =
            label1[0].toUpperCase() + label1.substring(1).toLowerCase();
        String formattedLabel2 =
            label2[0].toUpperCase() + label2.substring(1).toLowerCase();

        return FormField(validator: (formState) {
          if (getGroupValueFisik(index) == "" ||
              getGroupValueFisik(index) == null) {
            return "Silahkan pilih Pemeriksaan Fisik ";
          }
        }, builder: (formState) {
          return SizedBox(
            width: 170,
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.white),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(2, 2),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 137, 179, 243),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              label,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  border: const Border(
                                    right: BorderSide(
                                        color:
                                            Color.fromARGB(255, 180, 180, 180),
                                        width: 1),
                                  ),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Row(
                                    children: [
                                      Radio<String>(
                                        value: val1,
                                        groupValue: getGroupValueFisik(index),
                                        onChanged: (val) {
                                          setGroupValueFisik(index, val1);
                                          formState.didChange(val1);
                                        },
                                        visualDensity: const VisualDensity(
                                            horizontal: -4, vertical: -4),
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      Text(formattedLabel1,
                                          style: const TextStyle(fontSize: 12)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Row(
                                    children: [
                                      Radio<String>(
                                        value: val2,
                                        groupValue: getGroupValueFisik(index),
                                        onChanged: (val) {
                                          setGroupValueFisik(index, val2);
                                          formState.didChange(val2);
                                        },
                                        visualDensity: const VisualDensity(
                                            horizontal: -4, vertical: -4),
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      Text(formattedLabel2,
                                          style: const TextStyle(fontSize: 12)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                if (formState.hasError)
                  Text(
                    formState.errorText!,
                    style: const TextStyle(color: Colors.red),
                  ),
              ],
            ),
          );
        });
      }).toList(),
    );
  }

  String getGroupValueFisik(int index) {
    switch (index) {
      case 0:
        return _selectedKonjungtiva ?? "";
      case 1:
        return _selectedSklera ?? "";
      case 2:
        return _selectedLeher ?? "";
      case 3:
        return _selectedKulit ?? "";
      case 4:
        return _selectedGigiMulut ?? "";
      case 5:
        return _selectedTht ?? "";
      case 6:
        return _selectedJantung ?? "";
      case 7:
        return _selectedParu ?? "";
      case 8:
        return _selectedPerut ?? "";
      case 9:
        return _selectedTungkai ?? "";
      default:
        return "";
    }
  }

  void setGroupValueFisik(int index, String value) {
    setState(() {
      switch (index) {
        case 0:
          _selectedKonjungtiva = value;
        case 1:
          _selectedSklera = value;
        case 2:
          _selectedLeher = value;
        case 3:
          _selectedKulit = value;
        case 4:
          _selectedGigiMulut = value;
        case 5:
          _selectedTht = value;
        case 6:
          _selectedJantung = value;
        case 7:
          _selectedParu = value;
        case 8:
          _selectedPerut = value;
        case 9:
          _selectedTungkai = value;
        default:
          "";
      }
    });
  }

  Widget prosesMelahirkan() {
    return Column(
      children: [
        buildDropdownFieldVertical(
          "Pilih proses melahirkan",
          ["Normal", "Pervaginam Berbantu", "Sectio Caesaria"],
          _rencanaController,
        ),
      ],
    );
  }

  Widget rencanaKontrasepsi() {
    return Column(
      children: [
        buildDropdownFieldVertical(
          "Pilih rencana kontrasepsi",
          ["AKDR", "Pil", "Suntik", "Steril", "MAL", "Implan", "Belum memilih"],
          _kontrasepsiController,
        ),
      ],
    );
  }

  Widget Konseling() {
    final List<Map<String, dynamic>> konselingItems = [
      {
        "label": "Kebutuhan Konseling",
        "options": ["Ya", "Tidak"],
        "groupValue": konseling,
        "onChanged": (val) {
          setState(() {
            konseling = val!.toString().replaceAll(' ', '_');
          });
        },
      },
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: konselingItems.map((item) {
        return FormField(validator: (formState) {
          if (item["groupValue"] == null) {
            return 'Field Tidak Boleh Kosong';
          }
        }, builder: (formState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 180,
                      child: Text(
                        item["label"] ?? "",
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w400),
                      ),
                    ),
                    Row(
                      children: (item["options"] as List<String>).map((option) {
                        return Row(
                          children: [
                            Radio<String>(
                              value: option,
                              groupValue: item["groupValue"],
                              visualDensity: const VisualDensity(
                                  horizontal: -4, vertical: -4),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              onChanged: (val) {
                                item["onChanged"](val);
                                formState.didChange(val);
                              },
                            ),
                            SizedBox(
                              width: 60,
                              child: Text(
                                option,
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w400),
                              ),
                            ),
                            const SizedBox(width: 10),
                          ],
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              if (formState.hasError)
                Text(
                  formState.errorText!,
                  style: const TextStyle(color: Colors.red),
                ),
            ],
          );
        });
      }).toList(),
    );
  }

  Widget usgTrimester3InputView() {
    return Column(
      children: [
        buildDropdownFieldVertical("USG Trimester III telah dilakukan",
            ["Ya", "Tidak"], _usgTrimester3),
        _buildInputFieldNumber(
            "Umur Kehamilan berdasarkan USG Trimester I (minggu)",
            _umurUsgTrimester1Controller),
        _buildInputFieldNumber("Umur Kehamilan berdasarkan HPHT (minggu)",
            _umurUsgTrimester1Controller),
        _buildInputFieldNumber(
            "Umur Kehamilan berdasarkan biometrik bayi USG Trimester III (minggu)",
            _umurUsgTrimester3Controller),
        buildDropdownFieldVertical(
            "Apakah terdapat selisih 3 minggu atau lebih dengan UK USG Trimester I/HPHT",
            ["Ya", "Tidak"],
            _selisihUKUsgController),
        buildDropdownFieldVertical(
            "Jumlah Bayi", ["Tunggal", "Kembar"], _jumlahBayiController),
        buildDropdownFieldVertical(
            "Letak Bayi",
            ["Intrauterin", "Extrauterin", "Tidak di kenali"],
            _letakBayiController),
        buildDropdownFieldVertical("Presentasi Bayi",
            ["Kepala", "Bokong", "Letak Lintang"], _presentasiController),
        buildDropdownFieldVertical(
            "Keadaan Bayi", ["Hidup", "Meninggal"], _keadaanBayiController),
        _buildInputFieldNumber("DJJ (X/menit)", _djjController),
        buildDropdownFieldVertical(
            "Kondisi DJJ", ["Normal", "Tidak Normal"], _djjStatusController),
        buildDropdownFieldVertical(
            "Lokasi Plasenta",
            ["Fundus", "Corpus", "Letak Rendah", "Previa"],
            _lokasiPlasentaController),
        _buildInputFieldNumber("SDP (cm)", _sdpController),
        buildDropdownFieldVertical("Kondisi Cairan Ketuban",
            ["Cukup", "Kurang", "Berlebih"], _jumlahCairanController),
        buildBiometriRow("BPD", "cm", _bpdController, _bpdMingguController),
        buildBiometriRow("HC", "cm", _hcController, _hcMingguController),
        buildBiometriRow("AC", "cm", _acController, _acMingguController),
        buildBiometriRow("FL", "cm", _flController, _flMingguController),
        buildBiometriRow(
            "EFW/TBJ", "gram", _efwController, _efwMingguController),
        buildDropdownFieldVertical("Kecurigaan Temuan Abnormal",
            ["Ya", "Tidak"], _kecuigaanController),
        buildInputFieldVertical("Keterangan", _alasanController,
            isRequired: false),
      ],
    );
  }

  Widget buildBiometriRow(String label, String unit,
      TextEditingController controller1, TextEditingController controller2) {
    return Row(
      children: [
        Expanded(child: _buildInputFieldNumber("$label ($unit)", controller1)),
        const SizedBox(width: 10),
        Expanded(
            child: _buildInputFieldNumber("Sesuai: ... minggu", controller2)),
      ],
    );
  }

  Widget _buildInputFieldNumber(
      String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 13)),
          const SizedBox(height: 6),
          TextFormField(
            validator: (value) =>
                value!.isEmpty ? 'Field Tidak Boleh Kosong' : null,
            style: const TextStyle(fontSize: 13),
            keyboardType: TextInputType.number,
            controller: controller,
            decoration: InputDecoration(
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInputFieldVertical(String label, TextEditingController controller,
      {bool isRequired = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 13)),
          const SizedBox(height: 6),
          TextFormField(
            validator: (value) => (value!.isEmpty && isRequired)
                ? 'Field Tidak Boleh Kosong'
                : null,
            style: const TextStyle(fontSize: 13),
            controller: controller,
            decoration: InputDecoration(
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDropdownFieldVertical(
      String label, List<String> options, TextEditingController controller) {
    String? selectedValue;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 13)),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            validator: (value) =>
                value == null ? 'Field Tidak Boleh Kosong' : null,
            value: selectedValue,
            onChanged: (value) {
              selectedValue = value;
              setState(() {
                controller.text =
                    selectedValue!.toLowerCase().replaceAll(' ', '_');
              });
            },
            items: options.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: const TextStyle(fontSize: 13)),
              );
            }).toList(),
            decoration: InputDecoration(
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget SkriningView() {
    final List<Map<String, dynamic>> skriningItems = [
      {
        "label": "Skrining Kesehatan Jiwa",
        "options": ["Ya", "Tidak"],
        "groupValue": skriningJiwa,
        "onChanged": (val) {
          setState(() {
            skriningJiwa = val!;
          });
        },
      },
      {
        "label": "Tindak Lanjut Hasil Skrining Kesehatan Jiwa",
        "options": ["Edukasi", "Konseling"],
        "groupValue": tindakLanjutJiwa,
        "onChanged": (val) {
          setState(() {
            tindakLanjutJiwa = val!;
          });
        },
      },
      {
        "label": "Perlu Rujukan",
        "options": ["Ya", "Tidak"],
        "groupValue": perluRujukanValue,
        "onChanged": (val) {
          setState(() {
            perluRujukanValue = val!;
            perluRujukan = val == "Ya";
          });
        },
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: skriningItems.map((item) {
        return FormField(validator: (formState) {
          if (item["groupValue"] == null) {
            return 'Field Tidak Boleh Kosong';
          }
        }, builder: (formState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 180,
                      child: Text(
                        item["label"] ?? "",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w400),
                      ),
                    ),
                    Row(
                      children: (item["options"] as List<String>).map((option) {
                        return Row(
                          children: [
                            Radio<String>(
                              value: option,
                              groupValue: item["groupValue"],
                              visualDensity: const VisualDensity(
                                  horizontal: -4, vertical: -4),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              onChanged: (val) {
                                item["onChanged"](val);
                                formState.didChange(val);
                              },
                            ),
                            SizedBox(
                              width: 60,
                              child: Text(
                                option,
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w400),
                              ),
                            ),
                            const SizedBox(width: 10),
                          ],
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              if (formState.hasError)
                Text(
                  formState.errorText!,
                  style: const TextStyle(color: Colors.red),
                ),
            ],
          );
        });
      }).toList(),
    );
  }

  Widget buildInputField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 13)),
          const SizedBox(height: 4),
          TextFormField(
            controller: controller,
            style: const TextStyle(fontSize: 13),
            decoration: InputDecoration(
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInputFieldNumber(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 13)),
          const SizedBox(height: 4),
          TextFormField(
            controller: controller,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(fontSize: 13),
            decoration: InputDecoration(
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDropdownField(
    String label,
    List<String> options,
    String? selectedValue,
    ValueChanged<String?> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 13)),
          const SizedBox(height: 4),
          DropdownButtonFormField<String>(
            validator: (value) =>
                value!.isEmpty ? 'Field Tidak Boleh Kosong' : null,
            value: selectedValue,
            items: options
                .map((opt) => DropdownMenuItem(
                      value: opt,
                      child: Text(opt, style: const TextStyle(fontSize: 13)),
                    ))
                .toList(),
            onChanged: onChanged,
            decoration: InputDecoration(
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        validator: (value) =>
            value!.isEmpty ? 'Field Tidak Boleh Kosong' : null,
        style: const TextStyle(fontSize: 14),
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 13),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),
    );
  }

  Widget _buildTextFieldWithSuffix(
      String label, String suffix, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        validator: (value) =>
            value!.isEmpty ? 'Field Tidak Boleh Kosong' : null,
        style: const TextStyle(fontSize: 14),
        keyboardType: TextInputType.number,
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 13),
          suffixText: suffix,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),
    );
  }

  Widget _buildDateField(
      String label, TextEditingController controller, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        validator: (value) =>
            value!.isEmpty ? 'Field Tidak Boleh Kosong' : null,
        controller: controller,
        readOnly: true,
        onTap: onTap,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 13),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          suffixIcon: const Icon(Icons.calendar_month),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),
    );
  }

  Widget _buildBloodPressureField() {
    return Row(
      children: [
        Expanded(
          child: _buildTextFieldWithSuffix(
              "Tekanan Darah (Sistolik)", "mmHg", _tekananSistolController),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildTextFieldWithSuffix(
              "Tekanan Darah (Diastolik)", "mmHg", _tekananDiastolController),
        ),
      ],
    );
  }

  Widget _buildSuggestion() {
    return TypeAheadField<Map<String, dynamic>>(
      controller: _namaController,
      suggestionsCallback: fetchSuggestion,
      builder: (context, controller, focusNode) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          decoration: const InputDecoration(
            labelText: 'Cari Nama',
            border: OutlineInputBorder(),
          ),
        );
      },
      itemBuilder: (context, suggestion) {
        return ListTile(
          title: Text(suggestion['nama']),
        );
      },
      onSelected: (suggestion) {
        _namaController.text = suggestion['nama'];
        _selectedId = suggestion['id'];
        print("Nama: ${suggestion['nama']}, ID: $_selectedId");
      },
      emptyBuilder: (context) => const Padding(
        padding: EdgeInsets.all(8),
        child: Text("Nama tidak ditemukan"),
      ),
    );
  }
}
