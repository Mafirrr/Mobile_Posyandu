import 'package:flutter/material.dart';
import 'package:posyandu_mob/core/database/UserDatabase.dart';
import 'package:posyandu_mob/core/viewmodel/auth_viewmodel.dart';
import 'package:posyandu_mob/screens/login/login_screen.dart';
import 'package:posyandu_mob/screens/pelayanan/pemeriksaan_screen.dart';
import 'package:posyandu_mob/screens/pelayanan/jadwal_posyandu.dart';
import 'package:posyandu_mob/screens/anggota/anggota_screen.dart';
import 'package:posyandu_mob/screens/petugas/petugas_screen.dart';
import 'package:posyandu_mob/screens/profil/ubah_password_screen.dart';
import 'package:posyandu_mob/screens/pelayanan/dashboard_pe.dart';
import 'package:provider/provider.dart';

class DrawerkaderScreen extends StatefulWidget {
  final Widget initialScreen;

  const DrawerkaderScreen({
    super.key,
    required this.initialScreen,
  });

  @override
  State<DrawerkaderScreen> createState() => _DrawerkaderScreenState();
}

class _DrawerkaderScreenState extends State<DrawerkaderScreen> {
  String nama = "user";
  String email = "example@email.com";
  String _title = "Dashboard";

  late Widget _currentScreen;

  Future<void> _logout() async {
    final authProvider = Provider.of<AuthViewModel>(context, listen: false);
    await authProvider.logout(context);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  Future<void> _getData() async {
    final user = await UserDatabase().readPetugas();

    if (user != null) {
      setState(() {
        nama = user.petugas.nama!;
        email = user.petugas.email!;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getData();
    _currentScreen = widget.initialScreen;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: Stack(
                children: [
                  ClipPath(
                    clipper: DoubleCurveClipper(),
                    child: Container(
                      height: 200,
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
                        vertical: 36, horizontal: 16),
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
                        Text(
                          nama,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          email,
                          style: const TextStyle(
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
                  drawerItem(Icons.dashboard, "Dashboard", () {
                    setState(() {
                      _currentScreen = const DashboardPe();
                      _title = "Dashboard";
                    });
                    Navigator.of(context).pop();
                  }),
                  sectionTitle("Data Pengguna"),
                  drawerItem(Icons.pregnant_woman, "Ibu Hamil", () {
                    setState(() {
                      _currentScreen = const AnggotaScreen();
                      _title = "Data Ibu Hamil";
                    });
                    Navigator.of(context).pop();
                  }),
                  drawerItem(Icons.person, "Bidan", () {
                    setState(() {
                      _currentScreen = const PetugasScreen();
                      _title = "Data Bidan";
                    });
                    Navigator.of(context).pop();
                  }),
                  sectionTitle("Pelayanan Posyandu"),
                  drawerItem(Icons.calendar_month, "Jadwal Posyandu", () {
                    setState(() {
                      _currentScreen = const JadwalPosyanduView();
                      _title = "Jadwal Posyandu";
                    });
                    Navigator.of(context).pop();
                  }),
                  drawerItem(Icons.medical_information, "Pemeriksaan", () {
                    setState(() {
                      _currentScreen = const PemeriksaanScreen();
                      _title = "Pemeriksaan";
                    });
                    Navigator.of(context).pop();
                  }),
                  sectionTitle("Lainnya"),
                  drawerItem(Icons.key, "Ubah Password", () {
                    setState(() {
                      _currentScreen = const UbahPasswordScreen();
                      _title = "Ubah Password";
                    });
                    Navigator.of(context).pop();
                  }),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ElevatedButton.icon(
                onPressed: _logout,
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
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          _title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: _currentScreen,
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
