import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vehicle_management_and_booking_system/models/machinery_model.dart';
import 'package:vehicle_management_and_booking_system/screens/login_signup/model/user_model.dart';

void showUserDetails(BuildContext context, UserModel user) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("User Details"),
        content: SingleChildScrollView(
            child: ListBody(
          children: <Widget>[
           // _buildContainer("UID: ${user.uid}"),
            _buildContainer("Name: ${user.name}"),
            _buildContainer("Email: ${user.email}"),
            _buildContainer("Mobile Number: ${user.mobileNumber}"),
            _buildContainer("Languages: ${user.languages}"),
         //   _buildContainer("Profile URL: ${user.profileUrl ?? 'N/A'}"),
            _buildContainer('Blocked: ${user.blockOrNot ==true ?"Blocked":"Not Block"}'),
          //  _buildContainer("iOS Device Info: ${user.ioSDeviceInfo ?? 'N/A'}"),
          //  _buildContainer("Android Device Info: ${user.androidDeviceInfo ?? 'N/A'}"),
           // _buildContainer("FCM: ${user.fcm ?? 'N/A'}"),
            _buildContainer("Is Available: ${user.isAvailable ? 'Yes' : 'No'}"),
            // if (user.allRatings != null && user.allRatings!.isNotEmpty)
            //   for (var rating in user.allRatings!)
            //     ...[
            //       _buildContainer("Rating from ${rating.userId}: ${rating.value}"),
            //       _buildContainer("Comment: ${rating.comment}"),
            //       _buildContainer("Date: ${DateFormat('dd-MM-yyyy').format(rating.date.toDate())}"),
            //     ],
            if (user.blockingComments != null && user.blockingComments!.isNotEmpty)
              for (var comment in user.blockingComments!)
                _buildContainer("Blocking Comment: $comment"),
          ],
        )),
        actions: <Widget>[
          TextButton(
            child: Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Widget _buildContainer(String text) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 8.0),
    padding: const EdgeInsets.all(10.0),
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(5.0),
      border: Border.all(
        color: Colors.grey.shade400,
      ),
    ),
    child: SelectableText(
      text,
      style: TextStyle(fontSize: 16.0, color: Colors.black),
    ),
  );
}



void showMachineryDetails(BuildContext context, MachineryModel machinery) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Machinery Details"),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              _buildContainer("Machinery ID: ${machinery.machineryId}"),
              _buildContainer("Title: ${machinery.title}"),
              _buildContainer("Model: ${machinery.model}"),
              _buildContainer("Address: ${machinery.address}"),
              _buildContainer("Description: ${machinery.description}"),
              _buildContainer("Size: ${machinery.size}"),
              _buildContainer("Charges: ${machinery.charges}"),
              _buildContainer("Emergency Number: ${machinery.emergencyNumber}"),
              _buildContainer(
                  "Location: ${machinery.location.title} (${machinery.location.latitude}, ${machinery.location.longitude})"),
              _buildContainer("Is Available: ${machinery.isAvailable ? 'Yes' : 'No'}"),
              // if (machinery.allRatings != null && machinery.allRatings!.isNotEmpty)
              //   for (var rating in machinery.allRatings!)
              //     ...[
              //       _buildContainer("Rating from ${rating.userId}: ${rating.value},\nComment: ${rating.comment}\nDate: ${rating.date.toDate()}"),
              //       // _buildContainer("Comment: ${rating.comment}"),
              //       // _buildContainer("Date: ${rating.date.toDate()}"),
              //     ],
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

// Widget _buildContainer(String text) {
//   return Container(
//     padding: EdgeInsets.symmetric(vertical: 8.0),
//     child: Text(text),
//   );
// }
