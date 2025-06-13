import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posyandu_mob/core/database/UserDatabase.dart';
import 'package:posyandu_mob/core/models/dataAnggota.dart';
import 'package:posyandu_mob/core/services/profil_service.dart';
import 'package:posyandu_mob/core/viewmodel/profile_viewmodel.dart';
import 'package:posyandu_mob/widgets/custom_text.dart';
import 'package:posyandu_mob/widgets/custom_textfield.dart';
import 'package:posyandu_mob/widgets/custom_button.dart';
import 'package:posyandu_mob/widgets/custom_datepicker.dart';
import 'package:provider/provider.dart';

class DataKeluargaScreen extends StatefulWidget {
  const DataKeluargaScreen({super.key});

  @override
  _DataKeluargaScreenState createState() => _DataKeluargaScreenState();
}

final TextEditingController namaController = TextEditingController();
final TextEditingController nikController = TextEditingController();
final TextEditingController tk1Controller = TextEditingController();
final TextEditingController jknController = TextEditingController();
final TextEditingController rujukanController = TextEditingController();
final TextEditingController telpController = TextEditingController();
final TextEditingController tempatLahirController = TextEditingController();
final TextEditingController tanggalLahirController = TextEditingController();
final TextEditingController alamatController = TextEditingController();
final TextEditingController pekerjaanController = TextEditingController();

class _DataKeluargaScreenState extends State<DataKeluargaScreen> {
  final userDatabase = UserDatabase();
  final ProfilService _profilService = ProfilService();
  DataAnggota? _anggota;
  DateTime? tanggal_lahir;

  Future<int?> getID() async {
    dynamic userData = await userDatabase.readUser();

    if (userData != null) {
      return userData.anggota.id;
    }
    return null;
  }

  Future<void> getUser() async {
    int? id = await getID();
    final localUser = await userDatabase.getKeluargaById(id!);

    if (localUser != null) {
      _anggota = localUser;
    } else {
      final result = await _profilService.getKeluarga();
      if (result != null) {
        _anggota = result;
        await userDatabase.updateKeluarga(result);
      }
    }

    if (_anggota != null) {
      setState(() {
        namaController.text = _anggota!.nama;
        nikController.text = _anggota!.nik;
        jknController.text = _anggota!.noJkn;
        tk1Controller.text = _anggota!.faskesTk1!;
        rujukanController.text = _anggota!.faskesRujukan!;
        telpController.text = _anggota!.noTelepon!;
        tempatLahirController.text = _anggota!.tempatLahir;
        alamatController.text = _anggota!.alamat;
        pekerjaanController.text = _anggota!.pekerjaan;

        final original = _anggota!.tanggalLahir;
        tanggalLahirController.text = original;
        final parsed = DateTime.tryParse(original);
        if (parsed != null) {
          tanggal_lahir = parsed;
        }
      });
    } else {
      _showSnackbar('Gagal Mendapatkan Data');
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ProfilViewModel>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        title: const CustomText(
          text: 'Data Keluarga',
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Informasi Pribadi",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                CustomTextField(
                    controller: namaController, label: 'Nama Lengkap'),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: nikController,
                  label: 'NIK',
                  readOnly: nikController != null,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                    controller: tempatLahirController, label: 'Tempat Lahir'),
                const SizedBox(height: 12),
                CustomDatePicker(
                  controller: tanggalLahirController,
                  hintText: "Tanggal Lahir",
                  value: tanggal_lahir,
                  onDateSelected: (selectedDate) {
                    setState(() {
                      tanggalLahirController.text =
                          DateFormat('yyyy-MM-dd').format(selectedDate);
                    });
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  "Kontak & Alamat",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                CustomTextField(
                    controller: telpController, label: 'No. Telepon'),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: alamatController,
                  label: 'Alamat',
                  maxLines: 2,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Data BPJS & Kesehatan",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                CustomTextField(
                    controller: jknController, label: 'No JKN', readOnly: true),
                const SizedBox(height: 12),
                CustomTextField(
                    controller: tk1Controller,
                    label: 'Faskes TK1',
                    readOnly: true),
                const SizedBox(height: 12),
                CustomTextField(
                    controller: rujukanController,
                    label: 'Faskes Rujukan',
                    readOnly: true),
                const SizedBox(height: 20),
                const Text(
                  "Lainnya",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                CustomTextField(
                    controller: pekerjaanController, label: 'Pekerjaan'),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      text: 'Simpan',
                      isLoading: viewModel.isLoading,
                      onPressed: () async {
                        try {
                          String inputTanggal =
                              tanggalLahirController.text.trim();
                          final RegExp yyyyMMddFormat =
                              RegExp(r'^\d{4}-\d{2}-\d{2}$');
                          late String finalTanggal;

                          if (yyyyMMddFormat.hasMatch(inputTanggal)) {
                            finalTanggal = inputTanggal;
                          } else {
                            final parsedDate = DateFormat('dd MMM yyyy')
                                .parseStrict(inputTanggal);
                            finalTanggal =
                                DateFormat('yyyy-MM-dd').format(parsedDate);
                          }

                          final updatedAnggota = DataAnggota(
                            id: _anggota!.id,
                            anggotaId: _anggota!.anggotaId,
                            nama: namaController.text,
                            nik: nikController.text,
                            noJkn: jknController.text,
                            faskesTk1: tk1Controller.text,
                            faskesRujukan: rujukanController.text,
                            noTelepon: telpController.text,
                            tempatLahir: tempatLahirController.text,
                            tanggalLahir: finalTanggal,
                            alamat: alamatController.text,
                            pekerjaan: pekerjaanController.text,
                          );

                          final success =
                              await viewModel.updateKeluarga(updatedAnggota);
                          if (success) {
                            _showSnackbar('Profil berhasil diperbarui');
                            Navigator.pop(
                            context, true);
                          } else {
                            _showSnackbar('Gagal memperbarui profil');
                          }
                        } catch (e) {
                          _showSnackbar(
                              'Tanggal tidak valid: ${tanggalLahirController.text}');
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showSnackbar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
