import 'dart:developer';

import 'package:chatting_application/api/apis.dart';
import 'package:chatting_application/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../main.dart';
import 'auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      // EXIT FULL-SCREEN
      // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        systemNavigationBarColor: Colors.white,
      ));

      if (APIs.fAuth.currentUser != null) {
        log('\nUser: ${APIs.fAuth.currentUser}');

        // NAVIGATE TO HOME SCREEN
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      } else {
        // NAVIGATE TO LOGIN SCREEN
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // INITIALIZING MEDIA QUERY
    mq = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: mq.height * .15,
            right: mq.width * .25,
            width: mq.width * .5,
            child: Image(
              image: const AssetImage('assets/images/chat_outline.png'),
              color: Colors.teal[200],
            ),
          ),
          Positioned(
            bottom: mq.height * .15,
            width: mq.width,
            child: const Text(
              'MADE BY ANAS WITH ❤️ ',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 16,
                letterSpacing: .5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
