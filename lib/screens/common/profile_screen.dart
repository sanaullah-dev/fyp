// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_arc_speed_dial/flutter_speed_dial_menu_button.dart';
import 'package:flutter_arc_speed_dial/main_menu_floating_action_button.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_management_and_booking_system/app/app.dart';
import 'package:vehicle_management_and_booking_system/app/router.dart';
import 'package:vehicle_management_and_booking_system/authentication/controllers/auth_controller.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/machinery_register_controller.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/operator_register_controller.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/request_controller.dart';
import 'package:vehicle_management_and_booking_system/screens/admin/admin_main.dart';
import 'package:vehicle_management_and_booking_system/screens/common/image_viewer.dart';
import 'package:vehicle_management_and_booking_system/screens/common/my_reports.dart';
import 'package:vehicle_management_and_booking_system/screens/common/reviews_screen.dart';
import 'package:vehicle_management_and_booking_system/screens/common/user_total_machineris.dart';
import 'package:vehicle_management_and_booking_system/screens/common/widgets/rating_box.dart';
import 'package:vehicle_management_and_booking_system/screens/login_signup/model/user_model.dart';
import 'package:vehicle_management_and_booking_system/screens/operator/hired_operators_screen.dart';
import 'package:vehicle_management_and_booking_system/screens/operator/my_register_operator.dart';
import 'package:vehicle_management_and_booking_system/utils/app_colors.dart';
import 'package:vehicle_management_and_booking_system/utils/const.dart';
import 'package:vehicle_management_and_booking_system/utils/image_dialgue.dart';
import 'package:vehicle_management_and_booking_system/utils/media_query.dart';
import 'package:flutter/foundation.dart' as TargetPlatform;

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key, this.person}) : super(key: key);

  UserModel? person;
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final User? currentUser = FirebaseAuth.instance.currentUser;

  XFile? selectFile;
  Uint8List? selectedImageInBytes;
  bool _isShowDial = false;
  String? dropdownValue;
  bool isOperatorsExits = false;
  bool isMachinesExits = false;

  @override
  void initState() {
    // TODO: implement initState
    //  dropdownValue
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context
          .read<RequestController>()
          .getCombinedHiringRequestsForOperator(
              context.read<AuthController>().appUser!.uid);
      log(context
          .read<RequestController>()
          .allHiringRequests
          .length
          .toString());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = ConstantHelper.darkOrBright(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark ? null : AppColors.accentColor,
        centerTitle: true,
        automaticallyImplyLeading: false,
        // automaticallyImplyLeading: widget.person==null ? false : true,
        // ignore: unrelated_type_equality_checks
        leading: widget.person != null
            ? IconButton(
                onPressed: () {
                  navigatorKey.currentState!.pop();
                },
                icon: Icon(
                  Icons.arrow_back_ios_new_sharp,
                  color: isDark ? null : AppColors.blackColor,
                ))
            : null,
        title: widget.person == null
            ? Text(
                "My Profile",
                style: TextStyle(color: isDark ? null : AppColors.blackColor),
              )
            : Text("Profile",
                style: TextStyle(color: isDark ? null : AppColors.blackColor)),
        actions: currentUser!.email == "sana.dev11211@gmail.com"
            ? <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: ((context) => const AdminScreen())));
                      },
                      icon: Icon(
                        Icons.admin_panel_settings_outlined,
                        size: 40,
                        color: isDark ? null : AppColors.blackColor,
                      )),
                )
              ]
            : null,
      ),
      body: Consumer<AuthController>(
        builder: (context, value, child) {
          UserModel activeUser = widget.person ?? value.appUser!;
          return Center(
            child: Container(
              width: TargetPlatform.kIsWeb ? 500 : screenWidth(context),
              // decoration: TargetPlatform.kIsWeb? BoxDecoration(
              //     // border: Border.all(
              //     //   color: Colors.white,
              //     // ),
              //     borderRadius: BorderRadius.all(Radius.circular(10))): null,


              decoration:  const BoxDecoration(
                // border: Border.all(
                
                //   color: Colors.white
                // ),
                borderRadius: BorderRadius.all(Radius.circular(10)
                  // topRight: Radius.circular(10),
                  // bottomLeft: Radius.circular(10),
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
                            GestureDetector(
                              onTap: () {
                                activeUser.profileUrl == null
                                    ? null
                                    : Navigator.of(context)
                                        .push(MaterialPageRoute(builder: (ctx) {
                                        return ImageFromUrlViewer(
                                            image: activeUser.profileUrl);
                                      }));
                              },
                              child: CircleAvatar(
                                radius: 50,
                                backgroundImage: activeUser.profileUrl != null
                                    ? CachedNetworkImageProvider(
                                        // imageUrl:
                                        activeUser.profileUrl.toString(),
                                        // fit: BoxFit.cover,
                                      )
                                    : null,
                                child: activeUser.profileUrl == null
                                    ? Center(
                                        child: Text(
                                        "${activeUser.name[0]}",
                                        style: const TextStyle(fontSize: 35),
                                      ))
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
                            ),
                            // TargetPlatform.kIsWeb
                            //     ? SizedBox()
                            //     :
                            widget.person != null
                                ? Container()
                                : Positioned(
                                    right: -10,
                                    bottom: -5,
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
                                                    selectedImageInBytes =
                                                        file.item2;
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
                                                          image:
                                                              selectedImageInBytes!);
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
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              activeUser.name.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            FutureBuilder<UserModel>(
                              future: Future.value(context
                                  .read<MachineryRegistrationController>()
                                  .getUser(activeUser.uid)),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator(); // show a loader while waiting
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  UserModel operatorProfile = snapshot.data!;
                                  double rating = 0.0;
            
                                  if (operatorProfile.allRatings != null) {
                                    // Assuming this is synchronous, if not, further adjustments are needed
                                    rating = context
                                        .read<RequestController>()
                                        .userRating(
                                            userRating:
                                                operatorProfile.allRatings!)
                                        .toDouble();
                                  }
            
                                  return RatingDisplay(rating: rating);
                                }
                              },
                            )
            
                            // Builder(builder: (context) {
                            //   UserModel operatorProfile = context
                            //       .read<MachineryRegistrationController>()
                            //       .getUser(activeUser.uid);
                            //   double rating = 0.0;
            
                            //   if (operatorProfile.allRatings != null) {
                            //     rating = context
                            //         .read<RequestController>()
                            //         .userRating(
                            //             userRating: operatorProfile.allRatings!)
                            //         .toDouble();
                            //   }
            
                            //   return RatingDisplay(rating: rating);
                            // }),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          activeUser.email,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 20), // Add some spacing
                        Builder(builder: (context) {
                          dropdownValue = activeUser.isAvailable == true
                              ? "Available"
                              : "Not Available";
            
                          // Check if the current user is the active user
                          bool isActiveUser = activeUser.uid ==
                              context.read<AuthController>().appUser!.uid;
            
                          return isActiveUser
                              ? DropdownButton<String>(
                                  value: dropdownValue,
                                  icon: const Icon(
                                      Icons.keyboard_arrow_down_outlined),
                                  iconSize: 24,
                                  elevation: 16,
                                  style: const TextStyle(color: Colors.grey),
                                  underline: Container(
                                    height: 2,
                                    color: Colors.transparent,
                                  ),
                                  onChanged: (String? newValue) async {
                                    setState(() {
                                      activeUser.isAvailable =
                                          newValue == 'Available' ? true : false;
                                    });
                                    await context
                                        .read<AuthController>()
                                        .updateUserForBlock(activeUser);
                                    await context
                                        .read<MachineryRegistrationController>()
                                        .updateAllMachinesAvailability(
                                            activeUser.uid,
                                            activeUser.isAvailable);
            
                                    await context
                                        .read<OperatorRegistrationController>()
                                        .updateOperatorsAvailability(
                                            activeUser.uid,
                                            activeUser.isAvailable);
                                    // Assuming 'allMachineries' is your list of MachineryModel objects
            
                                    // for (var machine in context
                                    //     .read<MachineryRegistrationController>()
                                    //     .allMachineries!) {
                                    //   if (machine.uid == activeUser.uid &&
                                    //       activeUser.isAvailable == false) {
                                    //     machine.isAvailable = false;
                                    //   }
                                    // }
            
                                    // Update this value to your backend
            
                                    await context
                                        .read<OperatorRegistrationController>()
                                        .getNearestAndHighestRatedOperator();
            
                                    await context
                                        .read<MachineryRegistrationController>()
                                        .getAllMachineries();
                                    setState(() {});
                                  },
                                  items: <String>[
                                    'Available',
                                    'Not Available'
                                  ].map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey, width: 1),
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          value,
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey, width: 1),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    dropdownValue!,
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                  ),
                                );
                        }),
                        // Builder(builder: (context) {
                        //   dropdownValue = activeUser.isAvailable == true
                        //       ? "Available"
                        //       : "Not Available";
                        //   return DropdownButton<String>(
                        //     value: dropdownValue,
                        //     icon:  const Icon(Icons.keyboard_arrow_down_outlined),
                        //     iconSize: 24,
                        //     elevation: 16,
                        //     style: const TextStyle(color: Colors.grey),
                        //     underline: Container(
                        //       height: 2,
                        //       color: Colors.transparent,
                        //     ),
                        //     onChanged: (String? newValue) {
                        //       activeUser.uid ==
                        //               context.read<AuthController>().appUser!.uid
                        //           ? setState(() {
                        //               activeUser.isAvailable =
                        //                   newValue == 'Available' ? true : false;
                        //               context
                        //                   .read<AuthController>()
                        //                   .updateUserForBlock(activeUser);
                        //             })
                        //           : null;
                        //       // You can also update this value to your backend.
                        //     },
                        //     items: <String>['Available', 'Not Available']
                        //         .map<DropdownMenuItem<String>>((String value) {
                        //       return DropdownMenuItem<String>(
                        //         value: value,
                        //         child: Container(
                        //           decoration: BoxDecoration(
                        //             border:
                        //                 Border.all(color: Colors.grey, width: 1),
                        //             borderRadius: BorderRadius.circular(5.0),
                        //           ),
                        //           padding: EdgeInsets.all(5.0),
                        //           child: Text(
                        //             value,
                        //             style: TextStyle(fontSize: 14),
                        //           ),
                        //         ),
                        //       );
                        //     }).toList(),
                        //   );
                        // }),
            
                        const Divider(),
            
                        // const Text("Kabotr chowk, Peshawar"),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.construction_outlined,
                        color: Colors.orange),
                    title: const Text('Registered Machineries'),
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (ctx) {
                        return MachineryListScreen(
                            isthisAdmin: false, uid: activeUser.uid);
                      }));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.person, color: Colors.orange),
                    title: const Text('Registered Operators'),
                    onTap: () {
                      log(activeUser.uid);
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (ctx) {
                        return MyRegisteredOperators(uid: activeUser.uid);
                      }));
                    },
                  ),
                  activeUser.uid == context.read<AuthController>().appUser!.uid
                      ? ListTile(
                          leading: const Icon(Icons.person, color: Colors.orange),
                          title: const Text('My Hired Operators'),
                          onTap: () {
                            log(activeUser.uid);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HiredOperatorsScreen(),
                              ),
                            );
                          })
                      : const SizedBox(),
                  widget.person != null
                      ? Container()
                      : ListTile(
                          leading: const Icon(Icons.lock, color: Colors.orange),
                          title: const Text('Change Password'),
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(AppRouter.changePasswordScreen);
                          },
                        ),
                  activeUser.uid == context.read<AuthController>().appUser!.uid
                      ? ListTile(
                          leading: const Icon(Icons.report, color: Colors.orange),
                          title: const Text('My Reports'),
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: ((context) {
                              return MyReports();
                            })));
                          },
                        )
                      : Container(),
                  ListTile(
                    leading: const Icon(Icons.language, color: Colors.orange),
                    title: const Text('Language'),
                    subtitle: Text(activeUser.languages),
                  ),
                  ListTile(
                    leading: const Icon(Icons.feedback, color: Colors.orange),
                    title: const Text('Reviews'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AllReviewsScreen(
                                  uid: activeUser.uid,
                                  title: "User Reviews",
                                )),
                      );
                    },
                  ),
                  widget.person != null
                      ? Container()
                      : ListTile(
                          leading: const Icon(Icons.logout, color: Colors.orange),
                          title: const Text('Log Out'),
                          onTap: () async {
                            final bool? result = await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Confirm Logout'),
                                  content: const Text(
                                      'Are you sure you want to log out?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(
                                            false); // Dismiss the dialog and return false
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(
                                            true); // Dismiss the dialog and return true
                                      },
                                      child: const Text('Log Out'),
                                    ),
                                  ],
                                );
                              },
                            );
            
                            if (result != null && result) {
                              value.signOut(context); // if true, then log out
                            }
                          },
                        )
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton:
          widget.person == null ? _getFloatingActionButton() : null,
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
          backgroundColor: Colors.orange,
          mini: false,
          child: const Icon(Icons.add),
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
          backgroundColor: Colors.orange,
          child: Image.asset(
            "assets/images/pngegg.png",
            color: Colors.white,
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
          child: const Icon(
            Icons.person_add_alt_1_outlined,
            color: Colors.white,
          ),
        ),
      ],
      isSpeedDialFABsMini: true,
      paddingBtwSpeedDialButton: 60.0,
    );
  }
}
