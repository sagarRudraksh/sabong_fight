import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sabong_fight/screen/start_game_page.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (context) => const StartGamePage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/bg.png'), fit: BoxFit.cover),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 3),

              // Logo
              Image.asset(
                "assets/images/sabong_logo.png",
                width: size.width * 0.55,
                height: size.width * 0.55,
              ),

              const SizedBox(height: 20),

              // Title Text
              Text(
                "Sabong Fight",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size.width * 0.08,
                  fontWeight: FontWeight.w300,
                ),
              ),

              // Subtitle Text
              Text(
                "SabongPH 2026",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size.width * 0.085,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Spacer(flex: 4),
            ],
          ),
        ),
      ),
    );
  }
}
