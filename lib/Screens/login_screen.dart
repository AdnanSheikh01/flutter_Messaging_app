import 'dart:developer';
import 'dart:io';
import 'package:chatting_app/Screens/home_screen.dart';
import 'package:chatting_app/models/Apis.dart';
import 'package:chatting_app/utils/dialogs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
  }

  _handleGoogleBtnClick() {
    dialogs.showProgressBar(context);

    _signInWithGoogle().then(
      (user) async {
        Navigator.pop(context);

        if (user != null) {
          log('\nUser: ${user.user}');
          log('\nUserAdditionalInfo: ${user.additionalUserInfo}');

          if ((await Api.userExists())) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const HomeScreen()));
          } else {
            await Api.createUser().then(
              (value) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()));
              },
            );
          }
        }
      },
    );
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
      return await Api.auth.signInWithCredential(credential);
    } catch (e) {
      log('\n_signInWithGoogle: $e');
      dialogs.showSnackBar(
          context,
          'Something Went Wrong, try again later or Check Internet !!',
          Colors.red,
          EdgeInsets.only(bottom: MediaQuery.of(context).size.height * .01));
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(height: MediaQuery.of(context).size.height * .12),
                Text(
                  "Welcome to Alpine",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 35),
                ),
                Text(
                  "Let's go into your account",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * .07),
                Lottie.asset('assets/login_page.json'),
                SizedBox(height: MediaQuery.of(context).size.height * .09),
                Container(
                  height: MediaQuery.of(context).size.height * .07,
                  width: MediaQuery.of(context).size.width * .75,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: const StadiumBorder(),
                        elevation: 1),
                    onPressed: () {
                      _handleGoogleBtnClick();
                    },
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Login with ',
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                                TextSpan(
                                  text: 'Google',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Image.asset(
                            'images/google.png',
                            height: MediaQuery.of(context).size.height * .03,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
