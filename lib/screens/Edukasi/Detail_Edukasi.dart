import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailEdukasi extends StatelessWidget {
  const DetailEdukasi({super.key});

  @override
  Widget build(BuildContext context) {
    final inter = GoogleFonts.inter;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 40),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                const HeaderSection(),
                const SizedBox(height: 20),
                const SizedBox(height: 20),
                const MainImageSection(
                  imageUrl:
                      "https://storage.googleapis.com/a1aa/image/30e9999e-0767-4fe3-cc41-9147c2d26c0e.jpg",
                ),
                const SizedBox(height: 12),
                TitleAndIntroSection(inter: inter),
                const SizedBox(height: 20),
                const MainImageSection(
                  imageUrl:
                      "https://storage.googleapis.com/a1aa/image/5df10fb1-0bbe-4b27-6ac9-8c80a4391779.jpg",
                ),
                const SizedBox(height: 12),
                ReasonListSection(inter: inter),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, size: 24),
        ),
      ],
    );
  }
}

class MainImageSection extends StatelessWidget {
  final String imageUrl;

  const MainImageSection({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }
}

class TitleAndIntroSection extends StatelessWidget {
  final TextStyle Function({TextStyle? textStyle}) inter;

  const TitleAndIntroSection({super.key, required this.inter});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "17 Maret 2020",
          style: inter().copyWith(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "Pentingnya Pemeriksaan Ibu Hamil: Cara Menjaga Kesehatan Ibu dan Janin",
          style: inter().copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          "Pemeriksaan kehamilan adalah langkah penting untuk memastikan kesehatan ibu dan perkembangan janin tetap optimal. Melalui pemeriksaan rutin, dokter dapat memantau kondisi ibu, mendeteksi dini potensi komplikasi, serta memberikan saran terbaik untuk menjaga kehamilan yang sehat.",
          style: inter().copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            height: 1.5,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

class ReasonListSection extends StatelessWidget {
  final TextStyle Function({TextStyle? textStyle}) inter;

  const ReasonListSection({super.key, required this.inter});

  @override
  Widget build(BuildContext context) {
    const bulletPoints = [
      "Memastikan perkembangan janin sesuai usia kehamilan.",
      "Mendeteksi dini risiko atau komplikasi seperti preeklampsia, diabetes gestasional, atau kelainan janin.",
      "Memberikan edukasi seputar pola makan, aktivitas fisik, dan kesehatan mental ibu hamil.",
      "Menentukan tindakan medis yang diperlukan jika ada kondisi yang memerlukan penanganan khusus.",
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Mengapa Pemeriksaan Kehamilan Itu Penting",
          style: inter().copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          "Pemeriksaan kehamilan memiliki banyak manfaat, antara lain:",
          style: inter().copyWith(fontSize: 15, height: 1.5),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(bulletPoints.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  "${index + 1}. ${bulletPoints[index]}",
                  style: inter().copyWith(fontSize: 15, height: 1.5),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
