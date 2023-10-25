import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_management_and_booking_system/authentication/controllers/auth_controller.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/machinery_register_controller.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/operator_register_controller.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/request_controller.dart';
import 'package:vehicle_management_and_booking_system/screens/admin/admin_show_users.dart';
import 'package:vehicle_management_and_booking_system/screens/admin/admin_total_operator.dart';
import 'package:vehicle_management_and_booking_system/screens/admin/reports/all_reports_screen.dart';
import 'package:vehicle_management_and_booking_system/screens/admin/reports/completed_reports.dart';
import 'package:vehicle_management_and_booking_system/screens/common/user_total_machineris.dart';

class AdminScreen extends StatefulWidget {
  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {


  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp)async {
    await  context.read<MachineryRegistrationController>().fetchAllUsers();
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Screen'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 0.9,
        children: <Widget>[
          createGridItem(
            index: 0,
            title: 'Activate User Accounts',
            iconData: Icons.account_circle,
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                return UserListPageForAdmin(isActivate: true);
              }));
            },
          ),
          createGridItem(
            index: 1,
            title: 'Block User Accounts',
            iconData: Icons.block,
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                return UserListPageForAdmin(isActivate:false,);
              }));
            },
          ),
          createGridItem(
            index: 2,
            title: 'Remove Operator',
            iconData: Icons.person_remove,
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                return TotalOperatorsAdminScreen();
              }));
            },
          ),
          createGridItem(
            index: 3,
            title: 'Remove Machinery',
            iconData: Icons.construction,
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                return MachineryListScreen(isthisAdmin: true);
              }));
            },
          ),
            createGridItem(
            index: 3,
            title: 'Clients Reports',
            iconData: Icons.report_sharp,
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                return AdminReportScreen(isThisMachineriesReports: false,);
              }));
            },
          ),
            createGridItem(
            index: 3,
            title: 'Completed Reports',
            iconData: Icons.domain_verification_rounded,
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                return CompletedAdminReportScreen(isThisMachineriesReports: false,);
              }));
            },
          ),
           createGridItem(
            index: 3,
            title: 'Machineries Reports',
            iconData: Icons.report_gmailerrorred,
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                return AdminReportScreen(isThisMachineriesReports: true,);
              }));
            },
          ),
            createGridItem(
            index: 3,
            title: 'Completed Machineries Reports',
            iconData: Icons.done_all,
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                return CompletedAdminReportScreen(isThisMachineriesReports: true,);
              }));
            },
          ),
          // createGridItem(
          //   index: 5,
          //   title: 'Activate Machinery',
          //   iconData: Icons.build_circle,
          //   onTap: () {
          //     print('Activate Machinery');
          //   },
          // ),
          // createGridItem(
          //   index: 4,
          //   title: 'Block Machinery',
          //   iconData: Icons.block,
          //   onTap: () {
          //     print('Block Machinery');
          //   },
          // ),
          // createGridItem(
          //   index: 7,
          //   title: 'Activate Operator',
          //   iconData: Icons.person_add,
          //   onTap: () {
          //     print('Activate Operator');
          //   },
          // ),
          // createGridItem(
          //   index: 6,
          //   title: 'Block Operator',
          //   iconData: Icons.block,
          //   onTap: () {
          //     print('Block Operator');
          //   },
         // ),
        ],
      ),
    );
  }

  Widget createGridItem(
      {required int index,
      required String title,
      required IconData iconData,
      required VoidCallback onTap}) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Card(
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  iconData,
                  size: 50.0,
                ),
                SizedBox(height: 10.0),
                Text(
                  title,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
