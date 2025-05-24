import 'package:flutter/material.dart';
import 'package:posyandu_mob/core/database/UserDatabase.dart';
import 'package:posyandu_mob/core/services/KehamilanService.dart';
import 'package:posyandu_mob/screens/login/login_screen.dart';
import 'package:posyandu_mob/screens/navigation/drawerKader_screen.dart';
import 'package:posyandu_mob/screens/navigation/navAnggota_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController bgController;
  late Animation<double> bgAnimation;

  late AnimationController logoController;
  late Animation<double> logoOpacity;
  late Animation<double> logoScale;
  late Animation<Offset> logoOffset;

  late AnimationController textController;
  late Animation<double> textOpacity;

  late AnimationController fadeOutController;
  late Animation<double> fadeOutAnimation;

  bool showSplash = true;
  bool isLoggedIn = false;
  String role = '';

  // Durasi animasi
  final backgroundDuration = const Duration(milliseconds: 1000);
  final delayAfterBackground = const Duration(milliseconds: 200);
  final logoDuration = const Duration(milliseconds: 800);
  final textDuration = const Duration(milliseconds: 800);
  final delayAfterText = const Duration(milliseconds: 800);
  final fadeOutDuration = const Duration(milliseconds: 400);

  @override
  void initState() {
    super.initState();
    checkLoginStatus();

    bgController = AnimationController(
      duration: backgroundDuration,
      vsync: this,
    );
    bgAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: bgController, curve: Curves.easeOut),
    );

    logoController = AnimationController(
      duration: logoDuration,
      vsync: this,
    );
    logoOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: logoController, curve: Curves.easeIn),
    );
    logoScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: logoController, curve: Curves.easeOutBack),
    );

    textController = AnimationController(
      duration: textDuration,
      vsync: this,
    );
    textOpacity = Tween<double>(begin: 0, end: 1).animate(textController);

    logoOffset = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: textController, curve: Curves.easeOut));

    fadeOutController = AnimationController(
      duration: fadeOutDuration,
      vsync: this,
    );
    fadeOutAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: fadeOutController, curve: Curves.easeOut),
    );

    runAnimation();
  }

  Future<bool> checkLoginStatus() async {
    dynamic user = await UserDatabase().readUser();

    if (user != null) {
      setState(() {
        role = user.role;
        isLoggedIn = true;
      });
    } else {
      dynamic user = await UserDatabase().readPetugas();
      setState(() {
        role = user.role;
        isLoggedIn = true;
      });
    }
    return false;
  }

  // Fungsi untuk menjalankan animasi
  Future<void> runAnimation() async {
    await bgController.forward();
    await Future.delayed(delayAfterBackground);
    await logoController.forward();
    await textController.forward();
    await Future.delayed(delayAfterText);
    await fadeOutController.forward();
    setState(() {
      showSplash = false;
    });

    _renewData() async {
      final pemeriksaanService = KehamilanService();
      await pemeriksaanService.dataKehamilan();
    }

    if (isLoggedIn == true) {
      if (role == 'anggota') {
        _renewData();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const NavAnggotaScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DrawerkaderScreen()),
        );
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  void dispose() {
    bgController.dispose();
    logoController.dispose();
    textController.dispose();
    fadeOutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (showSplash)
            FadeTransition(
              opacity: fadeOutAnimation,
              child: AnimatedBuilder(
                animation: bgAnimation,
                builder: (context, child) {
                  return CustomPaint(
                    painter: ExpandingCirclePainter(
                        animationValue: bgAnimation.value),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SlideTransition(
                            position: logoOffset,
                            child: ScaleTransition(
                              scale: logoScale,
                              child: FadeTransition(
                                opacity: logoOpacity,
                                child: Image.asset(
                                  'assets/images/logo_putih.png',
                                  width: 120,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 0),
                          FadeTransition(
                            opacity: textOpacity,
                            child: const Text(
                              "Posyandu",
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class ExpandingCirclePainter extends CustomPainter {
  final double animationValue;

  ExpandingCirclePainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.longestSide * animationValue;
    final paint = Paint()..color = Colors.blue;
    canvas.drawCircle(size.center(Offset.zero), radius, paint);
  }

  @override
  bool shouldRepaint(covariant ExpandingCirclePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
