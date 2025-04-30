import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:posyandu_mob/core/viewmodel/artikel_viewmodel.dart';
import 'package:flutter/services.dart';
import 'package:posyandu_mob/core/viewmodel/auth_viewmodel.dart';
import 'package:posyandu_mob/core/viewmodel/kategori_viewmodel.dart';
import 'package:posyandu_mob/core/viewmodel/profile_viewmodel.dart';
import 'package:posyandu_mob/screens/SplashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await initializeDateFormatting('id_ID', null);
  FirebaseAuth.instance.setLanguageCode('id');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfilViewModel()),
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => ArtikelViewModel()..getArtikel()),
         ChangeNotifierProvider(create: (_) => KategoriViewmodel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
