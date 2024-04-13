import 'dart:developer';

import 'package:chatting_application/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'package:flutter_notification_channel/notification_visibility.dart';

import 'firebase_options.dart';

//GLOBAL OBJECT FOR ACCESSING SCREEN SIZE
late Size mq;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //ENTER FULL-SCREEN
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  //FOR SETTING ORIENTATION TO PORTRAIT ONLY
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((value) async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    // _initializeFirebase();
    var result = await FlutterNotificationChannel.registerNotificationChannel(
      description: 'For showing message notification',
      id: 'chat',
      importance: NotificationImportance.IMPORTANCE_HIGH,
      name: 'Chats',
      visibility: NotificationVisibility.VISIBILITY_PUBLIC,
    );
    log('Notification Channel Result $result');
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatSphere',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
              titleTextStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                // backgroundColor: Colors.white,
              ),
              centerTitle: true,
              backgroundColor: Colors.teal),
          buttonTheme: ButtonThemeData(buttonColor: Colors.teal[300]),
          useMaterial3: true,
          colorSchemeSeed: Colors.teal[300]),
      home: const SplashScreen(),
    );
  }
}

// _initializeFirebase() async {
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
// }
