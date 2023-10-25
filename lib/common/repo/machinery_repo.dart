import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:vehicle_management_and_booking_system/authentication/db/database.dart';
import 'package:vehicle_management_and_booking_system/models/machinery_model.dart';
import 'package:vehicle_management_and_booking_system/models/request_machiery_model.dart';

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

  Future<void> sendRequest(RequestModel request) async {
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
    await _firestore
        .collection('users')
        .doc(_db.isCurrentUser()!.uid)
        .set({
          'favorites': FieldValue.arrayUnion([machine.machineryId])
        }, SetOptions(merge: true)); // using SetOptions(merge: true) to not overwrite existing data
  } catch (e) {
    rethrow;
  }
}
}
