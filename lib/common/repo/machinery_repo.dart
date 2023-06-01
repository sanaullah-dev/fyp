import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:vehicle_management_and_booking_system/models/machinery_model.dart';

class MachineryRepo{

 final _firestore = FirebaseFirestore.instance;
  final _firebaseAuth = FirebaseAuth.instance;
  final _storage = FirebaseStorage.instance;
  Future<void> uploadMachinery({required MachineryModel machine}) async {
    try {
      await _firestore.collection("machineries").doc(machine.machineryId).set(machine.toJson());
    } on FirebaseException catch (e) {
      rethrow;
    }
  }

    Future<String> uploadFile(File image, var id,var uid,String collectionName) async {
     
    var storageReference =  FirebaseStorage.instance
        .ref()
        .child('$collectionName/$uid/$id/${const Uuid().v1()}');
    try {
     
      var uploadTask = await storageReference.putFile(image);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
    //await uploadTask.onComplete;

    return await storageReference.getDownloadURL();
  }
}