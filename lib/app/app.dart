import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_management_and_booking_system/app/router.dart';
import 'package:vehicle_management_and_booking_system/authentication/controllers/auth_controller.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/machinery_register_controller.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/operator_register_controller.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/request_controller.dart';
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  

   MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Widget example1 = SplashScreenView(
    //   navigateRoute: const LoginScreen(),
    //   duration: 5000,
    //   imageSize: 130,
    //   imageSrc: "assets/images/main.png",
    //   text: "Splash Screen",
    //   textType: TextType.ColorizeAnimationText,
    //   textStyle: const TextStyle(
    //     fontSize: 40.0,
    //   ),
    //   colors: const [
    //     Colors.purple,
    //     Colors.blue,
    //     Colors.yellow,
    //     Colors.red,
    //   ],
    //   backgroundColor: Colors.white,
    // );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthController(),
        ),
        ChangeNotifierProvider(
          create: (context) => MachineryRegistrationController(),
        ),
        ChangeNotifierProvider(
          create: (context) => OperatorRegistrationController(),
        ),
        ChangeNotifierProvider(
          create: (context) => RequestController(),
        ),
      ],
      child: MaterialApp(
        title: 'VMBS',
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        
        theme: ThemeData(
          // Define your light theme here
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        darkTheme: ThemeData(
          // Define your dark theme here
          brightness: Brightness.dark,
        ),
        themeMode: ThemeMode.system, // Set the themeMode to system
        //home: TrackOrder(),
        //home: SignUpScreen(),
        //home: MachineryFormScreen(),
        //home: MachineryDetail(machineryDetails: machineryDetails),
        //home: const MachineryFormScreen(),
        //home: MapScreen(title: "title"),
        onGenerateRoute: (settings) {
          return AppRouter.onGenerateScreen(settings);
        },
        //home: example1,
      ),
    );
  }
}
