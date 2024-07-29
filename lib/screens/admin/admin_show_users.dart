import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_management_and_booking_system/authentication/controllers/auth_controller.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/machinery_register_controller.dart';
import 'package:vehicle_management_and_booking_system/screens/common/profile_screen.dart';
import 'package:vehicle_management_and_booking_system/screens/login_signup/model/user_model.dart';
import 'package:vehicle_management_and_booking_system/utils/app_colors.dart';
import 'package:vehicle_management_and_booking_system/utils/const.dart';

// ignore: must_be_immutable
class UserListPageForAdmin extends StatefulWidget {
  UserListPageForAdmin({super.key, required this.isActivate});

  bool? isActivate;
  @override
  // ignore: library_private_types_in_public_api
  _UserListPageForAdminState createState() => _UserListPageForAdminState();
}

class _UserListPageForAdminState extends State<UserListPageForAdmin> {
  List<UserModel>? users;
  List<UserModel>? searchUsers;

  @override
  void initState() {
    users = [...context.read<MachineryRegistrationController>().allUsers!];
    super.initState();
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool _isSearching = false;

  void _filterUsers(String value) {
    if (value.isNotEmpty) {
      searchUsers = [
        ...searchUsers!.where((user) {
          return user.name.toLowerCase().contains(value.toLowerCase()) ||
              user.email.toLowerCase().contains(value.toLowerCase()) ||
              user.uid.toString().contains(value) ||
              user.mobileNumber.contains(value);
        }).toList()
      ];
    } else {
      searchUsers = [
        ...users!
            .where((user) =>
                user.uid != context.read<AuthController>().appUser!.uid)
            //  &&
            // machine.isAvailable != false)
            .toList()
      ];
    }
    setState(() {});
  }

  String searchValue = '';
  @override
  Widget build(BuildContext context) {
    bool isDark = ConstantHelper.darkOrBright(context);
    return Scaffold(
      appBar: AppBar(
        //  backgroundColor: isDark ? null : AppColors.accentColor,
        // You can add a leading button to control the drawer
        // leading: IconButton(
        //   icon:  Icon(
        //     Icons.menu,
        //     color: isDark ? null : AppColors.blackColor,
        //   ),
        //   onPressed: () async {
        //     // await context
        //     //     .read<RequestController>()
        //     //     .isSendReceivedRequestExist(
        //     //         uid: context.read<AuthController>().appUser!.uid);
        //     context
        //         .read<MachineryRegistrationController>()
        //         .zoomtogle(); // toggle drawer
        //     //showCancelDialog(context, false);
        //     // showCustomRatingDialog(context, context.read<MachineryRegistrationController>().allMachineries!.last);
        //   },
        // ),
        title: _isSearching
            ? TextField(
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(5),
                    hintText: "Search...",
                    focusColor: Colors.white,
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder()),
                onChanged: (value) {
                  setState(() {
                    searchValue = value;
                    _filterUsers(value);
                  });

                  log(users!.length.toString());
                },
              )
            : Text(
                'Users List',
                style: TextStyle(color: isDark ? null : AppColors.blackColor),
              ),
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
              color: isDark ? null : AppColors.blackColor,
            ),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                searchUsers = [
                  ...context.read<MachineryRegistrationController>().allUsers!
                ];

                // Call some method here if search is cancelled
                if (!_isSearching) {
                  // ignore: avoid_print
                  print("Search bar was hidden");
                }
              });
            },
          ),
        ],
      ),
      body: _isSearching ?usersList(searchUsers!): usersList(users!),
    );
  }

  ListView usersList(List<UserModel> allUsersList) {
    return ListView.builder(
      itemCount: allUsersList!.length,
      itemBuilder: (context, index) {
        var user = allUsersList![index];
        if (user.blockOrNot == true && widget.isActivate == false || user.email =='sana.dev11211@gmail.com') {
          return const SizedBox();
        }
        if ((user.blockOrNot == null || user.blockOrNot == false) &&
            widget.isActivate == true) {
          return const SizedBox();
        }
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: BorderSide(
                color: Colors.grey.shade400,
                width: 1.0,
              ),
            ),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) {
                return ProfileScreen(
                  person: user,
                );
              }));
            },
            leading: user.profileUrl != null
                ? CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                    // imageUrl:
                    user.profileUrl.toString(),
                   
                  ))
                : CircleAvatar(child: Text(user.name[0])),
            title: Text(user.name),
            subtitle: Text(
                'Email: ${user.email}\nMobile: ${user.mobileNumber}\nLanguages: ${user.languages}'),
            trailing: ElevatedButton(
                onPressed: () async {
                  try {
                    if (widget.isActivate == true) {
                      user.blockOrNot = false;
                      await context
                          .read<AuthController>()
                          .updateUserForBlock(user);
                      users!.remove(user);
                      setState(() {});
                    } else {
                      await showBlockDialog(user);
                      // user.blockOrNot = true;
                      // await context
                      //     .read<AuthController>()
                      //     .updateUserForBlock(user);
                      //     users!.remove(user);
                      setState(() {});
                    }
                  } catch (e) {
                    log("Error: $e");
                  }
                },
                child: widget.isActivate == true
                    ? const Text("ACTIVATE")
                    : const Text("BLOCK")),
          ),
        );
      },
    );
  }

  Future<void> showBlockDialog(UserModel user) async {
    String? comment; // To store the comment entered by the admin

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Block User'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text('Please provide a reason for blocking the user.'),
                TextField(
                  onChanged: (value) {
                    comment = value;
                  },
                  decoration: const InputDecoration(hintText: "Enter comment"),
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Block'),
              onPressed: () async {
                user.blockOrNot = true;
                // Initialize blockingComments list if it is null
                user.blockingComments ??= [];

                // Add the new comment to the list of blocking comments
                if (comment != null && comment!.isNotEmpty) {
                  user.blockingComments!.add(comment!);
                }
                // You might want to add the comment to the UserModel
                // or store it separately based on your needs
                if (comment!.isNotEmpty) {
                  await context.read<AuthController>().updateUserForBlock(user);
                  users!.remove(user);
                  setState(() {});
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
