import 'package:flutter/material.dart';
import 'package:vehicle_management_and_booking_system/app/app.dart';
import 'package:vehicle_management_and_booking_system/screens/common/drawer_items/drawer_screens/contact.dart';
import 'package:vehicle_management_and_booking_system/screens/common/drawer_items/drawer_screens/user_guid.dart';
import 'package:vehicle_management_and_booking_system/utils/app_colors.dart';
import 'package:vehicle_management_and_booking_system/utils/const.dart';

class HelpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isDark = ConstantHelper.darkOrBright(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Help",
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
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // ListTile(
          //   title: const Text('FAQs'),
          //   subtitle: const Text('Frequently Asked Questions'),
          //   onTap: () {
          //     // Navigate to FAQ screen
          //   },
          // ),
          ListTile(
            title: const Text('User Guide'),
            subtitle: const Text('How to use the app'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserGuideScreen(),
                ),
              );
            },
          ),
       
          ListTile(
            title: const Text('Updates'),
            subtitle: const Text('Latest features and improvements'),
            onTap: () {
              // Navigate to Updates screen
            },
          ),
          ListTile(
            title: const Text('App Rating System'),
            subtitle: const Text('How the rating system works'),
            onTap: () {
              showRatingExplanationDialog(context);
            },
          ),
          ListTile(
            title: const Text('Complaints'),
            subtitle: const Text('How to complaints on the requests or machines'),
            onTap: () {
              showComplaintsExplanationDialog(context);
            },
          ),   ListTile(
            title: const Text('Contact Support'),
            subtitle: const Text('Reach out for help'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ContactSupportScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

void showRatingExplanationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Rating System Explained"),
        content: const SingleChildScrollView(
          child: ListBody(
            children: [
              Text(
                "User Rating:",
              ),
              Text(
                "After a machinery owner completes work, the owner has the opportunity to rate the client. This is known as the user rating. It helps future machinery owners understand the credibility of the user.",
              textAlign: TextAlign.justify,),

              SizedBox(height: 10),
              Text(
                "Machinery Rating:",
              ),
              Text(
                "Once the client has experienced the machinery service, they can rate the machinery owner. This helps future clients gauge the quality of service provided.",
                  textAlign: TextAlign.justify,),
              SizedBox(height: 10),
              Text(
                "Operator Booking:",
              ),
              Text(
                "The rating system for operator booking works in a similar way. Both the client and the operator have the opportunity to rate each other after the work is completed.",
               textAlign: TextAlign.justify,),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Got it"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void showComplaintsExplanationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Complaints System Explained"),
        content: const SingleChildScrollView(
          child: ListBody(
            children: [
              Text(
                "If you have a complaint about a machine or request, you can long press on the machine or request. This will open a form where you can submit your complaint. Your complaint will be reviewed by our team and we will take the necessary action.",
                textAlign: TextAlign.justify,
              )
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Got it"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
