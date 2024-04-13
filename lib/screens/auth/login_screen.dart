import 'dart:developer';
import 'dart:io';

import 'package:chatting_application/api/apis.dart';
import 'package:chatting_application/helper/dialogs.dart';
import 'package:chatting_application/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../main.dart';

//login screen -- implements google sign in or sign up feature for app
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isAnimated = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(microseconds: 500), () {
      setState(() => _isAnimated = true);
    });
  }

  handleGoogleBtnClick() {
    // Store the context before the async operation
    BuildContext currentContext = context;

    //FOR SHOWING PROGRESS BAR
    Dialogs.showProgressBar(context);

    _signInWithGoogle().then((user) async {
      //FOR HIDING PROGRESS BAR
      Navigator.pop(context);
      if (user != null) {
        log('\nUser: ${user.user}');
        log('\nUserAdditionalInfo: ${user.additionalUserInfo}');

        if ((await APIs.userExits())) {
          if (mounted) {
            Navigator.pushReplacement(currentContext,
                MaterialPageRoute(builder: (_) => const HomeScreen()));
          }
        } else {
          await APIs.createUser().then((value) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const HomeScreen()));
          });
        }
      }
    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      log('\n_signInWithGoogle: $e');
      if (mounted) {
        Dialogs.showSnackBar(context, 'something went wrong (No Internet)');
      }

      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Welcome to ChatSphere',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Stack(
        children: [
          //APP LOGO
          AnimatedPositioned(
            top: mq.height * 0.15,
            right: _isAnimated ? mq.width * 0.25 : -mq.width * .5,
            width: mq.width * 0.50,
            duration: const Duration(seconds: 3),
            child: Image(
              image: const AssetImage('assets/images/chat_outline.png'),
              color: Colors.teal[100],
            ),
          ),

          //GOOGLE LOGIN BUTTON
          Positioned(
            bottom: mq.height * 0.15,
            left: mq.width * 0.05,
            height: mq.height * 0.06,
            width: mq.width * 0.9,
            child: ElevatedButton.icon(
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.teal[100]),
              onPressed: () {
                handleGoogleBtnClick();
              },
              icon: Image(
                image: const AssetImage('assets/images/google.png'),
                height: mq.height * 0.04,
              ),
              label: RichText(
                text: const TextSpan(
                  style: TextStyle(color: Colors.black, fontSize: 16),
                  children: [
                    TextSpan(text: ' Login in with '),
                    TextSpan(
                        text: 'Google',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
