import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vehicle_management_and_booking_system/common/repo/machinery_repo.dart';
import 'package:vehicle_management_and_booking_system/models/machinery_model.dart';

class MachineryRegistrationController with ChangeNotifier {
  final _repo = MachineryRepo();
  bool isLoading = false;

  Future<void> uploadMachinery(BuildContext context,
      {required MachineryModel details,
      required List<dynamic> images,
      required String collection}) async {
    List<String> imageUrls;
    try {
      isLoading = true;
      notifyListeners();
      if (!kIsWeb) {
        imageUrls = await Future.wait(
          images.map(
            (image) => _repo.uploadFile(
              image: image,
              id: details.machineryId,
              uid: details.uid,
              collectionName: collection,
            ),
          ),
        );
        log(imageUrls.toString());

        details.images = imageUrls;
      } else {
        imageUrls = await Future.wait(
          images.map(
            (image) => _repo.uploadWebFile(
              image: image,
              id: details.machineryId,
              uid: details.uid,
              collectionName: collection,
            ),
          ),
        );
        details.images = imageUrls;
      }
      // details.images != null || details.images!.isNotEmpty?
      await _repo.uploadMachinery(
          machine: details); //: throw Exception("Image Required");
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
