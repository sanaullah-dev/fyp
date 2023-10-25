import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_management_and_booking_system/app/app.dart';
import 'package:vehicle_management_and_booking_system/authentication/controllers/auth_controller.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/machinery_register_controller.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/request_controller.dart';
import 'package:vehicle_management_and_booking_system/models/messages_model.dart';
import 'package:vehicle_management_and_booking_system/models/operator_request_model.dart';
import 'package:vehicle_management_and_booking_system/models/request_machiery_model.dart';
import 'package:vehicle_management_and_booking_system/screens/common/drawer_items/operator_requests.dart';
import 'package:vehicle_management_and_booking_system/screens/common/profile_screen.dart';
import 'package:vehicle_management_and_booking_system/screens/login_signup/model/user_model.dart';
import 'package:vehicle_management_and_booking_system/utils/app_colors.dart';
import 'package:vehicle_management_and_booking_system/utils/const.dart';
import 'package:vehicle_management_and_booking_system/utils/media_query.dart';
import 'package:vehicle_management_and_booking_system/utils/notification_method.dart';

class MessagesScreen extends StatefulWidget {
  // final String requestId;
  final RequestModelForMachieries? request;
  final bool? isAdmin;
  final HiringRequestModel? hiringRequestModel;

  MessagesScreen({
    //required this.requestId
    this.request,
    this.isAdmin,
    this.hiringRequestModel,
  });

  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  Stream<QuerySnapshot> getMessages(String requestId) {
    return FirebaseFirestore.instance
        .collection('chats') // assuming you have a 'requests' collection
        .doc(requestId)
        .collection(
            'messages') // assuming each request document has a sub-collection called 'messages'
        .orderBy('timestamp',
            descending:
                false) // sorting by timestamp so newest messages appear at the bottom
        .snapshots(); // listening to realtime updates
  }

  final TextEditingController _messageController = TextEditingController();
  UserModel? _appUser;
  UserModel? _otherUser;
  final ScrollController _scrollController = ScrollController();
  //late String fcm;

