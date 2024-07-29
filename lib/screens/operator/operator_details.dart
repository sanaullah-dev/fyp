// ignore_for_file: use_build_context_synchronously

import 'dart:developer' as dev;
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vehicle_management_and_booking_system/app/router.dart';
import 'package:vehicle_management_and_booking_system/authentication/controllers/auth_controller.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/machinery_register_controller.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/operator_register_controller.dart';
import 'package:vehicle_management_and_booking_system/models/operator_model.dart';
import 'package:vehicle_management_and_booking_system/screens/common/image_viewer.dart';
import 'package:vehicle_management_and_booking_system/screens/common/profile_screen.dart';
import 'package:vehicle_management_and_booking_system/screens/common/reviews_screen.dart';
import 'package:vehicle_management_and_booking_system/screens/login_signup/model/user_model.dart';
import 'package:vehicle_management_and_booking_system/screens/operator/hiring_details.dart';
import 'package:vehicle_management_and_booking_system/screens/operator/widgets/custom_card_forImage_and_more_details_top.dart';
import 'package:vehicle_management_and_booking_system/screens/operator/widgets/custom_rows.dart';
import 'package:vehicle_management_and_booking_system/utils/const.dart';
import 'package:vehicle_management_and_booking_system/utils/media_query.dart';

// ignore: must_be_immutable
class OperatorDetailsScreen extends StatefulWidget {
  OperatorDetailsScreen({super.key, required this.operator, this.status});
  late OperatorModel operator;
  String? status;
  @override
  State<OperatorDetailsScreen> createState() => _OperatorDetailScreenState();
}

class _OperatorDetailScreenState extends State<OperatorDetailsScreen> {
  late UserModel _appUser;
  bool? _isFavorite;

