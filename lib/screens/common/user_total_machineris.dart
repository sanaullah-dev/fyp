import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/machinery_register_controller.dart';
import 'package:vehicle_management_and_booking_system/models/machinery_model.dart';
import 'package:flutter/foundation.dart' as TargetPlatform;
import 'package:vehicle_management_and_booking_system/screens/machinery/machinery_detials.dart';

// ignore: must_be_immutable
class MachineryListScreen extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  MachineryListScreen({required this.isthisAdmin});
  bool? isthisAdmin;
  //bool? isFavorite;
  @override
  State<MachineryListScreen> createState() => _MachineryListScreenState();
}

class _MachineryListScreenState extends State<MachineryListScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final User? currentUser = FirebaseAuth.instance.currentUser;
  bool _switchValue = true;
  // void showCustomDialog(BuildContext context) {
  //   showGeneralDialog(
  //     context: context,
  //     barrierLabel: "Barrier",
  //     barrierDismissible: true,
  //     barrierColor: Colors.black.withOpacity(0.5),
  //     transitionDuration: Duration(milliseconds: 700),
  //     pageBuilder: (_, __, ___) {
  //       return Center(
  //         child: Container(
  //           height: 240,
  //           child: SizedBox.expand(child: FlutterLogo()),
  //           margin: EdgeInsets.symmetric(horizontal: 20),
  //           decoration: BoxDecoration(
  //               color: Colors.white, borderRadius: BorderRadius.circular(40)),
  //         ),
  //       );
  //     },
  //     transitionBuilder: (_, anim, __, child) {
  //       Tween<Offset> tween;
  //       if (anim.status == AnimationStatus.reverse) {
  //         tween = Tween(begin: Offset(-1, 0), end: Offset.zero);
  //       } else {
  //         tween = Tween(begin: Offset(1, 0), end: Offset.zero);
  //       }

  //       return SlideTransition(
  //         position: tween.animate(anim),
  //         child: FadeTransition(
  //           opacity: anim,
  //           child: child,
  //         ),
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // log(widget.isthisAdmin.toString());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Machinery List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: widget.isthisAdmin == true
            ? firestore
                .collection('machineries')
                //.where('uid', isEqualTo: currentUser!.uid)
                .snapshots()
            : firestore
                .collection('machineries')
                .where('uid', isEqualTo: currentUser!.uid)
                .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("Not Regestered Any Machinery"),
            );
          }

          final List<DocumentSnapshot> documents = snapshot.data!.docs;

          return !TargetPlatform.kIsWeb
              ? ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    final MachineryModel machine = MachineryModel.fromJson(
                        documents[index].data() as Map<String, dynamic>);
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
                                    content: const Text(
                                        "Are you sure to delete this machiney?"),
                                    actions: <Widget>[
                                      OutlinedButton(
                                        onPressed: () async {
                                          // log(machine.toString());
                                          widget.isthisAdmin == true
                                              ? await context
                                                  .read<
                                                      MachineryRegistrationController>()
                                                  .deleteMachine(
                                                      machineId:
                                                          machine.machineryId,
                                                      images: machine.images!)
                                              : null;
                                          // ignore: use_build_context_synchronously
                                          Navigator.of(ctx).pop();
                                        },
                                        child: Text("Yes"),
                                      ),
                                      OutlinedButton(
                                        onPressed: () {
                                          log(machine.machineryId);
                                          log(machine.uid);
                                          log(machine.images.toString());
                                          Navigator.of(ctx).pop();
                                        },
                                        child: Text("No"),
                                      ),
                                    ],
                                  ),
                                )
                              : null;
                        },
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return DetalleWidget(model: machine);
                          }));
                          // TODO: Navigate to machinery detail screen
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
                        trailing: widget.isthisAdmin == true
                            ? Text("Rs. ${machine.charges}/h")
                            : Column(
                                children: [
                                  const Text(
                                    'Available',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  Expanded(
                                    child: Switch(
                                      value: _switchValue,
                                      onChanged: ((value) {
                                        _switchValue = value;
                                        setState(() {});
                                      }),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    );
                  },
                )
              : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 300,
                    crossAxisSpacing: 0.0,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    final MachineryModel machine = MachineryModel.fromJson(
                        documents[index].data() as Map<String, dynamic>);
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
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
                                            image: NetworkImage(
                                                machine.images!.last),
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
                                    widget.isthisAdmin == true
                                        ? Text("Rs. ${machine.charges}/h")
                                        : Row(
                                            children: [
                                              Text(
                                                'Available',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18.0,
                                                ),
                                              ),
                                              CupertinoSwitch(
                                                  value: _switchValue,
                                                  onChanged: ((value) {
                                                    _switchValue = value;
                                                    setState(() {
                                                      log(widget.isthisAdmin
                                                          .toString());
                                                    });
                                                  }))
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
        },
      ),
    );
  }
}
