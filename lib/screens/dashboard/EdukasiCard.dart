import 'package:flutter/material.dart';
import 'package:posyandu_mob/screens/Edukasi/Edukasi.dart';

class EdukasiCard extends StatelessWidget {
  final int index;

  const EdukasiCard({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EdukasiHomePage()),
            );
          },
          child: Container(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            child: Image.asset(
              'assets/images/edus.png',
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}
