import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as TargetPlatform;
import 'package:vehicle_management_and_booking_system/screens/machinery_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key, required this.title}) : super(key: key);
  var title;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchValue = '';
  final List<String> _suggestions = [
    'Afeganistan',
    'Albania',
    'Algeria',
    'Australia',
    'Brazil',
    'German',
    'Madagascar',
    'Mozambique',
    'Portugal',
    'Zambia'
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    /*24 is for notification bar on Android*/
    const double itemHeight = 170; //(size.height - kToolbarHeight - 24) / 2.3;
    const double itemWidth = 100; //size.width / 6;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: EasySearchBar(
          title: Text(widget.title),
          onSearch: (value) => setState(() => searchValue = value),
          suggestions: _suggestions),
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
          width: TargetPlatform.kIsWeb ? 600 : size.width,
          child: GridView.builder(
              itemCount: 10,
              //shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: (itemWidth / itemHeight),
                crossAxisCount: 2, //size.width > 770 ? 4 : 2,
                crossAxisSpacing: 3,
                mainAxisSpacing: 5,
              ),
              itemBuilder: (ctx, index) {
                return SizedBox(
                  //height: 500.0,

                  // margin: EdgeInsets.only(top: 5,left: 5,right: 5),

                  child: InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (ctx) {
                        return MachineryDetailScreen(
                            image: Image.asset("assets/images/main.png"),
                            title: "Doosan");
                      }));
                    },
                    child: Card(
                      color: Colors.pink,
                     // semanticContainer: true,
                      //clipBehavior: Clip.none,
                      elevation: 10,
                      //shadowColor: Colors.orangeAccent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                       mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                              height: size.height * 0.2,
                              child: Image.asset("assets/images/main.png")),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Doosan",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  margin: EdgeInsets.only(right: 10),
                                  child: Row(
                                    children: const [
                                      Icon(
                                        Icons.star,
                                        size: 15,
                                      ),
                                      Text(
                                        "4.5",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Doosan Excivater fdjjddkk lllsoew oekekoem",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: "Quantico",
                                color: Colors.black,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const Card(
                              elevation: 2,
                              child: Padding(
                                padding: EdgeInsets.all(6.0),
                                child: Text("Model 2022"),
                              )),
                          SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            
                            child: Container(
                              width: 100,
                              //height: size.height,
                              //  clipBehavior: Clip.antiAlias,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 10),

                              decoration: BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(20))),
                              child: Center(
                                  child: Text(
                                "Rs. 4000/hr",
                              )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
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

// import 'package:flutter/material.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return GridView.builder(
//       itemCount: 5,
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         crossAxisSpacing: 1,
//         mainAxisSpacing: 1,
//       ),
//       itemBuilder: (ctx, index) {
//         return Container(
//           margin: const EdgeInsets.all(10),
//           decoration: BoxDecoration(
//             shape: BoxShape.rectangle,
//             border: Border.all(
//               color: Colors.orangeAccent.withOpacity(0.80),
//               width: 0.5,
//             ),
//           ),
//           child: GridTile(
//
//             footer: Container(
//               height: 40,
//               width: MediaQuery.of(context).size.width,
//               color: Colors.orangeAccent.withOpacity(0.5),
//               child: Text(
//                 index.toString(),
//               ),
//             ),
//             child: Image.asset("assets/images/main.png"),
//           ),
//         );
//       },
//     );
//   }
// }
