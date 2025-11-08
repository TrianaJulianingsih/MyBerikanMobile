import 'package:flutter/material.dart';
import 'package:myberikan/views/dashboard.dart';
import 'package:myberikan/views/login_screen.dart';
import 'package:myberikan/views/riwayat_kehadiran.dart';
import 'package:myberikan/views/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Flutter Demo', home: SplashScreen(), routes: {
      LoginScreen.id: (context) => LoginScreen(),
      DashboardScreen.id: (context) => DashboardScreen(),
    },);
  }
}
