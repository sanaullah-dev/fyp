// ignore_for_file: library_private_types_in_public_api

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/machinery_register_controller.dart';
import 'package:vehicle_management_and_booking_system/models/report_model.dart';
import 'package:vehicle_management_and_booking_system/screens/admin/reports/report_details.dart';

// ignore: must_be_immutable
class AdminReportScreen extends StatefulWidget {
  AdminReportScreen({super.key, required this.isThisMachineriesReports});
  bool isThisMachineriesReports;
  @override
  _AdminReportScreenState createState() => _AdminReportScreenState();
}

class _AdminReportScreenState extends State<AdminReportScreen> {
  final CollectionReference _reportsCollection =
      FirebaseFirestore.instance.collection('Reports');
  List<ReportModel>? reports;
  final CollectionReference _machineriesReportsCollection =
      FirebaseFirestore.instance.collection('MachineriesReports');
  List<ReportModel>? machineriesReports;
  Future<void> getAllReports() async {
    try {
      QuerySnapshot querySnapshot = await _reportsCollection
          .orderBy('dateTime',
              descending:
                  false) // ordering by the 'date' field in descending order

          .get();
      QuerySnapshot querySnapshotForMachinerisReports =
          await _machineriesReportsCollection
              .orderBy('dateTime',
                  descending:
                      false) // ordering by the 'date' field in descending order
              .get();
      reports = querySnapshot.docs
          .map(
              (doc) => ReportModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      machineriesReports = querySnapshotForMachinerisReports.docs
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
    getAllReports();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Using Provider to get the list of reports
    // var reportsController = Provider.of<RequestController>(context);
    // var reports = reportsController
    //     .reports; // Assuming that your RequestController has a 'reports' getter.

    return Scaffold(
      appBar: AppBar(
        title: widget.isThisMachineriesReports
            ? const Text('Admin Machines Reports')
            : const Text('Admin Report Screen'),
      ),
      body: widget.isThisMachineriesReports ?
      (machineriesReports != null && machineriesReports!.isNotEmpty)
          ? ListView.builder(
              itemCount: machineriesReports!.length,
              itemBuilder: (context, index) {
                //final report = r

                return _buildReportItem(machineriesReports![index], context);
              },
            )
          : const Center(child: Text('No reports available.'))
      :
      
       (reports != null && reports!.isNotEmpty)
          ? ListView.builder(
              itemCount: reports!.length,
              itemBuilder: (context, index) {
                //final report = r

                return _buildReportItem(reports![index], context);
              },
            )
          : const Center(child: Text('No reports available.')),
    );
  }

  Widget? _buildReportItem(ReportModel report, BuildContext context) {
    if (report.status == 'completed') {
      return Container();
    }

    if (widget.isThisMachineriesReports) {
      final machine = context
          .read<MachineryRegistrationController>()
          .getMachineById(report.machineId);

      // Adjust the widget rendering logic based on the machine details
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
            '${report.dateTime}',
            style: const TextStyle(overflow: TextOverflow.ellipsis),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailedReportScreen(
                    report: report,
                    isAdmin: true,
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
          .firstWhere((u) => u.uid == report.reportFrom);

      // Your existing user details rendering logic
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
            'Description: ${report.description}',
            style: const TextStyle(overflow: TextOverflow.ellipsis),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailedReportScreen(
                    report: report,
                    isAdmin: true,
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
