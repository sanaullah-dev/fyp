import 'package:flutter/material.dart';
import 'package:vehicle_management_and_booking_system/screens/admin/admin_show_users.dart';
import 'package:vehicle_management_and_booking_system/screens/admin/admin_toto_operator.dart';
import 'package:vehicle_management_and_booking_system/screens/common/user_total_machineris.dart';
import 'package:vehicle_management_and_booking_system/screens/operator/operators_screen.dart';

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({super.key});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 178, 178, 178),
      appBar: AppBar(
        title: Text("ADMIN"),
      ),
      body: SafeArea(
          child: ListView(
        children: [
          buildCustomCard('Removed Machineries',
              AssetImage("assets/images/doosan.jpeg"), context),
          buildCustomCard(
              'Removed Operators',
              NetworkImage(
                  "https://media.istockphoto.com/id/493915904/photo/construction-worker-contractor-using-tablet.jpg?s=612x612&w=0&k=20&c=XZa72CKStwCgGH1iCRY0ocTk_wZSJK0jJXPpVIbCZ3s="),
              context),
          buildCustomCard(
            'Removed/Block Users',
            NetworkImage(
                "https://media.istockphoto.com/id/1347893227/photo/shot-of-a-unrecognizable-team-of-colleagues-using-digital-tablets-and.jpg?s=612x612&w=0&k=20&c=BBz5gdU8M1PRyKBK-WkTiWEv6kSowZBeB3uV87_Wdbk="),
            context,
          ),
        ],
      )),
    );
  }
}

Widget buildCustomCard(String title, var leading, BuildContext context) {
  return GestureDetector(
    onTap: () {
      title == 'Removed Machineries'
          ? Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
              return MachineryListScreen(isthisAdmin: true);
            }))
          : title == 'Removed Operators'
              ? Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                  return TotalOperatorsAdminScreen();
                }))
              : Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                  return UserListPageForAdmin();
                }));
    },
    child: Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Row(
          children: <Widget>[
            CircleAvatar(
                radius: 30,
                backgroundColor: Colors
                    .grey[200], // change this to your desired color or image
                backgroundImage: leading),
            SizedBox(width: 15),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.chevron_right_outlined, color: Colors.orange),
              onPressed: () {
                // Implement your remove functionality here
              },
            ),
          ],
        ),
      ),
    ),
  );
}
