import 'package:flutter/material.dart';
import 'package:posyandu_mob/core/models/Petugas.dart';
import 'package:posyandu_mob/screens/pelayanan/pemeriksaan_screen.dart';
import 'package:posyandu_mob/screens/pelayanan/jadwal_posyandu.dart';
import 'package:posyandu_mob/screens/anggota/anggota_screen.dart';
import 'package:posyandu_mob/screens/petugas/petugas_screen.dart';
class DrawerkaderScreen extends StatefulWidget {
  const DrawerkaderScreen({super.key});

  @override
  State<DrawerkaderScreen> createState() => _DrawerkaderScreenState();
}

class _DrawerkaderScreenState extends State<DrawerkaderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            SizedBox(
              height: 180,
              child: Stack(
                children: [
                  ClipPath(
                    clipper: DoubleCurveClipper(),
                    child: Container(
                      height: 180,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue, Colors.lightBlueAccent],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage:
                                  AssetImage('assets/images/picture.jpg'),
                            ),
                            SizedBox(height: 12),
                            Text(
                              "Mafira",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 0),
                            Text(
                              "mafira@email.com",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  sectionTitle("Home"),
                  drawerItem(Icons.home_outlined, "Dashboard", () {}),
                  sectionTitle("Data Pengguna"),
                  drawerItem(Icons.people, "Ibu Hamil", () {
                     Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AnggotaScreen(),
                      ),
                    );
                  }),
                  drawerItem(Icons.person, "Bidan", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PetugasScreen(),
                      ),
                    );
                  }),
                  sectionTitle("Pelayanan Posyandu"),
                  drawerItem(Icons.calendar_month, "Jadwal Posyandu", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const JadwalPosyanduView(),
                      ),
                    );
                  }),
                  drawerItem(Icons.medical_information, "Pemeriksaan", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PemeriksaanScreen(),
                      ),
                    );
                  }),
                  sectionTitle("Lainnya"),
                  drawerItem(Icons.menu_book, "Edukasi", () {}),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ElevatedButton.icon(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  minimumSize: const Size(double.infinity, 40),
                ),
                icon: const Icon(Icons.power_settings_new, color: Colors.white),
                label: const Text(
                  "LogOut",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text("Drawer Kader"),
      ),
      body: const Center(
        child: Text("Selamat Datang di Halaman Kader"),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget drawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      dense: true,
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      onTap: onTap,
    );
  }
}

class DoubleCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.85);

    path.quadraticBezierTo(
      size.width * 0.25,
      size.height,
      size.width * 0.5,
      size.height * 0.85,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.7,
      size.width,
      size.height * 0.85,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
