// ignore_for_file: use_build_context_synchronously

import 'dart:developer' as dev;
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_management_and_booking_system/app/app.dart';
import 'package:vehicle_management_and_booking_system/app/router.dart';
import 'package:vehicle_management_and_booking_system/authentication/controllers/auth_controller.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/machinery_register_controller.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/request_controller.dart';
import 'package:vehicle_management_and_booking_system/models/request_machiery_model.dart';
import 'package:vehicle_management_and_booking_system/screens/common/drawer_items/operator_requests.dart';
import 'package:vehicle_management_and_booking_system/screens/common/drawer_items/drawer_screens/report_screen.dart';
import 'package:vehicle_management_and_booking_system/screens/common/messages_screen.dart';
import 'package:vehicle_management_and_booking_system/screens/common/profile_screen.dart';
import 'package:vehicle_management_and_booking_system/screens/common/widgets/show_alert.dart';
import 'package:vehicle_management_and_booking_system/screens/login_signup/model/user_model.dart';
import 'package:vehicle_management_and_booking_system/screens/machinery/widgets/show_custom_rating_dialog.dart';
import 'package:vehicle_management_and_booking_system/utils/app_colors.dart';
import 'package:vehicle_management_and_booking_system/utils/const.dart';
import 'package:vehicle_management_and_booking_system/utils/media_query.dart';
import 'package:vehicle_management_and_booking_system/utils/notification_method.dart';

class ReceivedRequestsScreen extends StatefulWidget {
  ReceivedRequestsScreen({super.key, this.isHiring, this.isNotifications});
  bool? isHiring;
  bool? isNotifications;
  @override
  State<ReceivedRequestsScreen> createState() => _ReceivedRequestsScreenState();
}

