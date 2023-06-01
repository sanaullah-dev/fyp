import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:vehicle_management_and_booking_system/models/operator_model.dart';

class OperatorRepo{


  final _firestore = FirebaseFirestore.instance;
  final _firebaseAuth = FirebaseAuth.instance;
  final _firebaseStorage = FirebaseStorage.instance;

  Future<void> uploadOperator({required OperatorModel operator}) async{
try{
    await _firestore.collection("Operatros").doc(operator.operatorId).set(operator.toJson());
} on FirebaseException catch(e){
rethrow;
}

  }

}