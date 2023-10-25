// import 'dart:developer';

// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:easy_search_bar/easy_search_bar.dart';
// import 'package:flutter/material.dart';
// // ignore: library_prefixes
// import 'package:flutter/foundation.dart' as TargetPlatform;
// import 'package:provider/provider.dart';
// import 'package:vehicle_management_and_booking_system/common/controllers/machinery_register_controller.dart';
// import 'package:vehicle_management_and_booking_system/models/machinery_model.dart';
// import 'package:vehicle_management_and_booking_system/screens/machinery/dashBoard_single_machinery_widget.dart';
// import 'package:vehicle_management_and_booking_system/screens/machinery/widgets/machinery_stream.dart';
// import 'package:vehicle_management_and_booking_system/screens/machinery/widgets/menue.dart';
// import 'package:vehicle_management_and_booking_system/utils/media_query.dart';
// import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

// // ignore: must_be_immutable
// class HomeScreen extends StatefulWidget {
//   HomeScreen({Key? key}) : super(key: key);
//   // ignore: prefer_typing_uninitialized_variables
//   var title = "Home Screen";
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   List<MachineryModel> allMachineries = [];

//   String searchValue = '';
//   @override
//   void initState() {
//     // TODO: implement initState
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
//       await context.read<MachineryRegistrationController>().getAllMachineries();
//       allMachineries =
//           // ignore: use_build_context_synchronously
//           context.read<MachineryRegistrationController>().allMachineries;
//     });
//     super.initState();
//   }

//   final zoomDrawerController = ZoomDrawerController();
//   bool _isSearching = false;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(

//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         //automaticallyImplyLeading: false,
//         title: _isSearching
//             ? TextField(
//                 decoration: const InputDecoration(
//                     contentPadding: EdgeInsets.all(5),
//                     hintText: "Search...",
//                     focusColor: Colors.white,
//                     border: OutlineInputBorder(),
//                     focusedBorder: OutlineInputBorder()),
//                 onChanged: (value) {
//                   setState(() {
//                     searchValue = value;

//                     if (value.isNotEmpty) {
//                       allMachineries = allMachineries.where((machinery) {
//                         return machinery.title
//                                 .toLowerCase()
//                                 .contains(searchValue.toLowerCase()) ||
//                             machinery.model
//                                 .toLowerCase()
//                                 .contains(searchValue.toLowerCase());
//                       }).toList();
//                     } else {
//                       allMachineries = context
//                           .read<MachineryRegistrationController>()
//                           .allMachineries;
//                       setState(() {});
//                     }
//                   });

//                   log(allMachineries.length.toString());
//                 },
//               )
//             : Text('Home Screen'),
//         actions: [
//           IconButton(
//             icon: Icon(_isSearching ? Icons.close : Icons.search),
//             onPressed: () {
//               setState(() {
//                 _isSearching = !_isSearching;

//                 // Call some method here if search is cancelled
//                 if (!_isSearching) {
//                   print("Search bar was hidden");
//                 }
//               });
//             },
//           ),
//         ],
//       ),
//       body: _isSearching
//           ? Center(
//               child: SizedBox(
//                 width: TargetPlatform.kIsWeb ? 500 : screenWidth(context),
//                 child: GridView.builder(
//                     itemCount: allMachineries.length,
//                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                       childAspectRatio: TargetPlatform.kIsWeb
//                           ? 0.7
//                           : screenHeight(context) > 700
//                               ? 0.55
//                               : 0.6,
//                       crossAxisCount: 2,
//                     ),
//                     itemBuilder: (ctx, index) {
//                       final doc = allMachineries[index];

//                       return SingleMachineryWidget(
//                         machineryDetails: doc,
//                       );
//                     }),
//               ),
//             )
//           : Center(
//               child: SizedBox(
//                 width: TargetPlatform.kIsWeb ? 500 : screenWidth(context),
//                 child: const MachineryStream(),
//               ),
//             ),
//     );
//   }
// }

// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// ignore: library_prefixes
import 'package:flutter/foundation.dart' as TargetPlatform;
import 'package:provider/provider.dart';
import 'package:vehicle_management_and_booking_system/authentication/controllers/auth_controller.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/machinery_register_controller.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/operator_register_controller.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/request_controller.dart';
import 'package:vehicle_management_and_booking_system/models/machinery_model.dart';
import 'package:vehicle_management_and_booking_system/screens/machinery/gridview_card.dart';
import 'package:vehicle_management_and_booking_system/screens/machinery/widgets/machinery_stream.dart';
import 'package:vehicle_management_and_booking_system/screens/common/drawer_items/menue.dart';
import 'package:vehicle_management_and_booking_system/utils/app_colors.dart';
import 'package:vehicle_management_and_booking_system/utils/const.dart';
import 'package:vehicle_management_and_booking_system/utils/media_query.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:vehicle_management_and_booking_system/widgets/notification.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);
  // ignore: prefer_typing_uninitialized_variables
  var title = "Home Screen";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<MachineryModel> _allMachineries = [];
  NotificationServices notificationServices = NotificationServices();

  String searchValue = '';
  @override
  void initState() {
    // TODO: implement initState
    _allMachineries = [
      ...context
          .read<MachineryRegistrationController>()
          .allMachineries!
          .where((machine) =>
              machine.uid != context.read<AuthController>().appUser!.uid)
              //  &&
              // machine.isAvailable != false)
          .toList()
    ];
    notificationServices.requestNotificationPermissions();
    notificationServices.handleForegroundMessage();
    //notificationServices.flutterLocalNotificationsPlugin;
    notificationServices.setupInteractMessage(context);
    notificationServices.forgroundMessage();
    //notificationServices.initNotifications(context);

    notificationServices.getDeviceToken().then((value) {
      if (kDebugMode) {
        print('device token');
        print(value);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      log("message");
      // _allMachineries =
      //     // ignore: use_build_context_synchronously
      //await context.read<MachineryRegistrationController>().getAllMachineries();

      log(_allMachineries.length.toString() + "2");
      // await context
      //     .read<OperatorRegistrationController>()
      //     .getNearestAndHighestRatedOperator();
      await context.read<MachineryRegistrationController>().getAllRequests();
      if (mounted) {
        MapIcons.markerIcon = await MapIcons.getBytesFromAsset(
            'assets/images/axcevator/excavator1.png', 80);
        await context
            .read<OperatorRegistrationController>()
            .getNearestAndHighestRatedOperator();
      }
      if (mounted) {
        log("mountd");
        await context.read<MachineryRegistrationController>().fetchAllUsers();
        await context.read<RequestController>().checkActiveRequest(context);
      }
    });

    super.initState();
  }

  bool _isSearching = false;
  @override
  void dispose() {
    // TODO: implement dispose
    // _subscription?.cancel();
    super.dispose();
  }

  void _filterMachineries(String value) {
    if (value.isNotEmpty) {
      _allMachineries = [
        ..._allMachineries.where((machinery) {
          return machinery.title.toLowerCase().contains(value.toLowerCase()) ||
              machinery.model.toLowerCase().contains(value.toLowerCase()) ||
              machinery.charges.toString().contains(value.toLowerCase()) ||
              machinery.location.title
                  .toLowerCase()
                  .contains(value.toLowerCase());
        }).toList()
      ];
    } else {
      _allMachineries = [
        ...context
            .read<MachineryRegistrationController>()
            .allMachineries!
            .where((machine) =>
                machine.uid != context.read<AuthController>().appUser!.uid)
                //  &&
                // machine.isAvailable != false)
            .toList()
      ];
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = ConstantHelper.darkOrBright(context);

    return ZoomDrawer(
      // shadowLayer1Color: Color.fromARGB(255, 2, 163, 136),
      //menuScreenOverlayColor: Colors.orange,
      //drawerShadowsBackgroundColor: Colors.orange,
      controller:
          context.read<MachineryRegistrationController>().zoomDrawerController,
      style: DrawerStyle.defaultStyle, // or another style if you want
      borderRadius: 30.0,
      showShadow: true,
      menuScreen: MenuScreen(),
      mainScreen: Scaffold(
        appBar: AppBar(
          backgroundColor: isDark ? null : AppColors.accentColor,
          // You can add a leading button to control the drawer
          leading: IconButton(
            icon:  Icon(
              Icons.menu,
              color: isDark ? null : AppColors.blackColor,
            ),
            onPressed: () async {
              // await context
              //     .read<RequestController>()
              //     .isSendReceivedRequestExist(
              //         uid: context.read<AuthController>().appUser!.uid);
              context
                  .read<MachineryRegistrationController>()
                  .zoomtogle(); // toggle drawer
              //showCancelDialog(context, false);
              // showCustomRatingDialog(context, context.read<MachineryRegistrationController>().allMachineries!.last);
            },
          ),
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
                      _filterMachineries(value);
                    });

                    log(_allMachineries.length.toString());
                  },
                )
              :  Text(
                  'Home Screen',
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

                  // Call some method here if search is cancelled
                  if (!_isSearching) {
                    print("Search bar was hidden");
                  }
                });
              },
            ),
          ],
        ),
        body: _isSearching
            ? Center(
                child: SizedBox(
                  width: TargetPlatform.kIsWeb ? 500 : screenWidth(context),
                  child: GridView.builder(
                      itemCount: _allMachineries.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: TargetPlatform.kIsWeb
                            ? 0.7
                            : screenHeight(context) > 700
                                ? 0.55
                                : 0.6,
                        crossAxisCount: 2,
                      ),
                      itemBuilder: (ctx, index) {
                        MachineryModel doc = _allMachineries[index];

                        return SingleMachineryWidget(
                          machineryDetails: doc,
                        );
                      }),
                ),
              )
            :
            // Center(
            //     child: SizedBox(
            //       width: TargetPlatform.kIsWeb ? 500 : screenWidth(context),
            //       child: GridView.builder(
            //           itemCount: _allMachineriesForHomeScreen.length,
            //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //             childAspectRatio: TargetPlatform.kIsWeb
            //                 ? 0.7
            //                 : screenHeight(context) > 700
            //                     ? 0.55
            //                     : 0.6,
            //             crossAxisCount: 2,
            //           ),
            //           itemBuilder: (ctx, index) {
            //             final doc = _allMachineriesForHomeScreen[index];

            //             return SingleMachineryWidget(
            //               machineryDetails: doc,
            //             );
            //           }),
            //     ),
            //   )

            Center(
                child: SizedBox(
                  width: TargetPlatform.kIsWeb ? 500 : screenWidth(context),
                  child: const MachineryStream(),
                ),
              ),
      ),
      // You can adjust the parameters below according to your need
      slideWidth: MediaQuery.of(context).size.width * .80,
      openCurve: Curves.fastOutSlowIn,
      closeCurve: Curves.ease,
      // shadowLayer1Color:  Colors.orange,
      // shadowLayer2Color: ,
      menuBackgroundColor: Colors.black,
      //mainScreenOverlayColor: Colors.orange,
      // menuScreenOverlayColor: Colors.orange,
      // drawerShadowsBackgroundColor: Colors.orange,
    );
  }
}

