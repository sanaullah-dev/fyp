// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:uuid/uuid.dart';
import 'package:vehicle_management_and_booking_system/app/router.dart';
import 'package:vehicle_management_and_booking_system/authentication/db/database.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/machinery_register_controller.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/operator_register_controller.dart';
import 'package:vehicle_management_and_booking_system/screens/common/block_screen.dart';
import 'package:vehicle_management_and_booking_system/screens/login_signup/model/user_model.dart';
import 'dart:math' as math;

class AuthController extends ChangeNotifier {
  UserModel? appUser;
  final AuthDB _db = AuthDB();
  final MachineryRegistrationController _machine =
      MachineryRegistrationController();
  final OperatorRegistrationController _operatorRegistrationController =
      OperatorRegistrationController();
  // ignore: prefer_typing_uninitialized_variables
  Position? position;
  bool? verified;
  bool isloading = false;
  double? pstrength;

  void setLoading(bool value) {
    isloading = value;
    notifyListeners();
  }

  void verifiedUnverified(bool status) {
    verified = status;
    notifyListeners();
  }

  Future<User?> checkCurrentUser(BuildContext context) async {
    try {
     // log("1");
      
       //await Geolocator.requestPermission();
//log("3");
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
//log("5");
      final currentUser = _db.isCurrentUser();
      if (currentUser != null) {
        // await _machine.getAllMachineries();
        // await _operatorRegistrationController
        //     .getNearestAndHighestRatedOperator(); log("2");
        appUser = await _db.getUserById(currentUser.uid);
        log(appUser!.toJson().toString());
        log("1");
        updateFcm();
        // await context
        //     .read<MachineryRegistrationController>()
        //     .getAllMachineries();
        //context.read<RequestController>().getRequestIfActive(appUser!.uid);
        // var request = await context
        //     .read<RequestController>()
        //     .getRequestIfActive(appUser!.uid);
        // if (request != null) {
        //  Navigator.pushNamed(context, AppRouter.trackOrder);
        // }
        await context.read<MachineryRegistrationController>().fetchAllUsers();
        await context.read<MachineryRegistrationController>().getAllMachineries();


        appUser!.blockOrNot == true
            ? Navigator.of(context).push(MaterialPageRoute(builder: ((context) {
                return BlockScreen(
                  user: appUser!,
                );
              })))
            : Navigator.pushReplacementNamed(
                context, AppRouter.bottomNavigationBar);
        return currentUser;
        // Get user data from database
        // route to home screen
      } else {
        Navigator.pushReplacementNamed(context, AppRouter.login);
        return null;
      }
    } catch (e) {
      log(e.toString());
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
      //pd.close();

      log("1");
      updateFcm();
      await context.read<MachineryRegistrationController>().getAllMachineries();
      Navigator.of(context).pop();
      appUser!.blockOrNot == true
          ? Navigator.of(context).push(MaterialPageRoute(builder: ((context) {
              return BlockScreen(
                user: appUser!,
              );
            })))
          : Navigator.pushReplacementNamed(
              context, AppRouter.bottomNavigationBar);
      log("2");

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

      updateFcm();
      await context.read<MachineryRegistrationController>().getAllMachineries();
      pd.close();
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

  void updateFcm() async {
    appUser!.fcm = await FirebaseMessaging.instance.getToken() ?? "";
    _db.updateUser(user: appUser!);
  }

  Future<UserModel> getByUid(String userId) async {
    try {
      return await _db.getUserById(userId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUserForBlock(UserModel user) async {
    try {
      await _db.updateUser(user: user);
    } catch (e) {
      rethrow;
    }
  }

//   getPasswordStrength(String password) {
//     if (password.isEmpty) return 0;
//     double pFraction;

//     if (RegExp(r'^[a-zA-Z0-9]*$').hasMatch(password)) {
//       pFraction = 0.8;
//     } else if (RegExp(r'^[a-zA-Z0-9]*$').hasMatch(password)) {
//       pFraction = 1.5;
//     } else if (RegExp(r'^[a-z]*$').hasMatch(password)) {
//       pFraction = 1.0;
//     } else if (RegExp(r'^[a-zA-Z]*$').hasMatch(password)) {
//       pFraction = 1.3;
//     } else if (RegExp(r'^[a-z\-_!?]*$').hasMatch(password)) {
//       pFraction = 1.3;
//     } else if (RegExp(r'^[a-z0-9]*$').hasMatch(password)) {
//       pFraction = 1.2;
//     } else {
//       pFraction = 1.8;
//     }

//     var logF = (double x) {
//       return 1.0 / (1.0 + mt.exp(-x));
//     };

//     var logC = (double x) {
//       return logF((x / 2.0) - 4.0);
//     };

//     pstrength = logC(password.length * pFraction);
//     notifyListeners();
//   }

  double getPasswordStrength(String password) {
    if (password.isEmpty) return 0.0;
    double pFraction;

    if (RegExp(r'^[a-zA-Z0-9]*$').hasMatch(password)) {
      pFraction = 0.8;
    } else if (RegExp(r'^[a-z]*$').hasMatch(password)) {
      pFraction = 1.0;
    } else if (RegExp(r'^[a-zA-Z]*$').hasMatch(password)) {
      pFraction = 1.3;
    } else if (RegExp(r'^[a-z\-_!?]*$').hasMatch(password)) {
      pFraction = 1.3;
    } else if (RegExp(r'^[a-z0-9]*$').hasMatch(password)) {
      pFraction = 1.2;
    } else {
      pFraction = 1.8;
    }

    double logF(double x) {
      return 1.0 / (1.0 + math.exp(-x));
    }

    double logC(double x) {
      return logF((x / 2.0) - 4.0);
    }

    return logC(password.length * pFraction);
  }
}
