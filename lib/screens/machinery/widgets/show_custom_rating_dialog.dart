// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_management_and_booking_system/app/app.dart';
import 'package:vehicle_management_and_booking_system/app/router.dart';
import 'package:vehicle_management_and_booking_system/authentication/controllers/auth_controller.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/machinery_register_controller.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/operator_register_controller.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/request_controller.dart';
import 'package:vehicle_management_and_booking_system/models/machinery_model.dart';
import 'package:vehicle_management_and_booking_system/models/operator_model.dart';
import 'package:vehicle_management_and_booking_system/screens/login_signup/model/user_model.dart';
import 'package:vehicle_management_and_booking_system/widgets/notification.dart';

Future<void> showCustomRatingDialog({
  required BuildContext context,
  MachineryModel? machine,
  UserModel? user,
  required String requestId,
  OperatorModel? operator,
  bool? isHiring,
}) async {
  log('MachineryModel: $machine');
  log('UserModel: ${user?.name??"0"}');
  log('Request ID: $requestId');
  log('OperatorModel: ${operator?.name??"0"}');
  log('Is Hiring: $isHiring');

  double ratingValue = 1.0; // Default initial value
  final commentController = TextEditingController();

  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Consumer<AuthController>(builder: (context, provider, _) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Column(
            children: [
              operator != null
                  ? CircleAvatar(
                      radius: 50,
                      backgroundImage: CachedNetworkImageProvider(
                        // imageUrl:
                        operator.operatorImage.toString(),
                      
                      ))
                  : user != null
                      ? user.profileUrl != null
                          ? CircleAvatar(
                              radius: 50,
                              backgroundImage: CachedNetworkImageProvider(
                                // imageUrl:
                                user.profileUrl.toString(),
                            
                              ))
                          : CircleAvatar(radius: 50, child: Text(user.name[0]))
                      : CircleAvatar(
                          radius: 50,
                          backgroundImage: CachedNetworkImageProvider(
                              machine!.images!.last.toString()),
                        ),
              const SizedBox(height: 10),
               Text(
            "${operator?.name.toUpperCase()??user?.name.toUpperCase()??machine?.title.toUpperCase()}",
               // 'Rating Dialog',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text(
                  'Tap a star to set your rating. Add more description here if you want.',
                  textAlign: TextAlign.center,
                  style: TextStyle(),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RatingBar.builder(
                      initialRating: ratingValue,
                      minRating: 1,
                      itemSize: 30,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        ratingValue = rating;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextFormField(
                  maxLines: 1,
                  controller: commentController,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    hintText: "Your opinion matters to us.",
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            provider.isloading
                ? SizedBox()
                : TextButton(
                    child: const Text('Remind Me Later'),
                    onPressed: () {
                      log(ratingValue.toString());
                      NotificationServices notificationServices =
                          NotificationServices();
                      notificationServices.remindMeLater(hoursLater: 30);
                      navigatorKey.currentState!
                          .pop(context); // Move the pop command here
                      // navigatorKey.currentState!
                      //     .pushReplacementNamed(AppRouter.bottomNavigationBar);
                    },
                  ),
            provider.isloading
                ? Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : TextButton(
                    child: const Text('Submit'),
                    onPressed: () async {
                      provider.setLoading(true);
                      if (commentController.text.trim().isEmpty ||
                          commentController.text.length < 3) {
                        if (kDebugMode) {
                          print("Error: Comment is too short or empty");
                        }
                        // Optionally display an error to the user here.
                        return;
                      }
                      if (kDebugMode) {
                        print(
                            'rating: $ratingValue, comment: ${commentController.text}');
                      }
                      var appUser = provider.appUser;

                      if (appUser != null && appUser.uid.isNotEmpty) {
                        // Check for null in the rating response
                        if (commentController.text.isNotEmpty) {
                          if (operator != null) {
                            RatingForOperator rating = RatingForOperator(
                                userId: appUser.uid,
                                value: ratingValue.toDouble(),
                                date: Timestamp.now(),
                                comment: commentController.text);

                            await context
                                .read<OperatorRegistrationController>()
                                .addOperatorRating(operator.operatorId, rating);
                            // ignore: use_build_context_synchronously
                            // await context
                            //     .read<RequestController>()
                            //     .requestComplete(requestId, appUser.uid,
                            //         "Hiring Completed", 'operator_hiring_sent');
                            await context
                                .read<RequestController>()
                                .updateRequestRatingStatus(
                                    requestId: requestId,
                                    uid: appUser.uid,
                                    collection: "operator_hiring_sent",
                                    isOperatorRatingComplete: false,
                                    isHirerRatingComplete: true);
                          } else if (user != null && isHiring == true) {
                            RatingForUser rating = RatingForUser(
                                userId: appUser.uid,
                                value: ratingValue.toDouble(),
                                date: Timestamp.now(),
                                comment: commentController.text);

                            // await context
                            //     .read<RequestController>()
                            //     .requestComplete(
                            //         requestId,
                            //         appUser.uid,
                            //         "Hiring Completed",
                            //         'operator_hiring_received');
                            await context
                                .read<MachineryRegistrationController>()
                                .addUserRating(
                                  user.uid,
                                  rating,
                                );
                            await context
                                .read<RequestController>()
                                .updateRequestRatingStatus(
                                    requestId: requestId,
                                    uid: appUser.uid,
                                    collection: "operator_hiring_received",
                                    isOperatorRatingComplete: true,
                                    isHirerRatingComplete: false);
                          } else if (user == null) {
                            Rating rating = Rating(
                                userId: appUser.uid,
                                value: ratingValue.toDouble(),
                                date: Timestamp.now(),
                                comment: commentController.text);

                            await context
                                .read<MachineryRegistrationController>()
                                .addRatingToMachinery(
                                    machine!.machineryId, rating);
                            await context
                                .read<RequestController>()
                                .requestComplete(requestId, appUser.uid,
                                    "Completed", 'sent_requests',isOperator: true);
                          } else {
                            RatingForUser rating = RatingForUser(
                                userId: appUser.uid,
                                value: ratingValue.toDouble(),
                                date: Timestamp.now(),
                                comment: commentController.text);

                            await context
                                .read<RequestController>()
                                .requestComplete(requestId, appUser.uid,
                                    "Completed", 'received_requests',isOperator: true);
                            // ignore: use_build_context_synchronously
                            await context
                                .read<MachineryRegistrationController>()
                                .addUserRating(
                                  user.uid,
                                  rating,
                                );
                          }
                        } else {
                          print(
                              "Error: Rating value or comment is null or empty");
                          // Optionally display an error to the user
                        }
                      } else {
                        print("Error: appUser or its uid is null");
                        // Optionally display an error to the user
                      }
                      provider.setLoading(false);
                      // ignore: use_build_context_synchronously
                      navigatorKey.currentState!
                          .pop(context); // Move the pop command here
                      navigatorKey.currentState!
                          .pushReplacementNamed(AppRouter.bottomNavigationBar);
                    },
                  ),
          ],
        );
      });
    },
  );
}
