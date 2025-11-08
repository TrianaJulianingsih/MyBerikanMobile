import 'package:flutter/material.dart';
import 'package:myberikan/extension/navigation.dart';
import 'package:myberikan/utils/app_image.dart';
import 'package:myberikan/views/dashboard.dart';
import 'package:myberikan/views/login_screen.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const id = "/splash_screen";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    isLogin();
  }

  void isLogin() async {
    // bool? isLogin = await PreferenceHandler.getLogin();

    Future.delayed(Duration(seconds: 3)).then((value) async {
      print(isLogin);
      if (isLogin == true) {
        context.pushReplacementNamed(DashboardScreen.id);
      } else {
        context.push(LoginScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 200,
              width: 200,
              child: Image.asset(AppImage.logo,)),
            SizedBox(height: 20),
            Text("Welcome"),
          ],
        ),
      ),
    );
  }
}