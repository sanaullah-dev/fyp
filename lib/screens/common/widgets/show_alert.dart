import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_management_and_booking_system/authentication/controllers/auth_controller.dart';
import 'package:vehicle_management_and_booking_system/common/helper.dart';
import 'package:vehicle_management_and_booking_system/models/machinery_model.dart';
import 'package:vehicle_management_and_booking_system/models/request_machiery_model.dart';
import 'package:vehicle_management_and_booking_system/screens/login_signup/model/user_model.dart';
import 'package:vehicle_management_and_booking_system/utils/const.dart';
import 'package:vehicle_management_and_booking_system/utils/media_query.dart';

void showAlert(BuildContext context,
    {required UserModel sender,
    required MachineryModel machine,
    required RequestModelForMachieries request}) {
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
            //height: screenHeight(context) * 0.75, // fixed height of 500px
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                                    fontSize: 16, fontWeight: FontWeight.w700),
                              ),
                              Text(
                                sender.email.length > 24
                                    ? '${sender.email.substring(0, 24)}...'
                                    : sender.email,
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
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
                        SizedBox(
                          height: 10,
                        ),
                        // request.senderUid ==
                        //             context
                        //                 .read<AuthController>()
                        //                 .appUser!
                        //                 .uid &&
                        //         (request.status == "Confirm" || request.status == "Canceled")
                        //     ? OutlinedButton(
                        //         onPressed: () async {
                        //           (await context
                        //                   .read<
                        //                       MachineryRegistrationController>()
                        //                   .hasUserRatedMachinery(
                        //                       request.senderUid, machine.machineryId))
                        //               ? ScaffoldMessenger.of(context)
                        //                   .showSnackBar(SnackBar(
                        //                       content: Text("Already rated")))
                        //               : showCustomRatingDialog(
                        //                   context, machine);
                        //         },
                        //         child: Text("Rate this Machine"))
                        //     : SizedBox(),
                        request.senderUid !=
                                context.read<AuthController>().appUser!.uid
                            ? Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 0, 5, 0),
                                      child: Container(
                                        //width: screenWidth(context) * 0.28,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: Color(0x00FFFFFF),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          border: Border.all(
                                            color: Color(0xFF7F8788),
                                            width: 2,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(3, 0, 3, 0),
                                              child: Icon(
                                                Icons.location_on_outlined,
                                                color: Colors.orange,
                                                size: 18,
                                              ),
                                            ),
                                            FutureBuilder(
                                                future: Helper.getDistance(
                                                    lat: request.sourcelocation
                                                        .latitude,
                                                    lon: request.sourcelocation
                                                        .longitude),
                                                builder: (context, snapshot) {
                                                  switch (snapshot
                                                      .connectionState) {
                                                    case ConnectionState
                                                          .waiting:
                                                      return const Text(
                                                          'Loading....');
                                                    default:
                                                      if (snapshot.hasError) {
                                                        return Text(
                                                            'Error: ${snapshot.error}');
                                                      } else {
                                                        return Text(
                                                          '${snapshot.data} km  ',
                                                          style: GoogleFonts
                                                              .firaSans(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300),
                                                        );
                                                      }
                                                  }
                                                }),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox(),
                      ],
                    ),
                  ),
                  LayoutBuilder(builder: (context, BoxConstraints constraints) {
                    // Suppose this is your description string fetched from Firebase
                    String description = request.description.toString();
                    // You might decide to make the height proportional to the length of the description
                    double contentHeight =
                        description.length * 0.5; // Adjust the factor as needed

                    return Container(
                      height: contentHeight > screenHeight(context) * 0.5
                          ? screenHeight(context) * 0.5
                          : null,
                      width: screenWidth(context),
                      margin: const EdgeInsets.only(
                        left: 5,
                        right: 5,
                        top: 5,
                        bottom: 5,
                      ),
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
                                          ? Colors.white60
                                          : const Color.fromARGB(
                                              255, 117, 116, 116)),
                                  textAlign: TextAlign.justify,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
