import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_management_and_booking_system/app/router.dart';
import 'package:vehicle_management_and_booking_system/authentication/controllers/auth_controller.dart';
import 'package:vehicle_management_and_booking_system/screens/login_signup/forgot_password.dart';
import 'package:vehicle_management_and_booking_system/utils/media_query.dart';
import 'package:vehicle_management_and_booking_system/widgets/background.dart';
// ignore: library_prefixes
import 'package:flutter/foundation.dart' as TargetPlatform;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _key = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  showLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content:  Row(
        children: [
         const CircularProgressIndicator.adaptive(),
          Container(margin: const EdgeInsets.only(left: 7),child: const Text("Loading..." )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
     // barrierColor: Colors.transparent,
      builder:(BuildContext context){
        return alert;
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: SizedBox(
          width: TargetPlatform.kIsWeb ? 350 : screenWidth(context),
          height: TargetPlatform.kIsWeb
              ? screenHeight(context) * 0.9
              : screenHeight(context),
          child: Background(
            child: SingleChildScrollView(
              child: Form(
                key: _key,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: const Text(
                        "LOGIN",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: TargetPlatform.kIsWeb
                                ? Color.fromARGB(255, 255, 177, 41)
                                : Color(0xFF2661FA),
                            fontSize: 36),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(height: screenHeight(context) * 0.03),
                    Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(horizontal: 40),
                      child: TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                            labelStyle: TextStyle(fontSize: 18),
                            labelText: "Email"),
                        validator: (value) {
                          final expression = RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

                          if (!expression.hasMatch(value!)) {
                            return "The email is invalid.";
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: screenHeight(context) * 0.03),
                    Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(horizontal: 40),
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        obscuringCharacter: "*",
                        validator: (value) {
                          if (value!.length < 6) {
                            return "Password is too short!";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                            labelStyle: TextStyle(fontSize: 18),
                            labelText: "Password"),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 10),
                      child:  InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context){
                            return const ForgotPasswordScreen();
                          }));
                        },
                        child: const  Text(
                          "Forgot your password?",
                          style:
                              TextStyle(fontSize: 15, color: Color(0XFF2661FA)),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight(context) * 0.05),
                    Container(
                      alignment: Alignment.centerRight,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 10),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_key.currentState!.validate()) {
                          showLoaderDialog(context);
                            log(_emailController.text);
                            log(_passwordController.text);
                            await context
                                .read<AuthController>()
                                .loginWithEmailAndPassword(
                                  context,
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                );
                              
                             //Navigator.of(context).pop();
                            //.pushNamed(AppRouter.bottomNavigationBar);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(80.0)),
                            padding: const EdgeInsets.all(0),
                            textStyle: const TextStyle(color: Colors.white)),
                        child: Container(
                          alignment: Alignment.center,
                          height: 50.0,
                          width: 200,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(80.0),
                              gradient: const LinearGradient(colors: [
                                Color.fromARGB(255, 255, 136, 34),
                                Color.fromARGB(255, 255, 177, 41)
                              ])),
                          padding: const EdgeInsets.all(0),
                          child: const Text(
                            "LOGIN",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 19, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 10),
                      child: GestureDetector(
                        onTap: () => {
                          Navigator.of(context).pushNamed(AppRouter.signUp),
                        },
                        child: const Text(
                          "Don't Have an Account? Sign up",
                          style: TextStyle(
                            fontSize: 12,
                            //fontWeight: FontWeight.bold,
                            color: Color(0XFF2661FA),
                          ),
                          //color: Color(0xFF2661FA)),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
