import 'package:flutter/material.dart';

class EdukasiCard extends StatelessWidget {
  final int index;

  const EdukasiCard({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      // child: GestureDetector(
      //   onTap: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => const ProfilScreen()),
      //     );
      //   },
      child: Image.asset(
        'assets/images/Edu.jpg',
        height: 150,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
      // ),
    );
  }
}
