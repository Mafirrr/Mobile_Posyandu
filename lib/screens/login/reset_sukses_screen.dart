import 'package:flutter/material.dart';
import 'package:posyandu_mob/screens/login/login_screen.dart';
import 'package:posyandu_mob/widgets/custom_button.dart';
import 'package:posyandu_mob/widgets/custom_text.dart';

class ResetSuksesScreen extends StatefulWidget {
  const ResetSuksesScreen({super.key});

  @override
  _ResetSuksesScreenState createState() => _ResetSuksesScreenState();
}

class _ResetSuksesScreenState extends State<ResetSuksesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF4D81E7),
                  Color(0x99FFFFFF),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.6),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/images/sukses.png', height: 60),
                  const SizedBox(height: 10),
                  const CustomText(
                    text: "Berhasil",
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Selamat! Kata sandi Anda telah diubah. Klik Selesai untuk masuk.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14, color: Color.fromARGB(255, 52, 59, 65)),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      text: "Selesai",
                      isLoading: false,
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                        );
                      },
                      backgroundColor: const Color(0xFF4A7EFF),
                      textColor: Colors.white,
                      height: 50,
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
