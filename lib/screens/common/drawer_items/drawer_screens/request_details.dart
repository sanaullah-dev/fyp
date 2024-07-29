// ignore_for_file: use_build_context_synchronously
import 'dart:developer' as dev;
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_management_and_booking_system/app/app.dart';
import 'package:vehicle_management_and_booking_system/authentication/controllers/auth_controller.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/machinery_register_controller.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/operator_register_controller.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/request_controller.dart';
import 'package:vehicle_management_and_booking_system/models/operator_model.dart';
import 'package:vehicle_management_and_booking_system/models/operator_request_model.dart';
import 'package:vehicle_management_and_booking_system/screens/common/messages_screen.dart';
import 'package:vehicle_management_and_booking_system/screens/common/profile_screen.dart';
import 'package:vehicle_management_and_booking_system/screens/common/widgets/card_operator_requests.dart';
import 'package:vehicle_management_and_booking_system/screens/common/widgets/column_button_accept_reject.dart';
import 'package:vehicle_management_and_booking_system/screens/login_signup/model/user_model.dart';
import 'package:vehicle_management_and_booking_system/screens/operator/operator_details.dart';
import 'package:vehicle_management_and_booking_system/utils/app_colors.dart';
import 'package:vehicle_management_and_booking_system/utils/const.dart';
import 'package:vehicle_management_and_booking_system/utils/media_query.dart';

class RequestDetailsScreen extends StatefulWidget {
  final HiringRequestModel hiringRequest;
  final OperatorModel
      operatorModel; // Assuming you'll provide this information when navigating to this page.
  final UserModel
      sender; // Assuming you'll provide the sender's details when navigating.

  const RequestDetailsScreen({
    required this.hiringRequest,
    required this.operatorModel,
    required this.sender,
    Key? key,
  }) : super(key: key);

  @override
  State<RequestDetailsScreen> createState() => _RequestDetailsScreenState();
}

