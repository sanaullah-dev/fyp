import 'package:flutter/material.dart';
import 'package:vehicle_management_and_booking_system/screens/login_signup/model/user_model.dart';
import 'package:vehicle_management_and_booking_system/utils/media_query.dart';

// ignore: must_be_immutable
class BlockScreen extends StatefulWidget {
   BlockScreen({super.key, required this.user});
UserModel user;
  @override
  State<BlockScreen> createState() => _BlockScreenState();
}

class _BlockScreenState extends State<BlockScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          // mainAxisSize: MainAxisSize.min,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
            
              height: screenHeight(context)*0.8,
              width: screenWidth(context),
              margin: const EdgeInsets.all(20.0),
              child: Container(
                padding: const EdgeInsets.all(10.0),
                child:  Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.block,
                      size: 50.0,color: Colors.red,
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      "User Blocked",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red),
                    ),
                       SizedBox(height: 10.0),
                     Text(
                    widget.user.blockingComments!.last,
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
