import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posyandu_mob/core/database/UserDatabase.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/LabTrimester1.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/PemeriksaanAwal.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/PemeriksaanFisik.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/PemeriksaanKehamilan.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/PemeriksaanKhusus.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/PemeriksaanRutin.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/SkriningKesehatan.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/Trimestr1.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/UsgTrimester1.dart';
import 'package:posyandu_mob/core/services/AnggotaService.dart';
import 'package:posyandu_mob/core/services/pemeriksaanService.dart';
import 'package:posyandu_mob/screens/navigation/drawerKader_screen.dart';
import 'package:posyandu_mob/screens/pelayanan/pemeriksaan_screen.dart';
import 'package:posyandu_mob/screens/profil/InformasiPribadiScreen.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class Trimester1 extends StatefulWidget {
  const Trimester1({super.key});

  @override
  State<Trimester1> createState() => _Trimester1State();
}

class _Trimester1State extends State<Trimester1> {
  late TabController _tabController;
  int _currentStep = 0;
  DateTime? date;
  final TextEditingController _namaController = TextEditingController();
  int? _selectedId;
  int? _selectedIdLokasi;
  int? petugas_id;

  final _formKeyStep1 = GlobalKey<FormState>();
  final _formKeyStep2 = GlobalKey<FormState>();
  final _formKeyStep3 = GlobalKey<FormState>();
  final _formKeyStep4 = GlobalKey<FormState>();

  // State checkbox
  List<String> _selectedRiwayatKesehatan = [];
  List<String> _selectedPerilaku = [];
  List<String> _selectedPenyakitKeluarga = [];

  //pemeriksaan rutin
  final TextEditingController _tanggalPeriksaController =
      TextEditingController();
  final TextEditingController _tempatPeriksaController =
      TextEditingController();
  final TextEditingController _beratBadanController = TextEditingController();
  final TextEditingController _tinggiBadanController = TextEditingController();
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
  final TextEditingController _golonganDarahController =
      TextEditingController();

  // ini lab Trimester 1
  final TextEditingController hemoglobinController = TextEditingController();
  final TextEditingController golonganDarahDanRhesus = TextEditingController();
  final TextEditingController gulaDarahController = TextEditingController();
  final TextEditingController hemoglobinRtl = TextEditingController();
  final TextEditingController rhesusRtl = TextEditingController();
  final TextEditingController gulaDarahRtl = TextEditingController();
  String? hiv;
  String? sifilis;
  String? hepatitisB;

//usg trimester 1
  final TextEditingController _hphtController = TextEditingController();
  final TextEditingController _haidController = TextEditingController();
  final TextEditingController _umurHphtController = TextEditingController();
  final TextEditingController _umurUsgController = TextEditingController();
  final TextEditingController _hplBerdasarHphtController =
      TextEditingController();
  final TextEditingController _hplBerdasarUsgController =
      TextEditingController();
  final TextEditingController _jumlahGSController = TextEditingController();
  final TextEditingController _jumlahBayiController = TextEditingController();
  final TextEditingController _diameterGSController = TextEditingController();
  final TextEditingController _gsHariController = TextEditingController();
  final TextEditingController _gsMingguController = TextEditingController();
  final TextEditingController _crlController = TextEditingController();
  final TextEditingController _crlHariController = TextEditingController();
  final TextEditingController _crlMingguController = TextEditingController();
  final TextEditingController _letakProdukController = TextEditingController();
  final TextEditingController _pulsasiController = TextEditingController();
  final TextEditingController _kecurigaanController = TextEditingController();
  final TextEditingController _alasanController = TextEditingController();

// ini skrining Kesehatan Jiwa
  String? skriningJiwa;
  String? tindakLanjutJiwa;
  String? perluRujukanValue;
  bool perluRujukan = false;
  bool isLoading = false;
  PemeriksaanService service = PemeriksaanService();

  String _mapCondition(String? value) {
    switch (value) {
      case "normal":
        return "positif";
      case "tidak_normal":
        return "negatif";
      default:
        return value ?? "";
    }
  }

