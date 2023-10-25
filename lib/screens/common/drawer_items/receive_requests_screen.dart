import 'dart:developer' as dev;
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/machinery_register_controller.dart';
import 'package:vehicle_management_and_booking_system/common/helper.dart';
import 'package:vehicle_management_and_booking_system/models/request_machiery_model.dart';
import 'package:vehicle_management_and_booking_system/screens/common/widgets/show_alert.dart';
import 'package:vehicle_management_and_booking_system/utils/const.dart';
import 'package:vehicle_management_and_booking_system/utils/media_query.dart';

class ReceivedRequestsScreen extends StatefulWidget {
  final String receiverUid;

  ReceivedRequestsScreen({required this.receiverUid});

  @override
  State<ReceivedRequestsScreen> createState() => _ReceivedRequestsScreenState();
}

class _ReceivedRequestsScreenState extends State<ReceivedRequestsScreen> {
  List allRequests = [];
  bool isVissible = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<RequestModel>> getReceivedRequests(String receiverUid) {
    return _firestore
        .collection('users')
        .doc(receiverUid)
        .collection('received_requests')
        .orderBy('dateAdded', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return RequestModel.fromMap(doc.data());
      }).toList();
    });
  }

  Future<void> _load() async {
    //log(allRequests.length.toString());
    for (var request in allRequests) {
      // log(request.requestId.toString());
      // log(request.senderUid.toString());
      var dateDifference =
          DateTime.now().difference(request.dateAdded.toDate());
      if (dateDifference.inHours >= 2 && request.status == null) {
        try {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(
                  request.senderUid.toString()) // Replace with the sender's uid
              .collection('sent_requests')
              .doc(request.requestId.toString())
              .update({'status': 'Time Out'});

          // Update status in receiver's sub-collection
          await FirebaseFirestore.instance
              .collection('users')
              .doc(request.machineryOwnerUid
                  .toString()) // Replace with the receiver's uid
              .collection('received_requests')
              .doc(request.requestId.toString())
              .update({'status': 'Time Out'});
          isVissible = true;
          setState(() {});
        } catch (e) {
          print('Failed to update status: $e');
          isVissible = true;
          setState(() {});
          // Optionally, handle the exception further based on your needs.
        }
      }
    }
    isVissible = true;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(const Duration(seconds: 3), () {
        _load();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = ConstantHelper.darkOrBright(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Received Requests'),
      ),
      body: StreamBuilder<List<RequestModel>>(
        stream: getReceivedRequests(widget.receiverUid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<RequestModel> requests = snapshot.data!;
            allRequests = requests;
            return ListView.builder(
              itemCount: requests.length,
              itemBuilder: (context, index) {
                // = context.read<MachineryRegistrationController>().allMachineries.Where((machinery) => machinery.machineryId == requests[index].machineId);

                // ignore: prefer_typing_uninitialized_variables
                var machines;
                // ignore: prefer_typing_uninitialized_variables
                var sender;
                // for (var machine in context
                //     .read<MachineryRegistrationController>()
                //     .allMachineries) {
                //   requests[index].machineId == machine.machineryId
                //       ? machines = machine
                //       : null;
                // }
                // log("message");
                machines = context
                    .read<MachineryRegistrationController>()
                    .allMachineries
                    .firstWhere((machine) =>
                        requests[index].machineId == machine.machineryId);

                sender = context
                    .read<MachineryRegistrationController>()
                    .allUsers
                    .firstWhere(
                        (temp) => requests[index].senderUid == temp.uid);

                // for (var temp in context
                //     .read<MachineryRegistrationController>()
                //     .allUsers) {
                //   requests[index].senderUid == temp.uid ? sender = temp : null;
                // }

                return Card(
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                     // height: screenHeight(context) * 0.46,
                      width: screenWidth(context),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () {
                              showAlert(context,
                                  sender: sender,
                                  machine: machines,
                                  request: requests[index]);
                            },
                            child: Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      sender.profileUrl != null
                                          ? CircleAvatar(
                                              backgroundImage:
                                                  CachedNetworkImageProvider(
                                              // imageUrl:
                                              sender.profileUrl.toString(),
                                              errorListener: () {
                                                dev.log("error");
                                              },
                                            ))
                                          : CircleAvatar(
                                              child: Text(
                                                  sender.name[0].toString())),
                                      Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              sender.name
                                                  .toString()
                                                  .toUpperCase(),
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w800),
                                            ),
                                            Text(
                                              sender.email.length > 24
                                                  ? '${sender.email.substring(0, 24)}...'
                                                  : sender.email,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: isDark
                                                    ? Color.fromARGB(
                                                        255, 167, 160, 160)
                                                    : Colors.black54,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Offer"),
                                      Text("Rs.${requests[index].price}/h"),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          Divider(
                            thickness: 1,
                          ),
                          Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: screenHeight(context) * 0.2,
                                  width: screenWidth(context) * 0.4,
                                  child: Card(
                                      child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      machines.images.last.toString(),
                                      fit: BoxFit.cover,
                                    ),
                                  )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0, top: 0, bottom: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Builder(builder: (context) {
                                        String temp = machines.title;
                                        String _title = temp.length > 11
                                            ? "${temp.substring(0, min(11, temp.length))}..."
                                            : temp;
                                        return Text(
                                          //"Islamabad",
                                          _title,

                                          // widget.machineryDetails.address, overflow: TextOverflow.ellipsis,maxLines: 1,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontFamily: "Quantico",
                                            // color: Colors.black,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        );
                                      }),
                                      // Text(
                                      //   machines.title
                                      //       .toUpperCase()
                                      //       .toString(),
                                      //   overflow: TextOverflow.ellipsis,
                                      //   maxLines: 1,
                                      //   style: const TextStyle(
                                      //     fontSize: 18,
                                      //     fontFamily: "Quantico",
                                      //     // color: Colors.black,
                                      //     fontWeight: FontWeight.w800,
                                      //   ),
                                      // ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        "Charges",
                                        style: TextStyle(
                                            color: isDark
                                                ? Colors.white70
                                                : Colors.grey,
                                            fontSize: 12),
                                      ),
                                      Text(
                                        machines.charges.toString(),
                                        style: TextStyle(
                                          color: isDark
                                              ? Colors.white
                                              : Color.fromARGB(255, 84, 84, 84),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        "Size",
                                        style: TextStyle(
                                            color: isDark
                                                ? Colors.white70
                                                : Colors.grey,
                                            fontSize: 12),
                                      ),
                                      Text(
                                        "${machines.rating}/5",
                                        style: TextStyle(
                                          color: isDark
                                              ? Colors.white
                                              : Color.fromARGB(255, 84, 84, 84),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                        ),
                                      ),

                                      //requests[index].status ==null&& dateDifference.inHours >= 2? :

                                      requests[index].status == null
                                          ? Visibility(
                                              visible: isVissible,
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  OutlinedButton(
                                                    child: Text(
                                                      'Cancel',
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ),
                                                    onPressed: () async {
                                                      // Handle cancellation here
                                                      try {
                                                        // Get the id of the request
                                                        var requestId =
                                                            requests[index]
                                                                .requestId;

                                                        // Update status in sender's sub-collection
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection('users')
                                                            .doc(requests[index]
                                                                .senderUid) // Replace with the sender's uid
                                                            .collection(
                                                                'sent_requests')
                                                            .doc(requestId)
                                                            .update({
                                                          'status': 'Canceled'
                                                        });

                                                        // Update status in receiver's sub-collection
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection('users')
                                                            .doc(requests[index]
                                                                .machineryOwnerUid) // Replace with the receiver's uid
                                                            .collection(
                                                                'received_requests')
                                                            .doc(requestId)
                                                            .update({
                                                          'status': 'Canceled'
                                                        });
                                                      } catch (e) {
                                                        // Handle any errors that might occur
                                                        print(e);
                                                      }
                                                    },
                                                  ),
                                                  SizedBox(
                                                      width:
                                                          10), // Add some spacing between the buttons
                                                  OutlinedButton(
                                                    child: Text(
                                                      'Accept',
                                                      style: TextStyle(
                                                          color: Colors.blue),
                                                    ),
                                                    onPressed: () async {
                                                      // Handle cancellation here
                                                      try {
                                                        // Get the id of the request
                                                        var requestId =
                                                            requests[index]
                                                                .requestId;

                                                        // Update status in sender's sub-collection
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection('users')
                                                            .doc(requests[index]
                                                                .senderUid) // Replace with the sender's uid
                                                            .collection(
                                                                'sent_requests')
                                                            .doc(requestId)
                                                            .update({
                                                          'status': 'Accepted'
                                                        });

                                                        // Update status in receiver's sub-collection
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection('users')
                                                            .doc(requests[index]
                                                                .machineryOwnerUid) // Replace with the receiver's uid
                                                            .collection(
                                                                'received_requests')
                                                            .doc(requestId)
                                                            .update({
                                                          'status': 'Accepted'
                                                        });
                                                      } catch (e) {
                                                        // Handle any errors that might occur
                                                        print(e);
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),
                                            )
                                          : SizedBox(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                                  padding: const EdgeInsets.only(left:  8.0,),
                                  child: Text(
                                    "Total number of work hours: ${requests[index].workOfHours}/hrs.",
                                    style: TextStyle(
                                      color: isDark
                                          ? Color.fromARGB(255, 183, 178, 178)
                                          : Colors.black45,
                                    ),
                                  ),
                                ),
                             
                                requests[index].status == null?SizedBox()
                              : OutlinedButton(
                                  onPressed: () {},
                                  child: Text(
                                    requests[index]
                                        .status!
                                        .toUpperCase()
                                        .toString(),
                                    style: TextStyle(
                                      color: requests[index].status ==
                                              'Canceled'
                                          ? Colors.red
                                          : requests[index].status == 'Accepted'
                                              ? Colors.blue
                                              : Colors.orange,
                                    ),
                                  ),
                                ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Builder(builder: (context) {
                                Color textColor;
                                var dateDifference = DateTime.now().difference(
                                    requests[index].dateAdded.toDate());

                                switch (requests[index].status) {
                                  case 'Accepted':
                                    textColor = Colors.blue;
                                    break;
                                  case 'Canceled':
                                    textColor = Colors.red;
                                    break;
                                  case 'Time Out':
                                    textColor = Colors.orange;
                                    break;
                                  default:
                                    textColor = (dateDifference.inHours >= 2)
                                        ? Colors.red
                                        : Colors.green;
                                    break;
                                }

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      ConstantHelper.timeAgo(requests[index].dateAdded.toDate()),
                                      style: TextStyle(color: textColor),
                                    ),
                                     Text(
                                      Helper.getFormattedDateTime(requests[index].dateAdded.toDate()),
                                      style: TextStyle(color: textColor),
                                    ),
                                  ],
                                );
                              })
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
