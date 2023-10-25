import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vehicle_management_and_booking_system/app/app.dart';
import 'package:vehicle_management_and_booking_system/utils/media_query.dart';
// ignore: avoid_web_libraries_in_flutter


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDyCtN4KYInCI8NXHKvYNVq4YPNk7e8o70",
          appId: "1:467918462056:web:37bc883433ff8d2b9d2fdd",
          messagingSenderId: "467918462056",
          projectId: "vmbs-2c700",
          storageBucket: "vmbs-2c700.appspot.com"),
    );
  } else {
    await Firebase.initializeApp();
  }
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    //DeviceOrientation.landscapeLeft,
    // DeviceOrientation.landscapeRight
  ]).then(
    (_) {
      // html.document.body!.style
      //   ..margin = '0'
      //   ..padding = '0'
      //   ..minWidth = '800px' // Set your desired width
      //   ..maxWidth = '400px' // Should be same as minWidth
      //   ..minHeight = '600px' // Set your desired height
      //   ..maxHeight = '600px'; // Should be same as minHeight

      runApp(MyApp());
    },
  );
}