  @override
  void initState() {
    super.initState();

    _hphtController.addListener(() {
      if (_hphtController.text.isNotEmpty) {
        try {
          final hphtDate = DateFormat('dd-MM-yyyy').parse(_hphtController.text);

          final now = DateTime.now();
          final umurKehamilanMinggu = now.difference(hphtDate).inDays ~/ 7;
          _umurHphtController.text = umurKehamilanMinggu.toString();

          final hpl = hphtDate.add(Duration(days: 280));
          _hplBerdasarHphtController.text =
              DateFormat('dd-MM-yyyy').format(hpl);
        } catch (e) {
          _umurHphtController.clear();
          _hplBerdasarHphtController.clear();
        }
      } else {
        _umurHphtController.clear();
        _hplBerdasarHphtController.clear();
      }
    });

    _umurUsgController.addListener(() {
      if (_umurUsgController.text.isNotEmpty) {
        try {
          final usiaMinggu = int.tryParse(_umurUsgController.text);
          if (usiaMinggu != null && usiaMinggu > 0) {
            final now = DateTime.now();
            final perkiraanHPHT = now.subtract(Duration(days: usiaMinggu * 7));
            final hplUsg = perkiraanHPHT.add(Duration(days: 280));
            _hplBerdasarUsgController.text =
                DateFormat('dd-MM-yyyy').format(hplUsg);
          } else {
            _hplBerdasarUsgController.clear();
          }
        } catch (e) {
          _hplBerdasarUsgController.clear();
        }
      } else {
        _hplBerdasarUsgController.clear();
      }
    });
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

  Future<void> _selectDateUsg(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      helpText: 'Pilih Tanggal Pemeriksaan',
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

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

  void _nextStep() {
    if (_currentStep == 0 && _formKeyStep1.currentState!.validate()) {
      setState(() => _currentStep++);
    }
    if (_currentStep == 1 && _formKeyStep2.currentState!.validate()) {
      setState(() => _currentStep++);
    }
    if (_currentStep == 2 && _formKeyStep3.currentState!.validate()) {
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

  void _saveData() async {
    if (_currentStep == 3 && !_formKeyStep4.currentState!.validate()) {
      return;
    }
    setState(() {
      isLoading = true;
    });

    try {
      await _getID();

      final pemeriksaan = PemeriksaanKehamilan(
        jenisPemeriksaan: "trimester1",
        kehamilanId: _selectedId,
        kaderId: petugas_id,
        tanggalPemeriksaan:
            DateTime.tryParse(_tanggalPeriksaController.text.trim()) ??
                DateTime.now(),
        tempatPemeriksaan: _selectedIdLokasi,
      );

      final trimester1Data = Trimestr1(
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
        pemeriksaanAwal: PemeriksaanAwal(
          hemoglobin: double.parse(hemoglobinController.text.trim()),
          tinggiBadan: int.parse(_tinggiBadanController.text.trim()),
          golonganDarah: selectedGolDarah,
          statusImunisasiTd: _selectedImunisasi,
          riwayatKesehatanIbuSekarang: _selectedRiwayatKesehatan,
          riwayatPenyakitKeluarga: _selectedPenyakitKeluarga,
          riwayatPerilaku: _selectedPerilaku,
        ),
        pemeriksaanKhusus: PemeriksaanKhusus(
          porsio: _selectedPorsio,
          uretra: _selectedUretra,
          vagina: _selectedVagina,
          vulva: _selectedVulva,
          fluksus: _mapCondition(_selectedFluksus),
          fluor: _mapCondition(_selectedFluor),
        ),
        labTrimester1: LabTrimester1(
          hemoglobin: double.parse(hemoglobinController.text.trim()),
          golonganDarahDanRhesus: golonganDarahDanRhesus.text.trim(),
          gulaDarah: double.parse(gulaDarahController.text.trim()),
          hemoglobinRtl: hemoglobinRtl.text.trim(),
          rhesusRtl: rhesusRtl.text.trim(),
          gulaDarahRtl: gulaDarahRtl.text.trim(),
          hiv: hiv?.toLowerCase().replaceAll(' ', '_') ?? '',
          sifilis: sifilis?.toLowerCase().replaceAll(' ', '_') ?? '',
          hepatitisB: hepatitisB?.toLowerCase().replaceAll(' ', '_') ?? '',
        ),
        usgTrimester1: UsgTrimester1(
          hpht: _hphtController.text.trim(),
          keteraturanHaid: _haidController.text.trim(),
          umurKehamilanBerdasarHpht: int.parse(_umurHphtController.text.trim()),
          umurKehamilanBerdasarkanUsg:
              int.parse(_umurUsgController.text.trim()),
          hplBerdasarkanHpht: _hplBerdasarHphtController.text.trim(),
          hplBerdasarkanUsg: _hplBerdasarUsgController.text.trim(),
          jumlahBayi: _jumlahBayiController.text.trim(),
          jumlahGs: _jumlahGSController.text.trim(),
          diametesGs: double.parse(_diameterGSController.text.trim()),
          gsHari: int.parse(_gsHariController.text.trim()),
          gsMinggu: int.parse(_gsMingguController.text.trim()),
          crl: int.parse(_crlController.text.trim()),
          crlHari: int.parse(_crlHariController.text.trim()),
          crlMinggu: int.parse(_crlMingguController.text.trim()),
          letakProdukKehamilan: _letakProdukController.text
              .trim()
              .toLowerCase()
              .replaceAll(' ', '_'),
          pulsasiJantung: _pulsasiController.text.trim(),
          kecurigaanTemuanAbnormal: _kecurigaanController.text.trim(),
          keterangan: _alasanController.text.trim(),
        ),
      );

      final response =
          await service.pemeriksaanTrimester1(pemeriksaan, trimester1Data);

      if (response?.statusCode == 200) {
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
                  'Gagal menyimpan data: ${response?.statusCode ?? 'Unknown error'}')),
        );
      }
    } catch (e) {
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
    return _buildTrimester1WithSteps();
  }

  Widget _buildTrimester1WithSteps() {
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
                case 3:
                  return _buildStep4();
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
                onPressed: _currentStep < 3 ? _nextStep : _saveData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: _buttonRadius,
                  ),
                ),
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Text(
                        _currentStep < 3 ? "Lanjut" : "Simpan",
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
                "Langkah " + (_currentStep + 1).toString() + " dari 4",
                style: TextStyle(fontSize: 12, color: Colors.grey),
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
          _buildTextFieldWithSuffix(
              "Tinggi Badan", "Cm", _tinggiBadanController),
          _buildTextFieldWithSuffix("Lingkar Lengan", "Cm", _lilaController),
          _buildBloodPressureField(),
          _buildTextField("Tinggi Rahim", _tinggiRahimController),
          _buildTextField(
              "Denyut Jantung Janin", _denyutJantungJaninController),
          _buildTextField("Konseling", _konselingController),
          _buildTextField("Skrining Dokter", _skriningController),
          _buildTextField("Tablet Tambah Darah", _tabletDarahController),
          _buildDropdownField("Golongan Darah", _golonganDarahController),
        ],
      ),
    );
  }

