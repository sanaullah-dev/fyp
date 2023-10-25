import 'package:flutter/material.dart';
import 'package:vehicle_management_and_booking_system/app/splash.dart';
import 'package:vehicle_management_and_booking_system/screens/common/bottom_navigation.dart';
import 'package:vehicle_management_and_booking_system/screens/common/change_password.dart';
import 'package:vehicle_management_and_booking_system/screens/machinery/home_screen.dart';
import 'package:vehicle_management_and_booking_system/screens/login_signup/login.dart';
import 'package:vehicle_management_and_booking_system/screens/login_signup/sign_up.dart';
import 'package:vehicle_management_and_booking_system/screens/operator/operators_screen.dart';
import 'package:vehicle_management_and_booking_system/screens/registration_operator_machinery/add_operator.dart';
import 'package:vehicle_management_and_booking_system/screens/registration_operator_machinery/machinery_form_screen.dart';

class AppRouter {
  static const String splash = "/";
  static const String login = "/login";
  static const String signUp = "/signUp";
  static const String dashBoard = "/dashBoard";
  static const String bottomNavigationBar = "/bottomNavigationBar";
  static const String operatorDetails = "/operatorDetails";
  // static const String addOperatorStepperScreen = "/addOperatorStepperScreen";
  static const String machineryRegistration = "/machineryRegistration";
  static const String machineryDetails = "/maDetails";
  static const String operatorRegistration = "/operatorRegistration";
  static const String machineryFormScreen = "/machineryScreen";
  static const String changePasswordScreen = "/changePasswordScreen";

  static Route<dynamic>? onGenerateScreen(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          builder: ((context) => const SplashScreenOrLoadingScreen()),
          settings: settings,
        );
      case login:
        return MaterialPageRoute(
          builder: ((context) => const LoginScreen()),
          settings: settings,
        );
      case signUp:
        return MaterialPageRoute(
          builder: ((context) => const SignUpScreen()),
          settings: settings,
        );
      case bottomNavigationBar:
        return MaterialPageRoute(
          builder: ((context) => const BottomNavigationScreen()),
          settings: settings,
        );
      case dashBoard:
        return MaterialPageRoute(
          builder: ((context) => HomeScreen()),
          settings: settings,
        );
      case operatorDetails:
        return MaterialPageRoute(
          builder: ((context) => const OperatorSearchScreen()),
          settings: settings,
        );

      case operatorRegistration:
        return MaterialPageRoute(
          builder: ((context) => const OperatorFormScreen()),
          settings: settings,
        );
      case machineryFormScreen:
        return MaterialPageRoute(
          builder: ((context) => const MachineryFormScreen()),
          settings: settings,
        );
      // case machineryDetails:
      //   final args = settings.arguments as IndivisualPageArgs;
      //   return MaterialPageRoute(
      //     builder: ((context) => MachineryDetail(
      //           machineryDetails: args.machineryDetails, 
      //         )),
      //     settings: settings,
      //   );
      case changePasswordScreen:
        return MaterialPageRoute(
          builder: ((context) => const ChangePasswordScreen()),
          settings: settings,
        );
    }
    return null;
  }
}
