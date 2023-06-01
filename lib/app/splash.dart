import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_management_and_booking_system/authentication/controllers/auth_controller.dart';

class SplashScreenOrLoadingScreen extends StatefulWidget {
  const SplashScreenOrLoadingScreen({super.key});

  @override
  State<SplashScreenOrLoadingScreen> createState() => _SplashScreenOrLoadingScreenState();
}

class _SplashScreenOrLoadingScreenState extends State<SplashScreenOrLoadingScreen> {
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    
      loadData();
    });
    super.initState();
  }

  Future<void> loadData() async {
    // await context.read<ServiceController>().getData();
   
    // onMessageOpenedAppListner();
    //Future.delayed(const Duration(seconds: 1), () async {
   
          await context.read<AuthController>().checkCurrentUser(context);
      
  //  });
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold
    (
      body: Center(child: CircularProgressIndicator()),
    );
  }
}