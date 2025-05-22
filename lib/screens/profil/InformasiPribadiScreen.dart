import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posyandu_mob/core/database/UserDatabase.dart';
import 'package:posyandu_mob/core/models/Anggota.dart';
import 'package:posyandu_mob/core/services/profil_service.dart';
import 'package:posyandu_mob/core/viewmodel/profile_viewmodel.dart';
import 'package:posyandu_mob/widgets/custom_text.dart';
import 'package:posyandu_mob/widgets/custom_textfield.dart';
import 'package:posyandu_mob/widgets/custom_button.dart';
import 'package:posyandu_mob/widgets/custom_datepicker.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

class InformasiPribadiScreen extends StatefulWidget {
  const InformasiPribadiScreen({super.key});

  @override
  _InformasiPribadiScreenState createState() => _InformasiPribadiScreenState();
}

String? id;
String? nama;
String? nik;
String? no_telp;
String? alamat;
final TextEditingController namaController = TextEditingController();
final TextEditingController nikController = TextEditingController();
final TextEditingController jknController = TextEditingController();
final TextEditingController tk1Controller = TextEditingController();
final TextEditingController rujukanController = TextEditingController();
final TextEditingController telpController = TextEditingController();
final TextEditingController tempatLahirController = TextEditingController();
final TextEditingController TanggalLahirController = TextEditingController();
final TextEditingController alamatController = TextEditingController();
final TextEditingController pekerjaanController = TextEditingController();

String selectedGolDarah = 'A+';
final List<String> golDarahOptions = [
  'A+',
  'A-',
  'B+',
  'B-',
  'AB+',
  'AB-',
  'O+',
  'O-'
];

class _InformasiPribadiScreenState extends State<InformasiPribadiScreen> {
  final ProfilService _profilService = ProfilService();
  final userDatabase = UserDatabase();
  File? localImg;
  Anggota? _anggota;
  String? token;
  DateTime? tanggal_lahir;
  bool isLoading = true;

  Future<void> getUser() async {
    final localUser = await userDatabase.readUser();

    if (localUser != null) {
      _anggota = localUser.anggota;
    } else {
      final result = await _profilService.getAnggota();
      if (result != null) {
        _anggota = result;
        await userDatabase.update(result);
      }
    }

    if (_anggota != null) {
      setState(() {
        namaController.text = _anggota!.nama;
        nikController.text = _anggota!.nik;
        jknController.text = _anggota!.no_jkn;
        tk1Controller.text = _anggota!.faskes_tk1;
        rujukanController.text = _anggota!.faskes_rujukan;
        telpController.text = _anggota!.no_telepon ?? '';
        tempatLahirController.text = _anggota!.tempat_lahir;
        alamatController.text = _anggota!.alamat;
        pekerjaanController.text = _anggota!.pekerjaan;
        selectedGolDarah = _anggota!.golongan_darah ?? '';

        final original = _anggota!.tanggal_lahir;
        TanggalLahirController.text = original;
        final parsed = DateTime.tryParse(original);
        if (parsed != null) {
          tanggal_lahir = parsed;
        }
      });
    } else {
      _showSnackbar('Gagal Mendapatkan Data');
    }
  }

  Future<void> _checkImage() async {
    final authProvider = Provider.of<ProfilViewModel>(context, listen: false);
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/profile.jpg');

    if (await file.exists()) {
      setState(() {
        localImg = file;
      });
    } else {
      final url = await authProvider.checkImage();
      setState(() {
        localImg = File(url);
      });
    }
  }

  Future<void> _pickImage() async {
    final authProvider = Provider.of<ProfilViewModel>(context, listen: false);
    final permission =
        Platform.isAndroid ? Permission.storage : Permission.photos;

    var status = await permission.request();

    if (status.isGranted) {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery);

      if (picked != null) {
        File newImage = File(picked.path);

        final response = await authProvider.uploadImage(newImage);

        if (response.isNotEmpty) {
          setState(() {
            localImg = File(response);
          });
        }
      }
    } else {
      if (status.isPermanentlyDenied) {
        openAppSettings();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await getUser();
    await _checkImage();

    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ProfilViewModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const CustomText(
          text: 'Edit Profile',
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back)),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 55,
                        backgroundImage:
                            (localImg != null && localImg!.path.isNotEmpty)
                                ? FileImage(localImg!)
                                : const AssetImage('assets/images/picture.jpg'),
                      ),
                      if (localImg == null || localImg!.path.isEmpty)
                        GestureDetector(
                          onTap: () async {
                            await _pickImage();
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black,
                            ),
                            padding: const EdgeInsets.all(6.0),
                            child: const Icon(Icons.edit,
                                color: Colors.white, size: 18),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  CustomTextField(
                    controller: namaController,
                    label: 'Nama Lengkap',
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: nikController,
                    label: 'NIK',
                    readOnly: true,
                  ),
                  CustomTextField(
                    controller: jknController,
                    label: 'No_JKN',
                    readOnly: true,
                  ),
                  CustomTextField(
                    controller: tk1Controller,
                    label: 'Faskes_TK1',
                    readOnly: true,
                  ),
                  CustomTextField(
                    controller: rujukanController,
                    label: 'Faskes_Rujukan',
                    readOnly: true,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedGolDarah,
                          decoration: InputDecoration(
                            labelText: 'Gol. Darah',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          items: golDarahOptions.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedGolDarah = value!;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomTextField(
                            controller: telpController, label: 'No. Telepon'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                      controller: tempatLahirController, label: 'Tempat Lahir'),
                  const SizedBox(height: 16),
                  CustomDatePicker(
                    controller: TanggalLahirController,
                    hintText: "Tanggal Lahir",
                    value: tanggal_lahir,
                    onDateSelected: (selectedDate) {
                      setState(() {
                        TanggalLahirController.text =
                            DateFormat('yyyy-MM-dd').format(selectedDate);
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: alamatController,
                    label: 'Alamat',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                      controller: pekerjaanController, label: 'Pekerjaan'),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      text: 'Simpan',
                      isLoading: viewModel.isLoading,
                      onPressed: () async {
                        try {
                          String inputTanggal =
                              TanggalLahirController.text.trim();
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

                          final updatedAnggota = Anggota(
                            id: _anggota!.id,
                            nama: namaController.text,
                            nik: nikController.text,
                            no_jkn: jknController.text,
                            faskes_tk1: tk1Controller.text,
                            faskes_rujukan: rujukanController.text,
                            no_telepon: telpController.text,
                            tempat_lahir: tempatLahirController.text,
                            tanggal_lahir: finalTanggal,
                            alamat: alamatController.text,
                            pekerjaan: pekerjaanController.text,
                            golongan_darah: selectedGolDarah,
                          );

                          final success =
                              await viewModel.updateProfil(updatedAnggota);
                          if (success) {
                            _showSnackbar('Profil berhasil diperbarui');
                            Navigator.pop(context, true);
                          } else {
                            _showSnackbar('Gagal memperbarui profil');
                          }
                        } catch (e) {
                          _showSnackbar(
                              'Tanggal tidak valid: ${TanggalLahirController.text}');
                        }
                      },
                    ),
                  )
                ],
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
