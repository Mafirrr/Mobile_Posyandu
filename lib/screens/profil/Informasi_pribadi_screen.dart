import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posyandu_mob/core/models/Anggota.dart';
import 'package:posyandu_mob/core/services/profil_service.dart';
import 'package:posyandu_mob/core/viewmodel/profile_viewmodel.dart';
import 'package:posyandu_mob/widgets/custom_text.dart';
import 'package:posyandu_mob/widgets/custom_textfield.dart';
import 'package:posyandu_mob/widgets/custom_button.dart';
import 'package:posyandu_mob/widgets/custom_datepicker.dart';
import 'package:posyandu_mob/screens/profil/profil_screen.dart';
import 'package:provider/provider.dart';

class InformasiPribadiScreen extends StatefulWidget {
  const InformasiPribadiScreen({Key? key}) : super(key: key);

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
  Anggota? _anggota;
  String? token;
  DateTime? tanggal_lahir;

  Future<void> getUser() async {
    final ProfilService authService = ProfilService();

    final result = await authService.getAnggota();
    if (result != null) {
      setState(() {
        _anggota = result;
        namaController.text = _anggota!.nama;
        nikController.text = _anggota!.nik;
        telpController.text = _anggota!.no_telepon ?? '';
        tempatLahirController.text = _anggota!.tempat_lahir;
        alamatController.text = _anggota!.alamat;
        pekerjaanController.text = _anggota!.pekerjaan;
        selectedGolDarah = _anggota!.golongan_darah ?? '';

        final original = _anggota!.tanggal_lahir;
        final parsed = DateTime.tryParse(original);
        if (parsed != null) {
          tanggal_lahir = parsed;
        }
      });
    } else {
      print("Gagal mendapatkan data anggota.");
    }
  }

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await getUser();
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                const CircleAvatar(
                  radius: 55,
                  backgroundImage: AssetImage('images/picture.jpg'),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black,
                    ),
                    padding: const EdgeInsets.all(6.0),
                    child:
                        const Icon(Icons.edit, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            CustomTextField(
              controller: namaController,
              label: 'Nama Lengkap',
            ),
            SizedBox(height: 16),
            CustomTextField(controller: nikController, label: 'NIK'),
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
                      DateFormat('dd MMM yyyy').format(selectedDate);
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
            CustomButton(
              text: 'Simpan',
              onPressed: () async {
                try {
                  final tanggal = DateFormat('yyyy-MM-dd').format(
                    DateFormat('dd MMM yyyy')
                        .parse(TanggalLahirController.text),
                  );

                  final updatedAnggota = Anggota(
                    id: _anggota!.id,
                    nama: namaController.text,
                    nik: nikController.text,
                    no_telepon: telpController.text,
                    tempat_lahir: tempatLahirController.text,
                    tanggal_lahir: tanggal,
                    alamat: alamatController.text,
                    pekerjaan: pekerjaanController.text,
                    golongan_darah: selectedGolDarah,
                  );

                  final success = await viewModel.updateProfil(updatedAnggota);
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Profil berhasil diperbarui')),
                    );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const ProfilScreen()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Gagal memperbarui profil')),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'Tanggal tidak valid: ${TanggalLahirController.text}')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
