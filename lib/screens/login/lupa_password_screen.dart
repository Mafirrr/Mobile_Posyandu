import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:posyandu_mob/core/services/auth_service.dart';
import 'package:posyandu_mob/screens/login/verifikasi_kode_screen.dart';
import 'package:posyandu_mob/widgets/custom_button.dart';
import 'package:posyandu_mob/widgets/custom_text.dart';

class LupaPasswordScreen extends StatefulWidget {
  const LupaPasswordScreen({super.key});

  @override
  _LupaPasswordScreenState createState() => _LupaPasswordScreenState();
}

class _LupaPasswordScreenState extends State<LupaPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  String verificationId = "";
  bool isLoading = false;

  final authService = AuthService();

  void _lupaPassword(String input) async {
    if (input.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Harap masukkan nomor telepon.")),
      );
      return;
    }

    final phoneRegex = RegExp(r"^\+?\d{10,15}$");

    try {
      setState(() {
        isLoading = true;
      });
      if (!phoneRegex.hasMatch(input)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Format email atau nomor telepon tidak valid.")),
        );
        return;
      }

      print(input);
      final response = await authService.changePassword(input);

      if (response != null && response.statusCode == 200) {
        final identifer = response.data['identifier'];

        await sendOtp(identifer);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Kode OTP telah dikirim.")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Akun tidak ditemukan.")),
        );
      }
    } catch (e) {
      debugPrint("Error lupaPassword: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Terjadi kesalahan. Silakan coba lagi.")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> sendOtp(String noTelp) async {
    try {
      final response = await authService.sendOtpToEmail(noTelp);

      if (response.statusCode == 200) {
        final data = response.data;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => VerifikasiKodeScreen(
              verificationId: '',
              identifer: noTelp,
              user_id: data['user_id'],
              tipe: "nomor",
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint("Error lupaPassword: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Terjadi kesalahan. Silakan coba lagi.")),
      );
    }
  }

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
                  Image.asset('assets/images/logo.png', height: 60),
                  const SizedBox(height: 10),
                  const CustomText(
                    text: "Lupa Password",
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Masukkan nomor telepon yang terdaftar untuk mengatur ulang kata sandi Anda.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14, color: Color.fromARGB(255, 52, 59, 65)),
                  ),
                  const SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Nomor telepon harus diisi';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              hintText: 'Nomor Telepon',
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: CustomButton(
                            text: "Kirim Kode OTP",
                            isLoading: isLoading,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _lupaPassword(_phoneController.text.trim());
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
