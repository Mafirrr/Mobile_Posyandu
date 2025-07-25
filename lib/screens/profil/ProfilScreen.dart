import 'dart:io';
import 'package:flutter/material.dart';
import 'package:posyandu_mob/core/database/PemeriksaanDatabase.dart';
import 'package:posyandu_mob/core/database/UserDatabase.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/PemeriksaanRutin.dart';
import 'package:posyandu_mob/core/viewmodel/auth_viewmodel.dart';
import 'package:posyandu_mob/core/viewmodel/profile_viewmodel.dart';
import 'package:posyandu_mob/screens/login/login_screen.dart';
import 'package:posyandu_mob/screens/profil/InformasiPribadiScreen.dart';
import 'package:posyandu_mob/screens/profil/data_keluarga_screen.dart';
import 'package:posyandu_mob/screens/profil/ubah_password_screen.dart';
import 'package:posyandu_mob/widgets/custom_dialog.dart';
import 'package:posyandu_mob/widgets/custom_text.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfilScreen> {
  int? id;
  String? nama, role, nik;
  String? bb, diastol, sistol, lila, tinggi_rahim;
  File? localImg;
  bool isLoading = true;

  Future<void> _checkImage() async {
    final authProvider = Provider.of<ProfilViewModel>(context, listen: false);
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/profile.jpg');

    if (await file.exists()) {
      setState(() {
        localImg = file;
      });
    } else {
      final url = await authProvider.checkImage();
      setState(() {
        localImg = File(url);
      });
    }
  }

  Future<void> _getDetailPemeriksaan() async {
    PemeriksaanRutin? user = await Pemeriksaandatabase().getPemeriksaanRutin();

    if (user != null) {
      setState(() {
        bb = user.beratBadan.toString();
        lila = user.lingkarLenganAtas.toString();
        sistol = user.tekananDarahSistol.toString();
        diastol = user.tekananDarahDiastol.toString();
        if (user.tinggiRahim != null &&
            !user.tinggiRahim!.toLowerCase().contains('cm') &&
            double.tryParse(user.tinggiRahim!) != null) {
          tinggi_rahim = "${user.tinggiRahim} cm";
        } else {
          tinggi_rahim = user.tinggiRahim;
        }
      });
    }
  }

  Future<void> _logout() async {
    final authProvider = Provider.of<AuthViewModel>(context, listen: false);
    final result = await authProvider.logout(context);

    if (result) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  void _openEditPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const InformasiPribadiScreen()),
    );

    if (result == true) {
      _getUser();
      _checkImage();
    }
  }

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _getUser();
    await _checkImage();
    await _getDetailPemeriksaan();

    isLoading = false;
  }

  Future<void> _getUser() async {
    dynamic user = await UserDatabase().readUser();

    if (user != null) {
      setState(() {
        nama = user.anggota.nama ?? '';
        nik = user.anggota.nik ?? '';
        role = user.role ?? '';
        id = user.anggota.id ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const CustomText(
          text: 'Profile',
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 77, 129, 231),
                  Colors.white,
                ],
                stops: [0.0, 0.3],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SafeArea(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: (localImg != null &&
                                      localImg!.path.isNotEmpty)
                                  ? FileImage(localImg!)
                                  : const AssetImage(
                                          'assets/images/picture.jpg')
                                      as ImageProvider,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          nama!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          nik!,
                          style: const TextStyle(
                              color: Color.fromARGB(221, 63, 63, 63)),
                        ),
                        Text(
                          "$role • Aktif",
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: GridView.count(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 16 / 9,
                            children: [
                              _StatCard(
                                icon: Icons.monitor_weight,
                                label: 'Berat Badan',
                                value: bb != null ? '$bb kg' : '-',
                              ),
                              _StatCard(
                                icon: Icons.favorite,
                                label: 'Tekanan Darah',
                                value: (sistol != null && diastol != null)
                                    ? '$sistol/$diastol mmHg'
                                    : '-',
                              ),
                              _StatCard(
                                icon: Icons.accessibility_new,
                                label: 'Lingkar Lengan',
                                value: lila != null ? '$lila cm' : '-',
                              ),
                              _StatCard(
                                icon: Icons.height,
                                label: 'Tinggi Rahim',
                                value: tinggi_rahim != null
                                    ? '$tinggi_rahim'
                                    : '-',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Setting",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Column(
                          children: [
                            ProfileMenuCard(
                              title: "Informasi Pribadi",
                              subtitle: "Lihat dan ubah informasi pribadi Anda",
                              icon: Icons.person,
                              onTap: () {
                                _openEditPage();
                              },
                            ),
                            // ProfileMenuCard(
                            //   title: "Data Keluarga",
                            //   subtitle: "Kelola informasi anggota keluarga",
                            //   icon: Icons.family_restroom,
                            //   onTap: () {
                            //     Navigator.push(
                            //       context,
                            //       MaterialPageRoute(
                            //           builder: (context) =>
                            //               DataKeluargaScreen()),
                            //     );
                            //   },
                            // ),
                            ProfileMenuCard(
                              title: "Ganti Password",
                              subtitle: "Perbarui kata sandi akun Anda",
                              icon: Icons.key,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          UbahPasswordScreen()),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              CustomDialog.show(
                                context,
                                title: "Log Out",
                                message:
                                    "Anda akan logout dari akun ini.\nApakah Anda yakin ingin melanjutkan?",
                                primaryButtonText: "Keluar",
                                onPrimaryPressed: _logout,
                                secondaryButtonText: "Batal",
                              );
                            },
                            icon: const Icon(Icons.logout, color: Colors.white),
                            label: const Text("Logout",
                                style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFB02A37),
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Color.fromARGB(255, 194, 216, 255),
          width: 1.2,
        ),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.blue,
            size: 26,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ProfileMenuCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const ProfileMenuCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFEEF3FF),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.blueAccent,
                child: Icon(icon, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
