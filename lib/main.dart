import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:vehicle_management_and_booking_system/app/app.dart';
import 'package:timezone/data/latest.dart' as tz;

// ignore: avoid_web_libraries_in_flutter

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message ${message.data}");
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   tz.initializeTimeZones();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          // apiKey: "AIzaSyDyCtN4KYInCI8NXHKvYNVq4YPNk7e8o70",
          // appId: "1:467918462056:web:37bc883433ff8d2b9d2fdd",
          // messagingSenderId: "467918462056",
          // projectId: "vmbs-2c700",
          // storageBucket: "vmbs-2c700.appspot.com"
          apiKey: "AIzaSyDyCtN4KYInCI8NXHKvYNVq4YPNk7e8o70",
          authDomain: "vmbs-2c700.firebaseapp.com",
          databaseURL: "https://vmbs-2c700-default-rtdb.firebaseio.com",
          projectId: "vmbs-2c700",
          storageBucket: "vmbs-2c700.appspot.com",
          messagingSenderId: "467918462056",
          appId: "1:467918462056:web:7478d83e2c7369189d2fdd",
          measurementId: "G-VXFMBV6G80"),
    );
  } else {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
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
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);
      runApp(MyApp());
    },
  );
}
