import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Untuk input formatter
import 'package:provider/provider.dart';
import 'package:posyandu_mob/core/viewmodel/Anggota_viewmodel.dart';

class TambahAnggotaScreen extends StatefulWidget {
  final Map<String, dynamic>? anggota;
  final bool isEdit;

  const TambahAnggotaScreen({Key? key, this.anggota, required this.isEdit})
      : super(key: key);

  @override
  State<TambahAnggotaScreen> createState() => _TambahAnggotaScreenState();
}

class _TambahAnggotaScreenState extends State<TambahAnggotaScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _namaController;
  late TextEditingController _nikController;
  late TextEditingController _noJknController;
  late TextEditingController _faskesTk1Controller;
  late TextEditingController _faskesRujukanController;
  late TextEditingController _tanggalLahirController;
  late TextEditingController _tempatLahirController;
  late TextEditingController _pekerjaanController;
  late TextEditingController _alamatController;
  late TextEditingController _noTeleponController;

  final List<String> _golonganDarahList = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-'
  ];
  String? _selectedGolonganDarah;

  @override
  void initState() {
    super.initState();

    _namaController =
        TextEditingController(text: widget.anggota?['nama'] ?? '');
    _nikController = TextEditingController(text: widget.anggota?['nik'] ?? '');
    _noJknController =
        TextEditingController(text: widget.anggota?['no_jkn'] ?? '');
    _faskesTk1Controller =
        TextEditingController(text: widget.anggota?['faskes_tk1'] ?? '');
    _faskesRujukanController =
        TextEditingController(text: widget.anggota?['faskes_rujukan'] ?? '');
    _tanggalLahirController =
        TextEditingController(text: widget.anggota?['tanggal_lahir'] ?? '');
    _tempatLahirController =
        TextEditingController(text: widget.anggota?['tempat_lahir'] ?? '');
    _pekerjaanController =
        TextEditingController(text: widget.anggota?['pekerjaan'] ?? '');
    _alamatController =
        TextEditingController(text: widget.anggota?['alamat'] ?? '');
    _noTeleponController =
        TextEditingController(text: widget.anggota?['no_telepon'] ?? '');
    _selectedGolonganDarah = widget.anggota?['golongan_darah'];
  }

  @override
  void dispose() {
    _namaController.dispose();
    _nikController.dispose();
    _noJknController.dispose();
    _faskesTk1Controller.dispose();
    _faskesRujukanController.dispose();
    _tanggalLahirController.dispose();
    _tempatLahirController.dispose();
    _pekerjaanController.dispose();
    _alamatController.dispose();
    _noTeleponController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate =
        DateTime.tryParse(_tanggalLahirController.text) ?? DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _tanggalLahirController.text = picked.toIso8601String().split('T')[0];
      });
    }
  }

  void _saveAnggota() async {
    if (_formKey.currentState!.validate()) {
      final viewModel = context.read<AnggotaViewModel>();

      final data = {
        'nik': _nikController.text.trim(),
        'nama': _namaController.text.trim(),
        'no_jkn': _noJknController.text.trim(),
        'faskes_tk1': _faskesTk1Controller.text.trim(),
        'faskes_rujukan': _faskesRujukanController.text.trim(),
        'tanggal_lahir': _tanggalLahirController.text.trim(),
        'tempat_lahir': _tempatLahirController.text.trim(),
        'pekerjaan': _pekerjaanController.text.trim(),
        'alamat': _alamatController.text.trim(),
        'no_telepon': _noTeleponController.text.trim(),
        'golongan_darah': _selectedGolonganDarah,
        'status': 'aktif',
      };

      bool success;
      if (widget.isEdit) {
        success = await viewModel.updateAnggota(
            widget.anggota!['id'].toString(), data);
      } else {
        success = await viewModel.addAnggota(data);
      }

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(widget.isEdit
                  ? 'Berhasil mengubah anggota'
                  : 'Berhasil menambahkan anggota')),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan data anggota')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isEdit ? 'Edit Anggota' : 'Tambah Anggota',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor:
            const Color.from(alpha: 1, red: 0.129, green: 0.588, blue: 0.953),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Nama
              TextFormField(
                controller: _namaController,
                decoration: InputDecoration(
                  labelText: 'Nama',
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val == null || val.isEmpty
                    ? 'Nama tidak boleh kosong'
                    : null,
              ),
              SizedBox(height: 16),

              // NIK
              TextFormField(
                controller: _nikController,
                decoration: InputDecoration(
                  labelText: 'NIK',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'NIK tidak boleh kosong';
                  }
                  if (val.length != 16) {
                    return 'NIK harus 16 digit';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // No JKN
              TextFormField(
                controller: _noJknController,
                decoration: InputDecoration(
                  labelText: 'No JKN',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'No JKN tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Faskes TK1
              TextFormField(
                controller: _faskesTk1Controller,
                decoration: InputDecoration(
                  labelText: 'Faskes TK1',
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val == null || val.isEmpty
                    ? 'Faskes TK1 wajib diisi'
                    : null,
              ),
              SizedBox(height: 16),

              // Faskes Rujukan
              TextFormField(
                controller: _faskesRujukanController,
                decoration: InputDecoration(
                  labelText: 'Faskes Rujukan',
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val == null || val.isEmpty
                    ? 'Faskes Rujukan wajib diisi'
                    : null,
              ),
              SizedBox(height: 16),

              // Tanggal Lahir
              TextFormField(
                controller: _tanggalLahirController,
                decoration: InputDecoration(
                  labelText: 'Tanggal Lahir',
                  suffixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                onTap: () => _selectDate(context),
                validator: (val) => val == null || val.isEmpty
                    ? 'Tanggal lahir wajib diisi'
                    : null,
              ),
              SizedBox(height: 16),

              // Tempat Lahir
              TextFormField(
                controller: _tempatLahirController,
                decoration: InputDecoration(
                  labelText: 'Tempat Lahir',
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val == null || val.isEmpty
                    ? 'Tempat lahir wajib diisi'
                    : null,
              ),
              SizedBox(height: 16),

              // Pekerjaan
              TextFormField(
                controller: _pekerjaanController,
                decoration: InputDecoration(
                  labelText: 'Pekerjaan',
                  border: OutlineInputBorder(),
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Pekerjaan wajib diisi' : null,
              ),
              SizedBox(height: 16),

              // Alamat
              TextFormField(
                controller: _alamatController,
                decoration: InputDecoration(
                  labelText: 'Alamat',
                  border: OutlineInputBorder(),
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Alamat wajib diisi' : null,
              ),
              SizedBox(height: 16),

              // No Telepon
              TextFormField(
                controller: _noTeleponController,
                decoration: InputDecoration(
                  labelText: 'No Telepon',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'No telepon wajib diisi';
                  }
                  if (val.length < 10 || val.length > 13) {
                    return 'No telepon harus 10-13 digit';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Golongan Darah Dropdown
              DropdownButtonFormField<String>(
                value: _selectedGolonganDarah,
                decoration: InputDecoration(
                  labelText: 'Golongan Darah',
                  border: OutlineInputBorder(),
                ),
                items: _golonganDarahList
                    .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedGolonganDarah = val;
                  });
                },
                validator: (val) =>
                    null, // Validasi dihapus atau diubah agar selalu valid
              ),
              SizedBox(height: 24),
              SizedBox(height: 24),

              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.from(
                      alpha: 1, red: 0.129, green: 0.588, blue: 0.953),
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                label: Text(
                  'Simpan',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: _saveAnggota,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
