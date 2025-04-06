import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:posyandu_mob/core/services/auth_service.dart';
import 'package:posyandu_mob/core/viewmodel/auth_viewmodel.dart';
import 'package:posyandu_mob/core/viewmodel/profile_viewmodel.dart';
import 'package:posyandu_mob/screens/login/login_screen.dart';
import 'package:posyandu_mob/screens/navigation/navAnggota_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => ProfilViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

Future<Map<String, dynamic>?> checkLoginStatus() async {
  return await _getUser();
}

Future<dynamic> _getUser() async {
  final prefs = await SharedPreferences.getInstance();
  final String? userData = prefs.getString(AuthService.userKey);

  if (userData != null) {
    final Map<String, dynamic> userMap = jsonDecode(userData);
    return userMap;
  }
  return null;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<Map<String, dynamic>?>(
        future: checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasData && snapshot.data != null) {
            final userMap = snapshot.data!;

            if (userMap['role'] == "anggota") {
              return const NavAnggotaScreen();
            } else {
              return const LoginScreen();
            }
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
