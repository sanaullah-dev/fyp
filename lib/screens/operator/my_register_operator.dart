import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_management_and_booking_system/app/app.dart';
import 'package:vehicle_management_and_booking_system/app/router.dart';
import 'package:vehicle_management_and_booking_system/authentication/controllers/auth_controller.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/operator_register_controller.dart';
import 'package:vehicle_management_and_booking_system/models/operator_model.dart';
import 'package:vehicle_management_and_booking_system/utils/app_colors.dart';
import 'package:vehicle_management_and_booking_system/utils/const.dart';
import 'package:vehicle_management_and_booking_system/utils/media_query.dart';

class MyRegisteredOperators extends StatefulWidget {
  MyRegisteredOperators({super.key, required this.uid});
  String uid;

  @override
  State<MyRegisteredOperators> createState() => _MyRegisteredOperatorsState();
}

class _MyRegisteredOperatorsState extends State<MyRegisteredOperators> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final User? currentUser = FirebaseAuth.instance.currentUser;
  List<OperatorModel> operators = [];
  @override
  void initState() {
    // TODO: implement initState
    operators = context
        .read<OperatorRegistrationController>()
        .allOperators
        .where((operartor) => operartor.uid == widget.uid)
        .toList();
    super.initState();
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
          "My Registered Operator",
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
          operators.isEmpty
              ? const Center(
                  child: Text("Not Regestered Any Operator"),
                )
              : ListView.separated(
                  separatorBuilder: (context, index) {
                    return const Divider();
                  },
                  itemCount: operators.length,
                  itemBuilder: ((context, index) {
                    final OperatorModel operator = operators[index];
                    //  OperatorModel.fromJson(
                    //     documents[index].data() as Map<String, dynamic>);
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                            context, AppRouter.operatorDetailsScreen,
                            arguments: operator);
                        // Navigator.of(context)
                        //     .push(MaterialPageRoute(builder: (context) {
                        //   return OperatorDetailsScreen(
                        //     operator: operator,
                        //   );
                        // }));
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
                          subtitle: Text(operator.mobileNumber.toString()),
                          trailing: operator.uid !=
                                  context.read<AuthController>().appUser!.uid
                              ? operator.isHired == true
                                  ? const Text("Hired")
                                  : operator.isAvailable == true? const Text("Available"):const Text("UnAvailable")
                              : operator.isHired == true
                                  ? const Text("Hired")
                                  : SingleChildScrollView(
                                      child: Container(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          // mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              operator.isAvailable == false
                                                  ? 'UnAvailable'
                                                  : "Available",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                               // fontSize: 11.0,
                                              ),
                                            ),
                                            Switch(
                                              value: operator.isAvailable,
                                              onChanged: ((value) async {
                                                if (operator.isHired != true) {
                                                  try {
                                                    operator.isAvailable =
                                                        value;
                                                    log(value.toString());
                                                    setState(() {});
                                                    await context
                                                        .read<
                                                            OperatorRegistrationController>()
                                                        .updateOperator(
                                                            operator, value);
                                                    // ignore: use_build_context_synchronously
                                                    await context
                                                        .read<
                                                            OperatorRegistrationController>()
                                                        .getNearestAndHighestRatedOperator();
                                                  } catch (e) {
                                                    log(e.toString());
                                                  }
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(const SnackBar(
                                                          content: Text(
                                                              "You are already hired that is the reason which you are unavailble")));
                                                }
                                              }),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                        ),
                      ),
                    );
                  }),
                ),
    );
  }
}