class _RequestDetailsScreenState extends State<RequestDetailsScreen> {
  bool? isDark;
  late UserModel appUser;
  bool viewDetails = false;
  @override
  void initState() {
    // TODO: implement initState
    appUser = context.read<AuthController>().appUser!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isDark = ConstantHelper.darkOrBright(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Request Details",
          style: TextStyle(color: isDark! ? null : Colors.black),
        ),
        backgroundColor: isDark! ? null : AppColors.accentColor,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              navigatorKey.currentState!.pop();
            },
            icon: Icon(
              Icons.arrow_back_ios_new_sharp,
              color: isDark! ? null : AppColors.blackColor,
            )),
      ),
      body: Consumer<RequestController>(builder: (context, value, _) {
        DateTime now = DateTime.now();
        // DateTime twoDaysLater = now.add(Duration(hours: 14));
        DateTime interviewDate = widget.hiringRequest.interViewDateTime!;
        // Calculate the date two days after the interview date
        DateTime twoDaysAfterInterview = interviewDate.add(const Duration(days: 2));

        if (widget.hiringRequest.status == "Hiring Completed" &&
            viewDetails == false &&
            widget.operatorModel.isHired == true &&
            // widget.operatorModel.hiringRecordForOperator!.last.hirerUid ==
            //     appUser.uid &&
            widget.hiringRequest.hirerUserId != appUser.uid &&
            now.isBefore(twoDaysAfterInterview)) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Congratulations! You joined us.',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Handle button tap when the request status is "complete"
                    setState(() {
                      viewDetails = true;
                    });
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => RequestDetailsScreen(
                    //       hiringRequest: widget.hiringRequest,
                    //       operatorModel: widget.operatorModel,
                    //       sender: widget.sender,
                    //     ),
                    //   ),
                    // );
                  },
                  child: const Text('View Details'),
                ),
              ],
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                _buildOperatorImageContainer(
                    widget.operatorModel.operatorImage),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.orange, width: 0.5),
                    color: isDark! ? Colors.grey.shade700 : Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0, 2),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildDateColumn("Start Date",
                          widget.hiringRequest.startDate, Icons.date_range),
                      const VerticalDivider(
                        color: Colors.blueAccent,
                        thickness: 1.2,
                      ),
                      _buildDateColumn("End Date", widget.hiringRequest.endDate,
                          Icons.date_range_outlined),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                _buildDetailTile(
                    "Company Name", widget.hiringRequest.companyName),
                GestureDetector(
                    onTap: () async {
                      // widget.hiringRequest.status = "Pending";
                      // await value.updateOperatorRequest(
                      //     request: widget.hiringRequest);
                    },
                    child: _buildDetailTile(
                        "Purpose", widget.hiringRequest.purpose)),
                //_buildDetailTile("Job Type", widget.hiringRequest.jobType),
                const SizedBox(
                  height: 10,
                ),
                _buildDetailTileForStatusAndRequestDate(
                    "Job Type",
                    widget.hiringRequest.jobType,
                    "Messages",
                    "Chat Now",
                    widget.hiringRequest),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: appUser.uid == widget.hiringRequest.hirerUserId
                      ? () async {
                          // Show dialog box
                          widget.hiringRequest.status == "Pending"
                              ? showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    TextEditingController
                                        paymentDetailsController =
                                        TextEditingController(
                                            text: widget
                                                .hiringRequest.paymentDetails);

                                    return AlertDialog(
                                      title:
                                          const Text("Update Payment Details"),
                                      content: TextField(
                                        controller: paymentDetailsController,
                                        decoration: const InputDecoration(
                                            labelText:
                                                "Enter new payment details"),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text("Cancel"),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: const Text("Update"),
                                          onPressed: () async {
                                            // Perform the update operation here
                                            widget.hiringRequest
                                                    .paymentDetails =
                                                paymentDetailsController.text;
                                            try {
                                              await context
                                                  .read<RequestController>()
                                                  .updateOperatorRequest(
                                                      request: widget
                                                          .hiringRequest); // Call your update function here and pass updatedPaymentDetails
                                            } catch (e) {
                                              print(
                                                  'Error updating payment details $e');
                                            }

                                            // Close the dialog
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                )
                              : ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "Cannot change after acceptance")));
                        }
                      : null,
                  child: _buildDetailTile(
                      "Payment Details", widget.hiringRequest.paymentDetails,
                      isHirer: appUser.uid == widget.hiringRequest.hirerUserId
                          ? true
                          : null),
                ),
                _buildDetailTile("Notes", widget.hiringRequest.notes),

                const SizedBox(
                  height: 5,
                ),
                _buildDetailTileForStatusAndRequestDate(
                    "Status",
                    widget.hiringRequest.status,
                    "Request Date",
                    ConstantHelper.timeAgo(widget.hiringRequest.requestDate),
                    widget.hiringRequest),

                const SizedBox(
                  height: 5,
                ),
                widget.hiringRequest.status == "Accepted" &&
                            widget.hiringRequest.hirerUserId != appUser.uid ||
                        (widget.hiringRequest.status == "Hiring Completed" &&
                            widget.hiringRequest.hirerUserId != appUser.uid)
                    ? _buildDetailTile(
                        "Invitation for Interview/try",
                        "Congratulations! You have been selected for an interview. We look forward to meeting you in person. Please attend the interview and practical test on operating excavator/machine as scheduled. \n\nDate and Time: ${DateFormat('dd-MMM-yyyy hh:mm a').format(widget.hiringRequest.interViewDateTime!)}\n\nLocation: ${widget.hiringRequest.interViewLocation} \n\n Contact: ${widget.hiringRequest.contactNumber}",
                      )
                    : const SizedBox(),
                // widget.hiringRequest.status  == "Accepted"?
                //  _buildDetailTile(
                //     "Invite for Inter views","You need to come for test on excevator/machine"):SizedBox(),
                const Divider(),
                const SizedBox(
                  height: 5,
                ),

                widget.hiringRequest.operatorUid == appUser.uid
                    ? ListTile(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(
                                width: 0.5, color: Colors.orange)),
                        title: const Text("Hirer Profile"),
                        subtitle: Text(widget.sender.name.toUpperCase()),
                        leading: widget.sender.profileUrl != null
                            ? CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(
                                    widget.sender.profileUrl.toString()),
                              )
                            : CircleAvatar(
                                child: Text(widget.sender.name[0]),
                              ),
                        trailing: const Icon(Icons.arrow_forward_ios_outlined),
                        onTap: () {
                          UserModel user = widget.sender;
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ProfileScreen(
                                    person: user,
                                  )));
                        },
                      )
                    : Builder(builder: (context) {
                        UserModel owner = context
                            .read<MachineryRegistrationController>()
                            .allUsers!
                            .firstWhere((temp) =>
                                widget.hiringRequest.operatorUid == temp.uid);
                        return ListTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: const BorderSide(
                                  width: 0.5, color: Colors.orange)),
                          title: const Text("Operator Profile"),
                          subtitle: Text(owner.name.toUpperCase()),
                          leading: owner.profileUrl != null
                              ? CircleAvatar(
                                  backgroundImage: CachedNetworkImageProvider(
                                      owner.profileUrl.toString()),
                                )
                              : CircleAvatar(
                                  child: Text(owner.name[0]),
                                ),
                          trailing:
                              const Icon(Icons.arrow_forward_ios_outlined),
                          onTap: () {
                            UserModel user = owner;
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ProfileScreen(
                                      person: user,
                                    )));
                          },
                        );
                      }),
                const SizedBox(
                  height: 5,
                ),
                const Divider(),
                const SizedBox(
                  height: 5,
                ),
                // Displaying Operator details
                ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(width: 0.5, color: Colors.orange)),
                  title: const Text("Operator Details"),
                  subtitle: Text(widget.operatorModel.name.toUpperCase()),
                  leading: widget.operatorModel.operatorImage != null
                      ? CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(
                              widget.operatorModel.operatorImage!),
                        )
                      : CircleAvatar(
                          child: Text(widget.operatorModel.name[0]),
                        ),
                  trailing: const Icon(Icons.arrow_forward_ios_outlined),
                  onTap: () {
                    // UserModel user = sender;
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => OperatorDetailsScreen(
                              operator: widget.operatorModel,
                              status: widget.hiringRequest.status,
                            )));
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                value.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : widget.hiringRequest.hirerUserId !=
                            context.read<AuthController>().appUser!.uid
                        ? widget.hiringRequest.status == "Accepted" ||
                                widget.hiringRequest.status == "Rejected" ||
                                widget.hiringRequest.status ==
                                    "Hiring Completed" ||
                                widget.operatorModel.isHired == true ||
                                widget.hiringRequest.status == 'Job Ended'
                            ? const SizedBox()
                            : columnButtonAcceptReject(
                                request: widget.hiringRequest,
                                context: context,
                                op: widget.operatorModel,
                                value: value)
                        : const SizedBox(),
                const SizedBox(
                  height: 10,
                ),
               widget.hiringRequest.status == "Accepted" &&
                            widget.hiringRequest.hirerUserId == appUser.uid &&
                            widget.operatorModel.isHired != true
                        ? OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: isDark!
                                    ? Colors.white
                                    : AppColors.accentColor,
                                width: 0.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            onPressed: () async {
                              bool? confirmed =
                                  await _showConfirmationDialog(context);
                              if (confirmed!) {
                                UserModel? appUser =
                                    context.read<AuthController>().appUser;

                                OperatorModel operator = context
                                    .read<OperatorRegistrationController>()
                                    .allOperators
                                    .firstWhere((temp) =>
                                        widget.hiringRequest.operatorId ==
                                        temp.operatorId);

                                UserModel otherUser = context
                                    .read<MachineryRegistrationController>()
                                    .allUsers!
                                    .firstWhere((temp) =>
                                        widget.hiringRequest.hirerUserId ==
                                        temp.uid);
                                await context
                                    .read<RequestController>()
                                    .requestComplete(
                                        widget.hiringRequest.requestId,
                                        widget.hiringRequest.hirerUserId,
                                        "Hiring Completed",
                                        'operator_hiring_sent',
                                       );
                                await context
                                    .read<RequestController>()
                                    .requestComplete(
                                        widget.hiringRequest.requestId,
                                        widget.hiringRequest.operatorUid,
                                        "Hiring Completed",
                                        'operator_hiring_received',
                                       );
                                // operator.isHired = true;
                                operator.isAvailable = false;
                                operator.isHired = true;
                                await context
                                    .read<OperatorRegistrationController>()
                                    .updateFullOperator(operator: operator);
                                HiringRecordForOperator
                                    hiringRecordForOperator =
                                    HiringRecordForOperator(
                                  hirerUid: widget.hiringRequest.hirerUserId,
                                  requestId: widget.hiringRequest.requestId,
                                  startDate: Timestamp.now(),
                                  // endDate: Timestamp.now(),
                                );

                                await context
                                    .read<OperatorRegistrationController>()
                                    .hiringRecordForOperatorAndHirer(
                                        operator.operatorId,
                                        hiringRecordForOperator);

                                // widget.hiringRequest.operatorUid == appUser!.uid
                                //     ? showCustomRatingDialog(
                                //         context: context,
                                //         requestId: widget.hiringRequest.requestId,
                                //         user: otherUser,
                                //         isHiring: true)
                                //     : showCustomRatingDialog(
                                //         context: context,
                                //         requestId: widget.hiringRequest.requestId,
                                //         operator: operator);
                              } else {
                                dev.log(confirmed.toString());
                              }

                              setState(() {});
                            },
                            child: Text(
                              'Confirm Hire',
                              style: TextStyle(
                                color: isDark! ? null : AppColors.blackColor,
                              ),
                            ),
                          )
                        : Container(),
                widget.hiringRequest.status == "Accepted" &&
                            widget.hiringRequest.hirerUserId == appUser.uid &&
                            widget.operatorModel.isHired != true
                        ? OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white),
                            onPressed: () async {
                              await showRejectionDialog(context,
                                  request: widget.hiringRequest,
                                  value: value,
                                  uid: widget.hiringRequest.operatorUid);
                              // NotificationMethod notificationMethod =
                              //     NotificationMethod();
                              // widget.hiringRequest.status = "Rejected";
                              // await value.updateOperatorRequest(
                              //     request: widget.hiringRequest);
                              // UserModel user = context
                              //     .read<MachineryRegistrationController>()
                              //     .getUser(widget.hiringRequest.hirerUserId);

                              // notificationMethod.sendNotification(
                              //     fcm: user.fcm.toString(),
                              //     title: "Rejected",
                              //     body: "Hirer Offer Rejected",
                              //     type: "rejection");
                              // // Handle Reject action here
                              // print('Rejected');
                              Future.delayed(const Duration(seconds: 3), () {
                                setState(() {});
                              });
                            },
                            child: const Text("Rejected"))
                        : const SizedBox()
              ],
            ),
          );
        }
      }),
    );
  }

  Future<bool?> _showConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text(
              'Do you want to complete the hiring process interview/try passed?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // No, do not complete hiring
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Yes, complete hiring
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailTileForStatusAndRequestDate(String title1, String value1,
      String title2, String value2, HiringRequestModel hiringRequestModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildDetailColumn(title1, value1),
        const VerticalDivider(
          color: Colors.blueAccent,
          thickness: 1.2,
        ),
        GestureDetector(
            onTap: () {
              title2 =="Messages"?
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return MessagesScreen(
                  hiringRequestModel: hiringRequestModel,

                );
              })):null;
            },
            child: _buildDetailColumn(title2, value2)),
      ],
    );
  }

  Widget _buildDetailColumn(String title, String value) {
    return Container(
      width: screenWidth(context) * 0.4,
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(width: 0.5, color: Colors.orange)),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 15),
          Builder(builder: (context) {
            String temp;
            value == "Hiring Completed" ? temp = "Completed" : temp = value;
            return Text(
              temp,
              style: TextStyle(
                  fontSize: 14,
                  color: getStatusColor(status: value, isDark: isDark)),
            );
          }),
        ],
      ),
    );
  }

  // Widget _buildDetailTile(String title, String content) {
  //   return Padding(
  //     padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
  //     child: ListTile(

  //       shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(20),
  //           side: const BorderSide(width: 0.5, color: Colors.orange)),
  //       title: Text(title),
  //       subtitle: Text(content, textAlign: TextAlign.justify),
  //     ),
  //   );
  // }
  Widget _buildDetailTile(String title, String content, {bool? isHirer}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Material(
        // Wrap with Material to use InkWell
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(width: 0.5, color: Colors.orange),
        ),
        // color: Colors.transparent, // Ensure the material doesn't impose its own color
        child: Padding(
          padding: title == "Notes" ||
                  title == "Invitation for Interview/try" ||
                  title == "Purpose" ||
                  title == "Payment Details"
              ? const EdgeInsets.only(top: 15.0, bottom: 15)
              : const EdgeInsets.all(0),
          child: ListTile(
            title: Text(title),
            subtitle: SelectableText(content, textAlign: TextAlign.justify),
            trailing: title == "Payment Details" && isHirer == true
                ? const Icon(Icons.edit_note_outlined)
                : null,
          ),
        ),
      ),
    );
  }

  Widget _buildOperatorImageContainer(String? imageUrl) {
    return Container(
      //padding: EdgeInsets.only(bottom: 16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orange, width: 0.5),
        image: imageUrl != null
            ? DecorationImage(
                image: CachedNetworkImageProvider(imageUrl),
                fit: BoxFit.cover,
              )
            : null,
      ),
      height: 200, // Adjust height according to your needs
      child: imageUrl == null
          ? const Center(child: Text("No Image Available"))
          : null,
    );
  }

  Widget _buildDateColumn(String title, String date, IconData icon) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(
          height: 10,
        ),
        Icon(icon, color: Colors.orange, size: 24),
        const SizedBox(
          height: 5,
        ),
        Text(
          date.substring(0, min(10, date.length)),
          style: TextStyle(
              fontSize: 14, color: isDark! ? Colors.white60 : Colors.black54),
        ),
      ],
    );
  }

  // Function to show the acceptance dialog
  Future<void> showAcceptanceDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Accept Request'),
          content: const Text(
              'The operator will be hidden from public view. Continue?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Implement the logic for accepting the request and hiding the operator
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

// // Function to show the rejection dialog
//   Future<void> showRejectionDialog(BuildContext context) async {
//     return showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Reject Request'),
//           content: Text('Are you sure you want to reject this request?'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 // Implement the logic for rejecting the request
//               },
//               child: Text('Yes'),
//             ),
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text('No'),
//             ),
//           ],
//         );
//       },
//     );
//   }

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
}

