import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_management_and_booking_system/app/app.dart';
import 'package:vehicle_management_and_booking_system/authentication/controllers/auth_controller.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/machinery_register_controller.dart';
import 'package:vehicle_management_and_booking_system/models/machinery_model.dart';
import 'package:vehicle_management_and_booking_system/models/report_model.dart';
import 'package:vehicle_management_and_booking_system/models/request_machiery_model.dart';
import 'package:vehicle_management_and_booking_system/screens/admin/widgets/on_complete_report.dart';
import 'package:vehicle_management_and_booking_system/screens/admin/widgets/request_details_for_admin.dart';
import 'package:vehicle_management_and_booking_system/screens/admin/widgets/user_details_for_admin_dialog_box.dart';
import 'package:vehicle_management_and_booking_system/screens/common/image_viewer.dart';
import 'package:vehicle_management_and_booking_system/screens/common/messages_screen.dart';
import 'package:vehicle_management_and_booking_system/screens/common/profile_screen.dart';
import 'package:vehicle_management_and_booking_system/screens/login_signup/model/user_model.dart';
import 'package:vehicle_management_and_booking_system/screens/machinery/machinery_detials.dart';
import 'package:vehicle_management_and_booking_system/utils/app_colors.dart';
import 'package:vehicle_management_and_booking_system/utils/const.dart';
import 'package:vehicle_management_and_booking_system/utils/media_query.dart';

class DetailedReportScreen extends StatefulWidget {
  final ReportModel report;
  final bool? isCompleted;
  final bool? isAdmin;
  final bool isThisMachineriesReports;

  DetailedReportScreen(
      {required this.report,
      this.isCompleted,
      this.isAdmin,
      required this.isThisMachineriesReports});

  @override
  _DetailedReportScreenState createState() => _DetailedReportScreenState();
}

class _DetailedReportScreenState extends State<DetailedReportScreen> {
  // late Future<UserModel> userFuture;
  // late Future<MachineryModel> machineryFuture;

  late UserModel reportFromUser;
  late UserModel reportOn;
  late MachineryModel machine;

  @override
  void initState() {
    reportFromUser = context
        .read<MachineryRegistrationController>()
        .allUsers!
        .firstWhere((u) => u.uid == widget.report.reportFrom);
    reportOn = context
        .read<MachineryRegistrationController>()
        .allUsers!
        .firstWhere((u) => u.uid == widget.report.reportOn);
    machine = context
        .read<MachineryRegistrationController>()
        .allMachineries!
        .firstWhere((u) => u.machineryId == widget.report.machineId);
    super.initState();
    // userFuture = fetchUser(widget.report.reportFrom);
    // machineryFuture = fetchMachinery(widget.report.machineId);
  }

  // Future<UserModel> fetchUser(String uid) async {
  //   DocumentSnapshot doc = await FirebaseFirestore.instance.collection('Users').doc(uid).get();
  //   return UserModel.fromJson(doc.data() as Map<String, dynamic>);
  // }

  // Future<MachineryModel> fetchMachinery(String machineId) async {
  //   DocumentSnapshot doc = await FirebaseFirestore.instance.collection('Machineries').doc(machineId).get();
  //   return MachineryModel.fromJson(doc.data() as Map<String, dynamic>);
  // }

