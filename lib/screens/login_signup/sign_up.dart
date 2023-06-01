import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:vehicle_management_and_booking_system/authentication/controllers/auth_controller.dart';
import 'package:vehicle_management_and_booking_system/screens/login_signup/model/user_model.dart';
import 'package:vehicle_management_and_booking_system/screens/login_signup/login.dart';
import 'package:vehicle_management_and_booking_system/utils/media_query.dart';
import 'package:vehicle_management_and_booking_system/widgets/background.dart';
// ignore: library_prefixes
import 'package:flutter/foundation.dart' as TargetPlatform;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _cPsswordController = TextEditingController();
  final _languagesController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
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
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: const Text(
                        "REGISTER",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2661FA),
                            fontSize: 36),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(height: screenHeight(context) * 0.03),
                    Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(horizontal: 40),
                      child: TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelStyle: TextStyle(fontSize: 18),
                          labelText: "Name",
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight(context) * 0.03),
                    Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(horizontal: 40),
                      child: TextFormField(
                        controller: _emailController,
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
                        keyboardType: TextInputType.number,
                        controller: _mNumberController,
                        decoration: const InputDecoration(
                            labelStyle: TextStyle(fontSize: 18),
                            labelText: "Mobile Number"),
                      ),
                    ),
                     SizedBox(height: screenHeight(context) * 0.03),
                     Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(horizontal: 40),
                      child: TextFormField(
                        controller: _languagesController,
                        decoration: const InputDecoration(
                          labelStyle: TextStyle(fontSize: 18),
                          labelText: "Languages",
                        ),
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
                    SizedBox(height: screenHeight(context) * 0.03),
                    Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(horizontal: 40),
                      child: TextFormField(
                        controller: _cPsswordController,
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
                            labelText: "Confirm Password"),
                      ),
                    ),
                    SizedBox(height: screenHeight(context) * 0.05),
                    Container(
                      alignment: Alignment.centerRight,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                             
                            final user = UserModel(
                              uid: "",
                              name: _nameController.text,
                              email: _emailController.text,
                              mobileNumber: _mNumberController.text,
                              languages: _languagesController.text,
                            );
                            log(_nameController.text);
                            log(_emailController.text);
                            log(_mNumberController.text);
                            log(_passwordController.text);
                            log(_cPsswordController.text);
                            log(_languagesController.text);

                            context
                                .read<AuthController>()
                                .createWithEmailAndPassword(
                                  context,
                                  user: user,
                                  password: _passwordController.text,
                                );
                               
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
                          width: 200, //screenHeight(context) * 0.2,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(80.0),
                              gradient: const LinearGradient(colors: [
                                Color.fromARGB(255, 255, 136, 34),
                                Color.fromARGB(255, 255, 177, 41)
                              ])),
                          padding: const EdgeInsets.all(0),
                          child: const Text(
                            "SIGN UP",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 10),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (ctx) {
                            return const LoginScreen();
                          }));
                        },
                        child: const Text(
                          "Already Have an Account? Sign in",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2661FA)),
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
