import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:vehicle_management_and_booking_system/authentication/db/database.dart';
import 'package:vehicle_management_and_booking_system/models/machinery_model.dart';
import 'package:vehicle_management_and_booking_system/models/request_machiery_model.dart';
import 'package:vehicle_management_and_booking_system/screens/login_signup/model/user_model.dart';

class MachineryRepo {
  final _firestore = FirebaseFirestore.instance;
  final _db = AuthDB();

  Future<void> uploadMachinery({required MachineryModel machine}) async {
    try {
      await _firestore
          .collection("machineries")
          .doc(machine.machineryId)
          .set(machine.toJson());
    } on FirebaseException {
      rethrow;
    }
  }

  Future<String> uploadFile(
      {required File image,
      required var id,
      required var uid,
      required String collectionName}) async {
    var storageReference = FirebaseStorage.instance
        .ref()
        .child('$collectionName/$uid/$id/${const Uuid().v1()}');
    try {
      await storageReference.putFile(image);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
    //await uploadTask.onComplete;

    return await storageReference.getDownloadURL();
  }

  Future<String> uploadWebFile(
      {required Uint8List image,
      required var id,
      required var uid,
      required String collectionName}) async {
    try {
      // ignore: no_leading_underscores_for_local_identifiers
      FirebaseStorage _storage = FirebaseStorage.instance;
      // log(file.path);
      TaskSnapshot taskSnapshot = await _storage
          .ref()
          .child(
            '$collectionName/$uid/$id/${const Uuid().v1()}',
          )
          .putData(
            image,
          );
      //log(id);
      //log(ref);
      final url = await taskSnapshot.ref.getDownloadURL();

      return url;
    } on FirebaseException {
      rethrow;
    }
  }

  Future<void> sendRequest(RequestModelForMachieries request) async {
    DocumentReference requestRef =
        _firestore.collection('machinery_requests').doc(request.requestId);
    try {
      // Add request to sender's sub-collection
      await _firestore
          .collection('users')
          .doc(request.senderUid)
          .collection('sent_requests')
          .doc(request.requestId)
          .set(request.toMap());

      // Add request to receiver's sub-collection
      await _firestore
          .collection('users')
          .doc(request.machineryOwnerUid)
          .collection('received_requests')
          .doc(request.requestId)
          .set(request.toMap());

      // Add request to global requests collection
      await requestRef.set(request.toMap());
    } catch (e) {
      rethrow;
    }
  }

  //   Future<void> followUser(
  //     {required RequestModel myFollowModel,
  //     required RequestModel followModel}) async {
  //   try {
  //     // put otherUserdata in my followed
  //     // put my data in his followers
  //     await _firestore
  //         .collection("machinery_send_request")
  //         .doc(_db.isCurrentUser()!.uid)
  //         .collection("request")
  //         .doc(requst.uid)
  //         .set(followModel.toJson());

  //     await _firestore
  //         .collection("users")
  //         .doc(followModel.uid)
  //         .collection("followers")
  //         .doc(_firebaseAuth.currentUser!.uid)
  //         .set(myFollowModel.toJson());
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  // CollectionReference get favoritesCollection =>
  //   _firestore.collection('users').doc(_db.isCurrentUser()!.uid).collection('favorites');

  // Future<void> addToFavorites(MachineryModel machine) async {
  //   try {
  //     await _firestore
  //         .collection('Favorites')
  //         .doc(_db.isCurrentUser()!.uid)
  //         .set(machine.toJson());
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

//   Future<void> addToFavorites(MachineryModel machine) async {
//   try {
//     await _firestore
//         .collection('Favorites')
//         .doc(_db.isCurrentUser()!.uid)
//         .set({
//           'machineryIds': FieldValue.arrayUnion([machine.machineryId])
//         }, SetOptions(merge: true)); // using SetOptions(merge: true) to not overwrite existing data
//   } catch (e) {
//     rethrow;
//   }
// }

  Future<void> addToFavorites(MachineryModel machine) async {
    try {
      await _firestore.collection('users').doc(_db.isCurrentUser()!.uid).set(
          {
            'favorites': FieldValue.arrayUnion([machine.machineryId])
          },
          SetOptions(
              merge:
                  true)); // using SetOptions(merge: true) to not overwrite existing data
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeMachineFromFavorites(String machineId) async {
    // Get all the users from Firestore
    try {
      QuerySnapshot userSnapshot = await _firestore
          .collection('users')
          .where('favorites', arrayContains: machineId)
          .get();

      List<DocumentSnapshot> users = userSnapshot.docs;

      for (DocumentSnapshot user in users) {
        if (user.exists && user.data() is Map<String, dynamic>) {
          Map<String, dynamic> data = user.data() as Map<String, dynamic>;
          if (data.containsKey('favorites')) {
            List<dynamic> favorites = data['favorites'];
            favorites.remove(machineId);
            await user.reference.update({'favorites': favorites});
          }
        }
      }

      // final userQuerySnapshot = await _firestore.collection('users').get();

      // // Go through each user
      // for (final userDoc in userQuerySnapshot.docs) {
      //   // If the user has the machine in their favorites, remove it
      //   if (userDoc['favorites'] != null &&
      //       userDoc['favorites'].contains(machineId)) {
      //     await _firestore.collection('users').doc(userDoc.id).update({
      //       'favorites': FieldValue.arrayRemove([machineId]),
      //     });
      //   }
      // }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteRequestsOfMachinery(
      {required String machineId,
      required List<RequestModelForMachieries> requests}) async {
    for (final machie in requests) {
      if (machie.machineId == machineId) {
        await _firestore
            .collection('users')
            .doc(machie.senderUid)
            .collection('sent_requests')
            .doc(machie.requestId)
            .delete();

        await _firestore
            .collection('users')
            .doc(machie.machineryOwnerUid)
            .collection('received_requests')
            .doc(machie.requestId)
            .delete();

        await _firestore
            .collection('machinery_requests')
            .doc(machie.requestId)
            .delete();

        await FirebaseFirestore.instance
            .collection('chats')
            .doc(machie.requestId)
            .delete();
      }
    }
  }

  Future<bool> hasUserRatedMachinery(String userId, String machineryId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection("machineries").doc(machineryId).get();

      MachineryModel machinery =
          MachineryModel.fromJson(doc.data() as Map<String, dynamic>);

      if (machinery.allRatings == null) {
        return false; // No ratings for this machinery yet
      }

      for (Rating rating in machinery.allRatings!) {
        if (rating.userId == userId) {
          return true; // User has rated this machinery
        }
      }

      return false; // User has not rated this machinery
    } on FirebaseException catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  Future<void> addRatingToMachinery(String machineryId, Rating rating) async {
    try {
      // Reference to the machinery document
      DocumentReference machineryRef =
          _firestore.collection("machineries").doc(machineryId);

      // Use array-union to ensure the rating is added without duplication
      await machineryRef.update({
        'allRatings': FieldValue.arrayUnion([rating.toJson()])
      });
      DocumentSnapshot machinerySnapshot = await machineryRef.get();
      if (machinerySnapshot.exists) {
        Map<String, dynamic>? data =
            machinerySnapshot.data() as Map<String, dynamic>?;
        if (data != null) {
          MachineryModel machinery = MachineryModel.fromJson(data);

          // If allRatings is null, set it to an empty list
          List<Rating> allRatings = machinery.allRatings ?? [];

          double averageRating = calculateAverageRating(allRatings);
          log("The average rating is: $averageRating");
          await machineryRef.update({'rating': averageRating});
        }
      } else {
        print("Machinery does not exist");
      }
    } on FirebaseException catch (e) {
      print(e.toString());
      throw Exception("Error adding rating.");
    }
  }




  double calculateAverageRating(List<Rating> allRatings) {
    if (allRatings.isEmpty) {
      return 0.0;
    }
    double sum = 0.0;
    for (Rating rating in allRatings) {
      sum += rating.value;
    }
    return sum / allRatings.length;
  }

  Future<void> updateMachine(MachineryModel machine, bool value) async {
    try {
      DocumentReference machineryRef =
          _firestore.collection("machineries").doc(machine.machineryId);
      await machineryRef.update({'isAvailable': value});
      print("Updated machine: ${machine.machineryId} with value: $value");
    } catch (e) {
      log(e.toString());
    }
  }








   Future<void> addUserRating(String uid, RatingForUser rating) async {
    try {
      // Reference to the machinery document
      DocumentReference userRef =
          _firestore.collection("users").doc(uid);

      // Use array-union to ensure the rating is added without duplication
      await userRef.update({
        'allRatings': FieldValue.arrayUnion([rating.toJson()])
      });
      // DocumentSnapshot machinerySnapshot = await machineryRef.get();
      // if (machinerySnapshot.exists) {
      //   Map<String, dynamic>? data =
      //       machinerySnapshot.data() as Map<String, dynamic>?;
      //   if (data != null) {
      //     MachineryModel machinery = MachineryModel.fromJson(data);

      //     // If allRatings is null, set it to an empty list
      //     List<Rating> allRatings = machinery.allRatings ?? [];

      //     double averageRating = calculateAverageRating(allRatings);
      //     log("The average rating is: $averageRating");
      //     await machineryRef.update({'rating': averageRating});
      //   }
      // } else {
      //   print("Machinery does not exist");
      // }
    } on FirebaseException catch (e) {
      print(e.toString());
      throw Exception("Error adding rating.");
    }
  }


  Future<void> updateAllMachinesAvailability(String uid, bool isAvailable) async {
  try {
    // Get all machines related to the user
    QuerySnapshot querySnapshot = await _firestore
        .collection("machineries")
        .where('uid', isEqualTo: uid)
        .get();

    // Batch write to update all at once
    WriteBatch batch = _firestore.batch();

    for (QueryDocumentSnapshot document in querySnapshot.docs) {
      batch.update(document.reference, {'isAvailable': isAvailable});
    }

    await batch.commit();
  } on FirebaseException catch (e) {
    // Handle errors appropriately for your application
    log("Error updating all machines: $e");
   rethrow;
  }
}

}
