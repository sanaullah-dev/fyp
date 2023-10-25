import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_management_and_booking_system/app/app.dart';
import 'package:vehicle_management_and_booking_system/authentication/controllers/auth_controller.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/machinery_register_controller.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/request_controller.dart';
import 'package:vehicle_management_and_booking_system/models/machinery_model.dart';
import 'package:vehicle_management_and_booking_system/models/report_model.dart';
import 'package:vehicle_management_and_booking_system/screens/admin/reports/report_details.dart';
import 'package:vehicle_management_and_booking_system/screens/login_signup/model/user_model.dart';
import 'package:vehicle_management_and_booking_system/utils/app_colors.dart';
import 'package:vehicle_management_and_booking_system/utils/const.dart';
import 'package:vehicle_management_and_booking_system/utils/media_query.dart';

class MyReports extends StatefulWidget {
  @override
  _MyReportsState createState() => _MyReportsState();
}

class _MyReportsState extends State<MyReports> {
  final CollectionReference _reportsCollection =
      FirebaseFirestore.instance.collection('Reports');
  final CollectionReference _machineriesReportsCollection =
      FirebaseFirestore.instance.collection('MachineriesReports');
  List<ReportModel>? reports;
  List<ReportModel>? machineriesReports;
  late String uid;

  

  Future<void> getAllMachineriesReports() async {
    try {
      QuerySnapshot querySnapshot =
          await _machineriesReportsCollection //.where('reportFrom',isEqualTo: context.read<AuthController>().appUser!.uid)
              .orderBy('dateTime',
                  descending:
                      true) // ordering by the 'date' field in descending order

              .get();
      machineriesReports = querySnapshot.docs
          .map(
              (doc) => ReportModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      // machineriesReports = [...reports!.where((element) => element.requestId == null)];
      setState(() {});
    } catch (e) {
      throw Exception('Error fetching reports: $e');
    }
  }
Future<void> getAllReports() async {
    try {
      QuerySnapshot querySnapshot =
          await _reportsCollection //.where('reportFrom',isEqualTo: context.read<AuthController>().appUser!.uid)
              .orderBy('dateTime',
                  descending:
                      true) // ordering by the 'date' field in descending order

              .get();
      reports = querySnapshot.docs
          .map(
              (doc) => ReportModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      // machineriesReports = [...reports!.where((element) => element.requestId == null)];
      setState(() {});
    } catch (e) {
      throw Exception('Error fetching reports: $e');
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    uid = context.read<AuthController>().appUser!.uid;
    getAllReports();
    getAllMachineriesReports();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
     bool isDark = ConstantHelper.darkOrBright(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Reports",
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
                    "Requests Reports",
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
                    "On Machineries",
                    style: GoogleFonts.quantico(fontWeight: FontWeight.w600),
                  )),
                ),
              )
            ],
          ),
          context.read<RequestController>().isMachineryFavoritesScreen
              ? (reports != null && reports!.isNotEmpty)
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: reports!.length,
                        itemBuilder: (context, index) {
                          //final report = r

                          return _buildReportItem(
                              reports![index], context, false);
                        },
                      ),
                    )
                  : const Center(child: Text('No reports available.'))
              : (machineriesReports != null && machineriesReports!.isNotEmpty)
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: machineriesReports!.length,
                        itemBuilder: (context, index) {
                          //final report = r

                          return _buildReportItem(
                              machineriesReports![index], context, true);
                        },
                      ),
                    )
                  : const Center(child: Text('No reports available.')),
        ],
      ),
    );
  }

//   Widget? _buildReportItem(
//       ReportModel report, BuildContext context, bool isMachineReport) {
//     if (report.reportFrom != uid) {
//       return Container();
//     }
//  final UserModel user;
//  final MachineryModel machine; 
//     if (!isMachineReport) {
//     user = context
//           .read<MachineryRegistrationController>()
//           .allUsers!
//           .firstWhere((u) => u.uid == report.reportOn);
//     }else{
//      machine = context.read<MachineryRegistrationController>().getMachineById(report.machineId);
//     }

//     return Card(
//       elevation: 5.0,
//       margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
//       child: ListTile(
//         leading: !isMachineReport? user.profileUrl != null
//             ? CircleAvatar(
//                 backgroundImage: CachedNetworkImageProvider(
//                 // imageUrl:
//                 user.profileUrl.toString(),
//                 errorListener: () {
//                   log("error");
//                 },
//               ))
//             : CircleAvatar(child: Text(user.name[0])),
//         title: Text(user.name),
//         subtitle: Text(
//           'Status: ${report.status}',
//           style: TextStyle(
//               overflow: TextOverflow.ellipsis,
//               color: report.status == 'Pending' ? Colors.orange : Colors.green),
//         ),
//         trailing: IconButton(
//           icon: const Icon(Icons.arrow_forward_ios),
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => DetailedReportScreen(
//                   report: report,
//                   isAdmin: false,
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
Widget? _buildReportItem(
    ReportModel report, BuildContext context, bool isMachineReport) {
  if (report.reportFrom != uid) {
    return Container();
  }

  if (isMachineReport) {
    final machine =
        context.read<MachineryRegistrationController>().getMachineById(report.machineId);

    return Card(
      elevation: 5.0,
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      child: ListTile(
        leading: machine.images != null
            ? CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(
                  machine.images!.last.toString(),
             
                ),
              )
            : CircleAvatar(child: Text(machine.title[0])),
        title: Text(machine.title),
        subtitle: Text(
          'Status: ${report.status}',
          style: TextStyle(
              overflow: TextOverflow.ellipsis,
              color: report.status == 'Pending' ? Colors.orange : Colors.green),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailedReportScreen(
                  report: report,
                  isAdmin: false,
                  isThisMachineriesReports: true,
                ),
              ),
            );
          },
        ),
      ),
    );
  } else {
    final user = context
        .read<MachineryRegistrationController>()
        .allUsers!
        .firstWhere((u) => u.uid == report.reportOn);

    return Card(
      elevation: 5.0,
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      child: ListTile(
        leading: user.profileUrl != null
            ? CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(
                  user.profileUrl.toString(),
                
                ),
              )
            : CircleAvatar(child: Text(user.name[0])),
        title: Text(user.name),
        subtitle: Text(
          'Status: ${report.status}',
          style: TextStyle(
              overflow: TextOverflow.ellipsis,
              color: report.status == 'Pending' ? Colors.orange : Colors.green),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailedReportScreen(
                  report: report,
                  isAdmin: false,
                  isThisMachineriesReports: false,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

}
