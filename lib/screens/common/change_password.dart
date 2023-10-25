import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_management_and_booking_system/app/app.dart';
import 'package:vehicle_management_and_booking_system/authentication/controllers/auth_controller.dart';
import 'package:vehicle_management_and_booking_system/utils/app_colors.dart';
import 'package:vehicle_management_and_booking_system/utils/const.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _oldPasswordController = TextEditingController();
  late final TextEditingController _newPasswordController =
      TextEditingController();
  // ..addListener(() {
  //   setState(() {
  //     passwordStrength = context
  //         .read<AuthController>()
  //         .getPasswordStrength(_newPasswordController.text);
  //   });
  // });

  final _confirmPasswordController = TextEditingController();
  bool _isOldPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmNewPasswordVisible = false;
  bool _isLoading = false;
  double passwordStrength = 0.0;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _newPasswordController.addListener(() {
      setState(() {
        passwordStrength = context.read<AuthController>().getPasswordStrength(
            _newPasswordController.text); // Replace this with your method
      });
    });
  }

  void _togglePasswordVisibility(
      {required bool? oldPassword,
      required bool? newpassword,
      required bool? confirmNewPassword}) {
    // setState(() {
    //   _isPasswordVisible = !_isPasswordVisible;
    // });
    oldPassword != null
        ? _isOldPasswordVisible = !_isOldPasswordVisible
        : newpassword != null
            ? _isNewPasswordVisible = !_isNewPasswordVisible
            : _isConfirmNewPasswordVisible = !_isConfirmNewPasswordVisible;
    setState(() {});
  }

  void showSnackBarMessage(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Navigator.pop(context);
  }

  void _changePassword() async {
    if (!_formKey.currentState!.validate()) return;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Are you sure you want to change your password?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('Change Password'),
              onPressed: () async {
                Navigator.pop(context);

                setState(() {
                  _isLoading = true;
                });

                try {
                  User? user = FirebaseAuth.instance.currentUser;

                  if (user == null) {
                    throw 'User not found';
                  }

                  AuthCredential credential = EmailAuthProvider.credential(
                    email: user.email!,
                    password: _oldPasswordController.text.trim(),
                  );

                  await user.reauthenticateWithCredential(credential);

                  await user.updatePassword(_newPasswordController.text.trim());

                  setState(() {
                    _isLoading = false;
                  });

                  showSnackBarMessage('Password changed successfully');
                } catch (error) {
                  setState(() {
                    _isLoading = false;
                  });

                  showSnackBarMessage('Error changing password: $error');
                }
              },
            )
          ],
        );
      },
    );
    //Navigator.pop(context);
    //Navigator.of(context).pushNamed(AppRouter.bottomNavigationBar);
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = ConstantHelper.darkOrBright(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Change Password",
          style: TextStyle(color: isDark ? null : Colors.black),
        ),
        backgroundColor: isDark ? null : AppColors.accentColor,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              navigatorKey.currentState!.pop();
            },
            icon: Icon(
              Icons.arrow_back_ios_new_sharp,
              color: isDark ? null : AppColors.blackColor,
            )),
      ),
      // appBar: AppBar(
      //   title: const Text('Change Password'),
      // ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _oldPasswordController,
                  obscureText: !_isOldPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Old Password',
                    border: OutlineInputBorder(),
                    hintText: "xxxxxxxx",
                    suffixIcon: IconButton(
                        icon: Icon(
                          _isOldPasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          _togglePasswordVisibility(
                            oldPassword: true,
                            newpassword: null,
                            confirmNewPassword: null,
                          );
                        }),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Old password is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: !_isNewPasswordVisible,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: "xxxxxxxx",
                    labelText: 'New Password',
                    suffixIcon: IconButton(
                        icon: Icon(
                          _isNewPasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          _togglePasswordVisibility(
                            oldPassword: null,
                            newpassword: true,
                            confirmNewPassword: null,
                          );
                        }),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'New password is required';
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
                ),
                LinearProgressIndicator(
                  value: passwordStrength,
                  backgroundColor: Colors.grey[200],
                  valueColor:
                      AlwaysStoppedAnimation<Color>(passwordStrength < 0.2
                          ? Colors.red
                          : passwordStrength < 0.4
                              ? Colors.orange
                              : passwordStrength < 0.6
                                  ? Colors.amber
                                  : passwordStrength < 0.8
                                      ? Colors.lightGreen
                                      : Colors.green),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: !_isConfirmNewPasswordVisible,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "xxxxxxxx",
                    labelText: 'Confirm New Password',
                    suffixIcon: IconButton(
                        icon: Icon(
                          _isConfirmNewPasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          _togglePasswordVisibility(
                            oldPassword: null,
                            newpassword: null,
                            confirmNewPassword: true,
                          );
                        }),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Confirm new password is required';
                    }
                    if (value != _newPasswordController.text) {
                      return 'New passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      //elevation: 20,
                      backgroundColor: isDark
                          ? AppColors.primaryColor
                          : AppColors.accentColor,
                      side: BorderSide(
                          width: 0.5,
                          color: isDark ? Colors.white : Colors.orange)),
                  onPressed: _isLoading ? null : _changePassword,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : Text(
                          'Change Password',
                          style: TextStyle(color: isDark ? null : Colors.black),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
