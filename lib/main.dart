import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:myberikan/firebase_options.dart';
import 'package:myberikan/views/auth_wrapper.dart';
import 'package:myberikan/views/dashboard_karyawan.dart';
import 'package:myberikan/views/login_screen.dart';
import 'package:myberikan/views/register_screen.dart';
import 'package:myberikan/views/dashboard.dart';
import 'package:myberikan/views/splash_screen.dart';
import 'package:myberikan/views/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await initializeDateFormatting('id_ID', "null");
  await FirebaseMessaging.instance.requestPermission();
  await initializeDateFormatting('id_ID');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthWrapper(),
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
