
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:engv1/utils/splash.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

import 'sign_up.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue[900],
      ),
     home: const Splash(),
     // home: AnimatedSplashScreen(
     //   splash: Image.asset(
     //     'assets/logo.png',
     //     width: 200,
     //     height: 200,
     // ), nextScreen: SignInPage(),splashTransition: SplashTransition.fadeTransition,),
    );
  }
}
