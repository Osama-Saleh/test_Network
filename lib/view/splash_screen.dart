// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:netwrok/Cubit/home_cubit.dart';
import 'package:netwrok/constaint/constant.dart';
import 'package:netwrok/view/Home_Screen.dart';
import 'package:lottie/lottie.dart';
import 'package:netwrok/view/button_app_bar.dart';
import 'package:netwrok/view/register_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool animate = false;
  Future startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      animate = true;
    });
  }

  navigatToHome() async {
    await Future.delayed(const Duration(seconds: 6));
    if (Constant.uid == null || Constant.uid == "") {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RegisterScreen(),
          ));
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MyButtonAppBarScreen(),
          ));
    }
  }

  @override
  void initState() {
    startAnimation();
    navigatToHome();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: const Color.fromRGBO(47, 70, 109, 60),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: Duration(milliseconds: 1500),
              top: animate ? 50 : -100,
              left: 30,
              child: Lottie.asset("assets/splash_shop.json", width: 300),
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: 1500),
              top: 400,
              left: animate ? 20 : -400,
              child: Text(
                "Eazy Shopping ",
                style: TextStyle(color: Colors.white, fontSize: 50),
              ),
            )
          ],
        ),
      ),
    );
  }
}
