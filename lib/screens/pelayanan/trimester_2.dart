import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:posyandu_mob/core/database/UserDatabase.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/PemeriksaanKehamilan.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/PemeriksaanRutin.dart';
import 'package:posyandu_mob/core/services/AnggotaService.dart';
import 'package:posyandu_mob/core/services/pemeriksaanService.dart';
import 'package:posyandu_mob/screens/navigation/drawerKader_screen.dart';
import 'package:posyandu_mob/screens/pelayanan/pemeriksaan_screen.dart';

class Trimester2 extends StatefulWidget {
  @override
  _Trimester2State createState() => _Trimester2State();
}

class _Trimester2State extends State<Trimester2> {
  final _formKeyTrim2 = GlobalKey<FormState>();
  final TextEditingController _tanggalPeriksaController =
      TextEditingController();
  final TextEditingController _tempatPeriksaController =
      TextEditingController();
  final TextEditingController _namaController = TextEditingController();
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

  int? _selectedId;
  int? _selectedIdLokasi;
  int? petugas_id;
  bool isLoading = false;
  PemeriksaanService service = PemeriksaanService();

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

  void _saveData() async {
    if (!_formKeyTrim2.currentState!.validate()) {
      return;
    }
    try {
      await _getID();

      final pemeriksaan = PemeriksaanKehamilan(
        jenisPemeriksaan: "trimester2",
        kehamilanId: _selectedId,
        kaderId: petugas_id,
        tanggalPemeriksaan:
            DateTime.tryParse(_tanggalPeriksaController.text.trim()) ??
                DateTime.now(),
        tempatPemeriksaan: _selectedIdLokasi,
      );

      final pemeriksaanRutin = PemeriksaanRutin(
        beratBadan: int.parse(_beratBadanController.text.trim()),
        tinggiRahim: _tinggiRahimController.text.trim(),
        tekananDarahSistol: int.parse(_tekananSistolController.text.trim()),
        tekananDarahDiastol: int.parse(_tekananDiastolController.text.trim()),
        letakDanDenyutNadiBayi: _denyutJantungJaninController.text.trim(),
        lingkarLenganAtas: int.parse(_lilaController.text.trim()),
        tabletTambahDarah: _tabletDarahController.text.trim(),
        konseling: _konselingController.text.trim(),
        skriningDokter: _skriningController.text.trim(),
      );

      final response =
          await service.pemeriksaanTrimester2(pemeriksaan, pemeriksaanRutin);

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
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildTrimester2Step(),
    );
  }

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
            onPressed: _saveData,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: _buttonRadius,
              ),
            ),
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
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

  Widget _buildTrimester2Step() {
    return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKeyTrim2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Catatan Pemeriksaan",
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
              const SizedBox(height: 12),
              _buildDateField("Tanggal Periksa", _tanggalPeriksaController,
                  () => _selectDate(context)),
              _buildSuggestionLokasi(_tempatPeriksaController),
              const SizedBox(height: 12),
              _buildTextFieldWithSuffix(
                  "Timbang BB", "Kg", _beratBadanController),
              _buildTextFieldWithSuffix(
                  "Lingkar Lengan", "Cm", _lilaController),
              _buildBloodPressureField(),
              _buildTextField("Tinggi Rahim", _tinggiRahimController),
              _buildTextField(
                  "Denyut Jantung Janin", _denyutJantungJaninController),
              _buildTextField("Konseling", _konselingController),
              _buildTextField("Skrining Dokter", _skriningController),
              _buildTextField("Tablet Tambah Darah", _tabletDarahController),
              const SizedBox(height: 20),
              _buildSaveButton(),
            ],
          ),
        ));
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
