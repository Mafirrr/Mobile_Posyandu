import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:posyandu_mob/core/viewmodel/Petugas_viewmodel.dart';
import 'package:flutter/services.dart';

class TambahPetugasScreen extends StatefulWidget {
  final Map<String, dynamic>? petugas; // data untuk edit
  final bool isEdit;

  const TambahPetugasScreen({Key? key, this.petugas, required this.isEdit})
      : super(key: key);

  @override
  State<TambahPetugasScreen> createState() => _TambahPetugasScreenState();
}

class _TambahPetugasScreenState extends State<TambahPetugasScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nipController;
  late TextEditingController _namaController;
  late TextEditingController _noTeleponController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();

    _nipController = TextEditingController(text: widget.petugas?['nip'] ?? '');
    _namaController =
        TextEditingController(text: widget.petugas?['nama'] ?? '');
    _noTeleponController =
        TextEditingController(text: widget.petugas?['no_telepon'] ?? '');
    _emailController =
        TextEditingController(text: widget.petugas?['email'] ?? '');
  }

  @override
  void dispose() {
    _nipController.dispose();
    _namaController.dispose();
    _noTeleponController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _savePetugas() async {
    if (_formKey.currentState!.validate()) {
      final viewModel = context.read<PetugasViewModel>();

      final data = {
        'nip': _nipController.text.trim(),
        'nama': _namaController.text.trim(),
        'no_telepon': _noTeleponController.text.trim(),
        'email': _emailController.text.trim(),
        'role': 'bidan', // Role default
      };

      bool success;
      if (widget.isEdit) {
        success = await viewModel.updatePetugas(
            widget.petugas!['id'].toString(), data);
      } else {
        success = await viewModel.addPetugas(data);
      }

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.isEdit
                ? 'Berhasil mengubah petugas'
                : 'Berhasil menambahkan petugas'),
          ),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan data petugas')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? 'Edit Petugas' : 'Tambah Petugas',
            style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 33, 150, 243),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // NIP
              TextFormField(
                controller: _nipController,
                decoration: InputDecoration(
                  labelText: 'NIP',
                  border: OutlineInputBorder(),
                ),
                keyboardType:
                    TextInputType.number, // Membatasi input hanya angka
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly
                ], // Hanya angka
                validator: (val) {
                  if (val == null || val.isEmpty)
                    return 'NIP tidak boleh kosong';
                  if (!RegExp(r'^\d+$').hasMatch(val))
                    return 'NIP hanya boleh berisi angka';
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Nama
              TextFormField(
                controller: _namaController,
                decoration: InputDecoration(
                  labelText: 'Nama',
                  border: OutlineInputBorder(),
                ),
                validator: (val) {
                  if (val == null || val.isEmpty)
                    return 'Nama tidak boleh kosong';
                  if (val.length < 3) return 'Nama harus minimal 3 karakter';
                  if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(val))
                    return 'Nama hanya boleh berisi huruf';
                  return null;
                },
              ),
              SizedBox(height: 16),

              // No Telepon
              TextFormField(
                controller: _noTeleponController,
                decoration: InputDecoration(
                  labelText: 'No Telepon',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType
                    .phone, // Membatasi tipe input ke angka (telepon)
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly
                ], // Hanya angka yang diizinkan
                validator: (val) {
                  if (val == null || val.isEmpty)
                    return 'No telepon wajib diisi';
                  if (!RegExp(r'^\d+$').hasMatch(val))
                    return 'No telepon hanya boleh berisi angka';
                  if (val.length < 10) return 'No telepon minimal 10 digit';
                  if (val.length > 13) return 'No telepon maksimal 13 digit';
                  return null;
                },
              
              ),
   SizedBox(height: 16), 
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Email wajib diisi';
                  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                  if (!emailRegex.hasMatch(val))
                    return 'Format email tidak valid';
                  return null;
                },
              ),
              SizedBox(height: 24),

              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 33, 150, 243),
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                label: Text(
                  'Simpan',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: _savePetugas,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
