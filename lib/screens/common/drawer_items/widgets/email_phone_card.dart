import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Widget buildEmailCard(String email) {
  return Card(
    child: ListTile(
      leading: const Icon(Icons.email),
      title: const Text('Email'),
      subtitle: Text(email),
      onTap: () async {
        final Uri emailLaunchUri = Uri(scheme: 'mailto', path: email);
        await launchUrl(emailLaunchUri);
      },
    ),
  );
}

Widget buildPhoneCard(String phoneNumber, BuildContext context) {
  return Card(
    child: ListTile(
      leading: const Icon(Icons.phone),
      title: const Text('Phone'),
      subtitle: Text(phoneNumber),
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("What would you like to do?"),
              content: const Text("Would you like to call or send a message?"),
              actions: [
                TextButton(
                  onPressed: () async {
                    final Uri callUri = Uri(scheme: 'tel', path: phoneNumber);
                    await launchUrl(callUri);
                    Navigator.pop(context);
                  },
                  child: const Text("Call"),
                ),
                TextButton(
                  onPressed: () async {
                    final Uri smsUri = Uri(scheme: 'sms', path: phoneNumber);
                    await launchUrl(smsUri);
                    Navigator.pop(context);
                  },
                  child: const Text("Message"),
                ),
              ],
            );
          },
        );
      },
    ),
  );
}
