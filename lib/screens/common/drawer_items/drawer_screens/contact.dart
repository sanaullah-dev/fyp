import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vehicle_management_and_booking_system/app/app.dart';
import 'package:vehicle_management_and_booking_system/screens/common/drawer_items/widgets/email_phone_card.dart';
import 'package:vehicle_management_and_booking_system/utils/app_colors.dart';
import 'package:vehicle_management_and_booking_system/utils/const.dart';

class ContactSupportScreen extends StatelessWidget {
  Future<void> launchUrl(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      print('Could not launch $uri');
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = ConstantHelper.darkOrBright(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Contact Support",
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Description
              const Text(
                'If you are facing issues or have any questions, you can reach out to us through the following ways:',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 8),
              buildEmailCard('qaisarjamal@gamil.com'),
              const SizedBox(height: 8),
              buildPhoneCard('+92 (313) 9839858', context),
              const SizedBox(height: 8),
              buildEmailCard('sana.dev11211@gmail.com'),
              const SizedBox(height: 8),
              buildPhoneCard('+92 (311) 1733776', context),
              const SizedBox(height: 8),

              // // Email
              // Card(
              //   child: ListTile(
              //     leading: const Icon(Icons.email),
              //     title: const Text('Email'),
              //     subtitle: const Text('sana.dev11211@gmail.com'),
              //     onTap: () async {
              //       const emailAddress = "sana.dev11211@gmail.com";
              //       final Uri emailLaunchUri = Uri(
              //         scheme: 'mailto',
              //         path: emailAddress,
              //       );

              //       await launchUrl(emailLaunchUri);
              //     },
              //   ),
              // ),
              // const SizedBox(height: 8),

              // // Phone
              // Card(
              //   child: ListTile(
              //     leading: const Icon(Icons.phone),
              //     title: const Text('Phone'),
              //     subtitle: const Text('+92 (311) 1733776'),
              //     onTap: () async {
              //       showDialog(
              //         context: context,
              //         builder: (BuildContext context) {
              //           return AlertDialog(
              //             title: Text("What would you like to do?"),
              //             content:
              //                 Text("Would you like to call or send a message?"),
              //             actions: [
              //               TextButton(
              //                 onPressed: () async {
              //                   const phoneNumber = '+923111733776';
              //                   final Uri callUri = Uri(
              //                     scheme: 'tel',
              //                     path: phoneNumber,
              //                   );

              //                   if (await canLaunchUrl(callUri)) {
              //                     await launchUrl(callUri);
              //                   } else {
              //                     print("Could not place call.");
              //                   }
              //                   Navigator.pop(context);
              //                 },
              //                 child: Text("Call"),
              //               ),
              //               TextButton(
              //                 onPressed: () async {
              //                   const phoneNumber = '+923111733776';
              //                   final Uri smsUri = Uri(
              //                     scheme: 'sms',
              //                     path: phoneNumber,
              //                   );

              //                   if (await canLaunchUrl(smsUri)) {
              //                     await launchUrl(smsUri);
              //                   } else {
              //                     print("Could not send SMS.");
              //                   }
              //                   Navigator.pop(context);
              //                 },
              //                 child: Text("Message"),
              //               ),
              //             ],
              //           );
              //         },
              //       );
              //     },
              //   ),
              // ),
              // const SizedBox(height: 8),
              // Card(
              //   child: ListTile(
              //     leading: const Icon(Icons.email),
              //     title: const Text('Email'),
              //     subtitle: const Text('qaisarjamal@gamil.com'),
              //     onTap: () async {
              //       const emailAddress = "qaisarjamal@gamil.com";
              //       final Uri emailLaunchUri = Uri(
              //         scheme: 'mailto',
              //         path: emailAddress,
              //       );

              //       await launchUrl(emailLaunchUri);
              //     },
              //   ),
              // ),
              // const SizedBox(height: 8),

              // // Phone
              // Card(
              //   child: ListTile(
              //     leading: const Icon(Icons.phone),
              //     title: const Text('Phone'),
              //     subtitle: const Text('+92 (313) 9839858'),
              //     onTap: () async {
              //       showDialog(
              //         context: context,
              //         builder: (BuildContext context) {
              //           return AlertDialog(
              //             title: Text("What would you like to do?"),
              //             content:
              //                 Text("Would you like to call or send a message?"),
              //             actions: [
              //               TextButton(
              //                 onPressed: () async {
              //                   const phoneNumber = '+923139839858';
              //                   final Uri callUri = Uri(
              //                     scheme: 'tel',
              //                     path: phoneNumber,
              //                   );

              //                   if (await canLaunchUrl(callUri)) {
              //                     await launchUrl(callUri);
              //                   } else {
              //                     print("Could not place call.");
              //                   }
              //                   Navigator.pop(context);
              //                 },
              //                 child: Text("Call"),
              //               ),
              //               TextButton(
              //                 onPressed: () async {
              //                   const phoneNumber = '+923139839858';
              //                   final Uri smsUri = Uri(
              //                     scheme: 'sms',
              //                     path: phoneNumber,
              //                   );

              //                   if (await canLaunchUrl(smsUri)) {
              //                     await launchUrl(smsUri);
              //                   } else {
              //                     print("Could not send SMS.");
              //                   }
              //                   Navigator.pop(context);
              //                 },
              //                 child: Text("Message"),
              //               ),
              //             ],
              //           );
              //         },
              //       );
              //     },
              //   ),
              // ),
              // const SizedBox(height: 8),
              // FAQ
              // Card(
              //   child: ListTile(
              //     leading: const Icon(Icons.question_answer),
              //     title: const Text('Frequently Asked Questions'),
              //     onTap: () {
              //       // Navigate to FAQ screen if you have one
              //     },
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
