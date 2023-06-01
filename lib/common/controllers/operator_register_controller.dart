import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:vehicle_management_and_booking_system/common/repo/machinery_repo.dart';
import 'package:vehicle_management_and_booking_system/common/repo/operator_repo.dart';
import 'package:vehicle_management_and_booking_system/models/operator_model.dart';

class OperatorRegistrationController with ChangeNotifier {
  final _repo = OperatorRepo();
  final _repoForUploadImage = MachineryRepo();
  bool isLoading = false;

  Future<void> uploadOperator(BuildContext context,
      {required OperatorModel details, required File image}) async {
    try {
      isLoading = true;
      notifyListeners();

      final imageUrls = await _repoForUploadImage.uploadFile(
          image, details.operatorId, details.uid,"operators");
      log(imageUrls);

      details.profilePicture = imageUrls;
      // details.images != null || details.images!.isNotEmpty?
      await _repo.uploadOperator(
          operator: details); //: throw Exception("Image Required");
      isLoading = false;
      notifyListeners();

      // return imageUrls;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}
