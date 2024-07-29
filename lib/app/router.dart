
import 'package:flutter/material.dart';
import 'package:vehicle_management_and_booking_system/app/splash.dart';
import 'package:vehicle_management_and_booking_system/models/machinery_model.dart';
import 'package:vehicle_management_and_booking_system/models/operator_model.dart';
import 'package:vehicle_management_and_booking_system/screens/common/bottom_navigation.dart';
import 'package:vehicle_management_and_booking_system/screens/common/change_password.dart';
import 'package:vehicle_management_and_booking_system/screens/common/drawer_items/receive_requests_screen.dart';
import 'package:vehicle_management_and_booking_system/screens/common/drawer_items/send_requests_screen.dart';
import 'package:vehicle_management_and_booking_system/screens/common/messages_screen.dart';
import 'package:vehicle_management_and_booking_system/screens/machinery/home_screen.dart';
import 'package:vehicle_management_and_booking_system/screens/login_signup/login.dart';
import 'package:vehicle_management_and_booking_system/screens/login_signup/sign_up.dart';
import 'package:vehicle_management_and_booking_system/screens/machinery/machinery_detials.dart';
import 'package:vehicle_management_and_booking_system/screens/machinery/track_order.dart';
import 'package:vehicle_management_and_booking_system/screens/operator/hiring_fields.dart';
import 'package:vehicle_management_and_booking_system/screens/operator/operator_details.dart';
import 'package:vehicle_management_and_booking_system/screens/operator/operators_screen.dart';
import 'package:vehicle_management_and_booking_system/screens/registration_operator_machinery/add_operator.dart';
import 'package:vehicle_management_and_booking_system/screens/registration_operator_machinery/machinery_form_screen.dart';

class AppRouter {
  static const String splash = "/";
  static const String login = "/login";
  static const String signUp = "/signUp";
  static const String dashBoard = "/dashBoard";
  static const String bottomNavigationBar = "/bottomNavigationBar";
  static const String operatorSearch = "/operatorDetails";
  static const String machineryRegistration = "/machineryRegistration";
  // static const String machineryDetails = "/maDetails";
  static const String operatorRegistration = "/operatorRegistration";
  static const String machineryFormScreen = "/machineryScreen";
  static const String changePasswordScreen = "/changePasswordScreen";
  static const String trackOrder = "/trackOrder";
  static const String receiverRequest = "/receiverRequest";
  static const String sendRequest = "/sendRequest";
  static const String machineryDetailsPage = "/machineryDetailsPage";
  static const String operatorDetailsScreen = "/operatorDetailsScreen";
  static const String operatorHiringScreen = "/operatorHiringScreen";
 static const String messagesScreen = "/messagesScreen";

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
      case operatorSearch:
        return MaterialPageRoute(
          builder: ((context) => const OperatorSearchScreen()),
          settings: settings,
        );
      case receiverRequest:
        Map<String, dynamic> argsMap =
            settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: ((context) => ReceivedRequestsScreen(
                isHiring: argsMap['isHiring'],
                isNotifications: argsMap['isNotifications'],
              )),
          settings: settings,
        );

      // case receiverRequest:
      //   dynamic isHiring = settings.arguments;
      //   return MaterialPageRoute(
      //     builder: ((context) => ReceivedRequestsScreen(
      //           isHiring: isHiring,
      //         )),
      //     settings: settings,
      //   );
      // case sendRequest:
      //   dynamic isOperater = settings.arguments;
      //   return MaterialPageRoute(
      //     builder: ((context) => SentRequestsScreen(
      //           isOperater: isOperater,
      //         )),
      //     settings: settings,
      //   );
      case sendRequest:
        Map<String, dynamic> argsMap =
            settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: ((context) => SentRequestsScreen(
                isOperater: argsMap['isOperater'],
                isNotifications: argsMap['isNotifications'],
              )),
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
      case trackOrder:
        final dynamic argument = settings.arguments;
        return MaterialPageRoute(
          builder: (context) => TrackOrder(
            request: argument,
          ),
        );
      case operatorHiringScreen:
        final dynamic argument = settings.arguments;
        return MaterialPageRoute(
          builder: (context) => RequestForm(
            operator: argument,
          ),
        );

      case messagesScreen:
        dynamic argument = settings.arguments;

        return MaterialPageRoute(
          builder: (context) => MessagesScreen(
            request: argument,
          ),
        );

      // case trackOrder:
      //   final dynamic argument = settings.arguments;
      //   if (argument is RequestModel) {
      //     return MaterialPageRoute(
      //       builder: (context) => TrackOrder(request: argument),
      //       settings: settings,
      //     );
      //   } else if (argument is Map<String, dynamic>) {
      //     final request = RequestModel.fromMap(argument);
      //     return MaterialPageRoute(
      //         builder: (context) => TrackOrder(request: request),
      //         settings: settings);
      //   } else {
      //     return MaterialPageRoute(
      //         builder: ((context) => TrackOrder(request: argument)));
      //   }
      case machineryDetailsPage:
        final dynamic argument = settings.arguments;

        if (argument is MachineryModel) {
          return MaterialPageRoute(
            builder: (context) => DetalleWidget(model: argument),
            settings: settings,
          );
        } else if (argument is Map<String, dynamic>) {
          final model = MachineryModel.fromJson(argument);
          return MaterialPageRoute(
            builder: (context) => DetalleWidget(model: model),
            settings: settings,
          );
        }
        throw ArgumentError("Invalid argument type");

      case operatorDetailsScreen:
        final dynamic argument = settings.arguments;
        if (argument is Map<String, dynamic>) {
          final operator = OperatorModel.fromJson(argument);
          return MaterialPageRoute(
            builder: (context) => OperatorDetailsScreen(operator: operator),
            settings: settings,
          );
        } else if (argument is OperatorModel) {
          return MaterialPageRoute(
            builder: (context) => OperatorDetailsScreen(operator: argument),
            settings: settings,
          );
        } else {
          throw ArgumentError("Invalid argument type");
        }
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
