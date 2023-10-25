import 'dart:developer' as dev;
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:vehicle_management_and_booking_system/authentication/db/database.dart';
import 'package:vehicle_management_and_booking_system/common/repo/machinery_repo.dart';
import 'package:vehicle_management_and_booking_system/common/repo/operator_repo.dart';
import 'package:vehicle_management_and_booking_system/models/operator_model.dart';
// ignore: library_prefixes
import 'package:flutter/foundation.dart' as TargetPlatform;

class OperatorRegistrationController with ChangeNotifier {
  final _repo = OperatorRepo();
  final _db = AuthDB();
  final _repoForUploadImage = MachineryRepo();
  bool isLoading = false;
  List<OperatorModel> allOperators = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<OperatorModel>? favoriteOperators;
  List<OperatorModel> hiredOperators = [];

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
    try {
      await Geolocator.requestPermission();
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
      var latitude = position.latitude;
      var longitude = position.longitude;
      final ref = FirebaseFirestore.instance.collection('Operators');
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

      allOperators = sortedOperators;
      notifyListeners();
    } catch (e) {
      dev.log(e.toString());
    }
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
    try {
      await _db.deleteImage(url: imageUrl);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addToFavoritesOperator(OperatorModel operator) async {
    try {
      isLoading = true;

      await _repo.addToFavoritesOperator(operator);
      isLoading = false;
    } catch (e) {
      isLoading = false;
      rethrow;
    }
  }

  Future<void> removeOperatorFromFavorites(String operatorId) async {
    try {
      await _repo.removeOperatorFromFavorites(operatorId);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> isOperatorFavorited(String userId, String operatorId) async {
    try {
      isLoading = true;
      bool check = await _repo.isOperatorFavorited(userId, operatorId);
      isLoading = false;
      return check;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<OperatorModel>> getFavoritesOperators(String userId) async {
    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(userId).get();

    // Check if the document exists and if it has data before checking for 'favorites'
    if (userDoc.exists && userDoc.data() is Map<String, dynamic>) {
      Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
      if (data.containsKey('favoriteOperators')) {
        List<dynamic> favorites = data['favoriteOperators'];
        // var favorite =
        //     favorites.map((favorite) => favorite.toString()).toList();

        favoriteOperators = allOperators
            .where((operator) => favorites.contains(operator.operatorId))
            .toList();

        notifyListeners();
        return favoriteOperators!;
      }
    }
    // return an empty list if the document doesn't exist or it doesn't contain the 'favorites' field
    return [];
  }

  OperatorModel getOperator(String id) {
    return allOperators.firstWhere((temp) => id == temp.operatorId);
  }

  Future<void> updateOperator(OperatorModel operator, bool value) async {
    try {
      await _repo.updateOperator(operator, value);
    } catch (e) {
      dev.log(e.toString());
    }
  }

  Future<void> addOperatorRating(
      String operatorId, RatingForOperator rating) async {
    try {
      await _repo.addOperatorRating(operatorId, rating);
    } on FirebaseException catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  Future<void> updateOperatorStatus(OperatorModel operator, bool value) async {
    try {
      await _repo.updateOperatorStatus(operator, value);
    } catch (e) {
      dev.log(e.toString());
      rethrow;
    }
  }

  Future<bool> isOperatorExists({required String uid}) async {
    try {
      return await _repo.isOperatorExists(uid: uid);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateOperatorsAvailability(String uid, bool isAvailable) async {
    try {
      await _repo.updateOperatorsAvailability(uid, isAvailable);
    } on FirebaseException catch (e) {
      // Handle errors appropriately for your application
      dev.log("Error updating all operators: $e");
      rethrow;
    }
  }

  // Future<void> addToHiringList(OperatorModel operator) async {
  //   try {
  //     await _repo.addToHiringList(operator);
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  Future<void> hiringRecordForOperatorAndHirer(
      String opId, HiringRecordForOperator hiringRecordForOperator) async {
    try {
      await _repo.hiringRecordForOperatorAndHirer(
          opId, hiringRecordForOperator);
      // }
    } on FirebaseException catch (e) {
      print(e.toString());
      throw Exception("Error adding Hiring.");
    }
  }

  Future<void> updateFullOperator({required OperatorModel operator}) async {
    try {
      isLoading = true;
      notifyListeners();
      await _repo.updateFullOperator(operator: operator);
       isLoading = false;
      notifyListeners();
    } on FirebaseException {
       isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<List<OperatorModel>> getHiredOperators(String hirerUid) async {
    List<OperatorModel> tempHiredOperators = [];

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Operators')
          .where('hiringRecordForOperator',
              arrayContains: {'hirerUid': hirerUid}).get();

      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        OperatorModel operator = OperatorModel.fromJson(data);
        tempHiredOperators.add(operator);
      });
    } catch (e) {
      print('Error getting hired operators: $e');
    }
    dev.log(tempHiredOperators.length.toString());
    hiredOperators = tempHiredOperators;
    return tempHiredOperators;
  }
}
