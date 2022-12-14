import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:vehicle_management_and_booking_system/screens/home_screen.dart';
import 'package:vehicle_management_and_booking_system/screens/map_screen.dart';
import 'package:vehicle_management_and_booking_system/screens/my_profile_screen.dart';
import 'package:vehicle_management_and_booking_system/screens/operator_screen.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({Key? key}) : super(key: key);

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  var _currentIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(title: "Home",),
     const SearchScreen(),
    MapScreen(title: "Find Here",),
   
    ProfileScreen(),

  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   title: const Text("Vehicle Management & Booking System"),
      // ),
      body: _pages[_currentIndex],
      bottomNavigationBar: SalomonBottomBar(

        currentIndex: _currentIndex,
        onTap: (i) {
          setState(() => _currentIndex = i);
          // _currentIndex == 0
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
            icon: Icon(Icons.emoji_people),
            title: Text("Operators"),
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
            icon: Icon(Icons.person),
            title: Text("Profile"),
            selectedColor: Colors.orangeAccent,
          ),
        ],
      ),
    );
  }
}
