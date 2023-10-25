import 'dart:convert';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_management_and_booking_system/app/app.dart';
import 'package:vehicle_management_and_booking_system/app/router.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/machinery_register_controller.dart';
import 'package:vehicle_management_and_booking_system/models/request_machiery_model.dart';
import 'package:vehicle_management_and_booking_system/screens/common/drawer_items/receive_requests_screen.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:vehicle_management_and_booking_system/screens/common/drawer_items/send_requests_screen.dart';

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void initNotifications(BuildContext context) async {
    var androidInitialize =
        const AndroidInitializationSettings("@mipmap/ic_launcher");
    var iOSInitialize = const DarwinInitializationSettings();
    var initializationsSettings =
        InitializationSettings(android: androidInitialize, iOS: iOSInitialize);

    flutterLocalNotificationsPlugin.initialize(initializationsSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse response) async {
      if (response.payload != null) {
        Map<String, dynamic> data = jsonDecode(response.payload!);
        handleMessage(context, RemoteMessage.fromMap(data));
      }
    });
  }

  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      message.notification!.android!.channelId ?? "defautl",
      message.notification!.android!.channelId ?? "defaulChannelId",
      importance: Importance.max,
      showBadge: true,
      playSound: true,
      // sound: const RawResourceAndroidNotificationSound('jetsons_doorbell'),
    );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            channel.id.toString(), channel.name.toString(),
            channelDescription: 'your channel description',
            importance: Importance.high,
            priority: Priority.high,
            playSound: true,
            ticker: 'ticker',

            // sound: channel.sound
            //     sound: RawResourceAndroidNotificationSound('jetsons_doorbell')
            icon: "@mipmap/ic_launcher");

    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    var generalNotificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    // You could include the message.data in the AndroidNotificationDetails as a payload
    Future.delayed(Duration.zero, () {
      log("show messeage");
      flutterLocalNotificationsPlugin.show(
          0,
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          generalNotificationDetails,
          payload: jsonEncode(message.toMap()));
    });
  }

  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken(
        vapidKey:
            "BNeNNvWWq60dOponfdIKFChQ9vHPD7JDrTUUrWc7F04svQWUpP1ha66PwWC4S_oPJ3Xd6C0mmnejPKKc2qowqiY");
    return token!;
  }

  void handleInteractMessage(Map<String, Object> message) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('onMessage data: ${message.data}');
      }
      // Handle the message received
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('onMessageOpenedApp data: ${message.data}');
      }
      // Handle the message when the app is opened from a terminated state
    });
  }

  void requestNotificationPermissions() {
    messaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true);
  }

  void handleForegroundMessage() {
    log("m.........kekke");
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (kDebugMode) {
        print('A new onMessage event was published!');
      }
      await showNotification(message);
    });
  }

  //handle tap on notification when app is in background or terminated
  Future<void> setupInteractMessage(BuildContext context) async {
    // when app is terminated
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      // ignore: use_build_context_synchronously
      handleMessage(context, initialMessage);
    }

    //when app ins background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(context, event);
    });
  }

  // void handleMessage(BuildContext context, RemoteMessage message) {
  //   var messageType = message.data['type'];

  //   if (messageType != null) {
  //     switch (messageType) {
  //       case 'machine':
  //         Navigator.pushNamed(context, AppRouter.receiverRequest);
  //         break;
  //       case 'activation':
  //         Navigator.pushNamed(context, AppRouter.dashBoard);
  //         break;
  //       // Add more cases if you have multiple types
  //       // case 'ANOTHER_TYPE':
  //       //   // Handle another type
  //       //   break;

  //       default:
  //         print('Unknown type $messageType');
  //     }
  //   } else {
  //     print('No type field in the message data');
  //   }
  // }

  void handleMessage(BuildContext context, RemoteMessage message) {
    var messageType = message.data['type'];
    // var messageType = message.data['type'];
    var words = messageType.split(' ');
    var firstSevenWords = words[0];
    log(firstSevenWords.toString());

    if (firstSevenWords != null) {
      switch (firstSevenWords) {
        case 'machine':
          navigatorKey.currentState!.pushNamed(AppRouter.receiverRequest,
              arguments: {'isHiring': null, 'isNotifications': true});
          break;
        case 'activation':
          navigatorKey.currentState!.pushNamed(AppRouter.receiverRequest,
              arguments: {'isHiring': null, 'isNotifications': true});
          break;
        case 'cancel':
          navigatorKey.currentState!.pushNamed(AppRouter.sendRequest,
              arguments: {'isOperater': true, 'isNotifications': true});

          break;
        case 'hiring':
          navigatorKey.currentState!.pushNamed(AppRouter.receiverRequest,
              arguments: {'isHiring': false, 'isNotifications': true});

          break;
        case 'acceptance':
          navigatorKey.currentState!.pushNamed(AppRouter.sendRequest,
              arguments: {'isOperater': false, 'isNotifications': true});

          break;
        case 'rejection':
          navigatorKey.currentState!.pushNamed(AppRouter.sendRequest,
              arguments: {'isOperater': false, 'isNotifications': true});
          break;
        case 'message':
          RequestModelForMachieries request = context
              .read<MachineryRegistrationController>()
              .allRequests!
              .firstWhere((element) => element.requestId == words[1]);
          navigatorKey.currentState!
              .pushNamed(AppRouter.messagesScreen, arguments: request);
          break;

        //     });
        //   }));
        //   break;
        // Add more cases if you have multiple types
        // case 'ANOTHER_TYPE':
        //   // Handle another type
        //   break;

        default:
          break;
      }
    } else {
      print('No type field in the message data');
    }
  }

  // log(messageType);
  // RequestModelForMachieries req = context
  //     .read<MachineryRegistrationController>()
  //     .allRequests!
  //     .firstWhere((temp) => messageType == temp.requestId);

  Future forgroundMessage() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void messageListener(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print(
            'Message also contained a notification: ${message.notification!.body}');
        showDialog(
            context: context,
            builder: ((BuildContext context) {
              return DynamicDialog(
                  title: message.notification!.title,
                  body: message.notification!.body);
            }));
      }
    });
  }

  Future<void> remindMeLater({required int hoursLater}) async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'reminder_id',
      'Reminders',
      channelDescription: 'Reminder Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    final platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: const DarwinNotificationDetails(),
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Reminder',
      'This is your reminder!',
      tz.TZDateTime.now(tz.local).add(Duration(seconds: 30)),
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exact,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}

//push notification dialog for foreground
class DynamicDialog extends StatefulWidget {
  final title;
  final body;
  DynamicDialog({this.title, this.body});
  @override
  _DynamicDialogState createState() => _DynamicDialogState();
}

class _DynamicDialogState extends State<DynamicDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      actions: <Widget>[
        OutlinedButton.icon(
            label: const Text('Close'),
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close)),
        OutlinedButton.icon(
            label: const Text('Open'),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ReceivedRequestsScreen()));
            },
            icon: const Icon(Icons.done)),
      ],
      content: Text(widget.body),
    );
  }
}
