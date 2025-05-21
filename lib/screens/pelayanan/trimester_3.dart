import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/RencanaKonsultasi.dart';

class Trimester3 extends StatefulWidget {
  const Trimester3({super.key});

  @override
  State<Trimester3> createState() => _Trimester3State();
}

class _Trimester3State extends State<Trimester3> {
  late TabController _tabController;
  int _currentStep = 0;

  // State checkbox
  List<String> _selectedRiwayatKesehatan = [];
  List<String> _selectedPerilaku = [];
  List<String> _selectedPenyakitKeluarga = [];

  final TextEditingController _tanggalPeriksaController =
      TextEditingController();

  // ini lab Trimester 1
  final TextEditingController hemoglobinController = TextEditingController();
  String? golonganDarahDanRhesus;
  final TextEditingController gulaDarahController = TextEditingController();
  String? hemoglobinRtl;
  String? rhesusRtl;
  String? gulaDarahRtl;
  String? hiv;
  String? sifilis;
  String? hepatitisB;

// ini skrining Kesehatan Jiwa
  String? skriningJiwa;
  String? tindakLanjutJiwa;
  String? perluRujukanValue;
  bool perluRujukan = false;

// konseling
  String? konseling;

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
    if (_currentStep < 2) {
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

  void _saveData() {
    final data = {
      "tanggalPeriksa": _tanggalPeriksaController.text,
      "riwayatKesehatanIbu": _selectedRiwayatKesehatan,
      "riwayatPerilaku": _selectedPerilaku,
      "riwayatPenyakitKeluarga": _selectedPenyakitKeluarga,
    };
    print("Data disimpan: $data");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data pemeriksaan berhasil disimpan')),
    );
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Catatan Pemeriksaan",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Text(
              "Langkah " + (_currentStep + 1).toString() + " dari 3",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildDateField("Tanggal Periksa", _tanggalPeriksaController,
            () => _selectDate(context)),
        _buildTextField("Tempat Periksa"),
        _buildTextFieldWithSuffix("Timbang BB", "Kg"),
        _buildTextField("Lingkar Lengan"),
        _buildBloodPressureField(),
        _buildTextField("Tinggi Rahim"),
        _buildTextField("Denyut Jantung Janin"),
        _buildTextField("Konseling"),
        _buildTextField("Skrining Dokter"),
        _buildTextField("Tablet Tambah Darah"),
        _buildTextField("Tes Lab Protein Urine"),
        _buildTextField("Tes Lab Gula Darah"),
      ],
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Pemeriksaan Fisik",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Text(
              "Langkah " + (_currentStep + 1).toString() + " dari 3",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        const SizedBox(height: 20),
        pemeriksaanFisikView(),
        const SizedBox(height: 20),
        Text(
          "USG Trimester III",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 10),
        usgTrimester3InputView(),
      ],
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

    final List<String> pemeriksaanKhususOptions = [
      "Tidak ada pemeriksaan khusus",
      "USG",
      "Tes Darah",
      "Tes Urine",
      "Pemeriksaan Lainnya",
    ];
    int? _selectedPemeriksaanKhusus;

    return Column(
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
    );
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
          decoration: const InputDecoration(
            hintText: "Nilai",
            suffixText: "g/dL",
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          ),
          keyboardType: TextInputType.number,
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
        ),

        const SizedBox(height: 14),

        // === Protein Urine ===
        const Text("Protein Urine",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 4),
        TextFormField(
          decoration: const InputDecoration(
            hintText: "Nilai",
            suffixText: "Mg/dL",
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          ),
          keyboardType: TextInputType.number,
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
                                setState(() => urineReduksiValue = val!);
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

        return SizedBox(
          width: 170,
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
                                value: val1,
                                groupValue: getGroupValueFisik(index),
                                onChanged: (val) =>
                                    setGroupValueFisik(index, val1),
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
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            children: [
                              Radio<String>(
                                value: val2,
                                groupValue: getGroupValueFisik(index),
                                onChanged: (val) =>
                                    setGroupValueFisik(index, val2),
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
        );
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
        buildDropdownFieldVertical("Pilih proses melahirkan",
            ["Normal", "Pervaginam Berbantu", "Sectio Caesaria"]),
      ],
    );
  }

  Widget rencanaKontrasepsi() {
    return Column(
      children: [
        buildDropdownFieldVertical("Pilih rencana kontrasepsi", [
          "AKDR",
          "Pil",
          "Suntik",
          "Steril",
          "MAL",
          "Implan",
          "Belum memilih"
        ]),
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
            konseling = val!;
          });
        },
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: konselingItems.map((item) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 180,
                child: Text(
                  item["label"] ?? "",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                ),
              ),
              Row(
                children: (item["options"] as List<String>).map((option) {
                  return Row(
                    children: [
                      Radio<String>(
                        value: option,
                        groupValue: item["groupValue"],
                        visualDensity:
                            const VisualDensity(horizontal: -4, vertical: -4),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onChanged: item["onChanged"],
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
        );
      }).toList(),
    );
  }

  Widget usgTrimester3InputView() {
    return Column(
      children: [
        buildDropdownFieldVertical(
            "USG Trimester III telah dilakukan", ["Ya", "Tidak"]),
        buildInputFieldVertical(
            "Umur Kehamilan berdasarkan USG Trimester I (minggu)"),
        buildInputFieldVertical("Umur Kehamilan berdasarkan HPHT (minggu)"),
        buildInputFieldVertical(
            "Umur Kehamilan berdasarkan biometrik bayi USG Trimester III (minggu)"),
        buildDropdownFieldVertical(
            "Apakah terdapat selisih 3 minggu atau lebih dengan UK USG Trimester I/HPHT",
            ["Ya", "Tidak"]),
        buildDropdownFieldVertical("Jumlah Bayi", ["Tunggal", "Kembar"]),
        buildDropdownFieldVertical(
            "Letak Bayi", ["Intrauterin", "Ektopik", "Tidak diketahui"]),
        buildDropdownFieldVertical(
            "Presentasi Bayi", ["Kepala", "Bokong", "Letak Lintang"]),
        buildDropdownFieldVertical("Keadaan Bayi", ["Hidup", "Meninggal"]),
        buildInputFieldVertical("DJJ (X/menit)"),
        buildDropdownFieldVertical("Kondisi DJJ", ["Normal", "Tidak Normal"]),
        buildDropdownFieldVertical(
            "Lokasi Plasenta", ["Fundus", "Corpus", "Letak Rendah", "Previa"]),
        buildInputFieldVertical("SDP (cm)"),
        buildDropdownFieldVertical(
            "Kondisi Cairan Ketuban", ["Cukup", "Kurang", "Banyak"]),
        buildBiometriRow("BPD", "cm"),
        buildBiometriRow("HC", "cm"),
        buildBiometriRow("AC", "cm"),
        buildBiometriRow("FL", "cm"),
        buildBiometriRow("EFW/TBJ", "gram"),
        buildDropdownFieldVertical(
            "Kecurigaan Temuan Abnormal", ["Ya", "Tidak"]),
        buildInputFieldVertical("Keterangan"),
      ],
    );
  }

  Widget buildBiometriRow(String label, String unit) {
    return Row(
      children: [
        Expanded(child: buildInputFieldVertical("$label ($unit)")),
        SizedBox(width: 10),
        Expanded(child: buildInputFieldVertical("Sesuai: ... minggu")),
      ],
    );
  }

  Widget buildInputFieldVertical(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 13)),
          const SizedBox(height: 6),
          TextFormField(
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

  Widget buildDropdownFieldVertical(String label, List<String> options) {
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

  Widget pemeriksaanLab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildInputFieldNumber("Hemoglobin", hemoglobinController),
        buildInputField("Golongan Darah dan Rhesus",
            TextEditingController(text: golonganDarahDanRhesus ?? "")),
        buildInputFieldNumber("Gula Darah", gulaDarahController),
        buildInputField(
            "Hemoglobin RTL", TextEditingController(text: hemoglobinRtl ?? "")),
        buildInputField(
            "Rhesus RTL", TextEditingController(text: rhesusRtl ?? "")),
        buildInputField(
            "Gula Darah RTL", TextEditingController(text: gulaDarahRtl ?? "")),
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
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 180,
                child: Text(
                  item["label"] ?? "",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                ),
              ),
              Row(
                children: (item["options"] as List<String>).map((option) {
                  return Row(
                    children: [
                      Radio<String>(
                        value: option,
                        groupValue: item["groupValue"],
                        visualDensity:
                            const VisualDensity(horizontal: -4, vertical: -4),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onChanged: item["onChanged"],
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
        );
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

  Widget _buildTextField(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        style: const TextStyle(fontSize: 14),
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

  Widget _buildTextFieldWithSuffix(String label, String suffix) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        style: const TextStyle(fontSize: 14),
        keyboardType: TextInputType.number,
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

  Widget _buildDropdownField(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 13),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
        ),
        items: const [
          DropdownMenuItem(value: "A", child: Text("A")),
          DropdownMenuItem(value: "B", child: Text("B")),
          DropdownMenuItem(value: "AB", child: Text("AB")),
          DropdownMenuItem(value: "O", child: Text("O")),
        ],
        onChanged: (value) {},
      ),
    );
  }

  Widget _buildBloodPressureField() {
    return Row(
      children: [
        Expanded(
          child: _buildTextFieldWithSuffix("Tekanan Darah (Sistolik)", "mmHg"),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildTextFieldWithSuffix("Tekanan Darah (Diastolik)", "mmHg"),
        ),
      ],
    );
  }
}