  @override
  void initState() {
    // TODO: implement initState
    _appUser = context.read<AuthController>().appUser!;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _isFavorite = await context
          .read<OperatorRegistrationController>()
          .isOperatorFavorited(_appUser.uid, widget.operator.operatorId);
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = ConstantHelper.darkOrBright(context);
    UserModel operatorProfile = context
        .read<MachineryRegistrationController>()
        .getUser(widget.operator.uid);
    return Scaffold(
      appBar: AppBar(
        title: const Text("OPERATOR INFORMATION"),
        elevation: 0,
        backgroundColor: isDark
            ? const Color.fromARGB(255, 171, 166, 166)
            : const Color.fromARGB(255, 206, 214, 219),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () async {
                var providr = context.read<OperatorRegistrationController>();
                var isFavorited = await providr.isOperatorFavorited(
                    _appUser.uid, widget.operator.operatorId);
                // log(isFavorited.toString());

                if (isFavorited) {
                  // ignore: use_build_context_synchronously
                  await providr
                      .removeOperatorFromFavorites(widget.operator.operatorId);
                  //  providr.removeLocalFavorite(widget.model.machineryId);
                  dev.log('Operator is removed from favorites');
                  _isFavorite = false;
                } else {
                  await providr.addToFavoritesOperator(widget.operator);
                  //  providr.addLocalFavorite(widget.model);
                  dev.log('Operator is added to favorites');
                  _isFavorite = true;
                }
                setState(() {});
              },
              icon: _isFavorite == null || _isFavorite == false
                  ? const Icon(Icons.favorite_border_outlined)
                  : const Icon(
                      Icons.favorite,
                      color: Colors.orange,
                    ),
            ),
          )
        ],
      ),
      backgroundColor: isDark
          ? const Color.fromARGB(255, 171, 166, 166)
          : const Color.fromARGB(255, 206, 214, 219),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: <Widget>[
              // Container(
              //   margin: const EdgeInsets.only(left: 5, right: 5),
              //   decoration: BoxDecoration(
              //     color: isDark
              //         ? const Color.fromARGB(255, 111, 108, 108)
              //         : Colors.white,
              //     borderRadius: BorderRadius.circular(20),
              //   ),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Padding(
              //         padding: const EdgeInsets.only(
              //             left: 20.0, top: 10, bottom: 10),
              //         child: Column(
              //           mainAxisAlignment: MainAxisAlignment.start,
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             Text(
              //               widget.operator.name.toUpperCase().toString(),
              //               style: TextStyle(
              //                 fontSize: 22,
              //                 fontWeight: FontWeight.bold,
              //                 color: isDark
              //                     ? Colors.white
              //                     : const Color.fromARGB(255, 109, 109, 108),
              //               ),
              //             ),
              //             const SizedBox(
              //               height: 20,
              //             ),
              //             Text(
              //               "City",
              //               style: TextStyle(
              //                   color: isDark ? Colors.white : Colors.grey,
              //                   fontSize: 12),
              //             ),
              //             Text(
              //               widget.operator.location.title.toString(),
              //               style: TextStyle(
              //                 color: isDark
              //                     ? Colors.white
              //                     : const Color.fromARGB(255, 84, 84, 84),
              //                 fontWeight: FontWeight.w600,
              //                 fontSize: 18,
              //               ),
              //             ),
              //             const SizedBox(
              //               height: 20,
              //             ),
              //             Text(
              //               "Experience",
              //               style: TextStyle(
              //                   color: isDark ? Colors.white : Colors.grey,
              //                   fontSize: 12),
              //             ),
              //             Text(
              //               "${widget.operator.years} Years",
              //               style: TextStyle(
              //                 color: isDark
              //                     ? Colors.white
              //                     : const Color.fromARGB(255, 84, 84, 84),
              //                 fontWeight: FontWeight.w600,
              //                 fontSize: 18,
              //               ),
              //             ),
              //             const SizedBox(
              //               height: 20,
              //             ),
              //             Text(
              //               "Rating",
              //               style: TextStyle(
              //                   color: isDark ? Colors.white : Colors.grey,
              //                   fontSize: 12),
              //             ),
              //             Text(
              //               "${widget.operator.rating}",
              //               style: TextStyle(
              //                 color: isDark
              //                     ? Colors.white
              //                     : const Color.fromARGB(255, 84, 84, 84),
              //                 fontWeight: FontWeight.w600,
              //                 fontSize: 18,
              //               ),
              //             ),
              //             const SizedBox(
              //               height: 20,
              //             ),
              //             GestureDetector(
              //               onTap: () {
              //                 Navigator.of(context).push(
              //                   MaterialPageRoute(
              //                     builder: (ctx) {
              //                       return SingleMachineMap(
              //                         loc: widget.operator,
              //                         isOperator: true,
              //                       );
              //                     },
              //                   ),
              //                 );
              //               },
              //               child: Padding(
              //                 padding: const EdgeInsetsDirectional.fromSTEB(
              //                     0, 0, 5, 0),
              //                 child: Column(
              //                   mainAxisSize: MainAxisSize.max,
              //                   children: [
              //                     Padding(
              //                       padding:
              //                           const EdgeInsetsDirectional.fromSTEB(
              //                               0, 0, 5, 0),
              //                       child: Container(
              //                         width: screenWidth(context) * 0.3,
              //                         height: 30,
              //                         decoration: BoxDecoration(
              //                           color: const Color(0x00FFFFFF),
              //                           borderRadius: BorderRadius.circular(6),
              //                           border: Border.all(
              //                             color: const Color(0xFF7F8788),
              //                             width: 2,
              //                           ),
              //                         ),
              //                         child: Row(
              //                           mainAxisSize: MainAxisSize.max,
              //                           children: [
              //                             const Padding(
              //                               padding:
              //                                   EdgeInsetsDirectional.fromSTEB(
              //                                       3, 0, 3, 0),
              //                               child: Icon(
              //                                 Icons.map_outlined,
              //                                 color: Colors.orange,
              //                                 size: 18,
              //                               ),
              //                             ),
              //                             Flexible(
              //                               child: Text(
              //                                 " Find here",
              //                                 overflow: TextOverflow.ellipsis,
              //                                 style: GoogleFonts.firaSans(
              //                                     fontWeight: FontWeight.w300),
              //                               ),
              //                             ),
              //                           ],
              //                         ),
              //                       ),
              //                     ),
              //                   ],
              //                 ),
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //       Container(
              //         padding: const EdgeInsets.all(10),
              //         height: screenHeight(context) * 0.3,
              //         width: screenWidth(context) * 0.4,
              //         child: ClipRRect(
              //             borderRadius: BorderRadius.circular(20),
              //             child: CachedNetworkImage(
              //               height: screenHeight(context) * 1,
              //               width: screenWidth(context),
              //               // placeholder: (context, url) =>
              //               //   const Center(child: CircularProgressIndicator()),
              //               errorWidget: (context, url, error) =>
              //                   const Icon(Icons.error),
              //               imageUrl: widget.operator.operatorImage!,
              //               fit: BoxFit.cover,
              //             )),
              //       ),
              //     ],
              //   ),
              // ),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color.fromARGB(255, 111, 108, 108)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20, top: 10, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Builder(builder: (context) {
                            String temp = widget.operator.name;
                            String text = temp.length > 10
                                ? "${temp.substring(0, min(10, temp.length))}..."
                                : temp;
                            return Text(
                              text.toUpperCase().toString(),
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? Colors.white
                                    : const Color.fromARGB(255, 109, 109, 108),
                              ),
                            );
                          }),
                          const SizedBox(
                            height: 10,
                          ),
                          infoText(
                              "City",
                              widget.operator.location.title.toString(),
                              isDark),
                          infoText("Experience",
                              "${widget.operator.years} Years", isDark),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return AllReviewsScreen(
                                  title: "Operator Reviews",
                                  operatorId: widget.operator.operatorId,
                                );
                              }));
                            },
                            child: Container(
                              child: infoText(
                                  "Rating",
                                  "${widget.operator.rating.toStringAsFixed(1)}",
                                  isDark),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              findHereButton(context, widget.operator),
                              widget.operator.uid ==
                                      context
                                          .read<AuthController>()
                                          .appUser!
                                          .uid
                                  ? IconButton(
                                      onPressed: () {
                                           Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return HiringDetailsScreen(operatorModel: widget.operator);
                        }));
                                      },
                                      icon: const Icon(Icons.info_outline))
                                  : const SizedBox()
                            ],
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return ImageFromUrlViewer(
                              image: widget.operator.operatorImage);
                        }));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        height: screenHeight(context) * 0.3,
                        width: screenWidth(context) * 0.4,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: CachedNetworkImage(
                            height: screenHeight(context),
                            width: screenWidth(context),
                            // placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                            imageUrl: widget.operator.operatorImage!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color.fromARGB(255, 111, 108, 108)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customTextHeader("Description", isDark),
                      const SizedBox(height: 3),
                      Text(
                        widget.operator.summaryOrDescription.toString(),
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark
                              ? Colors.white
                              : const Color.fromARGB(255, 117, 116, 116),
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 30,
              ),
              widget.status == "Hiring Completed" ||
                      widget.status == "Accepted" ||
                      widget.operator.uid ==
                          context.read<AuthController>().appUser!.uid
                  ? Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color.fromARGB(255, 111, 108, 108)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final emailAddress =
                                  widget.operator.email.toString();
                              final Uri emailLaunchUri = Uri(
                                scheme: 'mailto',
                                path: emailAddress,
                              );

                              await launchUrl(emailLaunchUri);
                            },
                            child: customRow(
                              "Email:",
                              widget.operator.email.toString(),
                              isDark,
                              context,
                            ),
                          ),
                          SizedBox(height: screenHeight(context) * 0.03),
                          GestureDetector(
                            onTap: () async {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("What would you like to do?"),
                                    content: const Text(
                                        "Would you like to call or send a message?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () async {
                                          final phoneNumber =
                                              widget.operator.mobileNumber;
                                          final Uri callUri = Uri(
                                            scheme: 'tel',
                                            path: phoneNumber,
                                          );

                                          if (await canLaunchUrl(callUri)) {
                                            await launchUrl(callUri);
                                          } else {
                                            print("Could not place call.");
                                          }
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Call"),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          final phoneNumber =
                                              widget.operator.mobileNumber;
                                          final Uri smsUri = Uri(
                                            scheme: 'sms',
                                            path: phoneNumber,
                                          );

                                          if (await canLaunchUrl(smsUri)) {
                                            await launchUrl(smsUri);
                                          } else {
                                            print("Could not send SMS.");
                                          }
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Message"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: customRow(
                              "Phone:",
                              widget.operator.mobileNumber.toString(),
                              isDark,
                              context,
                            ),
                          ),
                          SizedBox(height: screenHeight(context) * 0.03),
                          GestureDetector(
                            onTap: () async {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("What would you like to do?"),
                                    content: const Text(
                                        "Would you like to call or send a message?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () async {
                                          final phoneNumber =
                                              widget.operator.mobileNumber;
                                          final Uri callUri = Uri(
                                            scheme: 'tel',
                                            path: phoneNumber,
                                          );

                                          if (await canLaunchUrl(callUri)) {
                                            await launchUrl(callUri);
                                          } else {
                                            print("Could not place call.");
                                          }
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Call"),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          final phoneNumber =
                                              widget.operator.mobileNumber;
                                          final Uri smsUri = Uri(
                                            scheme: 'sms',
                                            path: phoneNumber,
                                          );

                                          if (await canLaunchUrl(smsUri)) {
                                            await launchUrl(smsUri);
                                          } else {
                                            print("Could not send SMS.");
                                          }
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Message"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: customRow(
                              "Emergency:",
                              widget.operator.emergencyNumber.toString(),
                              isDark,
                              context,
                            ),
                          ),
                                                    SizedBox(height: screenHeight(context) * 0.03),

                          customRow(
                            "Address:",
                            widget.operator.fullAddress.toString(),
                            isDark,
                            context,
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(),
              widget.status == "Hiring Completed" ||
                      widget.status == "Accepted" ||
                      widget.operator.uid ==
                          context.read<AuthController>().appUser!.uid
                  ? const SizedBox(height: 30)
                  : Container(),

              // Container(
              //   padding: const EdgeInsets.all(20),
              //   margin: const EdgeInsets.symmetric(horizontal: 5),
              //   decoration: BoxDecoration(
              //     color: isDark
              //         ? const Color.fromARGB(255, 111, 108, 108)
              //         : Colors.white,
              //     borderRadius: BorderRadius.circular(20),
              //   ),
              //   child: Column(
              //     children: [
              //       // Education row
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Text(
              //             "EDUCATION:",
              //             style: TextStyle(
              //                 fontSize: 18,
              //                 fontWeight: FontWeight.w600,
              //                 color: isDark
              //                     ? Colors.white
              //                     : const Color.fromARGB(255, 103, 103, 103)),
              //           ),
              //           Flexible(
              //             child: SizedBox(
              //               width: screenWidth(context) * 0.48,
              //               child: Text(
              //                 "${widget.operator.education.toString()}",
              //                 style: TextStyle(
              //                     fontSize: 16,
              //                     fontWeight: FontWeight.w600,
              //                     color: isDark
              //                         ? Colors.white
              //                         : const Color.fromARGB(
              //                             255, 103, 103, 103)),
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //       SizedBox(height: screenHeight(context) * 0.03),

              //       // Skill row
              //       Row(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Text(
              //             "SKILL:",
              //             style: TextStyle(
              //                 fontSize: 18,
              //                 fontWeight: FontWeight.w600,
              //                 color: isDark
              //                     ? Colors.white
              //                     : const Color.fromARGB(255, 103, 103, 103)),
              //           ),
              //           Flexible(
              //             child: SizedBox(
              //               width: screenWidth(context) * 0.48,
              //               child: Text(
              //                 widget.operator.skills.toString(),
              //                 style: TextStyle(
              //                     fontSize: 16,
              //                     fontWeight: FontWeight.w600,
              //                     color: isDark
              //                         ? Colors.white
              //                         : const Color.fromARGB(
              //                             255, 103, 103, 103)),
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //       SizedBox(height: screenHeight(context) * 0.03),

              //       // Gender row
              //       Row(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Text(
              //             "GENDER:",
              //             style: TextStyle(
              //                 fontSize: 18,
              //                 fontWeight: FontWeight.w600,
              //                 color: isDark
              //                     ? Colors.white
              //                     : const Color.fromARGB(255, 103, 103, 103)),
              //           ),
              //           Flexible(
              //             child: SizedBox(
              //               width: screenWidth(context) * 0.48,
              //               child: Text(
              //                 widget.operator.gender.toString(),
              //                 style: TextStyle(
              //                     fontSize: 16,
              //                     fontWeight: FontWeight.w600,
              //                     color: isDark
              //                         ? Colors.white
              //                         : const Color.fromARGB(
              //                             255, 103, 103, 103)),
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ],
              //   ),
              // ),

              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color.fromARGB(255, 111, 108, 108)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    customRow(
                      "Education:",
                      widget.operator.education.toString(),
                      isDark,
                      context,
                    ),
                    SizedBox(height: screenHeight(context) * 0.03),
                    customRow(
                      "Skill:",
                      widget.operator.skills.toString(),
                      isDark,
                      context,
                    ),
                    SizedBox(height: screenHeight(context) * 0.03),
                    customRow(
                      "Gender:",
                      widget.operator.gender.toString(),
                      isDark,
                      context,
                    ),
                  ],
                ),
              ),
              widget.operator.uid == context.read<AuthController>().appUser!.uid
                  ? const SizedBox()
                  : SizedBox(
                      height: screenHeight(context) * 0.03,
                    ),
              widget.operator.uid == context.read<AuthController>().appUser!.uid
                  ? const SizedBox()
                  : Container(
                      //padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color.fromARGB(255, 111, 108, 108)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(
                                width: 0.5, color: Colors.orange)),
                        title: const Text("Operator Profile"),
                        subtitle: Text(operatorProfile.name.toUpperCase()),
                        leading: operatorProfile.profileUrl != null
                            ? CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(
                                    operatorProfile.profileUrl!),
                              )
                            : CircleAvatar(
                                child: Text(operatorProfile.name[0]),
                              ),
                        trailing: const Icon(Icons.arrow_forward_ios_outlined),
                        onTap: () {
                          // UserModel user = sender;
                          // UserModel operatorProfile = context
                          //     .read<MachineryRegistrationController>()
                          //     .getUser(operatorProfile.uid);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ProfileScreen(
                                    person: operatorProfile,
                                  )));
                        },
                      ),
                    ),
              SizedBox(
                height: screenHeight(context) * 0.03,
              ),
              widget.operator.isHired == true
                  ? Builder(builder: (context) {
                      UserModel hirerUser = context
                          .read<MachineryRegistrationController>()
                          .getUser(widget
                              .operator.hiringRecordForOperator!.last.hirerUid);
                      return Container(
                        //padding: const EdgeInsets.all(20),
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color.fromARGB(255, 111, 108, 108)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: const BorderSide(
                                  width: 0.5, color: Colors.orange)),
                          title: const Text("Hirer Profile"),
                          subtitle: Text(hirerUser.name.toUpperCase()),
                          leading: hirerUser.profileUrl != null
                              ? CircleAvatar(
                                  backgroundImage: CachedNetworkImageProvider(
                                      hirerUser.profileUrl!),
                                )
                              : CircleAvatar(
                                  child: Text(hirerUser.name[0]),
                                ),
                          trailing:
                              const Icon(Icons.arrow_forward_ios_outlined),
                          onTap: () {
                            // UserModel user = sender;
                            // UserModel operatorProfile = context
                            //     .read<MachineryRegistrationController>()
                            //     .getUser(operatorProfile.uid);
                            _appUser.uid == widget.operator.uid ||
                                    _appUser.uid == hirerUser.uid
                                ? Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ProfileScreen(
                                          person: hirerUser,
                                        )))
                                : null;
                          },
                        ),
                      );
                    })
                  : const SizedBox(),

              context.read<MachineryRegistrationController>().isCheckMachies
                  ? const SizedBox()
                  : widget.operator.uid == _appUser.uid
                      ? const SizedBox(
                          height: 10,
                        )
                      : Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0, 16, 0, 10),
                          child: GestureDetector(
                            onTap: operatorProfile.isAvailable == true
                                ? () {
                                    dev.log("Requested");
                                    // Navigator.of(context).push(
                                    //   MaterialPageRoute(
                                    //     builder: (ctx) => RequestFields(machinery: widget.model),
                                    //   ),
                                    // );

                                    if (widget.operator.isAvailable) {
                                      Navigator.pushNamed(context,
                                          AppRouter.operatorHiringScreen,
                                          arguments: widget.operator);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text('Operator is not available'),
                                          duration: Duration(seconds: 3),
                                        ),
                                      );
                                    }
                                  }
                                : null,
                            child: Container(
                              margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                              width: screenWidth(context) * 0.68,
                              height: 56,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Colors.orangeAccent,
                                    Colors.deepOrange,
                                  ],
                                  stops: [0, 1],
                                  begin: AlignmentDirectional(-0.34, 1),
                                  end: AlignmentDirectional(0.34, -1),
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: Text(
                                  widget.operator.isAvailable == true
                                      ? 'Hire Now'
                                      : "Not Available",
                                  style: GoogleFonts.libreBaskerville(
                                    color: Colors.white,
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
            ],
          ),
        ),
      ),
    );
  }
}
