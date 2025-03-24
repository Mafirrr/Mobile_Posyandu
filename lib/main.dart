import 'package:flutter/material.dart';
import 'package:posyandu_mob/core/viewmodel/auth_viewmodel.dart';
import 'package:posyandu_mob/screens/login_screen.dart';
import 'package:posyandu_mob/widgets/custom_text.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authViewModel = AuthViewModel();
  await authViewModel.loadUser(); // Load user data on startup

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => authViewModel),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Consumer<AuthViewModel>(
        builder: (context, authViewModel, child) {
          if (authViewModel.isLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (authViewModel.user != null) {
            return const CustomText(text: "Dashboard");
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