// GridView.builder(
//   itemCount: 15,
//   //shrinkWrap: true,
//   gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
//     //childAspectRatio: ((MediaQuery.of(context).size.width - extraSpace) / 2) / 241,
//     crossAxisCount: size.width > 770 ? 4 : 2,
//     //(MediaQuery.of(context).orientation == Orientation.landscape) || TargetPlatform.kIsWeb ? 4 :  2
//     crossAxisSpacing: 2,
//    mainAxisSpacing: 2,
//
//   ),
//   itemBuilder: (ctx, index) {
//     return Card(
//       color: Colors.red,
//       child: Column(
//          mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//
//             height: size.height / 4.5,
//
//             margin: const EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 1),
//             decoration: BoxDecoration(
//               //color: Colors.red,
//               shape: BoxShape.rectangle,
//               border: Border.all(
//                 color: Colors.orangeAccent.withOpacity(0.80),
//                 width: 0.5,
//               ),
//             ),
//
//             child: Image.asset("assets/images/main.png"),
//           ),
//           Container(
//
//             margin: const EdgeInsets.only(left: 10,right: 10,bottom: 1),
//
//             decoration: BoxDecoration(
//               color: Colors.orangeAccent[400],
//             ),
//             //height: MediaQuery.of(context).size.height * 0.07,
//             //margin: const EdgeInsets.only(left: 20,right: 10),
//
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.start,
//
//               //mainAxisSize: MainAxisSize.max,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisSize: MainAxisSize.min,
//                   children: const [
//                     Text("Excivater"),
//                     Text("Model 2022"),
//                     Text("20\$ /hr")
//                   ],
//                 ),
//                 Container(
//                   margin: EdgeInsets.only(right: 10),
//                   child: Column(
//                     children: const [
//                       Icon(Icons.star),
//                       Text("4.5"),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   },
// ),
//     );
//   }
// }

// appBar: EasySearchBar(
//  // showClearSearchIcon: true,
//     title: Text(widget.title),
//     isFloating: true,
//      onCancelSearch: () {
//   // Perform your action here
//   print('Search bar was hidden');
// },

//     onSearch: (value) {
//   setState(() {
//     searchValue = value;

//         if (value.isNotEmpty) {
//     allMachineries = allMachineries.where((machinery) {
//       return machinery.title
//               .toLowerCase()
//               .contains(searchValue.toLowerCase()) ||
//           machinery.model
//               .toLowerCase()
//               .contains(searchValue.toLowerCase());
//     }).toList();
//         }else{
//           allMachineries =  context.read<MachineryRegistrationController>().allMachineries;
//           setState(() {

//           });
//         }
//   });

// log( allMachineries.length.toString());
//     }),
