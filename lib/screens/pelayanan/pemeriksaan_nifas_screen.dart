import 'package:flutter/material.dart';

class PemeriksaanNifasScreen extends StatefulWidget {
  @override
  _PemeriksaanNifasScreenState createState() => _PemeriksaanNifasScreenState();
}

class _PemeriksaanNifasScreenState extends State<PemeriksaanNifasScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tanggalController = TextEditingController();
  final TextEditingController _tempatPeriksaController =
      TextEditingController();
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

  List<String> keadaanIbu = [];
  List<String> keadaanBayi = [];
  List<String> masalahNifas = [];

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

  void _saveData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    await Future.delayed(const Duration(seconds: 1)); // simulasi loading/simpan

    setState(() => isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Data nifas berhasil disimpan")),
    );
  }

  Widget _buildCheckboxGroup(
      String title, List<String> options, List<String> selectedList) {
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
              value: selectedList.contains(item),
              onChanged: (value) {
                setState(() {
                  if (value == true) {
                    selectedList.add(item);
                  } else {
                    selectedList.remove(item);
                  }
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
              dense: true,
            );
          }).toList(),
        )
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
              _buildDropdown(
                  "Bagian KF", ['KF1', 'KF2', 'KF3', 'KF4', 'KF5'], selectedKF,
                  (val) {
                setState(() => selectedKF = val);
              }),
              const SizedBox(height: 10),
              _buildDateField("Tanggal Pemeriksaan", _tanggalController,
                  () => _selectDate(context)),
              _buildDropdown("Posyandu", ['Posyandu Mawar', 'Posyandu Melati'],
                  selectedPosyandu, (val) {
                setState(() => selectedPosyandu = val);
              }),
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
                  "Keadaan Ibu", ["Sehat", "Sakit", "Meninggal"], keadaanIbu),
              const SizedBox(height: 10),
              _buildCheckboxGroup(
                  "Keadaan Bayi",
                  ["Sehat", "Sakit", "Kelainan Bawaan", "Meninggal"],
                  keadaanBayi),
              const SizedBox(height: 10),
              _buildCheckboxGroup(
                  "Masalah Nifas",
                  ["Pendarahan", "Infeksi", "Hipertensi", "Lainnya"],
                  masalahNifas),
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
