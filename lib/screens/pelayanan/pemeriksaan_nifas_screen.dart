import 'package:flutter/material.dart';
import 'package:posyandu_mob/core/database/UserDatabase.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/Nifas.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/PemeriksaanKehamilan.dart';
import 'package:posyandu_mob/core/services/AnggotaService.dart';
import 'package:posyandu_mob/core/services/pemeriksaanService.dart';
import 'package:posyandu_mob/screens/navigation/drawerKader_screen.dart';
import 'package:posyandu_mob/screens/pelayanan/pemeriksaan_screen.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class PemeriksaanNifasScreen extends StatefulWidget {
  @override
  _PemeriksaanNifasScreenState createState() => _PemeriksaanNifasScreenState();
}

class _PemeriksaanNifasScreenState extends State<PemeriksaanNifasScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tanggalController = TextEditingController();
  final TextEditingController _tempatPeriksaController =
      TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _periksaPayudaraController =
      TextEditingController();
  final TextEditingController _periksaPendarahanController =
      TextEditingController();
  final TextEditingController _periksaJalanLahirController =
      TextEditingController();
  final TextEditingController _vitaminAController = TextEditingController();
  final TextEditingController _kbController = TextEditingController();
  final TextEditingController _skriningJiwaController = TextEditingController();
  final TextEditingController _konselingController = TextEditingController();
  final TextEditingController _tataLaksanaController = TextEditingController();
  final TextEditingController _kesimpulanController = TextEditingController();

  String? selectedKF;
  String? selectedPosyandu;
  int? petugas_id;
  int? _selectedId;
  int? _selectedIdLokasi;
  PemeriksaanService service = PemeriksaanService();

  String? keadaanIbu;
  String? keadaanBayi;
  String? masalahNifas;

  Future<List<Map<String, dynamic>>> fetchSuggestion(String nama) async {
    return await PemeriksaanService().fetchSuggestion(nama);
  }

  Future<List<Map<String, dynamic>>> fetchSuggestionLokasi(String nama) async {
    return await AnggotaService().fetchSuggestion();
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
        _tanggalController.text =
            "${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}";
      });
    }
  }

  bool isLoading = false;

  final BorderRadius _buttonRadius = BorderRadius.circular(8);

  Widget _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          const SizedBox(
              width: 100), // agar posisi tombol tidak terlalu ke kiri
          const Spacer(),
          ElevatedButton(
            onPressed: isLoading ? null : _saveData,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: _buttonRadius,
              ),
            ),
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    "Simpan",
                    style: TextStyle(color: Colors.white),
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _getID() async {
    dynamic user = await UserDatabase().readUser();
    if (user != null) {
      setState(() {
        petugas_id = user.anggota.id;
      });
    }
  }

  void _saveData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    await Future.delayed(const Duration(seconds: 1)); // simulasi loading/simpan
    try {
      await _getID();

      final pemeriksaan = PemeriksaanKehamilan(
        jenisPemeriksaan: "nifas",
        kehamilanId: _selectedId,
        petugasId: petugas_id,
        tanggalPemeriksaan:
            DateTime.tryParse(_tanggalController.text.trim()) ?? DateTime.now(),
        tempatPemeriksaan: _selectedIdLokasi,
      );

      final nifas = Nifas(
        bagianKf: selectedKF,
        periksaPayudara: _periksaPayudaraController.text.trim(),
        periksaPendarahan: _periksaPendarahanController.text.trim(),
        periksaJalanLahir: _periksaJalanLahirController.text.trim(),
        vitaminA: _vitaminAController.text.trim(),
        kbPascaMelahirkan: _kbController.text.trim(),
        skriningKesehatanJiwa: _skriningJiwaController.text.trim(),
        konseling: _konselingController.text.trim(),
        tataLaksanaKasus: _tataLaksanaController.text.trim(),
        kesimpulan: _kesimpulanController.text.trim(),
        kesimpulanBayi: keadaanBayi,
        kesimpulanIbu: keadaanIbu,
        masalahNifas: masalahNifas,
      );

      final response = await service.pemeriksaanNifas(pemeriksaan, nifas);

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
      print('Terjadi kesalahan: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Widget _buildCheckboxGroup(
    String title,
    List<String> options,
    String? selectedValue,
    Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        Wrap(
          spacing: 10,
          runSpacing: -10,
          children: options.map((item) {
            return CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(item),
              value: selectedValue == item,
              onChanged: (value) {
                if (value == true) {
                  onChanged(item);
                } else {
                  onChanged(null);
                }
              },
              controlAffinity: ListTileControlAffinity.leading,
              dense: true,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDropdown(
    String label,
    List<String> items,
    String? selectedValue,
    void Function(String?) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
        ),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
        validator: (val) => val == null ? 'Wajib dipilih' : null,
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator: (value) =>
            value!.isEmpty ? 'Field tidak boleh kosong' : null,
        decoration: InputDecoration(
          labelText: label,
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
        validator: (value) =>
            value!.isEmpty ? 'Field tidak boleh kosong' : null,
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: const Icon(Icons.calendar_month),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),
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

  void _submit() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Data nifas berhasil disimpan")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Pemeriksaan Nifas",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "Langkah 1",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildSuggestion(),
              const SizedBox(height: 10),
              _buildDropdown(
                  "Bagian KF", ['KF1', 'KF2', 'KF3', 'KF4', 'KF5'], selectedKF,
                  (val) {
                setState(() => selectedKF = val);
              }),
              const SizedBox(height: 10),
              _buildDateField("Tanggal Pemeriksaan", _tanggalController,
                  () => _selectDate(context)),
              _buildSuggestionLokasi(_tempatPeriksaController),
              const SizedBox(height: 10),
              _buildTextField(
                  "Periksa Payudara (ASI)", _periksaPayudaraController),
              _buildTextField(
                  "Periksa Pendarahan", _periksaPendarahanController),
              _buildTextField(
                  "Periksa Jalan Lahir", _periksaJalanLahirController),
              _buildTextField("Vitamin A", _vitaminAController),
              _buildTextField("KB Pasca Melahirkan", _kbController),
              _buildTextField(
                  "Skrining Kesehatan Jiwa", _skriningJiwaController),
              _buildTextField("Konseling", _konselingController, maxLines: 2),
              _buildTextField("Tata Laksana Kasus", _tataLaksanaController,
                  maxLines: 2),
              const SizedBox(height: 10),
              _buildCheckboxGroup(
                "Keadaan Ibu",
                ["Sehat", "Sakit", "Meninggal"],
                keadaanIbu,
                (value) {
                  setState(() {
                    keadaanIbu = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              _buildCheckboxGroup(
                "Keadaan Bayi",
                ["Sehat", "Sakit", "Kelainan Bawaan", "Meninggal"],
                keadaanBayi,
                (value) {
                  setState(() {
                    keadaanBayi = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              _buildCheckboxGroup(
                "Masalah Nifas",
                ["Pendarahan", "Infeksi", "Hipertensi", "Lainnya"],
                masalahNifas,
                (value) {
                  setState(() {
                    masalahNifas = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              _buildTextField("Kesimpulan", _kesimpulanController, maxLines: 2),
              const SizedBox(height: 20),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }
}
