import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:posyandu_mob/core/services/auth_service.dart';
import 'package:posyandu_mob/screens/login/password_reset_screen.dart';
import 'package:posyandu_mob/widgets/custom_button.dart';
import 'package:posyandu_mob/widgets/custom_text.dart';

class VerifikasiKodeScreen extends StatefulWidget {
  final String verificationId, identifer, tipe;
  const VerifikasiKodeScreen(
      {super.key,
      required this.verificationId,
      required this.identifer,
      required this.tipe});

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
  AuthService authService = AuthService();
  bool isLoading = false;
  String verification = "";

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

  Future<void> handleResend(String identifier) async {
    try {
      if (widget.tipe == "email") {
        await authService.sendOtpToEmail(identifier);
        showSnack("Kode OTP telah dikirim ulang ke email.");
      } else {
        authService.sendOtp(
          phoneNumber: identifier,
          onVerificationCompleted: (_) {},
          onVerificationFailed: (e) =>
              showSnack("Verifikasi gagal: ${e.message}"),
          onCodeSent: (verId, _) {
            setState(() => verification = verId);
            showSnack("OTP dikirim ulang ke nomor.");
          },
          onCodeAutoRetrievalTimeout: (verId) =>
              setState(() => verification = verId),
        );
      }
    } catch (_) {
      showSnack("Gagal mengirim ulang OTP.");
    }
  }

  void showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void verifyOtp() async {
    setState(() {
      isLoading = true;
    });

    if (widget.tipe == "email") {
      try {
        final response =
            await authService.verifyOtp(widget.identifer, mergedText!);

        if (response.statusCode == 200) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PasswordResetScreen(
                identifier: widget.identifer,
                otp: mergedText!,
              ),
            ),
          );
        } else {
          showSnack("OTP salah atau kadaluarsa.");
        }
      } catch (e) {
        showSnack("Gagal verifikasi OTP email.");
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    } else if (widget.tipe == "nomor") {
      if (verification.isEmpty) {
        verification = widget.verificationId;
      }

      final credential = PhoneAuthProvider.credential(
        verificationId: verification,
        smsCode: mergedText!,
      );

      try {
        final userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        if (userCredential.user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PasswordResetScreen(
                identifier: widget.identifer,
                otp: '',
              ),
            ),
          );
        }
      } catch (e) {
        showSnack("OTP Firebase salah, coba lagi.");
      } finally {
        setState(() {
          isLoading = false;
        });
      }
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
                  Image.asset('assets/images/logo.png', height: 60),
                  const SizedBox(height: 10),
                  const CustomText(
                    text: "Verifikasi OTP",
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Masukkan kode OTP yang dikirim ke ${widget.tipe} Anda",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color.fromARGB(255, 52, 59, 65),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(6, (index) {
                      return SizedBox(
                        width: 50,
                        height: 60,
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
                        isLoading: isLoading,
                        onPressed: () {
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
                            handleResend(widget.identifer);
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
