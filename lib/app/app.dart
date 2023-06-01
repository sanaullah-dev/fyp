import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_management_and_booking_system/app/router.dart';
import 'package:vehicle_management_and_booking_system/authentication/controllers/auth_controller.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/machinery_register_controller.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        )
      ],
      child: MaterialApp(
        title: 'VMBS',

        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,

          // brightness: Brightness.dark
        ),
        // home: SignUpScreen(),
      //  home: MachineryFormScreen(),
        //home: MachineryDetail(machineryDetails: machineryDetails),
        onGenerateRoute: (settings) {
          return AppRouter.onGenerateScreen(settings);
        },
        //home: example1,
      ),
    );
  }
}
