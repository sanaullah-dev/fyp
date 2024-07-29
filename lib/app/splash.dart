// ignore_for_file: use_build_context_synchronously



import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_management_and_booking_system/authentication/controllers/auth_controller.dart';
import 'package:vehicle_management_and_booking_system/widgets/notification.dart';

class SplashScreenOrLoadingScreen extends StatefulWidget {
  const SplashScreenOrLoadingScreen({super.key});

  @override
  State<SplashScreenOrLoadingScreen> createState() =>
      _SplashScreenOrLoadingScreenState();
}

class _SplashScreenOrLoadingScreenState
    extends State<SplashScreenOrLoadingScreen> {
  NotificationServices notificationServices = NotificationServices();
  @override
  void initState() {
    if (kIsWeb) {
      notificationServices.messageListener(context);
    } else {
     
      notificationServices.handleForegroundMessage();
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      //var postion = context.read<AuthController>().position;
      //  getDistance();
      // await Geolocator.requestPermission();
      await loadData();
    });
    super.initState();
  }

  Future<void> loadData() async {
    LocationPermission permission = await Geolocator.requestPermission();
    
    // Check if the permission is denied or restricted
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      // Show a message to the user with an option to open system settings
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
              "Location permission denied! Please enable it from system settings."),
          duration: const Duration(days: 365 * 10), // effectively indefinite
          action: SnackBarAction(
            label: 'Settings',
            onPressed: () {
              openAppSettings(); // Opens app settings
            },
          ),
        ),
      );
      return; // Return early if permission is denied
    }

    // Your existing code for notifications and other logic
    NotificationServices notificationServices = NotificationServices();

    notificationServices.initNotifications(context);
     
    await context.read<AuthController>().checkCurrentUser(context);
  }

  // Future<void> loadData() async {
  //   LocationPermission permission = await Geolocator.requestPermission();

  //   // Check if the permission is denied or restricted
  //   if (permission == LocationPermission.denied ||
  //       permission == LocationPermission.deniedForever) {
  //     // Show a message to the user if desired
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Location permission denied!")),
  //     );
  //     return null; // Return early if permission is denied
  //   }

  //   // ignore: use_build_context_synchronously
  //   NotificationServices notificationServices = NotificationServices();

  //   notificationServices.initNotifications(context);
  //   await context.read<MachineryRegistrationController>().getAllMachineries();
  //   // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //   //     FlutterLocalNotificationsPlugin();
  //   // flutterLocalNotificationsPlugin
  //   //     .resolvePlatformSpecificImplementation<
  //   //         AndroidFlutterLocalNotificationsPlugin>()!
  //   //     .requestPermission();
  //   // ignore: use_build_context_synchronously
  //   //await context.read<MachineryRegistrationController>().getAllMachineries();
  //   // ignore: use_build_context_synchronously
  //   await context.read<AuthController>().checkCurrentUser(context);
  // }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),

      // body: SkeletonMachineryWidget(),
      //  Image.asset(
      //   "assets/images/splashForMobile.jpeg",
      //   fit: BoxFit.cover,
      //   height: screenHeight(context),
      //   width: screenWidth(context),
      // ),
    );
  }
}