// import 'package:flutter/material.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:vehicle_management_and_booking_system/models/operator_model.dart';
// import 'package:vehicle_management_and_booking_system/models/operator_request_model.dart';
// import 'package:vehicle_management_and_booking_system/screens/common/profile_screen.dart';
// import 'package:vehicle_management_and_booking_system/screens/login_signup/model/user_model.dart';
// import 'package:vehicle_management_and_booking_system/screens/operator/operator_details.dart';
// //... [Your other imports]

// class RequestDetailsScreen extends StatelessWidget {
//   final HiringRequest hiringRequest;
//   final OperatorModel operatorModel;
//   final UserModel sender;

//   const RequestDetailsScreen({
//     required this.hiringRequest,
//     required this.operatorModel,
//     required this.sender,
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Request Details"),
//         backgroundColor: Colors.blueAccent,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView(
//           children: [
//             _buildProfileSection(
//               "Sender Details",
//               sender.name,
//               sender.profileUrl,
//               () {
//                 Navigator.of(context).push(MaterialPageRoute(
//                     builder: (context) => ProfileScreen(person: sender)));
//               },
//             ),
//             const SizedBox(height: 20),
//             _buildProfileSection(
//               "Operator Details",
//               operatorModel.name,
//               operatorModel.operatorImage,
//               () {
//                 Navigator.of(context).push(MaterialPageRoute(
//                     builder: (context) =>
//                         OperatorDetailsScreen(operator: operatorModel)));
//               },
//             ),
//             const SizedBox(height: 20),
//             _buildInfoCard("Start Date", hiringRequest.startDate, Icons.date_range),
//             _buildInfoCard("End Date", hiringRequest.endDate, Icons.date_range),
//             _buildInfoCard("Purpose", hiringRequest.purpose, Icons.event_note),
//             _buildInfoCard("Payment Details", hiringRequest.paymentDetails, Icons.payment),
//             _buildInfoCard("Notes", hiringRequest.notes, Icons.note),
//             _buildInfoCard("Status", hiringRequest.status, Icons.verified),
//             _buildInfoCard("Request Date", hiringRequest.requestDate.toString(), Icons.calendar_today),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildProfileSection(String title, String subtitle, String? imageUrl, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(10),
//         decoration: BoxDecoration(
//           color: Colors.grey,
//           // gradient:  LinearGradient(
//           //   colors: [Colors.orange, Colors.orange.shade100],
//           // ),
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Row(
//           children: [
//             imageUrl != null
//                 ? CircleAvatar(
//                     radius: 40,
//                     backgroundImage: CachedNetworkImageProvider(imageUrl),
//                   )
//                 : CircleAvatar(
//                     radius: 40,
//                     child: Text(subtitle[0]),
//                     backgroundColor: Colors.white,
//                     foregroundColor: Colors.blueAccent,
//                   ),
//             const SizedBox(width: 10),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 4),
//                 Text(subtitle, style: const TextStyle(color: Colors.white70)),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Card _buildInfoCard(String title, String subtitle, IconData icon) {
//     return Card(
//       elevation: 2.0,
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       child: ListTile(
//         title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
//         subtitle: Text(
//           subtitle,
//           textAlign: TextAlign.justify,
//         ),
//         leading: Icon(icon, color: Colors.blueAccent),
//       ),
//     );
//   }
// }




// import 'package:flutter/material.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:vehicle_management_and_booking_system/models/operator_model.dart';
// import 'package:vehicle_management_and_booking_system/models/operator_request_model.dart';
// import 'package:vehicle_management_and_booking_system/screens/common/profile_screen.dart';
// import 'package:vehicle_management_and_booking_system/screens/login_signup/model/user_model.dart';
// import 'package:vehicle_management_and_booking_system/screens/operator/operator_details.dart';

// class RequestDetailsScreen extends StatelessWidget {
//   final HiringRequest hiringRequest;
//   final OperatorModel operatorModel;
//   final UserModel sender;

//   const RequestDetailsScreen({
//     required this.hiringRequest,
//     required this.operatorModel,
//     required this.sender,
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Request Details"),
//         backgroundColor: Colors.blueAccent,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView(
//           children: [
//             _buildDetailCard(
//               context,
//               "Sender Details",
//               sender.name,
//               sender.profileUrl,
//               () {
//                 Navigator.of(context).push(MaterialPageRoute(
//                     builder: (context) => ProfileScreen(person: sender)));
//               },
//             ),
//             SizedBox(height: 20),
//             _buildDetailCard(
//               context,
//               "Operator Details",
//               operatorModel.name,
//               operatorModel.operatorImage,
//               () {
//                 Navigator.of(context).push(MaterialPageRoute(
//                     builder: (context) =>
//                         OperatorDetailsScreen(operator: operatorModel)));
//               },
//             ),
//             SizedBox(height: 20),
//             _buildInfoCard("Start Date", hiringRequest.startDate),
//             _buildInfoCard("End Date", hiringRequest.endDate),
//             _buildInfoCard("Purpose", hiringRequest.purpose),
//             _buildInfoCard("Payment Details", hiringRequest.paymentDetails),
//             _buildInfoCard("Notes", hiringRequest.notes),
//             _buildInfoCard("Status", hiringRequest.status),
//             _buildInfoCard(
//                 "Request Date", hiringRequest.requestDate.toString()),
//           ],
//         ),
//       ),
//     );
//   }

//   Card _buildDetailCard(BuildContext context, String title, String subtitle,
//       String? imageUrl, VoidCallback onTap) {
//     return Card(
//       elevation: 4.0,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       child: ListTile(
//         title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
//         subtitle: Text(subtitle),
//         leading: imageUrl != null
//             ? CircleAvatar(
//                 backgroundImage: CachedNetworkImageProvider(imageUrl),
//               )
//             : CircleAvatar(
//                 child: Text(subtitle[0]),
//                 backgroundColor: Colors.blueAccent,
//               ),
//         onTap: onTap,
//       ),
//     );
//   }

//   Card _buildInfoCard(String title, String subtitle) {
//     return Card(
//       elevation: 2.0,
//       margin: EdgeInsets.symmetric(vertical: 8),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       child: ListTile(
//         title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
//         subtitle: Text(
//           subtitle,
//           textAlign: TextAlign.justify,
//         ),
//       ),
//     );
//   }

  
// }
