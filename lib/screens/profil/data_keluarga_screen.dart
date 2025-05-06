import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posyandu_mob/widgets/custom_text.dart';
import 'package:posyandu_mob/widgets/custom_textfield.dart';
import 'package:posyandu_mob/widgets/custom_button.dart';
import 'package:posyandu_mob/widgets/custom_datepicker.dart';

class DataKeluargaScreen extends StatelessWidget {
  const DataKeluargaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController namaController = TextEditingController();
    final TextEditingController nikController = TextEditingController();
    final TextEditingController telpController = TextEditingController();
    final TextEditingController tempatLahirController = TextEditingController();
    final TextEditingController tanggalLahirController =
        TextEditingController();
    final TextEditingController alamatController = TextEditingController();
    final TextEditingController pekerjaanController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const CustomText(
          text: 'Data Keluarga',
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomText(
              text: 'Nama Lengkap',
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(height: 4),
            CustomTextField(
              controller: namaController,
              label: 'Nama Lengkap',
            ),
            const SizedBox(height: 16),
            const CustomText(
              text: 'NIK',
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(height: 4),
            CustomTextField(controller: nikController, label: 'NIK'),
            const SizedBox(height: 16),
            const CustomText(
              text: 'No. Telepon',
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(height: 4),
            CustomTextField(controller: telpController, label: 'No. Telepon'),
            const SizedBox(height: 16),
            const CustomText(
              text: 'Tempat Lahir',
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(height: 4),
            CustomTextField(
                controller: tempatLahirController, label: 'Tempat Lahir'),
            const SizedBox(height: 16),
            const CustomText(
              text: 'Tanggal Lahir',
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(height: 4),
            CustomDatePicker(
              controller: tanggalLahirController,
              hintText: "Tanggal Lahir",
              onDateSelected: (selectedDate) {
                tanggalLahirController.text =
                    DateFormat('dd MMM yyyy').format(selectedDate);
              },
            ),
            const SizedBox(height: 16),
            const CustomText(
              text: 'Alamat',
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(height: 4),
            CustomTextField(
              controller: alamatController,
              label: 'Alamat',
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            const CustomText(
              text: 'Pekerjaan',
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(height: 4),
            CustomTextField(
                controller: pekerjaanController, label: 'Pekerjaan'),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: 'Simpan',
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
