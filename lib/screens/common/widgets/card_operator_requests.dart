import 'dart:math';
import 'dart:developer' as dev;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_management_and_booking_system/authentication/controllers/auth_controller.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/machinery_register_controller.dart';
import 'package:vehicle_management_and_booking_system/models/operator_model.dart';
import 'package:vehicle_management_and_booking_system/models/operator_request_model.dart';
import 'package:vehicle_management_and_booking_system/screens/common/drawer_items/drawer_screens/request_details.dart';
import 'package:vehicle_management_and_booking_system/screens/login_signup/model/user_model.dart';
import 'package:vehicle_management_and_booking_system/screens/machinery/widgets/show_custom_rating_dialog.dart';
import 'package:vehicle_management_and_booking_system/utils/const.dart';

Color getStatusColor({required String status, bool? isDark}) {
  switch (status) {
    case 'Pending':
      return Colors.orange;
    case 'Accepted':
      return Colors.green;
    case 'Rejected':
      return Colors.red;
    case 'Hiring Completed':
      return Colors.blue;
    case 'Job Ended':
      return Colors.black;
    default:
      return isDark == true
          ? Colors.white70
          : Colors.black54; // Default color if no match
  }
}

// Function to build individual request tiles
Widget buildHiringRequestTile(
    {required HiringRequestModel request,
    required UserModel sender,
    required BuildContext context,
    required OperatorModel operator}) {
  return Card(
    elevation: 5.0,
    margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Builder(builder: (context) {
          UserModel activeUser =
              // ignore: unrelated_type_equality_checks
              sender.uid == context.read<AuthController>().appUser!.uid
                  ? UserModel(
                      uid: "",
                      isAvailable: operator.isAvailable,
                      name: operator.name,
                      email: "",
                      mobileNumber: "",
                      languages: "languages",
                      profileUrl: operator.operatorImage)
                  : sender;
          return ListTile(
            contentPadding: const EdgeInsets.all(15.0),
            leading: CircleAvatar(
              radius: 25,
              backgroundImage: activeUser.profileUrl != null
                  ? CachedNetworkImageProvider(activeUser.profileUrl!)
                  : null,
              child: activeUser.profileUrl == null
                  ? Text(activeUser.name[0])
                  : null,
            ),
            title: Text(
              activeUser.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    "Start Date: ${request.startDate.substring(0, min(10, request.startDate.length))}"),
                Text(
                    "End Date: ${request.endDate.substring(0, min(10, request.endDate.length))}"),
                Text(
                  "Status: ${request.status}",
                  style:
                      TextStyle(color: getStatusColor(status: request.status)),
                ),
              ],
            ),
            trailing: Text(ConstantHelper.timeAgo(request.requestDate)

                /// "${request.paymentDetails.substring(0, min(7, request.paymentDetails.length))}",
                ),
            isThreeLine:
                true, // Allows space for the multiple lines in subtitle
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => RequestDetailsScreen(
                  hiringRequest: request,
                  operatorModel: operator, // You need to fetch these details.
                  sender: sender,
                ),
              ));
            },
          );
        }),
       ( (request.isHirerRatingComplete != true &&
                    request.hirerUserId ==
                        context.read<AuthController>().appUser!.uid) ||
                (request.isOperatorRatingComplete != true &&
                    request.operatorUid ==
                        context.read<AuthController>().appUser!.uid)) && (request.status !="Pending")
            ? IconButton(
                onPressed: () {
                  try {
                    UserModel otherUser = context
                        .read<MachineryRegistrationController>()
                        .getUser(request.hirerUserId);
                    request.operatorUid ==
                            context.read<AuthController>().appUser!.uid
                        ? showCustomRatingDialog(
                            context: context,
                            requestId: request.requestId,
                            user: otherUser,
                            isHiring: true)
                        : showCustomRatingDialog(
                            context: context,
                            requestId: request.requestId,
                            operator: operator);
                  } catch (e) {
                    dev.log(e.toString());
                  }
                },
                icon: const Icon(Icons.reviews_outlined))
            : const SizedBox(),
      ],
    ),
  );
}
