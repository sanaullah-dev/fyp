import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/machinery_register_controller.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/operator_register_controller.dart';
import 'package:vehicle_management_and_booking_system/models/operator_model.dart';
import 'package:vehicle_management_and_booking_system/models/operator_request_model.dart';
import 'package:vehicle_management_and_booking_system/screens/common/widgets/card_operator_requests.dart';
import 'package:vehicle_management_and_booking_system/screens/login_signup/model/user_model.dart';
import 'package:vehicle_management_and_booking_system/utils/media_query.dart';

// ignore: must_be_immutable
class OperatorRequests extends StatefulWidget {
  final String operatorUid;
  bool isReceivedScreen;
  OperatorRequests(
      {required this.operatorUid, required this.isReceivedScreen, Key? key})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _OperatorRequestsState createState() => _OperatorRequestsState();
}

class _OperatorRequestsState extends State<OperatorRequests> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Stream function to fetch hiring requests
  Stream<List<HiringRequestModel>> getHiringRequestsForOperator(
      String operatorUid) {
    return widget.isReceivedScreen == true
        ? firestore
            .collection('users')
            .doc(operatorUid)
            .collection('operator_hiring_received')
            .orderBy("requestDate", descending: true)
            .snapshots()
            .map((doc) {
            return doc.docs.map((e) {
              return HiringRequestModel.fromJson((e.data()));
            }).toList();
          })
        : firestore
            .collection('users')
            .doc(operatorUid)
            .collection('operator_hiring_sent')
            .orderBy("requestDate", descending: true)
            .snapshots()
            .map((doc) {
            return doc.docs.map((e) {
              return HiringRequestModel.fromJson((e.data()));
            }).toList();
          });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: screenHeight(context),
        width: screenWidth(context),
        child: StreamBuilder<List<HiringRequestModel>>(
          stream: getHiringRequestsForOperator(widget.operatorUid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error fetching requests.'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No hiring requests found.'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final request = snapshot.data![index];
                  UserModel sender = context
                      .read<MachineryRegistrationController>()
                      .getUser(request.hirerUserId);

                 

                  OperatorModel operator = context
                      .read<OperatorRegistrationController>()
                      .getOperator(request.operatorId);
                  return buildHiringRequestTile(
                      request: request,
                      sender: sender,
                      context: context,
                      operator: operator);
                },
              );
            }
          },
        ),
      ),
    );
  }
}
