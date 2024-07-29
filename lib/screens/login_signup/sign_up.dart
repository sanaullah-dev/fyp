import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_management_and_booking_system/authentication/controllers/auth_controller.dart';
import 'package:vehicle_management_and_booking_system/screens/login_signup/fade_animation.dart';
import 'package:vehicle_management_and_booking_system/screens/login_signup/model/user_model.dart';
import 'package:vehicle_management_and_booking_system/screens/login_signup/login.dart';
import 'package:vehicle_management_and_booking_system/screens/login_signup/otp_screen.dart';
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
  late final _passwordController = TextEditingController();
  final _cPsswordController = TextEditingController();
  final _languagesController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  EmailOTP myauth = EmailOTP();
  double passwordStrength = 0.0;
  bool _obsecurePassword = true;
  bool _obsecureConfirmPassword = true;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    _passwordController.addListener(() {
      setState(() {
        passwordStrength = context.read<AuthController>().getPasswordStrength(
            _passwordController.text); // Replace this with your method
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _passwordController.dispose();
    super.dispose();
  }

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
                    FadeAnimation(
                      delay: 1.6,
                      child: Container(
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
                    ),
                    SizedBox(height: screenHeight(context) * 0.03),
                    FadeAnimation(
                      delay: 2,
                      child: Container(
                        alignment: Alignment.center,
                         
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        child: TextFormField(
                          inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")), ],
                          controller: _nameController,
                          keyboardType: TextInputType.name,
                          decoration: const InputDecoration(
                            labelStyle: TextStyle(fontSize: 18),
                            labelText: "Name",
                            
                          ),
                            validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter Name';
                        }
                        return null;
                      },
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight(context) * 0.03),
                    FadeAnimation(
                      delay: 2.6,
                      child: Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        child: TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                              labelStyle: TextStyle(fontSize: 18),
                              // suffix: GestureDetector(
                              //   onTap: () async {

                              //   },
                              //   child: const Text(
                              //     "Send OTP",
                              //     style: TextStyle(color: Colors.blue),
                              //   ),
                              // ),
                              labelText: "Email"),
                          validator: (value) {
                            final expression = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

                            if (!expression.hasMatch(value!) &&
                                (context.read<AuthController>().verified ==
                                        false ||
                                    context.read<AuthController>().verified ==
                                        null)) {
                              return "The email is invalid.";
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight(context) * 0.03),
                    FadeAnimation(
                      delay: 3,
                      child: Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: _mNumberController,
                          decoration: const InputDecoration(
                              labelStyle: TextStyle(fontSize: 18),
                              labelText: "Mobile Number"),

                                     validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter Number';
                        }
                        return null;
                      },
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight(context) * 0.03),
                    FadeAnimation(
                      delay: 3.6,
                      child: Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        child: TextFormField(
                          controller: _languagesController,
                          decoration: const InputDecoration(
                            labelStyle: TextStyle(fontSize: 18),
                            labelText: "Languages",
                          ),
                          validator: (value) {
                        
                        if (value!.isEmpty) {
                          return 'Please enter Language';
                        } else {
                          return null;
                        }
                      },
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight(context) * 0.03),
                    FadeAnimation(
                      delay: 4,
                      child: Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: _obsecurePassword,
                          obscuringCharacter: "*",
                          validator: (value) {
                            if (value!.length < 6) {
                              return "Password is too short!";
                            }
                            double strength = context
                                .read<AuthController>()
                                .getPasswordStrength(value);
                            if (strength < 0.2) {
                              return 'Password is very weak';
                            } else if (strength < 0.4) {
                              return 'Password is weak';
                            } else if (strength < 0.6) {
                              return 'Password is medium';
                            } else if (strength < 0.8) {
                              return 'Password is strong';
                            } else {
                              return null; // Password is very strong
                            }
                          },
                          decoration: InputDecoration(
                            labelStyle: const TextStyle(fontSize: 18),
                            labelText: "Password",
                            contentPadding: EdgeInsets.zero,
                            suffix: IconButton(
                                onPressed: () {
                                  _obsecurePassword = !_obsecurePassword;
                                  setState(() {});
                                },
                                icon: _obsecurePassword
                                    ? const Icon(Icons.visibility)
                                    : const Icon(Icons.visibility_off)),
                          ),
                        ),
                      ),
                    ),
                    FadeAnimation(
                      delay: 4.3,
                      child: Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        child: LinearProgressIndicator(
                          value: passwordStrength,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(
                              passwordStrength < 0.2
                                  ? Colors.red
                                  : passwordStrength < 0.4
                                      ? Colors.orange
                                      : passwordStrength < 0.6
                                          ? Colors.amber
                                          : passwordStrength < 0.8
                                              ? Colors.lightGreen
                                              : Colors.green),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight(context) * 0.03),
                    FadeAnimation(
                      delay: 4.6,
                      child: Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        child: TextFormField(
                          controller: _cPsswordController,
                          obscureText: _obsecureConfirmPassword,
                          obscuringCharacter: "*",
                          validator: (value) {
                            if (value!.length < 6) {
                              return "Password is too short!";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelStyle: const TextStyle(fontSize: 18),
                            contentPadding: EdgeInsets.zero,
                            labelText: "Confirm Password",
                            suffix: IconButton(
                                onPressed: () {
                                  _obsecureConfirmPassword =
                                      !_obsecureConfirmPassword;
                                  setState(() {});
                                },
                                icon: _obsecureConfirmPassword
                                    ? const Icon(Icons.visibility)
                                    : const Icon(Icons.visibility_off)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight(context) * 0.05),
                    FadeAnimation(
                      delay: 5,
                      child: Container(
                        alignment: Alignment.centerRight,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final user = UserModel(
                                uid: "",
                                name: _nameController.text,
                                isAvailable: true,
                                email: _emailController.text,
                                mobileNumber: _mNumberController.text,
                                languages: _languagesController.text,
                              );
                              // log(_nameController.text);
                              // log(_emailController.text);
                              // log(_mNumberController.text);
                              // log(_passwordController.text);
                              // log(_cPsswordController.text);
                              // log(_languagesController.text);

                              myauth.setConfig(
                                  appEmail: "sana.dev11211@gmail.com",
                                  appName: "Email OTP",
                                  userEmail: _emailController.text,
                                  otpLength: 4,
                                  otpType: OTPType.digitsOnly);
                              if (await myauth.sendOTP() == true) {
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text("OTP has been sent"),
                                ));
                                // ignore: use_build_context_synchronously
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OtpScreen(
                                              myauth: myauth,
                                              password:
                                                  _passwordController.text,
                                              user: user,
                                            )));
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text("Oops, OTP send failed"),
                                ));
                              }

                              // ignore: use_build_context_synchronously
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
                              style: TextStyle( color: Colors.white,
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                    FadeAnimation(
                      delay: 5.6,
                      child: Container(
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
