// ignore_for_file: use_build_context_synchronously

import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_management_and_booking_system/app/app.dart';
import 'package:vehicle_management_and_booking_system/authentication/controllers/auth_controller.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/machinery_register_controller.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/request_controller.dart';
import 'package:vehicle_management_and_booking_system/models/machinery_model.dart';
import 'package:vehicle_management_and_booking_system/models/request_machiery_model.dart';
import 'package:vehicle_management_and_booking_system/screens/common/drawer_items/operator_requests.dart';
import 'package:vehicle_management_and_booking_system/screens/common/drawer_items/drawer_screens/report_screen.dart';
import 'package:vehicle_management_and_booking_system/screens/common/messages_screen.dart';
import 'package:vehicle_management_and_booking_system/screens/common/profile_screen.dart';
import 'package:vehicle_management_and_booking_system/screens/common/widgets/show_alert.dart';
import 'package:vehicle_management_and_booking_system/screens/login_signup/model/user_model.dart';
import 'package:vehicle_management_and_booking_system/screens/machinery/machinery_detials.dart';
import 'package:vehicle_management_and_booking_system/screens/machinery/widgets/show_custom_rating_dialog.dart';
import 'package:vehicle_management_and_booking_system/utils/app_colors.dart';
import 'package:vehicle_management_and_booking_system/utils/const.dart';
import 'package:vehicle_management_and_booking_system/utils/media_query.dart';
import 'dart:developer' as dev;

class SentRequestsScreen extends StatefulWidget {
  SentRequestsScreen({this.isOperater, this.isNotifications});

  bool? isOperater;
  bool? isNotifications;
  @override
  State<SentRequestsScreen> createState() => _SentRequestsScreenState();
}

class _SentRequestsScreenState extends State<SentRequestsScreen> {
  List<RequestModelForMachieries> allRequests = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var uid;

