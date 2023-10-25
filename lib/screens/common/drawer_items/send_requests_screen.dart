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
import 'dart:developer' as dev;

class SentRequestsScreen extends StatefulWidget {
  final String senderUid;

  SentRequestsScreen({required this.senderUid});

  @override
  State<SentRequestsScreen> createState() => _SentRequestsScreenState();
}

class _SentRequestsScreenState extends State<SentRequestsScreen> {
  List allRequests = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<RequestModel>> getSentRequests(String senderUid) {
    return _firestore
        .collection('users')
        .doc(senderUid)
        .collection('sent_requests')
        .orderBy('dateAdded', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return RequestModel.fromMap(doc.data());
      }).toList();
    });
  }

  Color getColorFromStatus(String status) {
    switch (status) {
      case 'accepted':
        return Colors.green; // Green indicates success or positive action
      case 'canceled':
        return Colors.red; // Red is often associated with stopping or errors
      case 'pending':
        return Colors.orange; // Orange is for waiting or pending action
      case 'timeout':
        return Colors
            .grey; // Grey indicates disabled, incomplete or terminated status
      default:
        return Colors
            .blue; // Blue can be a general color for neutral information
    }
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

          setState(() {});
        } catch (e) {
          print('Failed to update status: $e');

          setState(() {});
          // Optionally, handle the exception further based on your needs.
        }
      }
    }

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
        title: Text('Sent Requests'),
      ),
      body: StreamBuilder<List<RequestModel>>(
        stream: getSentRequests(widget.senderUid),
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
                var _machines; // = context.read<MachineryRegistrationController>().allMachineries.Where((machinery) => machinery.machineryId == requests[index].machineId);
                var _sender;

                _machines = context
                    .read<MachineryRegistrationController>()
                    .allMachineries
                    .firstWhere((machine) =>
                        requests[index].machineId == machine.machineryId);

                _sender = context
                    .read<MachineryRegistrationController>()
                    .allUsers
                    .firstWhere((temp) =>
                        requests[index].machineryOwnerUid == temp.uid);

                // for (var machine in context
                //     .read<MachineryRegistrationController>()
                //     .allMachineries) {
                //   requests[index].machineId == machine.machineryId
                //       ? machines = machine
                //       : null;
                // }
                // for (var users in context
                //     .read<MachineryRegistrationController>()
                //     .allUsers) {
                //   requests[index].machineryOwnerUid == users.uid
                //       ? user = users
                //       : null;
                // }

                return Card(
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      // height: screenHeight(context) * 0.42,
                      width: screenWidth(context),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
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
                                      _machines.images.last.toString(),
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
                                        String temp = _machines.title;
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
                                        _machines.charges.toString(),
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
                                        "${_machines.rating}/5",
                                        style: TextStyle(
                                          color: isDark
                                              ? Colors.white
                                              : Color.fromARGB(255, 84, 84, 84),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Builder(builder: (context) {
                            Color textColor;
                            Color borderColor;
                            var status = requests[index].status;

                            switch (status) {
                              case 'Accepted':
                                textColor = Colors.blue;
                                borderColor = Colors.blue;
                                break;
                              case 'Canceled':
                                textColor = Colors.red;
                                borderColor = Colors.red;
                                break;
                              case 'Time Out':
                                textColor = Colors.orange;
                                borderColor = Colors.orange;
                                break;
                              default:
                                textColor = Colors.orange;
                                borderColor = Colors.orange;
                            }

                            return status == null
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: OutlinedButton(
                                      onPressed: () {},
                                      child: Text(
                                        "PENDING",
                                        style: TextStyle(color: textColor),
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(color: borderColor),
                                      ),
                                    ),
                                  )
                                : OutlinedButton(
                                    onPressed: () {},
                                    child: Text(
                                      status!.toUpperCase().toString(),
                                      style: TextStyle(color: textColor),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(color: borderColor),
                                    ),
                                  );
                          }),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 8.0,
                            ),
                            child: Text(
                              "Total number of work hours: ${requests[index].workOfHours}/hrs.",
                              style: TextStyle(
                                color: isDark
                                    ? Color.fromARGB(255, 183, 178, 178)
                                    : Colors.black45,
                              ),
                            ),
                          ),
                          // requests[index].status == null
                          //     ? Padding(
                          //         padding: const EdgeInsets.all(8.0),
                          //         child: Text(
                          //           "Pending",
                          //           style: TextStyle(
                          //             color: isDark
                          //                 ? Color.fromARGB(255, 183, 178, 178)
                          //                 : Colors.black45,
                          //           ),
                          //         ),
                          //       )
                          //     : OutlinedButton(
                          //         onPressed: () {},
                          //         child: Text(
                          //           requests[index]
                          //               .status!
                          //               .toUpperCase()
                          //               .toString(),
                          //           style: TextStyle(
                          //             color: requests[index].status ==
                          //                     'Canceled'
                          //                 ? Colors.red
                          //                 : requests[index].status == 'Accepted'
                          //                     ? Colors.blue
                          //                     : Colors.orange,
                          //           ),
                          //         ),
                          //       ),

                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.end,
                          //   children: [
                          //     Builder(builder: (context) {
                          //       Color textColor;
                          //       var dateDifference = DateTime.now().difference(
                          //           requests[index].dateAdded.toDate());

                          //       switch (requests[index].status) {
                          //         case 'Accepted':
                          //           textColor = Colors.blue;
                          //           break;
                          //         case 'Canceled':
                          //           textColor = Colors.red;
                          //           break;
                          //         case 'Time Out':
                          //           textColor = Colors.orange;
                          //           break;
                          //         default:
                          //           textColor = (dateDifference.inHours >= 2)
                          //               ? Colors.red
                          //               : Colors.green;
                          //           break;
                          //       }

                          //       return Text(
                          //         Helper.getFormattedDateTime(
                          //                 requests[index].dateAdded.toDate())
                          //             .toString(),
                          //         style: TextStyle(color: textColor),
                          //       );
                          //     })
                          //   ],
                          // ),
                          Divider(
                            thickness: 1,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("To:"),
                              Text(
                                ConstantHelper.timeAgo(requests[index].dateAdded.toDate()),
                                
                              )
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              showAlert(context,
                                  sender: _sender,
                                  machine: _machines,
                                  request: requests[index]);
                            },
                            child: Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      _sender.profileUrl != null
                                          ? CircleAvatar(
                                              backgroundImage:
                                                  CachedNetworkImageProvider(
                                              // imageUrl:
                                              _sender.profileUrl.toString(),
                                              errorListener: () {
                                                dev.log("error");
                                              },
                                            ))
                                          : CircleAvatar(
                                              child: Text(
                                                  _sender.name[0].toString())),
                                      Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _sender.name
                                                  .toString()
                                                  .toUpperCase(),
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w800),
                                            ),
                                            Text(
                                              _sender.email.length > 24
                                                  ? '${_sender.email.substring(0, 24)}...'
                                                  : _sender.email,
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
