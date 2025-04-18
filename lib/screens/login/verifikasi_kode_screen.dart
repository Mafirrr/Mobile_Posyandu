import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:posyandu_mob/screens/login/password_reset_screen.dart';
import 'package:posyandu_mob/widgets/custom_button.dart';
import 'package:posyandu_mob/widgets/custom_text.dart';

class VerifikasiKodeScreen extends StatefulWidget {
  final String verificationId;
  const VerifikasiKodeScreen({Key? key, required this.verificationId})
      : super(key: key);

  @override
  State<VerifikasiKodeScreen> createState() => _VerifikasiKodeScreenState();
}

class _VerifikasiKodeScreenState extends State<VerifikasiKodeScreen> {
  final int length = 6;
  List<TextEditingController> controllers = [];
  String? mergedText;
  List<FocusNode> focusNodes = [];
  bool showResendButton = false;
  Duration countdownDuration = const Duration(minutes: 3);
  Timer? _resendTimer;
  String countdownText = '';

  @override
  void initState() {
    super.initState();
    controllers = List.generate(length, (_) => TextEditingController());
    focusNodes = List.generate(length, (_) => FocusNode());

    startCountdown();
  }

  void onOtpChanged() {
    mergedText = controllers.map((controller) => controller.text).join();
  }

  void verifyOtp() async {
    final credential = PhoneAuthProvider.credential(
      verificationId: widget.verificationId,
      smsCode: mergedText!,
    );

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PasswordResetScreen()),
        );
      }
    } catch (e) {
      // Catch errors such as incorrect OTP or network issues
      print("OTP verification failed: $e");

      // Optionally, show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("OTP salah, coba lagi.")),
      );
    }
  }

  void startCountdown() {
    const oneSec = Duration(seconds: 1);
    int secondsRemaining = countdownDuration.inSeconds;

    _resendTimer = Timer.periodic(oneSec, (timer) {
      if (secondsRemaining == 0) {
        timer.cancel();
        setState(() {
          showResendButton = true;
        });
      } else {
        secondsRemaining--;
        final minutes = (secondsRemaining ~/ 60).toString().padLeft(2, '0');
        final seconds = (secondsRemaining % 60).toString().padLeft(2, '0');
        setState(() {
          countdownText = 'Kirim ulang dalam $minutes:$seconds';
        });
      }
    });
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
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
                  Image.asset('images/logo.png', height: 60),
                  const SizedBox(height: 10),
                  const CustomText(
                    text: "Verifikasi OTP",
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Masukkan kode OTP yang dikirim ke nomor Anda",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color.fromARGB(255, 52, 59, 65),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(6, (index) {
                      return Container(
                        width: 50,
                        height: 60,
                        // alignment: Alignment.center,
                        // decoration: BoxDecoration(
                        //   color: Colors.transparent,
                        //   borderRadius: BorderRadius.circular(12),
                        //   border: Border.all(
                        //     color: Color.fromARGB(255, 151, 151, 151),
                        //     width: 1,
                        //   ),
                        // ),
                        child: TextField(
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          controller: controllers[index],
                          focusNode: focusNodes[index],
                          maxLength: 1,
                          onChanged: (value) {
                            if (value.length == 1 && index < length - 1) {
                              FocusScope.of(context)
                                  .requestFocus(focusNodes[index + 1]);
                            } else if (value.isEmpty && index > 0) {
                              FocusScope.of(context)
                                  .requestFocus(focusNodes[index - 1]);
                            }
                            onOtpChanged();
                          },
                          decoration: InputDecoration(
                            counterText: '',
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.blue),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 30),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        text: "Kirim Kode OTP",
                        isLoading: false,
                        onPressed: () {
                          // Resend logic here
                          verifyOtp();
                        },
                        backgroundColor: const Color(0xFF4A7EFF),
                        textColor: Colors.white,
                        height: 50,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: showResendButton
                        ? () {
                            //
                          }
                        : null,
                    child: Text.rich(
                      TextSpan(
                        text: 'Belum menerima kode? ',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                        children: showResendButton
                            ? [
                                const TextSpan(
                                  text: 'Kirim ulang',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF4A7EFF),
                                  ),
                                ),
                              ]
                            : [
                                TextSpan(
                                  text: countdownText,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF4A7EFF),
                                  ),
                                ),
                              ],
                      ),
                      textAlign: TextAlign.center,
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
