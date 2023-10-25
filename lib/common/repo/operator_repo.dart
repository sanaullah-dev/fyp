import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vehicle_management_and_booking_system/authentication/db/database.dart';
import 'package:vehicle_management_and_booking_system/models/operator_model.dart';

class OperatorRepo {
  final _firestore = FirebaseFirestore.instance;
  final _db = AuthDB();

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
              .collection("Operators").where("uid",isEqualTo: uid).get()).docs.isEmpty;
          
    } catch (e) {
      rethrow;
    }
  }

}
