// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/machinery_register_controller.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/operator_register_controller.dart';
import 'package:vehicle_management_and_booking_system/screens/machinery/home_screen.dart';
import 'package:vehicle_management_and_booking_system/screens/google_map/map_screen.dart';
import 'package:vehicle_management_and_booking_system/screens/common/profile_screen.dart';
import 'package:vehicle_management_and_booking_system/screens/machinery/widgets/shimmer.dart';
import 'package:vehicle_management_and_booking_system/screens/operator/operators_screen.dart';
// ignore: library_prefixes
import 'package:flutter/foundation.dart' as TargetPlatform;
import 'package:vehicle_management_and_booking_system/utils/media_query.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({Key? key}) : super(key: key);

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  @override
  void initState() {
    // TODO: implement initState
    _refreshData = _fetchData();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // await context.read<RequestController>().checkActiveRequest(context);
      // await context.read<MachineryRegistrationController>().getAllMachineries();
    });
    super.initState();
  }

  var _currentIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    const OperatorSearchScreen(),
    //TrackOrder(),
    MapScreen(
      title: "Find here...",
    ),
    ProfileScreen(),
  ];
  Future<void>? _refreshData;

  Future<void> _fetchData() async {
    await context.read<MachineryRegistrationController>().getAllMachineries();
    await context
        .read<OperatorRegistrationController>()
        .getNearestAndHighestRatedOperator();
        setState(() {
          
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   automaticallyImplyLeading: false,
        //   title: const Text("Vehicle Management & Booking System"),
        // ),
        body: RefreshIndicator(
          onRefresh: _fetchData,
          child: FutureBuilder<void>(
            future: _refreshData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: SkeletonMachineryWidget());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else {
                // Wrap your page with SingleChildScrollView to ensure it is scrollable
                return _pages[_currentIndex];
              }
            },
          ),
        ),
        bottomNavigationBar: Container(
          height: TargetPlatform.kIsWeb? 65:90,
          child: Center(
            child: Container(
              width: 700,
              child: SalomonBottomBar(
                itemPadding: TargetPlatform.kIsWeb
                    ? const EdgeInsets.symmetric(horizontal: 30, vertical: 10)
                    : const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                currentIndex: _currentIndex,
                margin: TargetPlatform.kIsWeb
                    ? EdgeInsets.symmetric(
                        horizontal: screenWidth(context) * 0.07, vertical: 10)
                    : const EdgeInsets.all(8),
                onTap: (i) {
                  setState(() => _currentIndex = i);
                  // ignore: unrelated_type_equality_checks
                  i == 0 &&
                          context
                                  .read<MachineryRegistrationController>()
                                  .zoomDrawerController
                                  .isOpen!() ==
                              true
                      ? context.read<MachineryRegistrationController>().zoomtogle()
                      : null;
              
                  //     ? Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                  //         return BottomNavigationScreen();
                  //       }))
                  //     : _currentIndex == 1
                  //         ? Navigator.of(context)
                  //             .push(MaterialPageRoute(builder: (ctx) {
                  //             return MapScreen();
                  //           }))
                  //         : _currentIndex == 3
                  //             ? Navigator.of(context)
                  //                 .push(MaterialPageRoute(builder: (ctx) {
                  //                 return ProfileScreen();
                  //               }))
                  //             : Container();
                },
                items: [
                  /// Home
                  SalomonBottomBarItem(
                    icon: const Icon(Icons.home),
                    title: const Text("Home"),
                    selectedColor: Colors.orangeAccent,
                  ),
              
                  /// Operator
                  SalomonBottomBarItem(
                    icon: const Icon(Icons.emoji_people),
                    title: const Text("Operators"),
                    selectedColor: Colors.orangeAccent,
                  ),
              
                  /// Map
                  SalomonBottomBarItem(
                    icon: const Icon(Icons.pin_drop_outlined),
                    title: const Text("Find"),
                    selectedColor: Colors.orangeAccent,
                  ),
              
                  /// Profile
                  SalomonBottomBarItem(
                    icon: const Icon(Icons.person),
                    title: const Text("Profile"),
                    selectedColor: Colors.orangeAccent,
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
