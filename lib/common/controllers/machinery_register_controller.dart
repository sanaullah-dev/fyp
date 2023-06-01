import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:vehicle_management_and_booking_system/common/repo/machinery_repo.dart';
import 'package:vehicle_management_and_booking_system/models/machinery_model.dart';
import 'package:vehicle_management_and_booking_system/utils/const.dart';

class MachineryRegistrationController with ChangeNotifier {
  final _repo = MachineryRepo();
  bool isLoading = false;
  


  Future<void> uploadMachinery(BuildContext context,
      {required MachineryModel details, required List<File> images, required String collection}) async {
   try{
   isLoading = true;
     notifyListeners();
    var imageUrls = await Future.wait(
        images.map((image) => _repo.uploadFile(image, details.machineryId,details.uid,collection)));
    log(imageUrls as String);

    details.images = imageUrls;
   // details.images != null || details.images!.isNotEmpty?
    await _repo.uploadMachinery(machine: details);//: throw Exception("Image Required");
    isLoading = false;
    notifyListeners();

   // return imageUrls;
  }catch(e){
    isLoading = false;
    notifyListeners();
    rethrow;
  }
      }

}