class _ReceivedRequestsScreenState extends State<ReceivedRequestsScreen> {
  List<RequestModelForMachieries> allRequests = [];
  bool isVissible = false;
  var uid;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<RequestModelForMachieries>> getReceivedRequests(
      String receiverUid) {
    return _firestore
        .collection('users')
        .doc(receiverUid)
        .collection('received_requests')
        .orderBy('dateAdded', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return RequestModelForMachieries.fromMap(doc.data());
      }).toList();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    uid = context.read<AuthController>().appUser!.uid;

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      try {
        Future.delayed(const Duration(seconds: 1), () async {
          if (mounted) {
            await context
                .read<RequestController>()
                .checkForTimeOut(allRequests: allRequests);
            setState(() {
              isVissible = true;
            });
          }
          //await context.read<RequestController>().checkActiveRequest(context);
        });
        if (widget.isHiring != null) {
          context
              .read<RequestController>()
              .updateIsMachineryFavoritesScreen(value: widget.isHiring!);
        }
        if (widget.isNotifications == true) {
          await context
              .read<MachineryRegistrationController>()
              .getAllMachineries();
          await context
              .read<MachineryRegistrationController>()
              .getAllRequests();
          await context.read<MachineryRegistrationController>().fetchAllUsers();
          await context.read<RequestController>().checkActiveRequest(context);
          setState(() {
            widget.isNotifications = false;
          });
        }
      } catch (e) {
        dev.log(e.toString());
      }
    });
  }

  Future<void> updateRequestStatus(
      BuildContext context,
      RequestModelForMachieries request,
      Position position,
      String status) async {
    await context
        .read<RequestController>()
        .updateRequest(request: request, position: position, status: status);
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
          "Notifications",
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
                  isReceivedScreen: true,
                )
              : Expanded(
                  child: Container(
                    height: screenHeight(context),
                    child: StreamBuilder<List<RequestModelForMachieries>>(
                      stream: getReceivedRequests(uid),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(
                              child: Text('No Received requests found.'));
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
                                  .allMachineries!
                                  .firstWhere((machine) =>
                                      requests[index].machineId ==
                                      machine.machineryId);

                              sender = context
                                  .read<MachineryRegistrationController>()
                                  .allUsers!
                                  .firstWhere((temp) =>
                                      requests[index].senderUid == temp.uid);

                              // for (var temp in context
                              //     .read<MachineryRegistrationController>()
                              //     .allUsers) {
                              //   requests[index].senderUid == temp.uid ? sender = temp : null;
                              // }

                              return GestureDetector(
                                // onTap: (){
                                // dev.log(requests[index].requestId);
                                // },
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
                                      // height: screenHeight(context) * 0.46,
                                      width: screenWidth(context),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                return ProfileScreen(
                                                  person: sender,
                                                );
                                              }));
                                              // log(requests[index].sourcelocation.longitude);
                                              // showAlert(context,
                                              //     sender: sender,
                                              //     machine: machines,
                                              //     request: requests[index]);
                                            },
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
                                                                  : Colors.grey,
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
                                          const Divider(
                                            thickness: 1,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pushNamed(
                                                  context,
                                                  AppRouter
                                                      .machineryDetailsPage,
                                                  arguments: machines);
                                              // Navigator.of(context)
                                              //     .push(MaterialPageRoute(builder: ((context) {
                                              //   return DetalleWidget(model: machines);
                                              // })));
                                            },
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  mainAxisSize: MainAxisSize.min,
                                              children: [
                                                SizedBox(
                                                  height:
                                                      screenHeight(context) *
                                                          0.2,
                                                  width:
                                                      screenWidth(context) *
                                                          0.39,
                                                  child: Card(
                                                      child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: Image.network(
                                                      machines.images.last
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
                                                        MainAxisAlignment
                                                            .start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Builder(
                                                          builder: (context) {
                                                        String temp =
                                                            machines.title;
                                                        String _title = temp
                                                                    .length >
                                                                11
                                                            ? "${temp.substring(0, min(11, temp.length))}..."
                                                            : temp;
                                                        return Text(
                                                          //"Islamabad",
                                                          _title
                                                              .toUpperCase(),
                                            
                                                          // widget.machineryDetails.address, overflow: TextOverflow.ellipsis,maxLines: 1,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 18,
                                                            fontFamily:
                                                                "Quantico",
                                                            // color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w800,
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
                                                                ? Colors
                                                                    .white70
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
                                                                ? Colors
                                                                    .white70
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

                                                      //requests[index].status ==null&& dateDifference.inHours >= 2? :
                                            
                                                      requests[index]
                                                                  .status ==
                                                              null
                                                          ? Visibility(
                                                              visible:
                                                                  isVissible,
                                                              child: Wrap(
                                                                // mainAxisSize:
                                                                //     MainAxisSize
                                                                //         .min,
                                                                children: [
                                                                  OutlinedButton(
                                                                    child:
                                                                        const Text(
                                                                      'Cancel',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.red),
                                                                    ),
                                                                    onPressed:
                                                                        () async {
                                                                      // Handle cancellation here
                                                                      try {
                                                                        // Get the id of the request
                                                                        var requestId =
                                                                            requests[index].requestId;
                                            
                                                                        // Update status in sender's sub-collection
                                                                        await FirebaseFirestore
                                                                            .instance
                                                                            .collection(
                                                                                'users')
                                                                            .doc(requests[index]
                                                                                .senderUid) // Replace with the sender's uid
                                                                            .collection(
                                                                                'sent_requests')
                                                                            .doc(
                                                                                requestId)
                                                                            .update({
                                                                          'status':
                                                                              'Canceled'
                                                                        });
                                            
                                                                        // Update status in receiver's sub-collection
                                                                        await FirebaseFirestore
                                                                            .instance
                                                                            .collection(
                                                                                'users')
                                                                            .doc(requests[index]
                                                                                .machineryOwnerUid) // Replace with the receiver's uid
                                                                            .collection(
                                                                                'received_requests')
                                                                            .doc(
                                                                                requestId)
                                                                            .update({
                                                                          'status':
                                                                              'Canceled'
                                                                        });
                                            
                                                                        await FirebaseFirestore
                                                                            .instance
                                                                            .collection(
                                                                                'machinery_requests')
                                                                            .doc(requests[index]
                                                                                .requestId) // Replace with the request's uid
                                                                            .update({
                                                                          'status':
                                                                              'Canceled'
                                                                        });
                                            
                                                                        final UserModel
                                                                            user =
                                                                            context.read<MachineryRegistrationController>().getUser(requests[index].senderUid);
                                            
                                                                        final notificationMethod =
                                                                            NotificationMethod();
                                                                        await notificationMethod.sendNotification(
                                                                            fcm: user.fcm.toString(),
                                                                            title: 'Canceled',
                                                                            body: 'Your request rejected',
                                                                            type: "cancel");
                                                                      } catch (e) {
                                                                        // Handle any errors that might occur
                                                                        print(
                                                                            e);
                                                                      }
                                                                    },
                                                                  ),
                                                                  const SizedBox(
                                                                      width:
                                                                          10), // Add some spacing between the buttons
                                                                  OutlinedButton(
                                                                      child:
                                                                          const Text(
                                                                        'Activate',
                                                                        style:
                                                                            TextStyle(color: Colors.blue),
                                                                      ),
                                                                      onPressed:
                                                                          () async {
                                                                        try {
                                                                          final currentPosition =
                                                                              await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
                                                                          await updateRequestStatus(
                                                                              context,
                                                                              requests[index],
                                                                              currentPosition,
                                                                              "Activated");
                                            
                                                                          final UserModel
                                                                              user =
                                                                              context.read<MachineryRegistrationController>().getUser(requests[index].senderUid);
                                            
                                                                          final notificationMethod =
                                                                              NotificationMethod();
                                                                          await notificationMethod.sendNotification(
                                                                              fcm: user.fcm.toString(),
                                                                              title: 'Activated',
                                                                              body: 'Open And Track!',
                                                                              type: "activation");
                                                                          await context.read<MachineryRegistrationController>().updateMachine(machines,
                                                                              false);
                                                                          Navigator.pushNamed(context,
                                                                              AppRouter.trackOrder,
                                                                              arguments: requests[index]);
                                                                        } catch (e) {
                                                                          print(e);
                                                                        }
                                                                      }),
                                                                        const SizedBox(
                                                                      width:
                                                                          10), // Add some spacing between the buttons
                                                                       requests[index]
                                                                  .status ==
                                                              null
                                                          ? OutlinedButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .push(MaterialPageRoute(
                                                                        builder:
                                                                            (ctx) {
                                                                  return MessagesScreen(
                                                                      request:
                                                                          requests[index]);
                                                                }));
                                                              },
                                                              child: const Text(
                                                                  "Messages"))
                                                          : Container(),
                                                                ],
                                                              ),
                                                            )
                                                          : const SizedBox(),
                                                     
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 8.0,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Total number of work hours: ${requests[index].workOfHours}/hrs.",
                                                  style: TextStyle(
                                                    color: isDark
                                                        ? const Color.fromARGB(
                                                            255, 183, 178, 178)
                                                        : Colors.black45,
                                                  ),
                                                ),
                                                Text(
                                                  ConstantHelper.timeAgo(
                                                      requests[index]
                                                          .dateAdded
                                                          .toDate()),
                                                  style: TextStyle(
                                                    color: isDark
                                                        ? const Color.fromARGB(
                                                            255, 183, 178, 178)
                                                        : Colors.black45,
                                                  ),
                                                  // style: TextStyle(
                                                  //     color: textColor),
                                                ),
                                              ],
                                            ),
                                          ),
                                          requests[index].status == null
                                              ? const SizedBox()
                                              : Row(
                                                  //mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    OutlinedButton(
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
                                                                    title: const Text(
                                                                        "Comment"),
                                                                    content: Text(
                                                                        requests[index]
                                                                            .comment!),
                                                                    actions: <Widget>[
                                                                      TextButton(
                                                                        child: const Text(
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
                                                          color: ConstantHelper
                                                              .textColors(
                                                                  requests[
                                                                          index]
                                                                      .status!),
                                                        ),
                                                      ),
                                                      child: Text(
                                                        requests[index]
                                                            .status!
                                                            .toUpperCase()
                                                            .toString(),
                                                        style: TextStyle(
                                                          color: ConstantHelper
                                                              .textColors(
                                                                  requests[
                                                                          index]
                                                                      .status!),
                                                          //  requests[index]
                                                          //             .status ==
                                                          //         'Canceled'
                                                          //     ? Colors.red
                                                          //     : requests[index]
                                                          //                     .status ==
                                                          //                 'Accepted' ||
                                                          //             requests[index]
                                                          //                     .status ==
                                                          //                 'Activated'
                                                          //         ? Colors.blue
                                                          //         : Colors.orange,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    ElevatedButton(
                                                        onPressed: () {
                                                          log(requests[index]
                                                              .sourcelocation
                                                              .longitude);
                                                          showAlert(context,
                                                              sender: sender,
                                                              machine: machines,
                                                              request: requests[
                                                                  index]);
                                                        },
                                                        child: const Text(
                                                          "View More Details",
                                                        )), //style: TextStyle(decoration: TextDecoration.underline),)),
                                                  ],
                                                ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              requests[index].status != null
                                                  ? TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .push(
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (ctx) {
                                                          return MessagesScreen(
                                                              request: requests[
                                                                  index]);
                                                        }));
                                                      },
                                                      child: const Text(
                                                        "Messages",
                                                        style: TextStyle(
                                                            decoration:
                                                                TextDecoration
                                                                    .underline),
                                                      ))
                                                  : ElevatedButton(
                                                      onPressed: () {
                                                        log(requests[index]
                                                            .sourcelocation
                                                            .longitude);
                                                        showAlert(context,
                                                            sender: sender,
                                                            machine: machines,
                                                            request: requests[
                                                                index]);
                                                      },
                                                      child: const Text(
                                                        "View More Details",
                                                      )),
                                              //style: TextStyle(decoration: TextDecoration.underline),)),
                                              requests[index].status ==
                                                          "Confirm" ||
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
                                                            user: sender,
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
                                              // Builder(builder: (context) {
                                              //   Color textColor;
                                              //   var dateDifference =
                                              //       DateTime.now().difference(
                                              //           requests[index]
                                              //               .dateAdded
                                              //               .toDate());

                                              // switch (requests[index].status) {
                                              //   case 'Accepted':
                                              //     textColor = Colors.blue;
                                              //     break;
                                              //   case 'Activated':
                                              //     textColor = Colors.blue;
                                              //     break;
                                              //   case 'Confirm':
                                              //     textColor = Colors.orange;
                                              //     break;
                                              //   case 'Canceled':
                                              //     textColor = Colors.red;
                                              //     break;
                                              //   case 'Time Out':
                                              //     textColor = Colors.orange;
                                              //     break;
                                              //   default:
                                              //     textColor =
                                              //         (dateDifference.inHours >=
                                              //                 2)
                                              //             ? Colors.red
                                              //             : Colors.blue;
                                              //     break;
                                              // }

                                              //   return Column(
                                              //     crossAxisAlignment:
                                              //         CrossAxisAlignment.end,
                                              //     mainAxisSize: MainAxisSize.min,
                                              //     children: [
                                              //       Text(
                                              //         ConstantHelper.timeAgo(
                                              //             requests[index]
                                              //                 .dateAdded
                                              //                 .toDate()),
                                              //         style: TextStyle(
                                              //             color: textColor),
                                              //       ),
                                              //       // Text(
                                              //       //   Helper.getFormattedDateTime(
                                              //       //       requests[index]
                                              //       //           .dateAdded
                                              //       //           .toDate()),
                                              //       //   style: TextStyle(
                                              //       //       color: textColor),
                                              //       // ),
                                              //     ],
                                              //   );
                                              // })
                                            ],
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
