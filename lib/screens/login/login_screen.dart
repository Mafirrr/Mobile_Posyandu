import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:posyandu_mob/core/services/auth_service.dart';
import 'package:posyandu_mob/core/viewmodel/auth_viewmodel.dart';
import 'package:posyandu_mob/screens/navigation/navAnggota_screen.dart';
import 'package:posyandu_mob/widgets/custom_button.dart';
import 'package:posyandu_mob/widgets/custom_text.dart';
import 'package:posyandu_mob/widgets/custom_textfield.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isPass = true;
  String? alert;

  Future<String> checkRole() async {
    final prefs = await SharedPreferences.getInstance();
    final String? userData = prefs.getString(AuthService.userKey);

    if (userData != null) {
      final Map<String, dynamic> userMap = jsonDecode(userData);
      return userMap['role'] ?? '';
    }

    return '';
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Gradient Background
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
                  Image.asset('images/logo.png', height: 60),
                  const SizedBox(height: 10),
                  const CustomText(
                    text: "Login",
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Mulai Langkah Pertama Menuju Kehamilan Sehat\n"
                    "dengan Catatan dan Pantauan Setiap Hari!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: CustomText(
                            text: alert ?? "",
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        CustomTextField(
                          controller: _nikController,
                          label: "NIK",
                          keyboardType: TextInputType.number,
                          validator: (value) => (value == null || value.isEmpty)
                              ? "NIK harus diisi"
                              : null,
                        ),
                        const SizedBox(height: 14),
                        CustomTextField(
                          controller: _passwordController,
                          label: "Password",
                          obscureText: isPass,
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isPass = !isPass;
                              });
                            },
                            icon: Icon(isPass
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                          validator: (value) =>
                              value!.isEmpty ? "Password harus diisi" : null,
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // TODO: Implement Forgot Password
                            },
                            child: const Text("Lupa Password?",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.blueAccent)),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: CustomButton(
                            text: "Masuk",
                            isLoading: authViewModel.isLoading,
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                bool success = await authViewModel.login(
                                  _nikController.text.trim(),
                                  _passwordController.text.trim(),
                                );

                                if (success) {
                                  String? role = await checkRole();

                                  if (role == "anggota") {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const NavAnggotaScreen()),
                                    );
                                  } else {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginScreen()),
                                    );
                                  }
                                } else {
                                  setState(() {
                                    alert = "Email atau Password salah!";
                                  });
                                }
                              }
                            },
                            backgroundColor: const Color(0xFF4A7EFF),
                            textColor: Colors.white,
                            height: 50,
                          ),
                        ),
                      ],
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
