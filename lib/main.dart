import 'package:camera/camera.dart';
import 'package:chatting_app/Screens/camera_screen.dart';
import 'package:chatting_app/Screens/home_screen.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: ' Message Chat',
        home: HomeScreen());
  }
}
