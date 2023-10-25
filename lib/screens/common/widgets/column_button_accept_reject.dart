// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/machinery_register_controller.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/request_controller.dart';
import 'package:vehicle_management_and_booking_system/models/operator_model.dart';
import 'package:vehicle_management_and_booking_system/models/operator_request_model.dart';
import 'package:vehicle_management_and_booking_system/screens/login_signup/model/user_model.dart';
import 'package:vehicle_management_and_booking_system/utils/notification_method.dart';

Widget columnButtonAcceptReject(
    {required HiringRequestModel request,
    required BuildContext context,
    required OperatorModel op,
    required RequestController value}) {
  return Column(
    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      GestureDetector(
        onTap: () async {
          showAcceptanceDialog(context, request: request, value: value);
          // NotificationMethod notificationMethod = NotificationMethod();
          // request.status = "Accepted";
          // await value.updateOperatorRequest(request: request);
          // // await context
          // //     .read<OperatorRegistrationController>()
          // //     .updateOperatorStatus(op, false);
          // UserModel user = context
          //     .read<MachineryRegistrationController>()
          //     .getUser(request.hirerUserId);
          // await notificationMethod.sendNotification(
          //     fcm: user.fcm.toString(),
          //     title: 'Accepted',
          //     body: "Operator Offer Accepted",
          //     type: "acceptance");
          // notificationMethod.sendNotification(
          //     user.fcm.toString(), "Accepted", "Operator Offer Accepted");
        },
        child: Container(
          margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
            child: Container(
              // margin: const EdgeInsets.fromLTRB(25, 0, 25, 0),
              // width: screenWidth(context) * 0.68,
              height: 56,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Colors.orangeAccent,
                    Colors.deepOrange,
                  ],
                  stops: [0, 1],
                  begin: AlignmentDirectional(-0.34, 1),
                  end: AlignmentDirectional(0.34, -1),
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  'Accept Now!',
                  style: GoogleFonts.libreBaskerville(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),

      const SizedBox(width: 20), // Spacing between the buttons
      // ignore: avoid_unnecessary_containers
      Container(
        child: TextButton(
          onPressed: () async {
            showRejectionDialog(context, request: request, value: value);
            // NotificationMethod notificationMethod = NotificationMethod();
            // request.status = "Rejected";
            // await value.updateOperatorRequest(request: request);
            // UserModel user = context
            //     .read<MachineryRegistrationController>()
            //     .getUser(request.hirerUserId);

            // notificationMethod.sendNotification(
            //     fcm: user.fcm.toString(),
            //     title: "Rejected",
            //     body: "Operator Offer Rejected",
            //     type: "rejection");
            // // Handle Reject action here
            // print('Rejected');
          },
          child: const Text('Reject this offer'),
        ),
      ),
    ],
  );
}

// // Function to show the acceptance dialog
// Future<void> showAcceptanceDialog(BuildContext context,
//     {required HiringRequestModel request,
//     required RequestController value}) async {
//   return showDialog(
//     context: context,
//     builder: (context) {
//       return AlertDialog(
//         title: Text('Accept Request'),
//         content:
//             Text('The operator will be hidden from public view. Continue?'),
//         actions: [
//           TextButton(
//             onPressed: () async {
//               NotificationMethod notificationMethod = NotificationMethod();
//               request.status = "Accepted";
//               await value.updateOperatorRequest(request: request);
//               // await context
//               //     .read<OperatorRegistrationController>()
//               //     .updateOperatorStatus(op, false);
//               UserModel user = context
//                   .read<MachineryRegistrationController>()
//                   .getUser(request.hirerUserId);
//               await notificationMethod.sendNotification(
//                   fcm: user.fcm.toString(),
//                   title: 'Accepted',
//                   body: "Operator Offer Accepted",
//                   type: "acceptance");
//               Navigator.pop(context);
//               // Implement the logic for accepting the request and hiding the operator
//             },
//             child: Text('Yes'),
//           ),
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('No'),
//           ),
//         ],
//       );
//     },
//   );
// }
Future<void> showAcceptanceDialog(BuildContext context,
    {required HiringRequestModel request,
    required RequestController value}) async {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Accept Request'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('The operator will be hidden from public view.\nI agree with the Reqeust Details'),
            SizedBox(height: 20),
            // Text(
            //   'Note: You can view the operator\'s contact details by opening their Operater Details Card after acceptance.',
            //   style: TextStyle(
            //     fontStyle: FontStyle.italic,
            //     fontSize: 12,
            //   ),
            // ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () async {
              NotificationMethod notificationMethod = NotificationMethod();
              request.status = "Accepted";
              await value.updateOperatorRequest(request: request);
              // await context
              //     .read<OperatorRegistrationController>()
              //     .updateOperatorStatus(op, false);
              UserModel user = context
                  .read<MachineryRegistrationController>()
                  .getUser(request.hirerUserId);
              await notificationMethod.sendNotification(
                  fcm: user.fcm.toString(),
                  title: 'Accepted',
                  body: "Operator Offer Accepted",
                  type: "acceptance");
              Navigator.pop(context);
              // Navigator.pop(context); // Close the dialog
            },
            child: const Text('Yes'),
          ),
        ],
      );
    },
  );
}

// Function to show the rejection dialog
Future<void> showRejectionDialog(BuildContext context,
    {required HiringRequestModel request,
    required RequestController value,
    String? uid}) async {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Reject Request'),
        content: const Text('Are you sure you want to reject this request?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () async {
              NotificationMethod notificationMethod = NotificationMethod();
              request.status = "Rejected";
              await value.updateOperatorRequest(request: request);
              UserModel user = context
                  .read<MachineryRegistrationController>()
                  .getUser(uid ?? request.hirerUserId);

              notificationMethod.sendNotification(
                  fcm: user.fcm.toString(),
                  title: "Rejected",
                  body: "Operator Offer Rejected",
                  type: "rejection");
              // Handle Reject action here
              print('Rejected');
              Navigator.pop(context);
              // Implement the logic for rejecting the request
            },
            child: const Text('Yes'),
          ),
        ],
      );
    },
  );
}

// Function to show the completion dialog
Future<void> showCompletionDialog(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Complete Hiring'),
        content: const Text(
            'Completing this will make the profile public again. Continue?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Implement the logic for completing the hiring
            },
            child: const Text('Yes'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
        ],
      );
    },
  );
}
