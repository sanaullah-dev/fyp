import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:vehicle_management_and_booking_system/models/machinery_model.dart';

class MachineryRepo {
  final _firestore = FirebaseFirestore.instance;
  final _firebaseAuth = FirebaseAuth.instance;
  final _storage = FirebaseStorage.instance;
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

  Future<String> uploadFile({
     required File image,required var id,required var uid,required String collectionName}) async {
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

  Future<String> uploadWebFile({
     required Uint8List image,required var id,required var uid,required String collectionName}) async {
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
}
