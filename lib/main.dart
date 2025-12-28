import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myberikan/firebase_options.dart';
import 'package:myberikan/views/dashboard_karyawan.dart';
import 'package:myberikan/views/login_screen.dart';
import 'package:myberikan/views/register_screen.dart';
import 'package:myberikan/views/dashboard.dart';
import 'package:myberikan/views/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegisterScreen.id: (context) => RegisterScreen(),
        DashboardHR.id: (context) => DashboardHR(idHR: ""),
        DashboardKaryawan.id: (context) => DashboardKaryawan(idKaryawan: ""),
      },
    );
  }
}
