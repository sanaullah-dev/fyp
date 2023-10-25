// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_management_and_booking_system/app/app.dart';
import 'package:vehicle_management_and_booking_system/app/router.dart';
import 'package:vehicle_management_and_booking_system/authentication/controllers/auth_controller.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/operator_register_controller.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/request_controller.dart';
import 'package:vehicle_management_and_booking_system/models/operator_model.dart';
import 'package:vehicle_management_and_booking_system/screens/operator/hiring_details.dart';
import 'package:vehicle_management_and_booking_system/utils/app_colors.dart';
import 'package:vehicle_management_and_booking_system/utils/const.dart';
import 'package:vehicle_management_and_booking_system/utils/media_query.dart';

class HiredOperatorsScreen extends StatefulWidget {
  @override
  _HiredOperatorsScreenState createState() => _HiredOperatorsScreenState();
}

class _HiredOperatorsScreenState extends State<HiredOperatorsScreen> {
  late List<OperatorModel> _hiredOperators;
  late String appUserUid;

  @override
  void initState() {
    super.initState();
    appUserUid = context.read<AuthController>().appUser!.uid;

// Filter operators based on hiringRecordForOperator containing appUser UID
    _hiredOperators = context
        .read<OperatorRegistrationController>()
        .allOperators
        .where((operator) {
      if (operator.hiringRecordForOperator != null) {
        // Check if hiringRecordForOperator contains appUser UID
        return operator.hiringRecordForOperator!
            .any((record) => record.hirerUid == appUserUid);
      }
      return false; // Return false for operators without hiring records
    }).toList();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // await context.read<OperatorRegistrationController>().getHiredOperators(
      //     context
      //         .read<AuthController>()
      //         .appUser!
      //         .uid); // Replace 'hirerUid' with the actual hirer's UID.
      // _hiredOperatorsFuture =
      //     context.read<OperatorRegistrationController>().hiredOperators;
      await context
          .read<OperatorRegistrationController>()
          .getNearestAndHighestRatedOperator();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = ConstantHelper.darkOrBright(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            navigatorKey.currentState!.pop();
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? null : AppColors.blackColor,
          ),
        ),
        backgroundColor: isDark ? null : AppColors.accentColor,
        title: Text(
          "My Hired Operators",
          style: TextStyle(color: isDark ? null : AppColors.blackColor),
        ),
      ),
      body:
          // StreamBuilder<QuerySnapshot>(
          //     stream: firestore
          //         .collection('Operators')
          //         .where('uid', isEqualTo: currentUser!.uid)
          //         .snapshots(),
          //     builder: (context, snapshot) {
          //       if (!snapshot.hasData) {
          //         return const Center(child: CircularProgressIndicator());
          //       } else if (snapshot.data!.docs.isEmpty) {
          //         return const Center(
          //           child: Text("Not Regestered Any Operator"),
          //         );
          //       }

          //       final List<DocumentSnapshot> documents = snapshot.data!.docs;
          _hiredOperators.isEmpty
              ? const Center(
                  child: Text("Not Hired Any Operator"),
                )
              : ListView.separated(
                  separatorBuilder: (context, index) {
                    return const Divider();
                  },
                  itemCount: _hiredOperators.length,
                  itemBuilder: ((context, index) {
                    final OperatorModel operator = _hiredOperators[index];
                    //  OperatorModel.fromJson(
                    //     documents[index].data() as Map<String, dynamic>);
                    return GestureDetector(
                      onTap: () {
                        // Navigator.pushNamed(
                        //     context, AppRouter.operatorDetailsScreen,
                        //     arguments: operator);
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return HiringDetailsScreen(operatorModel: operator);
                        }));
                      },
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 16.0),
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

                            // ignore: sort_child_properties_last
                            child: Container(
                                height: screenHeight(context),
                                width: screenWidth(context),
                                // margin: EdgeInsets.all(5),
                                // padding: EdgeInsets.all(5),
                                clipBehavior: Clip.antiAlias,
                                decoration:
                                    const BoxDecoration(shape: BoxShape.circle),
                                child: CachedNetworkImage(
                                  fit: BoxFit.fill,
                                  imageUrl: operator.operatorImage!,
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                )),
                          ),
                          title: Text(operator.name.toUpperCase().toString()),
                          subtitle: SelectableText(operator.email.toString()),
                          trailing: operator.isHired == true
                              ? operator.hiringRecordForOperator!.last
                                              .hirerUid ==
                                          appUserUid &&
                                      operator.hiringRecordForOperator!.last
                                              .endDate ==
                                          null
                                  ?
                                  // IconButton(
                                  //     onPressed: () async {
                                  //       operator.isHired = false;
                                  //       operator.isAvailable = true;
                                  //       operator.hiringRecordForOperator!
                                  //           .last.endDate = Timestamp.now();
                                  //       await context
                                  //           .read<RequestController>()
                                  //           .requestComplete(
                                  //               operator
                                  //                   .hiringRecordForOperator!
                                  //                   .last
                                  //                   .requestId,
                                  //               operator
                                  //                   .hiringRecordForOperator!
                                  //                   .last
                                  //                   .hirerUid,
                                  //               "Job Ended",
                                  //               "operator_hiring_sent");
                                  //       await context
                                  //           .read<RequestController>()
                                  //           .requestComplete(
                                  //               operator
                                  //                   .hiringRecordForOperator!
                                  //                   .last
                                  //                   .requestId,
                                  //               operator.uid,
                                  //               "Job Ended",
                                  //               "operator_hiring_received");

                                  //       await context
                                  //           .read<
                                  //               OperatorRegistrationController>()
                                  //           .updateFullOperator(
                                  //               operator: operator);
                                  //       ScaffoldMessenger.of(context)
                                  //           .showSnackBar(SnackBar(
                                  //               content: Text(
                                  //                   'You have ended the hire')));

                                  //       // widget.hiringRequest.operatorUid ==
                                  //       //         appUser!.uid
                                  //       //     ? showCustomRatingDialog(
                                  //       //         context: context,
                                  //       //         requestId: widget
                                  //       //             .hiringRequest.requestId,
                                  //       //         user: otherUser,
                                  //       //         isHiring: true)
                                  //       //     : showCustomRatingDialog(
                                  //       //         context: context,
                                  //       //         requestId: widget
                                  //       //             .hiringRequest.requestId,
                                  //       //         operator: operator);
                                  //       // setState(() {});
                                  //     },
                                  //     icon: const Icon(
                                  //       Icons.delete_forever_outlined,
                                  //       color: Colors.red,
                                  //       size: 30,
                                  //     ),
                                  //   )

                                  IconButton(
                                      onPressed: () async {
                                        bool confirmDelete = await showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text(
                                                  'Confirm Deletion'),
                                              content: const Text(
                                                  'Are you sure you want to end the hire?'),
                                              actions: <Widget>[
                                                context
                                                            .read<
                                                                RequestController>()
                                                            .isLoading ||
                                                        context
                                                            .read<
                                                                OperatorRegistrationController>()
                                                            .isLoading
                                                    ? const SizedBox()
                                                    : TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context).pop(
                                                              false); // User canceled the operation
                                                        },
                                                        child: const Text(
                                                            'Cancel'),
                                                      ),
                                                context
                                                            .read<
                                                                RequestController>()
                                                            .isLoading ||
                                                        context
                                                            .read<
                                                                OperatorRegistrationController>()
                                                            .isLoading
                                                    ? const SizedBox(
                                                        child:
                                                            CircularProgressIndicator())
                                                    : TextButton(
                                                        onPressed: () async {
                                                          // User confirmed deletion, proceed with the deletion logic
                                                          operator.isHired =
                                                              false;
                                                          operator.isAvailable =
                                                              true;
                                                          operator
                                                                  .hiringRecordForOperator!
                                                                  .last
                                                                  .endDate =
                                                              Timestamp.now();
                                                          await context
                                                              .read<
                                                                  RequestController>()
                                                              .requestComplete(
                                                                  operator
                                                                      .hiringRecordForOperator!
                                                                      .last
                                                                      .requestId,
                                                                  operator
                                                                      .hiringRecordForOperator!
                                                                      .last
                                                                      .hirerUid,
                                                                  "Job Ended",
                                                                  "operator_hiring_sent",
                                                                );
                                                          await context
                                                              .read<
                                                                  RequestController>()
                                                              .requestComplete(
                                                                  operator
                                                                      .hiringRecordForOperator!
                                                                      .last
                                                                      .requestId,
                                                                  operator.uid,
                                                                  "Job Ended",
                                                                  "operator_hiring_received",
                                                                 );

                                                          await context
                                                              .read<
                                                                  OperatorRegistrationController>()
                                                              .updateFullOperator(
                                                                  operator:
                                                                      operator);
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  const SnackBar(
                                                                      content: Text(
                                                                          'You have ended the hire')));

                                                          // Optionally, you can show additional dialogs or perform other actions based on user confirmation.

                                                          Navigator.of(context).pop(
                                                              true); // User confirmed the operation
                                                        },
                                                        child: const Text(
                                                            'Confirm'),
                                                      ),
                                              ],
                                            );
                                          },
                                        );

                                        setState(() {
                                          
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.delete_forever_outlined,
                                        color: Colors.red,
                                        size: 30,
                                      ),
                                    )
                                  : operator.isAvailable == false
                                      ? const Text("UnAvailable")
                                      : const Text("Available")
                              : const Text("Available"),
                        ),
                      ),
                    );
                  }),
                ),
    );
  }
}
