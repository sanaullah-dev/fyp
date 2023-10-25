
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_management_and_booking_system/authentication/controllers/auth_controller.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/machinery_register_controller.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/operator_register_controller.dart';

class SplashScreenOrLoadingScreen extends StatefulWidget {
  const SplashScreenOrLoadingScreen({super.key});

  @override
  State<SplashScreenOrLoadingScreen> createState() =>
      _SplashScreenOrLoadingScreenState();
}

class _SplashScreenOrLoadingScreenState
    extends State<SplashScreenOrLoadingScreen> {
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //var postion = context.read<AuthController>().position;
      //  getDistance();
      loadData();
    });
    super.initState();
  }

  Future<void> loadData() async {
    // DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    // IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
    // log("Running on${iosDeviceInfo.identifierForVendor}");
    await context.read<OperatorRegistrationController>().getNearestAndHighestRatedOperator();
    await context.read<MachineryRegistrationController>().getAllMachineries();
    // ignore: use_build_context_synchronously
    await context.read<AuthController>().checkCurrentUser(context);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
