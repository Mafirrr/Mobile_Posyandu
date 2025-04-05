import 'package:flutter/material.dart';
import 'package:posyandu_mob/widgets/custom_text.dart';
import 'package:posyandu_mob/widgets/custom_textfield.dart';
import 'package:posyandu_mob/widgets/custom_button.dart';
import 'package:posyandu_mob/widgets/custom_datepicker.dart';
import 'package:posyandu_mob/screens/profil/profil_screen.dart';

class InformasiPribadiScreen extends StatefulWidget {
  const InformasiPribadiScreen({Key? key}) : super(key: key);

  @override
  _InformasiPribadiScreenState createState() => _InformasiPribadiScreenState();
}

final TextEditingController namaController =
    TextEditingController(text: 'Rini Rani');
final TextEditingController nikController =
    TextEditingController(text: '3333333333333333');
final TextEditingController telpController =
    TextEditingController(text: '+62812345678');
final TextEditingController tempatLahirController =
    TextEditingController(text: 'Bondowoso');
final TextEditingController TanggalLahirController =
    TextEditingController(text: '01 Januari 1999');
final TextEditingController alamatController =
    TextEditingController(text: 'Tapen Bondowoso');
final TextEditingController pekerjaanController =
    TextEditingController(text: 'Bank');

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
  @override
  Widget build(BuildContext context) {
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
            CustomTextField(controller: namaController, label: 'Nama Lengkap'),
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
              label: 'Tempat, Tanggal Lahir',
              onDateSelected: (selectedDate) {
                setState(() {
                  TanggalLahirController.text =
                      'Bondowoso, ${_formatTanggal(selectedDate)}';
                });
              },
            ),
            const SizedBox(height: 16),
            CustomTextField(controller: alamatController, label: 'Alamat'),
            const SizedBox(height: 16),
            CustomTextField(
                controller: pekerjaanController, label: 'Pekerjaan'),
            const SizedBox(height: 16),
            CustomButton(
              text: 'Simpan',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Data berhasil disimpan'),
                    duration: Duration(seconds: 1),
                  ),
                );
                Future.delayed(const Duration(seconds: 2), () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfilScreen()),
                  );
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatTanggal(DateTime date) {
    final List<String> bulan = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    return '${date.day} ${bulan[date.month - 1]} ${date.year}';
  }
}
