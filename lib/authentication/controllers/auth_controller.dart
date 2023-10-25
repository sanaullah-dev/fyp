import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:uuid/uuid.dart';
import 'package:vehicle_management_and_booking_system/app/router.dart';
import 'package:vehicle_management_and_booking_system/authentication/db/database.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/machinery_register_controller.dart';
import 'package:vehicle_management_and_booking_system/screens/login_signup/model/user_model.dart';

class AuthController extends ChangeNotifier {
  UserModel? appUser;
  final AuthDB _db = AuthDB();
  final MachineryRegistrationController _machine = MachineryRegistrationController();
  // ignore: prefer_typing_uninitialized_variables
  dynamic position;
  Future<User?> checkCurrentUser(BuildContext context) async {
    try {
      await Geolocator.requestPermission();

     position = await Geolocator.getCurrentPosition(
         desiredAccuracy: LocationAccuracy.bestForNavigation);
        
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
        // ignore: use_build_context_synchronously
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
      log("1");
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, AppRouter.bottomNavigationBar);
      log("2");
      // ignore: use_build_context_synchronously

      // ignore: use_build_context_synchronously
      showSnackBarMessage('Login successfully', context);
    } on FirebaseAuthException catch (e) {
    //  log("11211 ${e.code}");
     // log("2233${e.message!}");
      log("Error in controller: $e");
      showSnackBarMessage('Error Login: ${e.message}', context);
      Navigator.of(context).pop();
      //   pd.close();
    }
  }

  void showSnackBarMessage(String message, BuildContext context) {
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
      log("Error in controller: $e");
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
  Uint8List? pickedWebImage;

  void changeImage({required XFile? image}) {
    pickedImage = image;
    uploadProfileImage();
  }

  void changeImageOnWeb({required Uint8List image}) {
    pickedWebImage = image;
    uploadProfileImage();
  }

  bool isUploading = false;

  Future<void> uploadProfileImage() async {
    try {
      isUploading = true;
      notifyListeners();
      if (pickedImage != null || pickedWebImage != null) {
        if (appUser!.profileUrl != null) {
          await _db.deleteImage(url: appUser!.profileUrl!);
          appUser!.profileUrl = null;
        }
        appUser!.profileUrl = null;
        late String url;
        if (!kIsWeb) {
          url = await _machine.uploadImage(
              id: appUser!.uid,
              file: pickedImage!,
              ref: "users/${appUser!.uid}/${const Uuid().v1()}");
        } else {
          url = await _machine.uploadWebImage(
            id: appUser!.uid,
            file: pickedWebImage!,
            ref: "users/${appUser!.uid}/${const Uuid().v1()}",
          );
        }
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
