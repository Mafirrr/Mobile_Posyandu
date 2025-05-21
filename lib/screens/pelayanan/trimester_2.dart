import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Trimester2 extends StatefulWidget {
  @override
  _Trimester2State createState() => _Trimester2State();
}

class _Trimester2State extends State<Trimester2> {
  final TextEditingController _tanggalPeriksaController =
      TextEditingController();

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

  void _saveData() {
    final data = {
      "tanggalPeriksa": _tanggalPeriksaController.text,
    };
    print("Data Trimester 2 disimpan: $data");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data Trimester 2 berhasil disimpan')),
    );
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
            child: const Text(
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
                "Langkah 1",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
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
          const SizedBox(height: 20),
          _buildSaveButton(),
        ],
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
