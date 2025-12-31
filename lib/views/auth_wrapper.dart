import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myberikan/views/login_screen.dart';
import 'package:myberikan/views/role_redirect.dart';
import 'package:myberikan/views/splash_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});
  static String id = "/auth_wrapper";

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData) {
          return RoleRedirect();
        }
        return SplashScreen();
      },
    );
  }
}