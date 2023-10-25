// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_management_and_booking_system/app/app.dart';
import 'package:vehicle_management_and_booking_system/authentication/controllers/auth_controller.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/machinery_register_controller.dart';
import 'package:vehicle_management_and_booking_system/models/machinery_model.dart';
import 'package:flutter/foundation.dart' as TargetPlatform;
import 'package:vehicle_management_and_booking_system/models/request_machiery_model.dart';
import 'package:vehicle_management_and_booking_system/screens/machinery/machinery_detials.dart';
import 'package:vehicle_management_and_booking_system/utils/app_colors.dart';
import 'package:vehicle_management_and_booking_system/utils/const.dart';
import 'package:vehicle_management_and_booking_system/widgets/notification.dart';

// ignore: must_be_immutable
class MachineryListScreen extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  MachineryListScreen({required this.isthisAdmin, this.uid});
  final String? uid;
  bool? isthisAdmin;
  //bool? isFavorite;
  @override
  State<MachineryListScreen> createState() => _MachineryListScreenState();
}

class _MachineryListScreenState extends State<MachineryListScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  //final User? currentUser = FirebaseAuth.instance.currentUser;
  bool _switchValue = true;
  late List<MachineryModel> searchMachines;

  String getStatusString(bool isAvailable) {
    if (isAvailable == true) {
      return 'Available';
    } else if (isAvailable == false) {
      return 'UnAvailable';
    }
    return 'Unknown';
  }

  List<MachineryModel> machines = [];
  @override
  void initState() {
    // TODO: implement initState
    machines = [
      ...context
          .read<MachineryRegistrationController>()
          .allMachineries!
          .where((machine) => widget.isthisAdmin == true
              // ignore: unnecessary_null_comparison
              ? machine.uid != null
              : machine.uid == widget.uid)
          .toList()
    ];
    super.initState();
  }

  bool _isSearching = false;

  void _filterMachines(String value) {
    if (value.isNotEmpty) {
      searchMachines = [
        ...machines.where((machine) {
          return machine.title.toLowerCase().contains(value.toLowerCase()) ||
              machine.location.title
                  .toLowerCase()
                  .contains(value.toLowerCase()) ||
              machine.machineryId.toString().contains(value) ||
              machine.uid.contains(value) ||
              machine.rating.toString().contains(value);
        }).toList()
      ];
    } else {
      searchMachines = [...machines];
    }
    setState(() {});
  }

  String searchValue = '';
  @override
  Widget build(BuildContext context) {
    // log(widget.isthisAdmin.toString());
    bool isDark = ConstantHelper.darkOrBright(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor:
            isDark || widget.isthisAdmin == true ? null : AppColors.accentColor,
        // You can add a leading button to control the drawer
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? null : AppColors.blackColor,
          ),
          onPressed: () async {
            Navigator.pop(context);
          },
        ),
        title: _isSearching
            ? TextField(
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(5),
                    hintText: "Search...",
                    focusColor: Colors.white,
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder()),
                onChanged: (value) {
                  setState(() {
                    searchValue = value;
                    _filterMachines(value);
                  });

                  log(machines!.length.toString());
                },
              )
            : Text(
                widget.isthisAdmin == true
                    ? "Machieries List"
                    : "My Register Machines",
                style: TextStyle(color: isDark ? null : AppColors.blackColor),
              ),
        actions: [
          widget.isthisAdmin == true
              ? IconButton(
                  icon: Icon(
                    _isSearching ? Icons.close : Icons.search,
                    color: isDark ? null : AppColors.blackColor,
                  ),
                  onPressed: () {
                    setState(() {
                      _isSearching = !_isSearching;
                      searchMachines = [...machines];

                      // Call some method here if search is cancelled
                      if (!_isSearching) {
                        print("Search bar was hidden");
                      }
                    });
                  },
                )
              : Container(),
        ],
      ),
      body:
          // StreamBuilder<QuerySnapshot>(
          //   stream: widget.isthisAdmin == true
          //       ? firestore
          //           .collection('machineries')
          //           //.where('uid', isEqualTo: currentUser!.uid)
          //           .snapshots()
          //       : firestore
          //           .collection('machineries')
          //           .where('uid', isEqualTo: widget.uid)
          //           .snapshots(),
          //   builder: (context, snapshot) {
          //     if (!snapshot.hasData) {
          //       return const Center(child: CircularProgressIndicator());
          //     } else if (snapshot.data!.docs.isEmpty) {
          //       return const Center(
          //         child: Text("Not Regestered Any Machinery"),
          //       );
          //     }

          //     final List<DocumentSnapshot> documents = snapshot.data!.docs;
          machines.isEmpty
              ? const Center(
                  child: Text("Not Regestered Any Machinery"),
                )
              : !TargetPlatform.kIsWeb
                  ? _isSearching
                      ? ListMachines(searchMachines)
                      : ListMachines(machines)
                  : _isSearching?
                  GridOfMachines(searchMachines)
                  : GridOfMachines(machines),
      //   },
      // ),
    );
  }

  GridView GridOfMachines(List<MachineryModel> _listOfMachines) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 300,
        crossAxisSpacing: 0.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 0.7,
      ),
      itemCount: _listOfMachines.length,
      itemBuilder: (context, index) {
        final MachineryModel machine = _listOfMachines[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onLongPress: () {
              // showAboutDialog(context: context);
              // showCustomDialog(context);
              widget.isthisAdmin == true
                  ? showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Row(
                          children: [
                            Text("Detete\t"),
                            Icon(
                              Icons.warning_outlined,
                              color: Colors.red,
                            )
                          ],
                        ),
                        content:
                            const Text("Are you sure to delete this machiney?"),
                        actions: <Widget>[
                          OutlinedButton(
                            onPressed: () async {
                              // log(machine.toString());
                              try {
                                widget.isthisAdmin == true
                                    ? await context
                                        .read<MachineryRegistrationController>()
                                        .deleteMachine(
                                            machineId: machine.machineryId,
                                            images: machine.images!)
                                    : null;
                                // ignore: use_build_context_synchronously
                                Navigator.of(ctx).pop();
                              } catch (e) {
                                log(e.toString());
                              }
                            },
                            child: const Text("Yes"),
                          ),
                          OutlinedButton(
                            onPressed: () {
                              log(machine.machineryId);
                              log(machine.uid);
                              log(machine.images.toString());
                              Navigator.of(ctx).pop();
                            },
                            child: const Text("No"),
                          ),
                        ],
                      ),
                    )
                  : null;
            },
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return DetalleWidget(model: machine);
              }));
              // TODO: Navigate to machinery detail screen
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(
                  color: Colors.grey.shade400,
                  width: 2.0,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                        ),
                        image: machine.images != null
                            ? DecorationImage(
                                image: NetworkImage(machine.images!.last),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          machine.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          machine.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14.0,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        widget.uid !=
                                context.read<AuthController>().appUser!.uid
                            ? Text("Rs. ${machine.charges}/h")
                            : widget.isthisAdmin == true
                                ? Text("Rs. ${machine.charges}/h")
                                : Row(
                                    children: [
                                      Text(
                                        machine.isAvailable == false
                                            ? 'UnAvailable'
                                            : "Available",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                      CupertinoSwitch(
                                        value: machine.isAvailable == null
                                            ? _switchValue
                                            : machine.isAvailable!,
                                        onChanged: ((value) async {
                                          try {
                                            machine.isAvailable = value;
                                            log(value.toString());
                                            setState(() {});
                                            await context
                                                .read<
                                                    MachineryRegistrationController>()
                                                .updateMachine(machine, value);
                                            // ignore: use_build_context_synchronously
                                            await context
                                                .read<
                                                    MachineryRegistrationController>()
                                                .getAllMachineries();
                                          } catch (e) {
                                            log(e.toString());
                                          }
                                        }),
                                      )
                                    ],
                                  ),
                      ],
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

  ListView ListMachines(List<MachineryModel> listOfMachines) {
    return ListView.builder(
      itemCount: listOfMachines.length,
      itemBuilder: (context, index) {
        final MachineryModel machine = listOfMachines[index];
        // log(machine.toString());
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            onLongPress: () {
              // showAboutDialog(context: context);
              // showCustomDialog(context);
              widget.isthisAdmin == true
                  ? showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Row(
                          children: [
                            Text("Detete\t"),
                            Icon(
                              Icons.warning_outlined,
                              color: Colors.red,
                            )
                          ],
                        ),
                        content:
                            const Text("Are you sure to delete this machiney?"),
                        actions: <Widget>[
                          OutlinedButton(
                            onPressed: () async {
                              // log(machine.toString());
                              try {
                                widget.isthisAdmin == true
                                    ? await context
                                        .read<MachineryRegistrationController>()
                                        .deleteMachine(
                                            machineId: machine.machineryId,
                                            images: machine.images!)
                                    : null;
                                // ignore: use_build_context_synchronously
                                Navigator.of(ctx).pop();
                              } catch (e) {
                                log(e.toString());
                              }
                            },
                            child: const Text("Yes"),
                          ),
                          OutlinedButton(
                            onPressed: () {
                              log(machine.machineryId);
                              log(machine.uid);
                              log(machine.images.toString());
                              Navigator.of(ctx).pop();
                            },
                            child: const Text("No"),
                          ),
                        ],
                      ),
                    )
                  : null;
            },
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return DetalleWidget(model: machine);
              }));
            },
            contentPadding: const EdgeInsets.symmetric(
              vertical: 20.0,
              horizontal: 16.0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: BorderSide(
                color: Colors.grey.shade400,
                width: 1.0,
              ),
            ),
            leading: CircleAvatar(
              radius: 30.0,
              backgroundColor: Colors.grey.shade100,
              backgroundImage: machine.images != null
                  ? CachedNetworkImageProvider(
                      machine.images!.last.toString(),
                    )
                  : null,
            ),
            title: Text(
              machine.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            subtitle: Text(
              machine.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14.0,
              ),
            ),
            trailing: widget.uid != context.read<AuthController>().appUser!.uid
                ? Text("Rs. ${machine.charges}/h")
                : widget.isthisAdmin == true
                    ? Text("Rs. ${machine.charges}/h")
                    : Column(
                        children: [
                          Text(
                            getStatusString(machine.isAvailable),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          Expanded(
                            child: Switch(
                              value: machine.isAvailable,
                              onChanged: ((value) async {
                                try {
                                  // List<RequestModelForMachieries>
                                  //     thisMachineRequests =
                                  //     context
                                  //         .read<
                                  //             MachineryRegistrationController>()
                                  //         .allRequests!
                                  //         .where((e) =>
                                  //             e.machineId ==
                                  //             machine
                                  //                 .machineryId)
                                  //         .toList();
                                  // // Sort allRatings by date
                                  // DocumentSnapshot?
                                  //     documentSnapshot;

                                  // if (thisMachineRequests
                                  //     .isNotEmpty) {
                                  //   log(thisMachineRequests
                                  //           .first
                                  //           .toString() +
                                  //       "@");
                                  //   thisMachineRequests.sort(
                                  //       (a, b) => b.dateAdded
                                  //           .compareTo(
                                  //               a.dateAdded));
                                  //   log(thisMachineRequests
                                  //       .first.description
                                  //       .toString());

                                  //   documentSnapshot = await FirebaseFirestore
                                  //       .instance
                                  //       .collection('users')
                                  //       .doc(thisMachineRequests
                                  //           .first
                                  //           .senderUid) // Replace with the sender's UID
                                  //       .collection(
                                  //           'sent_requests')
                                  //       .doc(thisMachineRequests
                                  //           .first
                                  //           .requestId) // Replace with the request ID you're looking for
                                  //       .get();

                                  //   RequestModelForMachieries?
                                  //       retrivedRequest;

                                  //   if (documentSnapshot
                                  //       .exists) {
                                  //     retrivedRequest =
                                  //         RequestModelForMachieries
                                  //             .fromMap(documentSnapshot
                                  //                     .data()
                                  //                 as Map<String,
                                  //                     dynamic>);
                                  //   }

                                  //   if (((retrivedRequest !=
                                  //               null) &&
                                  //           retrivedRequest
                                  //                   .status ==
                                  //               "Completed") ||
                                  //       retrivedRequest!
                                  //               .status ==
                                  //           "Canceled" ||
                                  //       thisMachineRequests
                                  //           .isEmpty) {
                                  //     machine.isAvailable =
                                  //         value;
                                  //     log(value.toString() +
                                  //         "2");
                                  //     setState(() {});
                                  //     await context
                                  //         .read<
                                  //             MachineryRegistrationController>()
                                  //         .updateMachine(
                                  //             machine, value);
                                  //     // ignore: use_build_context_synchronously
                                  //     await context
                                  //         .read<
                                  //             MachineryRegistrationController>()
                                  //         .getAllMachineries();
                                  //   } else {
                                  //     ScaffoldMessenger.of(
                                  //             context)
                                  //         .showSnackBar(SnackBar(
                                  //             content: Text(
                                  //                 'Your Client cannot mark Complete')));
                                  //   }
                                  // } else if(thisMachineRequests.isEmpty) {
                                  //   machine.isAvailable = value;
                                  //   log(value.toString() + "2");
                                  //   setState(() {});
                                  //   await context
                                  //       .read<
                                  //           MachineryRegistrationController>()
                                  //       .updateMachine(
                                  //           machine, value);
                                  //   // ignore: use_build_context_synchronously
                                  //   await context
                                  //       .read<
                                  //           MachineryRegistrationController>()
                                  //       .getAllMachineries();
                                  //   log("No matching requests found.");
                                  // }

                                  machine.isAvailable = value;
                                  log(value.toString() + "2");
                                  setState(() {});
                                  await context
                                      .read<MachineryRegistrationController>()
                                      .updateMachine(machine, value);
                                  // ignore: use_build_context_synchronously
                                  await context
                                      .read<MachineryRegistrationController>()
                                      .getAllMachineries();
                                  log("No matching requests found.");
                                } catch (e) {
                                  log(e.toString());
                                }
                              }),
                            ),
                          ),
                        ],
                      ),
          ),
        );
      },
    );
  }
}
