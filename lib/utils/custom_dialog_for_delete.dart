
// import 'package:flutter/material.dart';

// class CustomDialogBox extends StatefulWidget {
//   CustomDialogBox({required BuildContext context})
 
//   @override
//   _CustomDialogBoxState createState() => _CustomDialogBoxState();
// }

// class _CustomDialogBoxState extends State<CustomDialogBox> {
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(20),
//       ),
//       elevation: 0,
//       backgroundColor: Colors.orange,
//       child: contentBox(context),
//     );
//   }

//   contentBox(context) {
//     return Stack(
//       children: <Widget>[
//         Container(
//           padding: EdgeInsets.all(10),
//           margin: EdgeInsets.only(top: 20),
//           decoration: BoxDecoration(
//               shape: BoxShape.rectangle,
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                     color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
//               ]),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               Text(
//                 "SANA ULLAH",
//                 style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
//               ),
//               SizedBox(
//                 height: 15,
//               ),
//               Text(
//                 "Flutter Developer",
//                 style: TextStyle(fontSize: 14),
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(
//                 height: 22,
//               ),
//               Align(
//                 alignment: Alignment.bottomRight,
//                 child: OutlinedButton(
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     },
//                     child: Text(
//                       "Yess",
//                       style: TextStyle(fontSize: 18),
//                     )),
//               ),
//             ],
//           ),
//         ),
//         Positioned(
//           left: 20,
//           right: 20,
//           child: CircleAvatar(
//             backgroundColor: Colors.transparent,
//             radius: 20,
//             child: ClipRRect(
//                 borderRadius: BorderRadius.all(Radius.circular(20)),
//                 child: Image.asset("assets/model.jpeg")),
//           ),
//         ),
//       ],
//     );
//   }
// }






// // Dialog(
// //     shape: RoundedRectangleBorder(
// //       borderRadius: BorderRadius.circular(20),
// //     ),
// //     elevation: 0,
// //     backgroundColor: Colors.orange,
// //     child: contentBox(context),
// //   );
// // }

// // contentBox(context) {
// //   return Stack(
// //     children: <Widget>[
// //       Container(
// //         padding: EdgeInsets.all(10),
// //         margin: EdgeInsets.only(top: 20),
// //         decoration: BoxDecoration(
// //             shape: BoxShape.rectangle,
// //             color: Colors.white,
// //             borderRadius: BorderRadius.circular(20),
// //             boxShadow: [
// //               BoxShadow(
// //                   color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
// //             ]),
// //         child: Column(
// //           mainAxisSize: MainAxisSize.min,
// //           children: <Widget>[
// //             Text(
// //               "SANA ULLAH",
// //               style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
// //             ),
// //             SizedBox(
// //               height: 15,
// //             ),
// //             Text(
// //               "Flutter Developer",
// //               style: TextStyle(fontSize: 14),
// //               textAlign: TextAlign.center,
// //             ),
// //             SizedBox(
// //               height: 22,
// //             ),
// //             Align(
// //               alignment: Alignment.bottomRight,
// //               child: OutlinedButton(
// //                   onPressed: () {
// //                     Navigator.of(context).pop();
// //                   },
// //                   child: Text(
// //                     "Yess",
// //                     style: TextStyle(fontSize: 18),
// //                   )),
// //             ),
// //           ],
// //         ),
// //       ),
// //       Positioned(
// //         left: 20,
// //         right: 20,
// //         child: CircleAvatar(
// //           backgroundColor: Colors.transparent,
// //           radius: 20,
// //           child: ClipRRect(
// //               borderRadius: BorderRadius.all(Radius.circular(20)),
// //               child: Image.asset("assets/model.jpeg")),
// //         ),
// //       ),
// //     ],
// //   );