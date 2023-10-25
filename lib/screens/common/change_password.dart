

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isOldPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmNewPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
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
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Change Password'),
      ),
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
                    border: OutlineInputBorder(),
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
                        }
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'New password is required';
                    }
                    return null;
                  },
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
                        }
                    ),
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
                  onPressed: _isLoading ? null : _changePassword,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Change Password'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
