import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:vehicle_management_and_booking_system/models/operator_model.dart';
import 'package:vehicle_management_and_booking_system/models/operator_request_model.dart';
import 'package:vehicle_management_and_booking_system/models/report_model.dart';
import 'package:vehicle_management_and_booking_system/models/request_machiery_model.dart';
import 'package:vehicle_management_and_booking_system/screens/login_signup/model/user_model.dart';

class RequestRepo {
  final _firestore = FirebaseFirestore.instance;
  // void requestActivateListner() {
  //   FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(userId) // Assuming you have the user's id
  //       .collection('received_requests')
  //       .doc(requestId)
  //       .snapshots()
  //       .listen((snapshot) {
  //     var status = snapshot.data()!['status'];
  //     if (status == 'Activated') {
  //       // Navigate to TrackOrder screen
  //     }
  //   });
  // }

  Future<void> updateRequest(RequestModelForMachieries request) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(request.senderUid) // Replace with the sender's uid
          .collection('sent_requests')
          .doc(request.requestId)
          .update(request.toMap());

      // Update status in receiver's sub-collection
      await FirebaseFirestore.instance
          .collection('users')
          .doc(request.machineryOwnerUid) // Replace with the receiver's uid
          .collection('received_requests')
          .doc(request.requestId)
          .update(request.toMap());
      await FirebaseFirestore.instance
          .collection('machinery_requests')
          .doc(request.requestId) // Replace with the request's uid
          .update(request.toMap());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<bool> isReceivedRequestExist({required String uid}) async {
    try {
      DocumentReference userDocRef = _firestore.collection('users').doc(uid);
      CollectionReference receivedRequestsRef =
          userDocRef.collection('received_requests');
      QuerySnapshot<Object?> snapshot =
          await receivedRequestsRef.limit(1).get();

      if (snapshot.docs.isNotEmpty) {
        // 'received_requests' collection exists (i.e., has at least one document)
        return true;
      } else {
        // No documents in 'received_requests' or the collection doesn't exist
        return false;
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<bool> isSendRequestExist({required String uid}) async {
    try {
      DocumentReference userDocRef = _firestore.collection('users').doc(uid);
      CollectionReference receivedRequestsRef =
          userDocRef.collection('sent_requests');
      QuerySnapshot<Object?> snapshot =
          await receivedRequestsRef.limit(1).get();

      if (snapshot.docs.isNotEmpty) {
        // 'received_requests' collection exists (i.e., has at least one document)
        return true;
      } else {
        // No documents in 'received_requests' or the collection doesn't exist
        return false;
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> checkForTimeOut({
    required List<RequestModelForMachieries> allRequests,
  }) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final batch = firestore.batch();

      for (var request in allRequests) {
        final dateDifference =
            DateTime.now().difference(request.dateAdded.toDate());

        if (dateDifference.inMinutes >= 30 && request.status == null) {
          // Get references
          final senderRef = firestore
              .collection('users')
              .doc(request.senderUid)
              .collection('sent_requests')
              .doc(request.requestId);
          final receiverRef = firestore
              .collection('users')
              .doc(request.machineryOwnerUid)
              .collection('received_requests')
              .doc(request.requestId);

          // Add operations to batch
          batch.update(senderRef, {'status': 'Time Out'});
          batch.update(receiverRef, {'status': 'Time Out'});
        }
      }

      // Commit the batch
      await batch.commit();
    } catch (e) {
      print('Failed to update status: $e');
      rethrow;
    }
  }

// Separate function to handle Firestore batched writes
  Future<void> updateRequestStatus({
    required String senderUid,
    required String receiverUid,
    required String requestId,
    required String status,
    String? comment,
  }) async {
    try {
      final batch = FirebaseFirestore.instance.batch();

      final senderRef = FirebaseFirestore.instance
          .collection('users')
          .doc(senderUid)
          .collection('sent_requests')
          .doc(requestId);

      final receiverRef = FirebaseFirestore.instance
          .collection('users')
          .doc(receiverUid)
          .collection('received_requests')
          .doc(requestId);
      final allRequestsRef = FirebaseFirestore.instance
          .collection('machinery_requests')
          .doc(requestId);

      if (comment != null) {
        batch.update(senderRef, {'status': status, "comment": comment});
        batch.update(receiverRef, {'status': status, "comment": comment});
        batch.update(allRequestsRef, {'status': status, "comment": comment});

        return await batch.commit();
      } else {
        batch.update(senderRef, {'status': status});
        batch.update(receiverRef, {'status': status});
        batch.update(allRequestsRef, {'status': status});

        return await batch.commit();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addMessage(
      String requestId, Map<String, dynamic> messageData) async {
    try {
      await FirebaseFirestore.instance
          .collection('chats') // assuming you have a 'requests' collection
          .doc(requestId)
          .collection(
              'messages') // assuming each request document has a sub-collection called 'messages'
          .add(messageData);
    } catch (e) {
      print("Error adding message: $e");
      rethrow;
    }
  }

  Future<void> sendHiringRequest({required HiringRequestModel request}) async {
    //DocumentReference requestRef = _firestore.collection('hiring_requests').doc(request.requestId);

    try {
      // 1. Add request to sender's sub-collection 'hiring_sent'
      await _firestore
          .collection('users')
          .doc(request
              .hirerUserId) // This assumes the HiringRequest model has a field 'senderUid' for the user sending the request.
          .collection('operator_hiring_sent')
          .doc(request.requestId)
          .set(request.toJson());

      // 2. Add request to operator's sub-collection 'hiring_received'
      await _firestore
          .collection('users')
          .doc(request
              .operatorUid) // Assuming the HiringRequest model has a field 'operatorUid' for the operator being hired.
          .collection('operator_hiring_received')
          .doc(request.requestId)
          .set(request.toJson());

      // 3. Add request to global hiring requests collection
      //await requestRef.set(request.toJson());

      if (kDebugMode) {
        print("Hiring request successfully stored.");
      }
    } catch (e) {
      if (kDebugMode) {
        log("Error sending hiring request: $e");
      }
      rethrow;
    }
  }

  Future<void> updateOperatorRequest(HiringRequestModel request) async {
    try {
      DocumentReference operatorRequestSender = _firestore
          .collection('users')
          .doc(request.hirerUserId)
          .collection('operator_hiring_sent')
          .doc(request.requestId);

      DocumentReference operatorRequestReceiver = _firestore
          .collection('users')
          .doc(request.operatorUid)
          .collection('operator_hiring_received')
          .doc(request.requestId);
      await operatorRequestSender.update(request.toJson());
      await operatorRequestReceiver.update(request.toJson());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

//  Future<void> updateMachine(MachineryModel machine, bool value) async {
//     try {
//       DocumentReference machineryRef =
//           _firestore.collection("machineries").doc(machine.machineryId);
//       await machineryRef.update({'isAvailable': value});
//       print("Updated machine: ${machine.machineryId} with value: $value");
//     } catch (e) {
//       log(e.toString());
//     }
//   }

  Future<void> requestComplete(
      String requestId, String uid, String status, String collection,
      {bool? isOperator}) async {
    try {
      //final _firestore = FirebaseFirestore.instance;

      final senderRef = _firestore
          .collection('users')
          .doc(uid)
          .collection(collection)
          .doc(requestId);

      await senderRef.update({"status": status});

      //await senderRef.update({"status": status});
      if (isOperator != null) {
        final allRequestsRef =
            _firestore.collection('machinery_requests').doc(requestId);
        await allRequestsRef.update({"status": status});
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  double userRating({required List<RatingForUser> userRating}) {
    try {
      double averageRating = calculateAverageRating(userRating);
      return averageRating;
    } catch (e) {
      rethrow;
    }
  }

  double calculateAverageRating(List<RatingForUser> allRatings) {
    if (allRatings.isEmpty) {
      return 0.0;
    }
    double sum = 0.0;
    for (RatingForUser rating in allRatings) {
      sum += rating.value;
    }
    return sum / allRatings.length;
  }

  Future<void> reportSubmition(
      {required ReportModel report,
      required String fireStoreCollectionForReport}) async {
    try {
      await _firestore
          .collection(fireStoreCollectionForReport)
          .doc(report.reportId)
          .set(report.toJson());
    } on FirebaseException {
      rethrow;
    }
  }

  Future<void> updateReportWithCommentAndStatus(
      {required String reportId,
      required String comment,
      required bool isThisMachineriesReports}) async {
    try {
      isThisMachineriesReports
          ? await _firestore
              .collection(
                "MachineriesReports",
              )
              .doc(
                reportId,
              )
              .update({
              'comment': comment,
              'status': 'completed',
            })
          : await _firestore
              .collection(
                "Reports",
              )
              .doc(
                reportId,
              )
              .update({
              'comment': comment,
              'status': 'completed',
            });
    } on FirebaseException catch (e) {
      print(e.message);
      rethrow;
    }
  }

  // Future<void> updatePaymentDetails(
  //     String requestId, String updatedPaymentDetails) async {
  //   try {
  //     // Update the payment details in the hiring request document
  //     await _firestore.collection('users')
  //         .doc(senderUid).
  //         .collection('operator_hiring_received')
  //         .doc(requestId)
  //         .update({'paymentDetails': updatedPaymentDetails});
  //     await _firestore
  //         .collection('operator_hiring_sent')
  //         .doc(requestId)
  //         .update({'paymentDetails': updatedPaymentDetails});

  //     print('Payment details updated successfully.');
  //   } catch (e) {
  //     print('Error updating payment details: $e');
  //     rethrow;
  //     // Handle the error as needed, e.g., show an error message to the user
  //   }
  // }

  // Stream function to fetch hiring requests

  Future<List<HiringRequestModel>> getCombinedHiringRequestsForOperator(
      String operatorUid) async {
    try {
      QuerySnapshot receivedSnapshot = await _firestore
          .collection('users')
          .doc(operatorUid)
          .collection('operator_hiring_received')
          .orderBy("requestDate", descending: true)
          .get();

      QuerySnapshot sentSnapshot = await _firestore
          .collection('users')
          .doc(operatorUid)
          .collection('operator_hiring_sent')
          .orderBy("requestDate", descending: true)
          .get();

      List<HiringRequestModel> received = receivedSnapshot.docs.map((e) {
        return HiringRequestModel.fromJson(e.data() as Map<String, dynamic>);
      }).toList();

      List<HiringRequestModel> sent = sentSnapshot.docs.map((e) {
        return HiringRequestModel.fromJson(e.data() as Map<String, dynamic>);
      }).toList();

      // Combine the received and sent lists into one list
      List<HiringRequestModel> combinedList = [...received, ...sent];

      return combinedList;
    } catch (e) {
      log('Failed to load hiring requests for operator: $e');
      rethrow;
    }
  }

  Future<void> updateRequestRatingStatus(
      {required String requestId,
      required String uid,
      required String collection,
      required bool isOperatorRatingComplete,
      required bool isHirerRatingComplete}) async {
    try {
      DocumentReference operatorRef = _firestore
          .collection("users")
          .doc(uid)
          .collection(collection)
          .doc(requestId);

      isOperatorRatingComplete == true
          ? await operatorRef
              .update({'isOperatorRatingComplete': isOperatorRatingComplete})
          : await operatorRef
              .update({'isHirerRatingComplete': isHirerRatingComplete});
      // print("Updated Operator: ${operator.operatorId} with value: $value");
    } catch (e) {
      log(e.toString());
    }
  }

  //   bool? isOperatorRatingComplete;
  // bool? isHirerRatingComplete;
}
