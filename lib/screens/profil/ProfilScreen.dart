import 'dart:io';
import 'package:flutter/material.dart';
import 'package:posyandu_mob/core/database/UserDatabase.dart';
import 'package:posyandu_mob/core/viewmodel/auth_viewmodel.dart';
import 'package:posyandu_mob/core/viewmodel/profile_viewmodel.dart';
import 'package:posyandu_mob/screens/login/login_screen.dart';
import 'package:posyandu_mob/screens/profil/InformasiPribadiScreen.dart';
import 'package:posyandu_mob/screens/profil/data_keluarga_screen.dart';
import 'package:posyandu_mob/widgets/custom_dialog.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfilScreen> {
  int? id;
  String? nama, role;
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

    isLoading = false;
  }

  Future<void> _getUser() async {
    dynamic user = await UserDatabase.instance.readUser();

    if (user != null) {
      setState(() {
        nama = user.anggota.nama ?? '';
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
          : Stack(
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
                  )),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),

                    //profile
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: (localImg != null &&
                                    localImg!.path.isNotEmpty)
                                ? FileImage(localImg!)
                                : const AssetImage('assets/images/picture.jpg'),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "$nama",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenWidth * 0.05,
                                ),
                              ),
                              Text(
                                "$role",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenWidth * 0.035,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    //info card
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 100,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(
                            top: 10,
                            left: 10,
                            right: 10,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                  child: InfoCard(
                                "Berat Badan",
                                "50.2 kg",
                                "assets/images/berat_badan.png",
                              )),
                              const SizedBox(width: 8),
                              Expanded(
                                  child: InfoCard(
                                "Tinggi Badan",
                                "160 cm",
                                "assets/images/tinggi_badan.png",
                              )),
                              const SizedBox(width: 8),
                              Expanded(
                                  child: InfoCard(
                                "Tekanan Darah",
                                "120/100 mmHg",
                                "assets/images/tekanan_darah.png",
                              )),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 50),

                    MenuOption(
                      Icons.person,
                      "Informasi Pribadi",
                      onTap: () {
                        _openEditPage();
                      },
                    ),
                    MenuOption(
                      Icons.group,
                      "Data Keluarga",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const DataKeluargaScreen()),
                        );
                      },
                    ),

                    const Spacer(),

                    // Logout Button at Bottom
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
                            onPrimaryPressed: () {
                              _logout();
                            },
                            secondaryButtonText: "Batal",
                          );
                        },
                        icon: const Icon(Icons.logout, color: Colors.white),
                        label: const Text("Logout",
                            style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 176, 42, 55),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}

class SingleRoundedCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(
        size.width / 2, size.height + 40, size.width, size.height - 40);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final String icon;

  const InfoCard(this.title, this.value, this.icon, {super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      height: screenWidth * 0.28,
      width: screenWidth * 0.28,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.02),
          child: Column(
            children: [
              Image.asset(
                icon,
                width: screenWidth * 0.08,
                height: screenWidth * 0.08,
              ),
              SizedBox(height: screenWidth * 0.02),
              Text(title,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: screenWidth * 0.02,
                  )),
              SizedBox(height: screenWidth * 0.02),
              Text(value,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.03,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

// Menu Option Widget
class MenuOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const MenuOption(this.icon, this.title, {required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
      trailing:
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}
