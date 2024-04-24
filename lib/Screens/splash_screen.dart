import 'dart:developer';

import 'package:chatting_app/Screens/login_screen.dart';
import 'package:chatting_app/Screens/home_screen.dart';
import 'package:chatting_app/models/Apis.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(
      const Duration(seconds: 2),
      () {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            systemNavigationBarColor: Colors.white));

        if (Api.auth.currentUser != null) {
          log('\nUser: ${Api.auth.currentUser}');
          //navigate to home screen
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const HomeScreen()));
        } else {
          //navigate to login screen
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const LoginScreen()));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * .15),
            Image.asset(
              "images/messenger.png",
              height: MediaQuery.of(context).size.height * .4,
              width: MediaQuery.of(context).size.width * .6,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .15,
            ),
            Text(
              "Welcome to Alpine",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