  @override
  Widget build(BuildContext context) {
      bool isDark = ConstantHelper.darkOrBright(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Report Details",
          style: TextStyle(color: isDark || widget.isAdmin==true ? null : Colors.black),
        ),
        backgroundColor: isDark || widget.isAdmin==true ? null : AppColors.accentColor,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              navigatorKey.currentState!.pop();
            },
            icon: Icon(
              Icons.arrow_back_ios_new_sharp,
              color: isDark || widget.isAdmin==true ? null : AppColors.blackColor,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          children: [
            // Text('Report ID: ${widget.report.reportId}'),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                ),
                //color: Colors.orange,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  buildReportItem(
                      context: context,
                      profileUrl: reportFromUser.profileUrl,
                      name: reportFromUser.name,
                      subtitle: SelectableText(
                          '${reportFromUser.email} ${widget.isAdmin == true ? "\nUID:${reportFromUser.uid}" : ""}'), // Wrap the string in a Text widget
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: ((context) {
                          return ProfileScreen(person: reportFromUser);
                        })));
                      },
                      label: "Report from this user",
                      user: reportFromUser,
                      isAdmin: widget.isAdmin),
                  widget.isAdmin == true
                      ? OutlinedButton(
                          onPressed: () {
                            showUserDetails(context, reportFromUser);
                          },
                          child: const Text("More Details about Above User"))
                      : Container(),
                ],
              ),
            ),

            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                ),
                //color: Colors.orange,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  buildReportItem(
                    context: context,
                    profileUrl: machine.images?.last,
                    name: machine.title,
                    subtitle: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.star,
                                color: Colors.orange, size: 18),
                            Text(
                                '${machine.rating.toStringAsFixed(1).toString()}'),
                          ],
                        ),
                        widget.isAdmin ==true?
                        SelectableText(widget.isThisMachineriesReports
                            ? "\nID: ${machine.machineryId}"
                            : ""):SizedBox(),
                      ],
                    ),
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: ((context) {
                        return DetalleWidget(model: machine);
                      })));
                    },
                    label: "Report on this machine",
                    isMachine: true,
                    isAdmin: widget.isAdmin,
                  ),
                  widget.isAdmin == true && widget.isThisMachineriesReports
                      ? OutlinedButton(
                          onPressed: () {
                            showMachineryDetails(context, machine);
                          },
                          child: const Text("More Details about Above Machine"))
                      : Container(),
                ],
              ),
            ),
            const SizedBox(height: 5),

            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                border: Border.all(width: 1),
                //color: Colors.orange,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  buildReportItem(
                      isAdmin: widget.isAdmin,
                      context: context,
                      profileUrl: reportOn.profileUrl,
                      name: reportOn.name,
                      subtitle: SelectableText(
                          '${reportOn.email} ${widget.isAdmin == true ? "\nUID:${reportOn.uid}" : ""}'), // Wrap the string in a Text widget
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: ((context) {
                          return ProfileScreen(person: reportOn);
                        })));
                      },
                      label: "Report on this user",
                      user: reportOn),
                  widget.isAdmin == true
                      ? OutlinedButton(
                          onPressed: () {
                            showUserDetails(context, reportOn);
                          },
                          child: const Text("More Details about Above User"))
                      : Container(),
                ],
              ),
            ),

            // SizedBox(height: 10),
            // Text('Reported On: ${widget.report.reportOn}'),
            const SizedBox(height: 10),
            //Text('Description: ${widget.report.description}'),
            const SizedBox(height: 10),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              color: Colors
                  .white, // Assuming you want a white background for the text
              child: const Text(
                "Report Related Images",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                ...widget.report.images?.map((url) => GestureDetector(
                          onTap: () {
                            //    Navigator.pushNamed(context,'/image',arguments:{'imageUrl': url});
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: ((context) {
                              return ImageFromUrlViewer(image: url);
                            })));
                            // log(DateTime.now().toString());
                          },
                          child: Container(
                              margin: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 0.5,
                                  ),
                                  borderRadius: BorderRadius.circular(20)),
                              height: screenHeight(context) * 0.5,
                              width: screenWidth(context) * 0.65,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: Image.network(
                                  url,
                                  fit: BoxFit.cover,
                                ),
                              )),
                        )) ??
                    [],
              ]),
            ),

            const SizedBox(height: 20),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  color: Colors
                      .white, // Assuming you want a white background for the text
                  child: const Text(
                    "Description",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.5),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text(
                      widget.report.description,
                      style: const TextStyle(),
                      textAlign: TextAlign.justify,
                    )),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(width: 0.5),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Status : ${widget.report.status} ",
                    style: const TextStyle(),
                  ),
                  Text(
                      "Date of Report: ${DateFormat('dd-MM-yyyy').format(widget.report.dateTime)}"),
                  const SizedBox(
                    height: 10,
                  ),
                  widget.isThisMachineriesReports
                      ? SizedBox()
                      : widget.isAdmin != true
                          ? Container()
                          : Builder(builder: (context) {
                              RequestModelForMachieries request = context
                                  .read<MachineryRegistrationController>()
                                  .allRequests!
                                  .firstWhere((element) =>
                                      element.requestId ==
                                      widget.report.requestId);

                              return Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // TODO: Implement functionality to check conversation
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: ((context) {
                                          return MessagesScreen(
                                            request: request,
                                            isAdmin: true,
                                          );
                                        })));
                                      },
                                      child: const Text('Check Conversation'),
                                    ),
                                  ),
                                  const SizedBox(
                                      width:
                                          8.0), // Provide some spacing between the buttons
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // TODO: Implement functionality to check request details
                                        showRequestDetails(context, request);
                                      },
                                      child:
                                          const Text('Check Request Details'),
                                    ),
                                  ),
                                ],
                              );
                            }),
                ],
              ),
            ),

            const SizedBox(height: 10),
            widget.isCompleted == true || (widget.isAdmin != true)
                ? widget.report.comment == ""
                    ? const SizedBox()
                    : Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border.all(width: 0.5),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Text('Comment: ${widget.report.comment!}'))
                : ElevatedButton(
                    onPressed: () {
                      showUpdateDialog(context, widget.report,
                          widget.isThisMachineriesReports);
                    },
                    child: const Text("Relief Granted/Completed"))
          ],
        ),
      ),
    );
  }
}

