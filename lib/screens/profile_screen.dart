import 'dart:developer';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_arc_speed_dial/flutter_speed_dial_menu_button.dart';
import 'package:flutter_arc_speed_dial/main_menu_floating_action_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_management_and_booking_system/app/router.dart';
import 'package:vehicle_management_and_booking_system/authentication/controllers/auth_controller.dart';
import 'package:vehicle_management_and_booking_system/screens/user_total_machineris.dart';
import 'package:vehicle_management_and_booking_system/utils/image_dialgue.dart';
import 'package:vehicle_management_and_booking_system/utils/media_query.dart';
// ignore: library_prefixes
import 'package:flutter/foundation.dart' as TargetPlatform;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final User? currentUser = FirebaseAuth.instance.currentUser;

  XFile? selectFile;
  Uint8List? selectedImageInBytes;
  bool _isShowDial = false;
  dynamic snapshot;

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      snapshot = FirebaseFirestore.instance
          .collection('machineries')
          .where('uid', isEqualTo: currentUser!.uid)
          .snapshots();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: const Text("My Profile"),
      ),
      body: Consumer<AuthController>(
        builder: (context, value, child) {
          // var imageUrl = context.read<AuthController>().appUser!.profileUrl;
          return Container(
            width: TargetPlatform.kIsWeb ? 500 : screenWidth(context),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
            ),
            child: ListView(
              children: [
                Container(
                  margin: const EdgeInsets.all(30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundImage: value.appUser!.profileUrl != null
                                ? CachedNetworkImageProvider(
                                    // imageUrl:
                                    value.appUser!.profileUrl.toString(),
                                    // fit: BoxFit.cover,
                                  )
                                : null,
                            // :            NetworkImage(value.appUser!.profileUrl.toString()),
                            // imageUrl !=null || _pickedImage == null
                            //     ? NetworkImage(url)
                            // : FileImage(
                            //     File(
                            //       _pickedImage!.path.toString(),
                            //     ),
                            //   ),
                            //child:  imageUrl!=null?Image.network(imageUrl,fit: BoxFit.contain,):SizedBox()
                          ),
                          // TargetPlatform.kIsWeb
                          //     ? SizedBox()
                          //     :
                          Positioned(
                            right: -5,
                            bottom: 0,
                            child: IconButton(
                              icon: Icon(
                                Icons.camera,
                                size: 35,
                                color: Colors.amber.shade900,
                              ),
                              onPressed: () async {
                                showModalBottomSheet(
                                    //isDismissible: true,
                                    context: context,
                                    builder: (context) {
                                      return imageDialogue(
                                        context,
                                        onSelect: (file) {
                                          // log(file.path.toString());

                                          if (TargetPlatform.kIsWeb) {
                                            selectedImageInBytes = file.item2;
                                            log("message");
                                          } else {
                                            // _pickedImage = file.item1;
                                            selectFile = file.item1;
                                          }
                                          setState(() {
                                            // log(selectFile!.name);
                                          });
                                          // setState(() {
                                          //   _pickedImage = file;
                                          // });
                                          !kIsWeb
                                              ? value.changeImage(
                                                  image: selectFile)
                                              : value.changeImageOnWeb(
                                                  image: selectedImageInBytes!);
                                          Navigator.pop(context);
                                        },
                                      );
                                    });
                                // Navigator.pop(context);
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text(
                        context.read<AuthController>().appUser!.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        context.read<AuthController>().appUser!.email,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),

                      Divider(),

                      // const Text("Kabotr chowk, Peshawar"),
                    ],
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.construction_outlined,color: Colors.orange),
                  title: const Text('Registered Machineries'),
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (ctx) {
                      return MachineryListScreen();
                    }));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.lock,color: Colors.orange),
                  title: Text('Change Password'),
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(AppRouter.changePasswordScreen);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.language,color: Colors.orange),
                  title: Text('Language'),
                  subtitle:
                      Text(context.read<AuthController>().appUser!.languages),
                ),
                ListTile(
                  leading: Icon(Icons.logout,color: Colors.orange),
                  title: Text('Log Out'),
                  onTap: () {
                    context.read<AuthController>().signOut(context);
                  },
                )
              ],
            ),
          );
        },
      ),
      floatingActionButton: _getFloatingActionButton(),
    );
  }

  Widget _getFloatingActionButton() {
    return SpeedDialMenuButton(
      //if needed to close the menu after clicking sub-FAB
      isShowSpeedDial: _isShowDial,
      //manually open or close menu
      updateSpeedDialStatus: (isShow) {
        //return any open or close change within the widget
        _isShowDial = isShow;
      },
      //general init
      isMainFABMini: false,
      mainMenuFloatingActionButton: MainMenuFloatingActionButton(
          mini: false,
          child: const Icon(Icons.menu),
          onPressed: () {},
          closeMenuChild: const Icon(Icons.close),
          closeMenuForegroundColor: Colors.white,
          closeMenuBackgroundColor: Colors.red),
      floatingActionButtonWidgetChildren: <FloatingActionButton>[
        FloatingActionButton(
          mini: true,
          heroTag: "btn1",
          onPressed: () {
            //if need to close menu after click
            // _isShowDial = false;
            //  setState(() {});

            Navigator.of(context).pushNamed(AppRouter.machineryFormScreen);
          },
          backgroundColor: Colors.pink,
          child: Image.asset(
            "assets/images/pngegg.png",
            height: 30,
            width: 30,
          ),
        ),
        FloatingActionButton(
          heroTag: "btn2",
          mini: true,
          onPressed: () {
            //if need to toggle menu after click
            //_isShowDial = !_isShowDial;
            // setState(() {});
            Navigator.pushNamed(context, AppRouter.operatorRegistration);
          },
          backgroundColor: Colors.orange,
          child: const Icon(Icons.person_add_alt_1_outlined),
        ),
      ],
      isSpeedDialFABsMini: true,
      paddingBtwSpeedDialButton: 60.0,
    );
  }
}