//ini group khusus
  String? _selectedPorsio;
  String? _selectedUretra;
  String? _selectedVagina;
  String? _selectedVulva;
  String? _selectedFluksus;
  String? _selectedFluor;
  String? _selectedImunisasi;

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
    final List<String> riwayatKesehatanIbu = [
      "Alergi",
      "Asma",
      "Autoimun",
      "Diabetes",
      "Hepatitis B",
      "Hipertensi",
      "Jantung",
      "Jiwa",
      "Sifilis",
      "TB",
    ];

    final List<String> riwayatPerilaku = [
      "Aktivitas fisik kurang",
      "Alkohol",
      "Merokok",
      "Kosmetik yang mengandung zat berbahaya",
      "Obat Teratogenik",
      "Pola makan berisiko",
    ];
    final List<String> riwayatPenyakitKeluarga = riwayatKesehatanIbu;

    final List<Map<String, String>> _imunisasiTd = [
      {"tt": "1", "selang": "-", "perlindungan": "Awal"},
      {"tt": "2", "selang": "1 bulan", "perlindungan": "3 tahun"},
      {"tt": "3", "selang": "6 bulan", "perlindungan": "5 tahun"},
      {"tt": "4", "selang": "12 bulan", "perlindungan": "10 tahun"},
      {"tt": "5", "selang": "12 bulan", "perlindungan": "> 25 tahun"},
    ];

    final List<String> pemeriksaanKhususOptions = [
      "Tidak ada pemeriksaan khusus",
      "USG",
      "Tes Darah",
      "Tes Urine",
      "Pemeriksaan Lainnya",
    ];
    int? _selectedPemeriksaanKhusus;

    return Form(
      key: _formKeyStep2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Riwayat Kesehatan Ibu Sekarang",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Text(
                "Langkah " + (_currentStep + 1).toString() + " dari 4",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 0,
            children: riwayatKesehatanIbu.map((item) {
              return SizedBox(
                width: MediaQuery.of(context).size.width * 0.44,
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
                  title: Text(item, style: const TextStyle(fontSize: 14)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          const Text(
            "Riwayat Perilaku Berisiko 1 Bulan Sebelum Hamil",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 0,
            children: riwayatPerilaku.map((item) {
              return SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: CheckboxListTile(
                  value: _selectedPerilaku.contains(item),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        _selectedPerilaku.add(item);
                      } else {
                        _selectedPerilaku.remove(item);
                      }
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(item, style: const TextStyle(fontSize: 14)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          const Text(
            "Riwayat Penyakit Keluarga",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 0,
            children: riwayatPenyakitKeluarga.map((item) {
              return SizedBox(
                width: MediaQuery.of(context).size.width * 0.44,
                child: CheckboxListTile(
                  value: _selectedPenyakitKeluarga.contains(item),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        _selectedPenyakitKeluarga.add(item);
                      } else {
                        _selectedPenyakitKeluarga.remove(item);
                      }
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(item, style: const TextStyle(fontSize: 14)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          const Text(
            "Status Imunisasi TD",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          FormField(validator: (formState) {
            if (_selectedImunisasi == null) {
              return "Silahkan pilih vaksin TT ";
            }
          }, builder: (formState) {
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (formState.hasError)
                    Text(
                      formState.errorText!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _imunisasiTd.length,
                      itemBuilder: (context, index) {
                        final item = _imunisasiTd[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Material(
                            color: imunisasiSelected == index
                                ? const Color(0xFFE3F2FD)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () => setState(() {
                                imunisasiSelected = index;
                                _selectedImunisasi =
                                    "t" + (index + 1).toString();
                                formState.didChange(_selectedImunisasi);
                              }),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 6),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: imunisasiSelected == index
                                        ? Colors.blue
                                        : Colors.transparent,
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Radio<String>(
                                      value: "t" + (index + 1).toString(),
                                      groupValue: _selectedImunisasi,
                                      visualDensity: const VisualDensity(
                                          horizontal: -4, vertical: -4),
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      onChanged: (val) => setState(() {
                                        _selectedImunisasi =
                                            "t" + (index + 1).toString();
                                        formState.didChange(_selectedImunisasi);
                                      }),
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Vaksin TT ${item['tt']}",
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          const SizedBox(height: 2),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Selang Waktu: ${item['selang']}",
                                                style: const TextStyle(
                                                    fontSize: 12),
                                              ),
                                              Text(
                                                "Perlindungan: ${item['perlindungan']}",
                                                style: const TextStyle(
                                                    fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ]);
          }),
          const SizedBox(height: 20),
          pemeriksaanKhususView()
        ],
      ),
    );
  }

  Widget pemeriksaanKhususView() {
    final List<String> pemeriksaanKhusus = [
      "Porsio",
      "Uretra",
      "Vagina",
      "Vulva",
      "Fluksus",
      "Fluor"
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Pemeriksaan Khusus",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        for (int i = 0; i < pemeriksaanKhusus.length; i += 2)
          Row(
            children: [
              Expanded(
                child: pemeriksaanKhususCell(i, pemeriksaanKhusus[i]),
              ),
              const SizedBox(width: 8),
              if (i + 1 < pemeriksaanKhusus.length)
                Expanded(
                  child: pemeriksaanKhususCell(i + 1, pemeriksaanKhusus[i + 1]),
                ),
            ],
          ),
      ],
    );
  }

  Widget pemeriksaanKhususCell(int index, String title) {
    return FormField(validator: (formState) {
      if (getGroupValueKhusus(index) == "" ||
          getGroupValueKhusus(index) == null) {
        return "Silahkan pilih Pemeriksaan Khusus ";
      }
    }, builder: (formState) {
      return Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: const Color.fromARGB(
                    255, 255, 255, 255), // Warna border putih
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5), // Warna bayangan
                  spreadRadius: 1, // Penyebaran shadow
                  blurRadius: 4, // Seberapa blur
                  offset: Offset(2, 2), // Arah bayangan (x, y)
                ),
              ],
              borderRadius: BorderRadius.circular(
                  8), // Opsional: biar sudutnya lebih lembut
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
                      title,
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
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: const Border(
                            right: BorderSide(
                                color: Color.fromARGB(255, 180, 180, 180),
                                width: 1),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            children: [
                              Radio<String>(
                                value: "normal",
                                groupValue: getGroupValueKhusus(index),
                                onChanged: (val) {
                                  setGroupValueKhusus(index, "normal");
                                  formState.didChange("normal");
                                },
                                visualDensity: const VisualDensity(
                                    horizontal: -4, vertical: -4),
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              ),
                              const Text("Normal",
                                  style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            children: [
                              Radio<String>(
                                value: "tidak_normal",
                                groupValue: getGroupValueKhusus(index),
                                onChanged: (val) {
                                  setGroupValueKhusus(index, "tidak_normal");
                                  formState.didChange("tidak_normal");
                                },
                                visualDensity: const VisualDensity(
                                    horizontal: -4, vertical: -4),
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              ),
                              const Text("Tidak Normal",
                                  style: TextStyle(fontSize: 12)),
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
          if (formState.hasError)
            Text(
              formState.errorText!,
              style: const TextStyle(color: Colors.red),
            ),
        ],
      );
    });
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

  String getGroupValueKhusus(int index) {
    switch (index) {
      case 0:
        return _selectedPorsio ?? "";
      case 1:
        return _selectedUretra ?? "";
      case 2:
        return _selectedVagina ?? "";
      case 3:
        return _selectedVulva ?? "";
      case 4:
        return _selectedFluksus ?? "";
      case 5:
        return _selectedFluor ?? "";
      default:
        return "";
    }
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

  void setGroupValueKhusus(int index, String value) {
    setState(() {
      switch (index) {
        case 0:
          _selectedPorsio = value;
          break;
        case 1:
          _selectedUretra = value;
          break;
        case 2:
          _selectedVagina = value;
          break;
        case 3:
          _selectedVulva = value;
          break;
        case 4:
          _selectedFluksus = value;
          break;
        case 5:
          _selectedFluor = value;
          break;
      }
    });
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

  Widget usgTrimester1InputView() {
    return Column(
      children: [
        _buildDateField("HPHT", _hphtController,
            () => _selectDateUsg(context, _hphtController)),
        buildDropdownFieldVertical(
            "Keteraturan Haid", ["Teratur", "Tidak Teratur"], _haidController),
        _buildInputFieldNumber(
            "Umur Kehamilan Berdasarkan HPHT (minggu)", _umurHphtController),
        _buildInputFieldNumber(
            "Umur Kehamilan Berdasarkan USG (minggu)", _umurUsgController),
        _buildDateField("HPL Berdasarkan HPHT", _hplBerdasarHphtController,
            () => _selectDateUsg(context, _hplBerdasarHphtController)),
        _buildDateField("HPL Berdasarkan USG", _hplBerdasarUsgController,
            () => _selectDateUsg(context, _hplBerdasarUsgController)),
        buildDropdownFieldVertical(
            "Jumlah GS", ["Tunggal", "Kembar"], _jumlahGSController),
        buildDropdownFieldVertical(
            "Jumlah Bayi", ["Tunggal", "Kembar"], _jumlahBayiController),
        _buildInputFieldNumber("Diameter GS (cm)", _diameterGSController),
        _buildInputFieldNumber("GS Hari", _gsHariController),
        _buildInputFieldNumber("GS Minggu", _gsMingguController),
        _buildInputFieldNumber("CRL (cm)", _crlController),
        _buildInputFieldNumber("CRL Hari", _crlHariController),
        _buildInputFieldNumber("CRL Minggu", _crlMingguController),
        buildDropdownFieldVertical(
            "Letak Produk Kehamilan",
            ["Intrauterin", "Extrauterin", "Tidak dapat ditemukan"],
            _letakProdukController),
        buildDropdownFieldVertical(
            "Pulsasi Jantung", ["Tampak", "Tidak Tampak"], _pulsasiController),
        buildDropdownFieldVertical("Kecurigaan Temuan Abnormal",
            ["Ya", "Tidak"], _kecurigaanController),
        buildInputFieldVertical("Keterangan", _alasanController,
            isRequired: false),
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

  Widget buildInputFieldVertical(
    String label,
    TextEditingController controller, {
    bool isRequired = true,
  }) {
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

  Widget _buildStep3() {
    return Form(
      key: _formKeyStep3,
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
                "Langkah ${(_currentStep + 1).toString()} dari 4",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 20),
          pemeriksaanFisikView(),
          const SizedBox(height: 20),
          const Text(
            "USG Trimester 1",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 10),
          usgTrimester1InputView(),
        ],
      ),
    );
  }

  Widget pemeriksaanLab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildInputFieldNumber("Hemoglobin", hemoglobinController),
        buildInputField("Golongan Darah dan Rhesus", golonganDarahDanRhesus),
        buildInputFieldNumber("Gula Darah", gulaDarahController),
        buildInputField("Hemoglobin RTL", hemoglobinRtl, isRequired: false),
        buildInputField("Rhesus RTL", rhesusRtl, isRequired: false),
        buildInputField("Gula Darah RTL", gulaDarahRtl, isRequired: false),
        buildDropdownField(
          "HIV",
          ["Reaktif", "Non Reaktif"],
          hiv,
          (val) => setState(() => hiv = val),
        ),
        buildDropdownField(
          "Sifilis",
          ["Reaktif", "Non Reaktif"],
          sifilis,
          (val) => setState(() => sifilis = val),
        ),
        buildDropdownField(
          "Hepatitis B",
          ["Reaktif", "Non Reaktif"],
          hepatitisB,
          (val) => setState(() => hepatitisB = val),
        ),
      ],
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
            return "Silahkan pilih Skrining Kesehatan Jiwa";
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
                Text(formState.errorText ?? "",
                    style: const TextStyle(color: Colors.red, fontSize: 12)),
            ],
          );
        });
      }).toList(),
    );
  }

  Widget buildInputField(
    String label,
    TextEditingController controller, {
    bool isRequired = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 13)),
          const SizedBox(height: 4),
          TextFormField(
            validator: (value) => (isRequired && value!.isEmpty)
                ? 'Field Tidak Boleh Kosong'
                : null,
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
            validator: (value) =>
                value!.isEmpty ? 'Field Tidak Boleh Kosong' : null,
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
          FormField(validator: (formState) {
            if (selectedValue == null) {
              return "Field Tidak Boleh Kosong";
            }
          }, builder: (formState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedValue,
                  items: options
                      .map((opt) => DropdownMenuItem(
                            value: opt,
                            child:
                                Text(opt, style: const TextStyle(fontSize: 13)),
                          ))
                      .toList(),
                  onChanged: (value) {
                    onChanged(value);
                    formState.didChange(value);
                  },
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 12),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6)),
                  ),
                ),
                if (formState.hasError)
                  Text(formState.errorText ?? "",
                      style: const TextStyle(color: Colors.red, fontSize: 12)),
              ],
            );
          })
        ],
      ),
    );
  }

  Widget _buildStep4() {
    return Form(
      key: _formKeyStep4,
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
                "Langkah ${(_currentStep + 1).toString()} dari 4",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 20),
          pemeriksaanLab(),
          const SizedBox(height: 20),
          const Text(
            "Skrining Kesehatan Jiwa",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 10),
          SkriningView(),
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

  Widget _buildDropdownField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: DropdownButtonFormField<String>(
        value: controller.text.isNotEmpty ? controller.text : null,
        validator: (value) =>
            value!.isEmpty ? 'Field Tidak Boleh Kosong' : null,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 13),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
        ),
        items: const [
          DropdownMenuItem(value: "A+", child: Text("A+")),
          DropdownMenuItem(value: "A-", child: Text("A-")),
          DropdownMenuItem(value: "B+", child: Text("B+")),
          DropdownMenuItem(value: "B-", child: Text("B-")),
          DropdownMenuItem(value: "AB+", child: Text("AB+")),
          DropdownMenuItem(value: "AB-", child: Text("AB-")),
          DropdownMenuItem(value: "O+", child: Text("O+")),
          DropdownMenuItem(value: "O-", child: Text("O-")),
        ],
        onChanged: (value) {
          if (value != null) {
            controller.text = value;
          }
        },
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
      },
      emptyBuilder: (context) => const Padding(
        padding: EdgeInsets.all(8),
        child: Text("Nama tidak ditemukan"),
      ),
    );
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
}
