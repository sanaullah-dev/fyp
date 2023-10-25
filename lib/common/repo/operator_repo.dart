import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:vehicle_management_and_booking_system/authentication/db/database.dart';
import 'package:vehicle_management_and_booking_system/models/operator_model.dart';

class OperatorRepo {
  final _firestore = FirebaseFirestore.instance;
  final _db = AuthDB();
  bool isLoading = false;

  Future<void> uploadOperator({required OperatorModel operator}) async {
    try {
      await _firestore
          .collection("Operators")
          .doc(operator.operatorId)
          .set(operator.toJson());
    } on FirebaseException {
      rethrow;
    }
  }

  Future<void> removeOperator({required String operatorId}) async {
    try {
      await _firestore.collection("Operators").doc(operatorId).delete();
    } catch (e) {
      rethrow;
    }
    //snackBarr.showSnackBarMessage("Operator Removed");
  }

  Future<bool> isOperatorExists({required String uid}) async {
    try {
      return (await _firestore
              .collection("Operators")
              .where("uid", isEqualTo: uid)
              .get())
          .docs
          .isEmpty;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addToFavoritesOperator(OperatorModel operator) async {
    try {
      await _firestore.collection('users').doc(_db.isCurrentUser()!.uid).set(
          {
            'favoriteOperators': FieldValue.arrayUnion([operator.operatorId])
          },
          SetOptions(
              merge:
                  true)); // using SetOptions(merge: true) to not overwrite existing data
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeOperatorFromFavorites(String operatorId) async {
    try {
      isLoading = true;
      // Get all users who have this machinery in their favorites
      QuerySnapshot usersQuery = await _firestore
          .collection('users')
          .where('favoriteOperators', arrayContains: operatorId)
          .get();

      // Get all user document IDs from the query
      List<String> userIds = usersQuery.docs.map((doc) => doc.id).toList();

      // For each user, update the 'favorites' field to remove the machineryId
      for (String userId in userIds) {
        await _firestore.collection('users').doc(userId).update({
          'favoriteOperators': FieldValue.arrayRemove([operatorId])
        });
      }
      isLoading = false;
    } catch (e) {
      isLoading = false;
      rethrow;
    }
  }

  Future<bool> isOperatorFavorited(String userId, String operatorId) async {
    try {
      isLoading = true;
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();
      if (!userDoc.exists) {
        if (kDebugMode) {
          print('UserDoc does not exist');
        }
        isLoading = false;
        return false;
      }

      Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;
      if (data == null || !data.containsKey('favoriteOperators')) {
        print('Data is null or favorites field does not exist');
        isLoading = false;
        return false;
      }

      List<dynamic> favorites = data['favoriteOperators'];

      print('favorites: $favorites');
      print('operatorId: $operatorId');

      // If favorites contains the machineryId, return true. Otherwise, return false.
      isLoading = false;
      return favorites.contains(operatorId);
    } catch (e) {
      isLoading = false;
      print('Error in isMachineryFavorited: $e');
      return false;
    }
  }

  Future<void> updateOperator(OperatorModel operator, bool value) async {
    try {
      DocumentReference operatorRef =
          _firestore.collection("Operators").doc(operator.operatorId);
      await operatorRef.update({'isAvailable': value});
      print("Updated Operator: ${operator.operatorId} with value: $value");
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> addOperatorRating(
      String operatorId, RatingForOperator rating) async {
    try {
      // Reference to the machinery document
      DocumentReference userRef =
          _firestore.collection("Operators").doc(operatorId);

      // Use array-union to ensure the rating is added without duplication
      await userRef.update({
        'allRatings': FieldValue.arrayUnion([rating.toJson()])
      });

      DocumentSnapshot operatorSnapshot = await userRef.get();
      if (operatorSnapshot.exists) {
        Map<String, dynamic>? data =
            operatorSnapshot.data() as Map<String, dynamic>?;
        if (data != null) {
          OperatorModel operator = OperatorModel.fromJson(data);

          // If allRatings is null, set it to an empty list
          List<RatingForOperator> allRatings = operator.allRatings ?? [];

          double averageRating = calculateAverageRating(allRatings);
          log("The average rating is: $averageRating");
          await userRef.update({'rating': averageRating});
        }
      } else {
        print("Operator does not exist");
      }
    } on FirebaseException catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  double calculateAverageRating(List<RatingForOperator> allRatings) {
    if (allRatings.isEmpty) {
      return 0.0;
    }
    double sum = 0.0;
    for (RatingForOperator rating in allRatings) {
      sum += rating.value;
    }
    return sum / allRatings.length;
  }

  Future<void> updateOperatorStatus(OperatorModel operator, bool value) async {
    try {
      DocumentReference operatorRef =
          _firestore.collection("Operators").doc(operator.operatorId);
      await operatorRef.update({'isAvailable': value});
      print("Updated Operator: ${operator.operatorId} with value: $value");
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> updateOperatorsAvailability(String uid, bool isAvailable) async {
    try {
      // Get all operators related to the appUser
      QuerySnapshot querySnapshot = await _firestore
          .collection("Operators")
          .where('uid', isEqualTo: uid)
          .get();

      // Batch write to update all at once
      WriteBatch batch = _firestore.batch();

      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        // batch.update(document.reference, {'isAvailable': isAvailable});
        // Check if operator is hired and available before updating
        bool isHired =
            (document.data() as Map<String, dynamic>)['isHired'] ?? false;
        

        if (!isHired) {
          batch.update(document.reference, {'isAvailable': isAvailable});
        }
      }

      await batch.commit();
    } on FirebaseException catch (e) {
      // Handle errors appropriately for your application
      log("Error updating all operators: $e");
      rethrow;
    }
  }

//  Future<void> addToHiringList(OperatorModel operator) async {
//     try {
//       await _firestore.collection('users').doc(_db.isCurrentUser()!.uid).set(
//           {
//             'hirerOperatorRecordList': FieldValue.arrayUnion([operator.operatorId])
//           },
//           SetOptions(
//               merge:
//                   true)); // using SetOptions(merge: true) to not overwrite existing data
//     } catch (e) {
//       rethrow;
//     }
//   }

  Future<void> hiringRecordForOperatorAndHirer(
      String opId, HiringRecordForOperator hiringRecordForOperator) async {
    try {
      // Reference to the machinery document
      DocumentReference userRef = _firestore.collection("Operators").doc(opId);

      // Use array-union to ensure the rating is added without duplication
      await userRef.update({
        'hiringRecordForOperator':
            FieldValue.arrayUnion([hiringRecordForOperator.toJson()])
      });
    } on FirebaseException catch (e) {
      print(e.toString());
      throw Exception("Error adding Hiring.");
    }
  }

  Future<void> updateFullOperator({required OperatorModel operator}) async {
    try {
      await _firestore
          .collection("Operators")
          .doc(operator.operatorId)
          .update(operator.toJson());
    } on FirebaseException {
      rethrow;
    }
  }
}