  @override
  void initState() {
    // TODO: implement initState
    _appUser = context.read<AuthController>().appUser;
    _otherUser = widget.hiringRequestModel == null
        ? context.read<MachineryRegistrationController>().getUser(
            widget.request!.senderUid == _appUser!.uid
                ? widget.request!.machineryOwnerUid
                : widget.request!.senderUid)
        : context.read<MachineryRegistrationController>().getUser(
            widget.hiringRequestModel!.operatorUid == _appUser!.uid
                ? widget.hiringRequestModel!.hirerUserId
                : widget.hiringRequestModel!.operatorUid);
    // fcm = _otherUser!.fcm!;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = ConstantHelper.darkOrBright(context);
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              navigatorKey.currentState!.pop();
            },
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: isDark ? null : AppColors.blackColor,
            ),
          ),
          backgroundColor: isDark ? null : AppColors.accentColor,
          titleSpacing: 0.0,
          title: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ProfileScreen(
                  person: _otherUser,
                );
              }));
              // showAlert(context,
              //     sender: sender,
              //     machine: machines,
              //     request: requests[index]);
            },
            child: Row(
              children: [
                _otherUser!.profileUrl != null
                    ? CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                        // imageUrl:

                        _otherUser!.profileUrl.toString(),
                
                      ))
                    : CircleAvatar(child: Text(_otherUser!.name[0])),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  _otherUser!.name,
                  style: TextStyle(
                    color: isDark ? null : AppColors.blackColor,
                  ),
                ),
              ],
            ),
          )),
      // bool _isDark = ConstantHelper.darkOrBright(context);
      // return Scaffold(
      //   appBar: AppBar(
      //       titleSpacing: 0.0,
      //       title: Row(
      //         children: [
      //           _otherUser!.profileUrl != null
      //               ? CircleAvatar(
      //                   backgroundImage: CachedNetworkImageProvider(
      //                   // imageUrl:
      //                   _otherUser!.profileUrl.toString(),
      //                   errorListener: () {
      //                     log("error");
      //                   },
      //                 ))
      //               : CircleAvatar(child: Text(_otherUser!.name[0])),
      //           const SizedBox(
      //             width: 10,
      //           ),
      //           Text(_otherUser!.name),
      //         ],
      //       )),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: widget.hiringRequestModel == null
                    ? getMessages(widget.request!.requestId)
                    : getMessages(widget.hiringRequestModel!.requestId),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  List<DocumentSnapshot> docs = snapshot.data!.docs;
                  List<Message> messages =
                      docs.map((doc) => Message.fromFirestore(doc)).toList();

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  });
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      String senderUid = widget.hiringRequestModel == null
                          ? widget.request!.senderUid
                          : widget.hiringRequestModel!.hirerUserId;
                      //String receiverUid = widget.request.machineryOwnerUid;

                      final message = messages[index];
                      bool isMe = message.senderId ==
                          _appUser!
                              .uid; // replace 'YOUR_CURRENT_USER_ID' with logic to get the current user's ID

                      return widget.isAdmin == true
                          ? ListTile(
                              title: Align(
                                alignment: message.senderId == senderUid
                                    ? Alignment.topRight
                                    : Alignment.topLeft,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isMe
                                        ? Colors.orange
                                        : isDark
                                            ? Colors.grey.shade700
                                            : Colors.grey[300],
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(message.messageText),
                                ),
                              ),
                            )
                          : ListTile(
                              title: Align(
                                alignment: isMe
                                    ? Alignment.topRight
                                    : Alignment.topLeft,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isMe
                                        ? Colors.orange
                                        : isDark
                                            ? Colors.grey.shade700
                                            : Colors.grey[300],
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(message.messageText),
                                ),
                              ),
                            );
                    },
                  );
                },
              ),
            ),
            widget.isAdmin == true
                ? Builder(
                    builder: (context) {
                      // UserModel user1 = context
                      //     .read<MachineryRegistrationController>()
                      //     .getUser(widget.request.senderUid);

                      UserModel user2 = context
                          .read<MachineryRegistrationController>()
                          .getUser(widget.hiringRequestModel == null
                              ? widget.request!.machineryOwnerUid
                              : widget.hiringRequestModel!.operatorUid);

                      return Card(
                        elevation: 0.0,
                        // margin: const EdgeInsets.all(10.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            //  mainAxisSize: MainAxisSize.min,
                            //  crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // _buildUserDetail(user1.name),
                              // Container(color: Colors.orange,width: 1,height: 30,),
                              _buildUserDetail(user2.name, user2.profileUrl),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                :
                //  Builder(builder: (context) {
                //     UserModel user1 = context
                //         .read<MachineryRegistrationController>()
                //         .getUser(widget.request.senderUid);
                //     UserModel user2 = context
                //         .read<MachineryRegistrationController>()
                //         .getUser(widget.request.machineryOwnerUid);
                //     return Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceAround,
                //       children: [
                //         Container(
                //           child: Row(
                //             children: [Icon(Icons.person), Text(user1.name)],
                //           ),
                //         ),
                //          Container(
                //           child: Row(
                //             children: [Icon(Icons.person), Text(user2.name)],
                //           ),
                //         )
                //       ],
                //     );
                //   })
                //:
                widget.hiringRequestModel?.status == "Job Ended"
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _messageController,
                                decoration: InputDecoration(
                                  hintText: widget.hiringRequestModel == null
                                      ? widget.request!.status == null ||
                                              widget.request!.status ==
                                                  "Activated"
                                          ? 'Type a message...'
                                          : "Conversation compleated"
                                      : widget.hiringRequestModel!.status ==
                                                  null ||
                                              widget.hiringRequestModel!
                                                      .status ==
                                                  "Accepted"
                                          ? 'Type a message...'
                                          : "Conversation compleated",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                              ),
                            ),
                            widget.hiringRequestModel == null
                                ? widget.request!.status == null ||
                                        widget.request!.status == "Activated"
                                    ? IconButton(
                                        icon: const Icon(Icons.send),
                                        onPressed: () async {
                                          // ...
                                        })
                                    : const IconButton(
                                        onPressed: null,
                                        icon:
                                            Icon(Icons.schedule_send_outlined))
                                : IconButton(
                                    icon: const Icon(Icons.send),
                                    onPressed: () async {
                                      // ...
                                    })
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _messageController,
                                decoration: InputDecoration(
                                  hintText: widget.hiringRequestModel == null
                                      ? widget.request!.status == null ||
                                              widget.request!.status ==
                                                  "Activated"
                                          ? 'Type a message...'
                                          : "Conversation compleated"
                                      : widget.hiringRequestModel!.status ==
                                                  null ||
                                              widget.hiringRequestModel!
                                                      .status ==
                                                  "Accepted"
                                          ? 'Type a message...'
                                          : "Conversation compleated",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                              ),
                            ),
                            widget.hiringRequestModel == null
                                ? widget.request!.status == null ||
                                        widget.request!.status == "Activated"
                                    ? IconButton(
                                        icon: const Icon(Icons.send),
                                        onPressed: () async {
                                          if (_messageController.text
                                              .trim()
                                              .isEmpty) {
                                            return; // Do nothing if the message is empty or just whitespace
                                          }

                                          final messageText =
                                              _messageController.text;
                                          final message = {
                                            'senderId':
                                                _appUser!.uid.toString(),
                                            'messageText': messageText,
                                            'timestamp': Timestamp.now(),
                                          };

                                          final notificationMethod =
                                              NotificationMethod();

                                          // Use Future.wait to run tasks in parallel
                                          _messageController.clear();
                                          // log(_otherUser!.fcm.toString());
                                          // String fcm = _appUser!.fcm == _otherUser!.fcm ? _appUser!.fcm .toString():_otherUser!.fcm.toString() ;
                                          //log(fcm.toString());
                                          await Future.wait([
                                            notificationMethod.sendNotification(
                                                fcm: _otherUser!.fcm.toString(),
                                                title: _appUser!.name,
                                                body: messageText,
                                                type:
                                                    'message ${widget.request!.requestId}'),
                                            context
                                                .read<RequestController>()
                                                .addMessage(
                                                    widget.request!.requestId,
                                                    message),
                                          ]);

                                          // Scroll to the bottom of the list to show the new message
                                          _scrollController.animateTo(
                                            _scrollController
                                                .position.maxScrollExtent,
                                            duration: const Duration(
                                                milliseconds: 300),
                                            curve: Curves.easeOut,
                                          );
                                        })
                                    : const IconButton(
                                        onPressed: null,
                                        icon:
                                            Icon(Icons.schedule_send_outlined))
                                : IconButton(
                                    icon: const Icon(Icons.send),
                                    onPressed: () async {
                                      if (_messageController.text
                                          .trim()
                                          .isEmpty) {
                                        return; // Do nothing if the message is empty or just whitespace
                                      }

                                      final messageText =
                                          _messageController.text;
                                      final message = {
                                        'senderId': _appUser!.uid.toString(),
                                        'messageText': messageText,
                                        'timestamp': Timestamp.now(),
                                      };

                                      final notificationMethod =
                                          NotificationMethod();

                                      // Use Future.wait to run tasks in parallel
                                      _messageController.clear();
                                      // log(_otherUser!.fcm.toString());
                                      // String fcm = _appUser!.fcm == _otherUser!.fcm ? _appUser!.fcm .toString():_otherUser!.fcm.toString() ;
                                      //log(fcm.toString());
                                      await Future.wait([
                                        notificationMethod.sendNotification(
                                            fcm: _otherUser!.fcm.toString(),
                                            title: _appUser!.name,
                                            body: messageText,
                                            type:
                                                'message ${widget.hiringRequestModel!.requestId}'),
                                        context
                                            .read<RequestController>()
                                            .addMessage(
                                                widget.hiringRequestModel!
                                                    .requestId,
                                                message),
                                      ]);

                                      // Scroll to the bottom of the list to show the new message
                                      _scrollController.animateTo(
                                        _scrollController
                                            .position.maxScrollExtent,
                                        duration:
                                            const Duration(milliseconds: 300),
                                        curve: Curves.easeOut,
                                      );
                                    })
                          ],
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}

Widget _buildUserDetail(String userName, String? url) {
  return Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        url != null
            ? CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(
                // imageUrl:

                url.toString(),
   
              ))
            : CircleAvatar(child: Text(userName[0])),

        // CircleAvatar(

        //   child: url ==null? Icon(Icons.person, color: Colors.white):null,
        //   backgroundColor: Colors.blue,
        // ),
        const SizedBox(width: 8.0),
        Text(userName, style: const TextStyle(fontSize: 16.0)),
      ],
    ),
  );
}
