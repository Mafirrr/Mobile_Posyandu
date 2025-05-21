import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Trimester1 extends StatefulWidget {
  const Trimester1({super.key});

  @override
  State<Trimester1> createState() => _Trimester1State();
}

class _Trimester1State extends State<Trimester1> {
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
    if (_currentStep < 3) {
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
                child: Text(
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
              "Langkah " + (_currentStep + 1).toString() + " dari 4",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildDateField("Tanggal Periksa", _tanggalPeriksaController,
            () => _selectDate(context)),
        _buildTextField("Tempat Periksa"),
        _buildTextFieldWithSuffix("Timbang BB", "Kg"),
        _buildTextFieldWithSuffix("Tinggi Badan", "Cm"),
        _buildTextField("Lingkar Lengan"),
        _buildBloodPressureField(),
        _buildTextField("Tinggi Rahim"),
        _buildTextField("Denyut Jantung Janin"),
        _buildTextField("Konseling"),
        _buildTextField("Skrining Dokter"),
        _buildTextField("Tablet Tambah Darah"),
        _buildDropdownField("Golongan Darah"),
      ],
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
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
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _imunisasiTd.length,
            itemBuilder: (context, index) {
              final item = _imunisasiTd[index];

              print(imunisasiSelected);
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
                      _selectedImunisasi = "t" + (index + 1).toString();
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
                            onChanged: (val) => setState(() =>
                                _selectedImunisasi =
                                    "t" + (index + 1).toString()),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    Text(
                                      "Perlindungan: ${item['perlindungan']}",
                                      style: const TextStyle(fontSize: 12),
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
        const SizedBox(height: 20),
        pemeriksaanKhususView()
      ],
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
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color.fromARGB(255, 255, 255, 255), // Warna border putih
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
        borderRadius:
            BorderRadius.circular(8), // Opsional: biar sudutnya lebih lembut
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
                          color: Color.fromARGB(255, 180, 180, 180), width: 1),
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
                          onChanged: (val) =>
                              setGroupValueKhusus(index, "normal"),
                          visualDensity:
                              const VisualDensity(horizontal: -4, vertical: -4),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                        const Text("Normal", style: TextStyle(fontSize: 12)),
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
                          onChanged: (val) =>
                              setGroupValueKhusus(index, "tidak_normal"),
                          visualDensity:
                              const VisualDensity(horizontal: -4, vertical: -4),
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
        buildInputFieldVertical("HPHT"),
        buildDropdownFieldVertical(
            "Keteraturan Haid", ["Teratur", "Tidak Teratur"]),
        buildInputFieldVertical("Umur Kehamilan Berdasarkan HPHT (minggu)"),
        buildInputFieldVertical("Umur Kehamilan Berdasarkan USG (minggu)"),
        buildInputFieldVertical("HPL Berdasarkan HPHT"),
        buildInputFieldVertical("HPL Berdasarkan USG"),
        buildDropdownFieldVertical("Jumlah GS", ["Tunggal", "Kembar"]),
        buildDropdownFieldVertical("Jumlah Bayi", ["Tunggal", "Kembar"]),
        buildInputFieldVertical("Diameter GS (cm)"),
        buildInputFieldVertical("GS Hari"),
        buildInputFieldVertical("GS Minggu"),
        buildInputFieldVertical("CRL (cm)"),
        buildInputFieldVertical("CRL Hari"),
        buildInputFieldVertical("CRL Minggu"),
        buildDropdownFieldVertical("Letak Produk Kehamilan",
            ["Intrauterin", "Ektopik", "Tidak diketahui"]),
        buildDropdownFieldVertical("Pulsasi Jantung", ["Ada", "Tidak Ada"]),
        buildDropdownFieldVertical(
            "Kecurigaan Temuan Abnormal", ["Ya", "Tidak"]),
        buildInputFieldVertical("Keterangan"),
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

  Widget _buildStep3() {
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
              "Langkah " + (_currentStep + 1).toString() + " dari 4",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        const SizedBox(height: 20),
        pemeriksaanFisikView(),
        const SizedBox(height: 20),
        Text(
          "USG Trimester 1",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 10),
        usgTrimester1InputView(),
      ],
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

  Widget _buildStep4() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Pemeriksaan Laboratorium",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Text(
              "Langkah " + (_currentStep + 1).toString() + " dari 4",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        const SizedBox(height: 20),
        pemeriksaanLab(),
        const SizedBox(height: 20),
        Text(
          "Skrining Kesehatan Jiwa",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 10),
        SkriningView(),
      ],
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