Widget buildReportItem(
    {required BuildContext context,
    required String? profileUrl,
    required String name,
    required Widget subtitle,
    required Function onTap,
    required String label,
    UserModel? user,
    bool? isMachine,
    bool? isAdmin}) {
  return Stack(
    children: [
      ListTile(
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
        onTap: () => onTap(),
        leading: profileUrl != null
            ? CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(
                // imageUrl:
                profileUrl.toString(),
          
              ))
            : CircleAvatar(child: Text(name[0])),
        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        subtitle: subtitle,
        trailing: isAdmin != true
            ? null
            : isMachine == true
                ? null
                : SingleChildScrollView(
                    child: Container(
                      child: Column(
                        children: [
                          Text(user!.blockOrNot! ? "Unblock" : "Block"),
                          Switch(
                              value: user.blockOrNot!,
                              onChanged: ((value) async {
                                try {
                                  if (user!.blockOrNot == true) {
                                    user.blockOrNot = false;
                                    await context
                                        .read<AuthController>()
                                        .updateUserForBlock(user);
                                    //  users!.remove(user);
                                    //  setState(() {});
                                  } else {
                                    await showBlockDialog(user, context);
                                    // user.blockOrNot = true;
                                    // await context
                                    //     .read<AuthController>()
                                    //     .updateUserForBlock(user);
                                    //     users!.remove(user);
                                    // setState(() {});
                                  }
                                } catch (e) {
                                  log("Error: $e");
                                }
                              })),
                        ],
                      ),
                    ),
                  ),
      ),
      Positioned(
        top: 0,
        left: 0,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 4.0,
          ),
          color: Colors.white,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ],
  );
}

Future<void> showBlockDialog(UserModel user, BuildContext context) async {
  String? comment; // To store the comment entered by the admin

  return showDialog<void>(
    context: context,
    barrierDismissible: false, // User must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Block User'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              const Text('Please provide a reason for blocking the user.'),
              TextField(
                onChanged: (value) {
                  comment = value;
                },
                decoration: const InputDecoration(hintText: "Enter comment"),
              )
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Block'),
            onPressed: () async {
              user.blockOrNot = true;
              // Initialize blockingComments list if it is null
              user.blockingComments ??= [];

              // Add the new comment to the list of blocking comments
              if (comment != null && comment!.isNotEmpty) {
                user.blockingComments!.add(comment!);
              }
              // You might want to add the comment to the UserModel
              // or store it separately based on your needs
              if (comment!.isNotEmpty) {
                await context.read<AuthController>().updateUserForBlock(user);

                Navigator.of(context).pop();
              }
            },
          ),
        ],
      );
    },
  );
}
