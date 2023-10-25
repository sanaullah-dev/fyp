import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_management_and_booking_system/authentication/controllers/auth_controller.dart';
import 'package:vehicle_management_and_booking_system/screens/login_signup/model/user_model.dart';

class UserListPageForAdmin extends StatefulWidget {
  @override
  _UserListPageForAdminState createState() => _UserListPageForAdminState();
}

class _UserListPageForAdminState extends State<UserListPageForAdmin> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection('users')
            .where('uid',
                isNotEqualTo: context.read<AuthController>().appUser!.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              UserModel user = UserModel.fromJson(data);
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(
                      color: Colors.grey.shade400,
                      width: 1.0,
                    ),
                  ),
                  leading: user.profileUrl != null
                      ? CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(
                          // imageUrl:
                          user.profileUrl.toString(),
                          errorListener: () {
                            log("error");
                          },
                        ))
                      : CircleAvatar(child: Text(user.name[0])),
                  title: Text(user.name),
                  subtitle: Text(
                      'Email: ${user.email}\nMobile: ${user.mobileNumber}\nLanguages: ${user.languages}'),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
