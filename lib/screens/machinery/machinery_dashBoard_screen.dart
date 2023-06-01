import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:flutter/material.dart';
// ignore: library_prefixes
import 'package:flutter/foundation.dart' as TargetPlatform;
import 'package:vehicle_management_and_booking_system/screens/machinery/widgets/machinery_stream.dart';
import 'package:vehicle_management_and_booking_system/utils/media_query.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);
  // ignore: prefer_typing_uninitialized_variables
  var title = "Home Screen";
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchValue = '';
  final List<String> _suggestions = [
    "doosan",
    "Kobilko",
    "komatsu",
    "Hitachi",
  ];

  @override
  Widget build(BuildContext context) {
    /*24 is for notification bar on Android*/
    // double itemHeight = TargetPlatform.kIsWeb
    //     ? 120
    //     : Platform.isAndroid
    //         ? screenHeight(context) > 668
    //             ? 200
    //             : 230
    //         : 170; //(size.height - kToolbarHeight - 24) / 2.3;
    // const double itemWidth = 100; //size.width / 6;

    return Scaffold(
      //resizeToAvoidBottomInset: true,

      backgroundColor: Colors.white,
      appBar: EasySearchBar(
        // backgroundColor: Color(0XFF2661FA),
        // leading: Text("data"),
        title: Text(widget.title),
        onSearch: (value) => setState(() => searchValue = value),
        suggestions: _suggestions,
      ),
      // AppBar(
      //   automaticallyImplyLeading: false,
      //   title: Text(widget.title),
      //   actions: [
      //     Container(
      //       margin: const EdgeInsets.only(right: 15),
      //       child: const Icon(Icons.notifications_none_outlined),
      //     ),
      //   ],
      // ),
      // drawer: Drawer(
      //   //elevation: 5,
      //   child: ListView(
      //     padding: EdgeInsets.zero,
      //     children: const [
      //       DrawerHeader(
      //         decoration: BoxDecoration(
      //           color: Colors.grey,
      //         ),
      //         child: Text("Drawer header"),
      //       ),
      //       ListTile(
      //         title: Text("Setting"),
      //         leading: Icon(Icons.settings),
      //       ),
      //       ListTile(
      //         title: Text("Log Out"),
      //         leading: Icon(Icons.logout),
      //       ),
      //     ],
      //   ),
      // ),
      body: Center(
        child: SizedBox(
          width: TargetPlatform.kIsWeb ? 500 : screenWidth(context),
          child: const MachineryStream(),
        ),
      ),

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
    );
  }
}
