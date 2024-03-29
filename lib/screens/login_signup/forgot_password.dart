import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vehicle_management_and_booking_system/app/app.dart';
import 'package:vehicle_management_and_booking_system/utils/app_colors.dart';
import 'package:vehicle_management_and_booking_system/utils/const.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  String? _errorMessage;

  void _sendPasswordResetEmail() async {
    try {
      await _auth.sendPasswordResetEmail(email: _emailController.text.trim());
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.lightGreenAccent,
          content: Text(
            "Password Reset Link Send Through Email.",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      );
      // ignore: use_build_context_synchronously
      Navigator.pop(context); // return to login screen
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
   bool isDark = ConstantHelper.darkOrBright(context);
    return Scaffold(
     appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(onPressed: (){
          navigatorKey.currentState!.pop();

        },icon:  Icon(Icons.arrow_back_ios_new_rounded,color:  isDark ? null :AppColors.blackColor,),),
        backgroundColor: isDark ? null : AppColors.accentColor,
        title:  Text(
          "Forgot Password",
          style: GoogleFonts.changa(color: isDark ? null : AppColors.blackColor),// TextStyle(color: isDark ? null : AppColors.blackColor),
        ),
      ),
      // appBar: AppBar(
      //   title: Text(
      //     'Forgot Password',
      //     style: GoogleFonts.changa(),
      //   ),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration:  InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Your Email Address...',
                    labelStyle: GoogleFonts.raleway(),
                    hintStyle: GoogleFonts.raleway(),
                    hintText: "Enter your email here..."),
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return 'Please enter your email.';
                  } else if (!value.trim().contains('@')) {
                    return 'Please enter a valid email.';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                
                "We will send you an email with a link to reset your password, please enter the email associated with your account above.",
             style: GoogleFonts.raleway(), ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark?null:AppColors.accentColor,
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _sendPasswordResetEmail();
                  }
                },
                child:  Text('Send Reset Link', style: GoogleFonts.raleway(color: isDark ? null : AppColors.blackColor),),
              ),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
