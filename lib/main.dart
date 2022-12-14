import 'package:flutter/material.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'package:vehicle_management_and_booking_system/screens/home_screen.dart';
import 'package:vehicle_management_and_booking_system/screens/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Widget example1 = SplashScreenView(
      navigateRoute: const LoginScreen(),
      duration: 5000,
      imageSize: 130,
      imageSrc: "assets/images/main.png",
      text: "Splash Screen",
      textType: TextType.ColorizeAnimationText,
      textStyle: const TextStyle(
        fontSize: 40.0,
      ),
      colors: const [
        Colors.purple,
        Colors.blue,
        Colors.yellow,
        Colors.red,
      ],
      backgroundColor: Colors.white,
    );
    return MaterialApp(
      title: 'VMBS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
       // brightness: Brightness.dark
      ),
      home: HomeScreen(title: "title"),
    );
  }
}

