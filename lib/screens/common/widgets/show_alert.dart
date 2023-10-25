import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:vehicle_management_and_booking_system/models/machinery_model.dart';
import 'package:vehicle_management_and_booking_system/models/request_machiery_model.dart';
import 'package:vehicle_management_and_booking_system/screens/login_signup/model/user_model.dart';
import 'package:vehicle_management_and_booking_system/utils/const.dart';
import 'package:vehicle_management_and_booking_system/utils/media_query.dart';

void showAlert(BuildContext context,
    {required UserModel sender,
    required MachineryModel machine,
    required RequestModel request}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      bool isDark = ConstantHelper.darkOrBright(context);

      return GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Dialog(
          
          child: Container(
            height: screenHeight(context) * 0.7, // fixed height of 500px
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        sender.profileUrl != null
                            ? CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(
                                // imageUrl:
                                sender.profileUrl.toString(),
                                errorListener: () {
                                  log("error");
                                },
                              ))
                            : CircleAvatar(child: Text(sender.name[0])),
      
                        // CircleAvatar(
                        //   radius: 20,
                        //   backgroundImage: NetworkImage(
                        //       sender.profileUrl.toString()),
                        // ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                sender.name.toString().toUpperCase(),
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w800),
                              ),
                              Text(
                                sender.email.length > 24
                                    ? '${sender.email.substring(0, 24)}...'
                                    : sender.email,
                                style: TextStyle(fontSize: 12),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Offer"),
                            Text("Rs.${request.price}/h"),
                          ],
                        ),
                        Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Total Work Hours"),
                            Text("${request.workOfHours}/hrs."),
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: screenHeight(context) * 0.5,
                    width: screenWidth(context),
                    margin: const EdgeInsets.only(left: 5, right: 5, top: 5),
                    decoration: BoxDecoration(
                        color: isDark
                            ? const Color.fromARGB(255, 111, 108, 108)
                            : Colors.white60,
                        borderRadius: BorderRadius.circular(5)),
                    child: Material(
                      elevation: 5.0,
                      child: Padding(
                        padding: const EdgeInsets.all(13.0),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Description",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? Colors.white
                                        : Color.fromARGB(255, 103, 103, 103)),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                request.description.toString(),
                                style: TextStyle(
                                    fontSize: 16,
                                    color: isDark
                                        ? Colors.white
                                        : const Color.fromARGB(
                                            255, 117, 116, 116)),
                                textAlign: TextAlign.justify,
                              )
                            ],
                          ),
                        ),
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
