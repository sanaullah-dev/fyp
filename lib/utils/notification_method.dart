import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class NotificationMethod {
  Future<void> sendNotification({
    required String fcm,
    required String title,
    required String body,
    required String type,
  }) async {
    var data = {
      'to': fcm.toString(),
      'notification': {
        'title': title,
        'body': body,
      },
      'android': {
        'notification': {
          'channel_id': const Uuid().v1().toString(),
          'notification_count': 23,
        },
      },
      'data': {
        'type': type,
        'id': 'Sana ULLAH' // Maybe make this dynamic?
      }
    };

    try {
      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        body: jsonEncode(data),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
              'key=AAAAbPIdHGg:APA91bFiPdN7T0lYK_o8xAw2ySX7KAi8EdP9-v0eRC809Z8qRQ6eShnibU-AcRhMAuImfIxT_FK1Hz0Rx1NDKNcTYsBmqUZRO5PkDVpvEIgO1OTKYyl-YEr7otfG24Ygl13Tyd1fF0H9'
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to send notification. Error: ${response.body}');
      }
    } catch (error) {
      print(error);
    }
  }
}
