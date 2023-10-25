// ignore_for_file: library_private_types_in_public_api

import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/machinery_register_controller.dart';
import 'package:vehicle_management_and_booking_system/models/report_model.dart';
import 'package:vehicle_management_and_booking_system/screens/admin/reports/report_details.dart';

class CompletedAdminReportScreen extends StatefulWidget {
  CompletedAdminReportScreen(
      {super.key, required this.isThisMachineriesReports});
  bool isThisMachineriesReports;
  @override
  _CompletedAdminReportScreenState createState() =>
      _CompletedAdminReportScreenState();
}

class _CompletedAdminReportScreenState
    extends State<CompletedAdminReportScreen> {
  final CollectionReference _reportsCollection =
      FirebaseFirestore.instance.collection('Reports');
  List<ReportModel>? reports;
  final CollectionReference _machineriesReportsCollection =
      FirebaseFirestore.instance.collection('MachineriesReports');
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
      QuerySnapshot querySnapshot = await _reportsCollection
          .orderBy('dateTime',
              descending:
                  false) // ordering by the 'date' field in descending order

          .get();
      reports = querySnapshot.docs
          .map(
              (doc) => ReportModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      setState(() {});
    } catch (e) {
      throw Exception('Error fetching reports: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    widget.isThisMachineriesReports
        ? getAllMachineriesReports()
        : getAllReports();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // List<ReportModel> reportsTemp =
    //     widget.isThisMachineriesReports ? machineriesReports! : reports!;

    // Using Provider to get the list of reports
    // var reportsController = Provider.of<RequestController>(context);
    // var reports = reportsController
    //     .reports; // Assuming that your RequestController has a 'reports' getter.

    return Scaffold(
      appBar: AppBar(
        title: const Text('Completed Admin Report Screen'),
      ),
      body: (reports != null && reports!.isNotEmpty)
          ? ListView.builder(
              itemCount: reports!.length,
              itemBuilder: (context, index) {
                //final report = r

                return _buildReportItem(
                    reports![index], context, widget.isThisMachineriesReports);
              },
            )
          : (machineriesReports != null && machineriesReports!.isNotEmpty)
              ? ListView.builder(
                  itemCount: machineriesReports!.length,
                  itemBuilder: (context, index) {
                    //final report = r

                    return _buildReportItem(machineriesReports![index], context,
                        widget.isThisMachineriesReports);
                  },
                )
              : const Center(child: Text('No reports available.')),
    );
  }

  // Widget? _buildReportItem(ReportModel report, BuildContext context) {
  //   if (report.status == 'Pending') {
  //     return Container();
  //   }

  //   final user = context
  //       .read<MachineryRegistrationController>()
  //       .allUsers!
  //       .firstWhere((u) => u.uid == report.reportFrom);

  //   return Card(
  //     elevation: 5.0,
  //     margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
  //     child: ListTile(
  //       leading: user.profileUrl != null
  //           ? CircleAvatar(
  //               backgroundImage: CachedNetworkImageProvider(
  //               // imageUrl:
  //               user.profileUrl.toString(),
  //               errorListener: () {
  //                 log("error");
  //               },
  //             ))
  //           : CircleAvatar(child: Text(user.name[0])),
  //       title: Text(user.name),
  //       subtitle: Text(
  //         'Status: ${report.status}',
  //         style: const TextStyle(
  //             overflow: TextOverflow.ellipsis, color: Colors.orange),
  //       ),
  //       trailing: IconButton(
  //         icon: const Icon(Icons.arrow_forward_ios),
  //         onPressed: () {
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => DetailedReportScreen(
  //                 report: report,
  //                 isCompleted: true,
  //                 isAdmin: true,
  //                 isThisMachineriesReports: false,
  //               ),
  //             ),
  //           );
  //         },
  //       ),
  //     ),
  //   );
  // }

  Widget? _buildReportItem(
      ReportModel report, BuildContext context, bool isMachineReport) {
    if (report.status != "completed") {
      return Container();
    }

    if (isMachineReport) {
      final machine = context
          .read<MachineryRegistrationController>()
          .getMachineById(report.machineId);

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
                color:
                    report.status == 'Pending' ? Colors.orange : Colors.green),
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
                color:
                    report.status == 'Pending' ? Colors.orange : Colors.green),
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