  Stream<List<RequestModelForMachieries>> getSentRequests(String senderUid) {
    return _firestore
        .collection('users')
        .doc(senderUid)
        .collection('sent_requests')
        .orderBy('dateAdded', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return RequestModelForMachieries.fromMap(doc.data());
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

  @override
  void initState() {
    // TODO: implement initState
    uid = context.read<AuthController>().appUser!.uid;
    // if (widget.isOperater != null) {
    //   context
    //       .read<RequestController>()
    //       .updateIsMachineryFavoritesScreen(value: widget.isOperater!);
    // }

    // allRequests = context.read<MachineryRegistrationController>().allRequests!;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Future.delayed(const Duration(seconds: 1), () async {
        if (mounted) {
          await context
              .read<RequestController>()
              .checkForTimeOut(allRequests: allRequests);
        }
        // await context.read<RequestController>().checkActiveRequest(context);
      });

      //  context.read<MachineryRegistrationController>().getAllMachineries();
      if (widget.isOperater != null) {
        context
            .read<RequestController>()
            .updateIsMachineryFavoritesScreen(value: widget.isOperater!);
      }
      if (widget.isNotifications == true) {
        await context
            .read<MachineryRegistrationController>()
            .getAllMachineries();
        await context.read<MachineryRegistrationController>().getAllRequests();
        await context.read<MachineryRegistrationController>().fetchAllUsers();
        await context.read<RequestController>().checkActiveRequest(context);
        setState(() {
          widget.isNotifications = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = ConstantHelper.darkOrBright(context);

    if (widget.isNotifications == true) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Sent Requests",
          style: TextStyle(color: isDark ? null : Colors.black),
        ),
        backgroundColor: isDark ? null : AppColors.accentColor,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              navigatorKey.currentState!.pop();
            },
            icon: Icon(
              Icons.arrow_back_ios_new_sharp,
              color: isDark ? null : AppColors.blackColor,
            )),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  context
                      .read<RequestController>()
                      .updateIsMachineryFavoritesScreen(value: true);
                  setState(() {});
                },
                child: Container(
                  height: 43,
                  width: screenWidth(context) * 0.5,
                  color: context
                          .read<RequestController>()
                          .isMachineryFavoritesScreen
                      ? const Color.fromARGB(255, 193, 190, 190)
                      : null,
                  child: Center(
                      child: Text(
                    "Machineries",
                    style: GoogleFonts.quantico(fontWeight: FontWeight.w600),
                  )),
                ),
              ),
              GestureDetector(
                onTap: () {
                  context
                      .read<RequestController>()
                      .updateIsMachineryFavoritesScreen(value: false);
                  setState(() {});
                },
                child: Container(
                  height: 40,
                  width: screenWidth(context) * 0.5,
                  color: !context
                          .read<RequestController>()
                          .isMachineryFavoritesScreen
                      ? Colors.grey
                      : null,
                  child: Center(
                      child: Text(
                    "Operators",
                    style: GoogleFonts.quantico(fontWeight: FontWeight.w600),
                  )),
                ),
              )
            ],
          ),
          !context.read<RequestController>().isMachineryFavoritesScreen
              ? OperatorRequests(
                  operatorUid: context.read<AuthController>().appUser!.uid,
                  isReceivedScreen: false,
                )
              : Expanded(
                  child: SizedBox(
                    height: screenHeight(context),
                    child: StreamBuilder<List<RequestModelForMachieries>>(
                      stream: getSentRequests(uid),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(
                              child: Text('No Sent requests found.'));
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else {
                          List<RequestModelForMachieries> requests =
                              snapshot.data!;
                          allRequests = requests;
                          return ListView.builder(
                            itemCount: requests.length,
                            itemBuilder: (context, index) {
                              MachineryModel
                                  machines; // = context.read<MachineryRegistrationController>().allMachineries.Where((machinery) => machinery.machineryId == requests[index].machineId);
                              UserModel sender;
                              // dev.log("message");
                              // _machines = context
                              //     .read<MachineryRegistrationController>()
                              //     .allMachineries
                              //     .firstWhere((machine) {
                              //       if(requests[index].machineId == machine.machineryId){
                              //         dev.log(requests[index].machineId);
                              //         dev.log(machine.machineryId);
                              //         return true;
                              //       }
                              //       else{
                              //         dev.log(index.toString());
                              //         return false;
                              //       }
                              //     });

                              // =>
                              //     requests[index].machineId == machine.machineryId);
                              machines = context
                                  .read<MachineryRegistrationController>()
                                  .allMachineries!
                                  .firstWhere((machine) =>
                                      requests[index].machineId ==
                                      machine.machineryId);

                              sender = context
                                  .read<MachineryRegistrationController>()
                                  .allUsers!
                                  .firstWhere((temp) =>
                                      requests[index].machineryOwnerUid ==
                                      temp.uid);

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

                              return GestureDetector(
                                 onLongPress: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ReportScreen(
                                              request: requests[index],
                                            )),
                                  );
                                },
                                child: Card(
                                  elevation: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      // height: screenHeight(context) * 0.42,
                                      width: screenWidth(context),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: ((context) {
                                                return DetalleWidget(
                                                    model: machines);
                                              })));
                                            },
                                            child: Container(
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    height:
                                                        screenHeight(context) *
                                                            0.2,
                                                    width: screenWidth(context) *
                                                        0.4,
                                                    child: Card(
                                                        child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      child: Image.network(
                                                        machines.images!.last
                                                            .toString(),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    )),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 20.0,
                                                            top: 0,
                                                            bottom: 10),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Builder(
                                                            builder: (context) {
                                                          String temp =
                                                              machines.title;
                                                          String title = temp
                                                                      .length >
                                                                  11
                                                              ? "${temp.substring(0, min(11, temp.length))}..."
                                                              : temp;
                                                          return Text(
                                                            //"Islamabad",
                                                            title,
                              
                                                            // widget.machineryDetails.address, overflow: TextOverflow.ellipsis,maxLines: 1,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 18,
                                                              fontFamily:
                                                                  "Quantico",
                                                              // color: Colors.black,
                                                              fontWeight:
                                                                  FontWeight.w800,
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
                                                          machines.charges
                                                              .toString(),
                                                          style: TextStyle(
                                                            color: isDark
                                                                ? Colors.white
                                                                : const Color
                                                                        .fromARGB(
                                                                    255,
                                                                    84,
                                                                    84,
                                                                    84),
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 18,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 15,
                                                        ),
                                                        Text(
                                                          "Rating",
                                                          style: TextStyle(
                                                              color: isDark
                                                                  ? Colors.white70
                                                                  : Colors.grey,
                                                              fontSize: 12),
                                                        ),
                                                        Text(
                                                          "${machines.rating.toStringAsFixed(1)}/5",
                                                          style: TextStyle(
                                                            color: isDark
                                                                ? Colors.white
                                                                : const Color
                                                                        .fromARGB(
                                                                    255,
                                                                    84,
                                                                    84,
                                                                    84),
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 18,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                              
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Builder(builder: (context) {
                                                Color textColor;
                                                Color borderColor;
                                                var status =
                                                    requests[index].status;
                              
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
                                                    textColor = Colors.red;
                                                    borderColor = Colors.red;
                                                    break;
                                                  default:
                                                    textColor = Colors.blue;
                                                    borderColor = Colors.blue;
                                                }
                              
                                                return status == null
                                                    ? OutlinedButton(
                                                        onPressed: null, //() {},
                                                        style: OutlinedButton
                                                            .styleFrom(
                                                          side: BorderSide(
                                                              color: borderColor),
                                                        ),
                                                        child: Text(
                                                          "PENDING ",
                                                          style: TextStyle(
                                                              color: textColor),
                                                        ),
                                                      )
                                                    : OutlinedButton(
                                                        onPressed: requests[index]
                                                                    .comment !=
                                                                ""
                                                            ? () async {
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return AlertDialog(
                                                                      title: Text(
                                                                          "Comment"),
                                                                      content: Text(
                                                                          requests[index]
                                                                              .comment!),
                                                                      actions: <Widget>[
                                                                        TextButton(
                                                                          child: Text(
                                                                              'OK'),
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.of(context)
                                                                                .pop();
                                                                          },
                                                                        ),
                                                                      ],
                                                                    );
                                                                  },
                                                                );
                                                              }
                                                            : null,
                                                        style: OutlinedButton
                                                            .styleFrom(
                                                          side: BorderSide(
                                                              color: borderColor),
                                                        ),
                                                        child: Text(
                                                          status
                                                              .toUpperCase()
                                                              .toString(),
                                                          style: TextStyle(
                                                              color: textColor),
                                                        ),
                                                      );
                                              }),
                                              ElevatedButton(
                                                  onPressed: () {
                                                    log(requests[index]
                                                        .sourcelocation
                                                        .longitude);
                                                    showAlert(context,
                                                        sender: sender,
                                                        machine: machines,
                                                        request: requests[index]);
                                                  },
                                                  child: const Text(
                                                      "View More Details")),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (ctx) {
                                                      return MessagesScreen(
                                                          request:
                                                              requests[index]);
                                                    }));
                                                  },
                                                  child: const Text(
                                                    "Messages",
                                                    style: TextStyle(
                                                        decoration: TextDecoration
                                                            .underline),
                                                  )),
                                              (requests[index].status ==
                                                          "Confirm") ||
                                                      (requests[index].status ==
                                                              "Canceled" &&
                                                          requests[index]
                                                                  .comment !=
                                                              "")
                                                  ? OutlinedButton(
                                                      onPressed: () async {
                                                        // (await context
                                                        //         .read<
                                                        //             MachineryRegistrationController>()
                                                        //         .hasUserRatedMachinery(
                                                        //             uid,
                                                        //             machines
                                                        //                 .machineryId))
                                                        //     ? ScaffoldMessenger
                                                        //             .of(context)
                                                        //         .showSnackBar(
                                                        //             const SnackBar(
                                                        //                 content: Text(
                                                        //                     "Already rated")))
                                                        //     :
                                                        showCustomRatingDialog(
                                                            context: context,
                                                            machine: machines,
                                                            requestId:
                                                                requests[index]
                                                                    .requestId);
                                                      },
                                                      child: const Row(
                                                        children: [
                                                          Text("Work Complete"),
                                                          Icon(
                                                            Icons.done,
                                                            size: 18,
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  : Container(),
                                            ],
                                          ),
                              
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 8.0,
                                            ),
                                            child: Text(
                                              "Total number of work hours: ${requests[index].workOfHours}/hrs.",
                                              style: TextStyle(
                                                color: isDark
                                                    ? const Color.fromARGB(
                                                        255, 183, 178, 178)
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
                                          const Divider(
                                            thickness: 1,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text("To:"),
                                              Text(
                                                ConstantHelper.timeAgo(
                                                    requests[index]
                                                        .dateAdded
                                                        .toDate()),
                                              )
                                            ],
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                return ProfileScreen(
                                                  person: sender,
                                                );
                                              }));
                                              // showAlert(context,
                                              //     sender: sender,
                                              //     machine: machines,
                                              //     request: requests[index]);
                                            },
                                            child: Container(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      sender.profileUrl != null
                                                          ? CircleAvatar(
                                                              backgroundImage:
                                                                  CachedNetworkImageProvider(
                                                              // imageUrl:
                                                              sender.profileUrl
                                                                  .toString(),
                                                         
                                                            ))
                                                          : CircleAvatar(
                                                              child: Text(sender
                                                                  .name[0]
                                                                  .toString())),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets.all(
                                                                15.0),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              sender.name
                                                                  .toString()
                                                                  .toUpperCase(),
                                                              style: const TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                            Text(
                                                              sender.email.length >
                                                                      24
                                                                  ? '${sender.email.substring(0, 24)}...'
                                                                  : sender.email,
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                color: isDark
                                                                    ? const Color
                                                                            .fromARGB(
                                                                        255,
                                                                        167,
                                                                        160,
                                                                        160)
                                                                    : Colors
                                                                        .black54,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      const Text("Offer"),
                                                      Text(
                                                          "Rs.${requests[index].price}/h"),
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
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
