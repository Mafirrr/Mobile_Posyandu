import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:posyandu_mob/core/models/Artikel.dart';
import 'package:intl/intl.dart';

class DetailEdukasi extends StatelessWidget {
  final Artikel artikel;

  const DetailEdukasi({super.key, required this.artikel});

  @override
  Widget build(BuildContext context) {
    const inter = GoogleFonts.inter;

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
                MainImageSection(artikel: artikel),
                const SizedBox(height: 12),
                TitleAndIntroSection(inter: inter, artikel: artikel),
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
  final Artikel artikel;

  const MainImageSection({super.key, required this.artikel});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Image.network(
      artikel.gambar,
      width: double.infinity,
      height: screenHeight * 0.25,
      fit: BoxFit.cover,
    );
  }
}

class TitleAndIntroSection extends StatelessWidget {
  final TextStyle Function({TextStyle? textStyle}) inter;
  final Artikel artikel;

  const TitleAndIntroSection({
    super.key,
    required this.inter,
    required this.artikel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          DateFormat('yyyy-MM-dd').format(artikel.createdAt ?? DateTime(1970)),
          style: inter().copyWith(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          artikel.judul,
          style: inter().copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          artikel.isi,
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
