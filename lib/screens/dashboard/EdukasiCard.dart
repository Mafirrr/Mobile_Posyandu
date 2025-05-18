import 'package:flutter/material.dart';
import 'package:posyandu_mob/screens/Edukasi/Edukasi.dart';
import 'package:posyandu_mob/core/models/Artikel.dart';
import 'package:posyandu_mob/screens/Edukasi/Detail_Edukasi.dart';

class EdukasiCard extends StatelessWidget {
  final Artikel artikel;


  const EdukasiCard({super.key, required this.artikel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetailEdukasi(artikel: artikel),
              ),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              artikel.gambar,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}