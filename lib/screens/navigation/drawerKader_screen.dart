import 'package:flutter/material.dart';
import 'package:posyandu_mob/core/viewmodel/auth_viewmodel.dart';
import 'package:posyandu_mob/screens/login/login_screen.dart';
import 'package:posyandu_mob/screens/pelayanan/pemeriksaan_screen.dart';
import 'package:posyandu_mob/screens/pelayanan/jadwal_posyandu.dart';
import 'package:posyandu_mob/screens/anggota/anggota_screen.dart';
import 'package:posyandu_mob/screens/petugas/petugas_screen.dart';
import 'package:provider/provider.dart';

class DrawerkaderScreen extends StatefulWidget {
  const DrawerkaderScreen({super.key});

  @override
  State<DrawerkaderScreen> createState() => _DrawerkaderScreenState();
}

class _DrawerkaderScreenState extends State<DrawerkaderScreen> {
  Future<void> _logout() async {
    final authProvider = Provider.of<AuthViewModel>(context, listen: false);
    final result = await authProvider.logout(context);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
    // if (result) {
    // }
  }

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
                    padding:
                        const EdgeInsets.only(top: 40, left: 16.0, right: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/logo_putih.png',
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.menu, color: Colors.white),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Mafira",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "mafira@email.com",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
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
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  _logout();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  minimumSize: const Size(double.infinity, 40),
                ),
                icon: const Icon(Icons.power_settings_new, color: Colors.white),
                label: const Text(
                  "Logout",
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
      leading: Icon(icon, color: const Color.fromARGB(255, 96, 96, 96)),
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
