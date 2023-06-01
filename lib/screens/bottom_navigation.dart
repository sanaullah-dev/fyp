import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:vehicle_management_and_booking_system/screens/machinery/machinery_dashBoard_screen.dart';
import 'package:vehicle_management_and_booking_system/screens/map_screen.dart';
import 'package:vehicle_management_and_booking_system/screens/profile_screen.dart';
import 'package:vehicle_management_and_booking_system/screens/operators_screen.dart';
// ignore: library_prefixes
import 'package:flutter/foundation.dart' as TargetPlatform;
import 'dart:io';
import 'package:vehicle_management_and_booking_system/utils/media_query.dart';
class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({Key? key}) : super(key: key);

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  var _currentIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(
    ),
    const OperatorSearchScreen(),
    MapScreen(
      title: "Find Here",
    ),
    const ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   title: const Text("Vehicle Management & Booking System"),
      // ),
      body: _pages[_currentIndex],
      bottomNavigationBar: 
      SalomonBottomBar(
        itemPadding: TargetPlatform.kIsWeb ?  EdgeInsets.symmetric(horizontal: 30,vertical: 10) : EdgeInsets.symmetric(vertical: 10,horizontal: 16),
        currentIndex: _currentIndex,
        margin: TargetPlatform.kIsWeb ?  EdgeInsets.symmetric(horizontal: screenWidth(context)*0.07,vertical: 10):EdgeInsets.all(8),
        onTap: (i) {
          setState(() => _currentIndex = i);
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
      )
    );
  }
}
