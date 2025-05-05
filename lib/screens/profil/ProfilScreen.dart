import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:posyandu_mob/core/database/UserDatabase.dart';
import 'package:posyandu_mob/core/models/Anggota.dart';
import 'package:posyandu_mob/core/services/auth_service.dart';
import 'package:posyandu_mob/core/viewmodel/auth_viewmodel.dart';
import 'package:posyandu_mob/screens/login/login_screen.dart';
import 'package:posyandu_mob/screens/profil/InformasiPribadiScreen.dart';
import 'package:posyandu_mob/screens/profil/data_keluarga_screen.dart';
import 'package:posyandu_mob/widgets/custom_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfilScreen> {
  int? id;
  String? nama, role;

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    final authProvider = Provider.of<AuthViewModel>(context, listen: false);
    await authProvider.logout(context);

    if (prefs.getString('token') == null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  Future<void> _getUser() async {
    // final prefs = await SharedPreferences.getInstance();
    // final String? userData = prefs.getString(AuthService.userKey);
    dynamic user = await UserDatabase.instance.readUser();

    if (user != null) {
      setState(() {
        nama = user.anggota.nama ?? '';
        role = user.role ?? '';
        id = user.anggota.id ?? '';
      });
    } else {
      print("object not found");
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: SingleRoundedCurveClipper(),
              child: Container(
                height: 250,
                color: const Color.fromARGB(51, 133, 180, 255),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),

              // Profile Info
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage("assets/images/picture.jpg"),
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
                            color: Colors.grey,
                            fontSize: screenWidth * 0.035,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Spacer to push the cards into the middle
              const SizedBox(height: 40),

              // Info Cards Positioned in the Middle
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 100,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const InformasiPribadiScreen()),
                  );
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
                    backgroundColor: Colors.red,
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
      onTap: onTap, // Execute the function when tapped
    );
  }
}
