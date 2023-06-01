import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:vehicle_management_and_booking_system/app/router.dart';
import 'package:vehicle_management_and_booking_system/authentication/db/database.dart';
import 'package:vehicle_management_and_booking_system/common/helper.dart';
import 'package:vehicle_management_and_booking_system/screens/login_signup/model/user_model.dart';

class AuthController extends ChangeNotifier {
  UserModel? appUser;
  final AuthDB _db = AuthDB();

  Future<User?> checkCurrentUser(BuildContext context) async {
    try {
      final currentUser = _db.isCurrentUser();
      if (currentUser != null) {
        appUser = await _db.getUserById(currentUser.uid);
        log(appUser!.toJson().toString());
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, AppRouter.bottomNavigationBar);
        return currentUser;
        // Get user data from database
        // route to home screen
      } else {
        Navigator.pushReplacementNamed(context, AppRouter.login);
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> loginWithEmailAndPassword(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
   /// ProgressDialog pd = ProgressDialog(context: context);
    try {
     // pd.show(max: 100, msg: "Please wait...");
      appUser = await _db.signInWithEmailAndPassword(email, password);
      // ignore: use_build_context_synchronously
      //pd.close();
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, AppRouter.bottomNavigationBar);
      
       // ignore: use_build_context_synchronously
       
       // ignore: use_build_context_synchronously
       showSnackBarMessage('Login successfully',context);
    } on FirebaseAuthException catch (e) {
      log(e.code);
      log(e.message!);
      print("Error in controller: $e");
       showSnackBarMessage('Error Login: ${e.message}',context);
   //   pd.close();
    }
  }
void showSnackBarMessage(String message,BuildContext context) {
  final snackBar = SnackBar(

    content: Text(message),
    duration: const Duration(seconds: 4),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
  Future<void> createWithEmailAndPassword(
    BuildContext context, {
    required UserModel user,
    required String password,
  }) async {
     ProgressDialog pd = ProgressDialog(context: context);
    try {
       pd.show(max: 100, msg: "Please wait...");
      
          await _db.signUpWithEmailAndPassword(user: user, password: password);
      appUser = user;
        pd.close();
      
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, AppRouter.bottomNavigationBar);
      log("Now current User: ${appUser?.toJson().toString()}");
      notifyListeners();
    
    } catch (e) {
      print("Error in controller: $e");
      pd.close();
    }
  }

  Future<void> signOut(BuildContext context) async {
    await _db.signOut();
    appUser = null;
    // ignore: use_build_context_synchronously
    Navigator.pushNamedAndRemoveUntil(
        context, AppRouter.login, (route) => false);
  }



// Upload Image
  XFile? pickedImage;

  void changeImage({required XFile? image}) {
    pickedImage = image;
    uploadProfileImage();
  }


  bool isUploading = false;

  Future<void> uploadProfileImage() async {
    try {
     
      isUploading = true;
      notifyListeners();
      if (pickedImage != null) {
        if (appUser!.profileUrl != null) {
          await Helper.deleteImage(url: appUser!.profileUrl!);
          appUser!.profileUrl = null;
        }
        final url = await Helper.uploadImage(
            id: appUser!.uid,
            file: pickedImage!,
            ref: "users/${appUser!.uid}/${pickedImage!.name}");

        appUser!.profileUrl = url;
        await _db.updateUser(user: appUser!);
        isUploading = false;
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

}
