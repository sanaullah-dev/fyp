import 'dart:developer' as dev;
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:vehicle_management_and_booking_system/authentication/db/database.dart';
import 'package:vehicle_management_and_booking_system/common/repo/machinery_repo.dart';
import 'package:vehicle_management_and_booking_system/common/repo/operator_repo.dart';
import 'package:vehicle_management_and_booking_system/models/operator_model.dart';
import 'package:flutter/foundation.dart' as TargetPlatform;

class OperatorRegistrationController with ChangeNotifier {
  final _repo = OperatorRepo();
  final _db = AuthDB();
  final _repoForUploadImage = MachineryRepo();
  bool isLoading = false;
  List<OperatorModel> allOperators = [];








  Future<void> uploadOperator(BuildContext context,
      {required OperatorModel details, required dynamic image}) async {
    try {
      isLoading = true;
      notifyListeners();

      final imageUrls = !TargetPlatform.kIsWeb
          ? await _repoForUploadImage.uploadFile(
              image: image,
              id: details.operatorId,
              uid: details.uid,
              collectionName: "operators",
            )
          : await _repoForUploadImage.uploadWebFile(
              image: image,
              id: details.operatorId,
              uid: details.uid,
              collectionName: "operators");
      dev.log(imageUrls.toString());

      details.operatorImage = imageUrls.toString();
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



Future<void> getNearestAndHighestRatedOperator() async {
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation);
  var latitude = position.latitude;
  var longitude = position.longitude;
  final ref =  FirebaseFirestore.instance.collection('Operators');
  final snapshots = await ref.get();

  List<OperatorModel> sortedOperators = snapshots.docs.map((doc) {
    return OperatorModel.fromJson(doc.data());
  }).toList()
    ..sort((a, b) {
      // Normalize distance to a 0-1 scale (Assuming max distance is 20000 km)
      final distA = calculateDistance(a.location, latitude, longitude) / 10;
      final distB = calculateDistance(b.location, latitude, longitude) / 10;

      // Normalize rating to a 0-1 scale (Assuming max rating is 5)
      final rateA = a.rating / 5;
      final rateB = b.rating / 5;

      // Calculate a combined score based on distance and rating
      final scoreA = calculateScore(distA, rateA);
      final scoreB = calculateScore(distB, rateB);

      // Sort in descending order of combined score
      return scoreB.compareTo(scoreA);
    });

  allOperators =  sortedOperators;
  notifyListeners();
}

 double calculateDistance(
      Locations location, double latitude, double longitude) {
    final earthRadius = 6371.0; // in kilometers
    final dLat = _degreesToRadians(location.latitude - latitude);
    final dLon = _degreesToRadians(location.longitude - longitude);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        sin(dLon / 2) *
            sin(dLon / 2) *
            cos(_degreesToRadians(latitude)) *
            cos(_degreesToRadians(location.latitude));
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  double _degreesToRadians(degrees) {
    return degrees * pi / 180;
  }

  double calculateScore(double distance, double rating) {
    final weightDistance = 0.4; // weight for distance (less is better)
    final weightRating = 0.6; // weight for rating (more is better)

    // Note that we subtract distance from 1 because a shorter distance is better
    return weightDistance * (1 - distance) + weightRating * rating;
  }








  Future<void> deleteOperator(
      {required String operatorId, required String images}) async {
    try {
      await _repo.removeOperator(operatorId: operatorId);
      await _deleteOpImage(imageUrl: images);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _deleteOpImage({required String imageUrl}) async {
    try{
    await _db.deleteImage(url: imageUrl);
    }catch(e){
      rethrow;
    }
  }
}
