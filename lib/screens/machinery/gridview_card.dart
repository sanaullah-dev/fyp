// ignore: file_names
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vehicle_management_and_booking_system/common/helper.dart';
import 'package:vehicle_management_and_booking_system/models/machinery_model.dart';
import 'package:vehicle_management_and_booking_system/screens/machinery/machinery_detials.dart';
import 'package:vehicle_management_and_booking_system/utils/media_query.dart';

// ignore: library_prefixes
import 'package:flutter/foundation.dart' as TargetPlatform;

// ignore: must_be_immutable
class SingleMachineryWidget extends StatefulWidget {
  SingleMachineryWidget({
    required this.machineryDetails,
    super.key,
  });
  MachineryModel machineryDetails;

  @override
  State<SingleMachineryWidget> createState() => _SingleMachineryWidgetState();
}

class _SingleMachineryWidgetState extends State<SingleMachineryWidget>
    with SingleTickerProviderStateMixin {
 

  @override
  void initState() {
    super.initState();
 
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   // dev.log(MediaQuery.of(context).size.height.toString());
   final Brightness brightnessValue = MediaQuery.of(context).platformBrightness;
    final isDarkModeOn = brightnessValue == Brightness.dark;
    return InkWell(
      onTap: () async {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return DetalleWidget(
                model: widget.machineryDetails,
              );
              
            },
          ),
        );
      },
      child: Card(
        clipBehavior: Clip.hardEdge,
        elevation: 10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: screenWidth(context) * 1,
              height: TargetPlatform.kIsWeb
                  ? 180
                  : screenHeight(context) > 846
                      ? screenHeight(context) * 0.22
                      : screenHeight(context) * 0.19,
              child: !TargetPlatform.kIsWeb
                  ? CachedNetworkImage(
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      imageUrl: widget.machineryDetails.images!.last,
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      widget.machineryDetails.images!.last,
                      fit: BoxFit.cover,
                    ),
            ),
            
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 20,
                      ),
                      Builder(builder: (context) {
                        String temp = widget.machineryDetails.location.title;
                        String city = temp.length > 11
                            ? "${temp.substring(0, min(7, temp.length))}..."
                            : temp;
                        return Text(
                          //"Islamabad",
                          city,
      
                          // widget.machineryDetails.address, overflow: TextOverflow.ellipsis,maxLines: 1,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        );
                      }),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 15,
                          color: Colors.amber,
                        ),
                        Builder(
                          builder: (context) {
                            return Text(
                              widget.machineryDetails.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                overflow: TextOverflow.clip,
                                  fontWeight: FontWeight.w500, fontSize: 14),
                            );
                          }
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.machineryDetails.title.toUpperCase().toString(),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 18,
                  fontFamily: "Quantico",
                 // color: Colors.black,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            SizedBox(
            //  color:  isDarkModeOn ? const Color.fromARGB(255, 111, 108, 108):null,
              height: 40,
              width: screenHeight(context) * 0.15,
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: FutureBuilder(
                    future: Helper.getDistance(
                        lat: widget.machineryDetails.location.latitude,
                        lon: widget.machineryDetails.location.longitude),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return const Text('Loading....');
                        default:
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return Text(
                              '${snapshot.data} km',
                              style: GoogleFonts.firaSans(
                                  fontWeight: FontWeight.w300),
                            );
                          }
                      }
                    }),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Container(
                width: 110,
                //height: MediaQuery.of(context).size.height,
                //height: size.height,
                // clipBehavior: Clip.hardEdge,
                //  padding: const EdgeInsets.only(l),
      
                decoration:  BoxDecoration(
                    color: isDarkModeOn ? const Color.fromARGB(255, 111, 108, 108): Colors.yellow,
                    borderRadius:
                        const BorderRadius.only(topRight: Radius.circular(20))),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 11.0),
                    child: Text(
                      "Rs.${widget.machineryDetails.charges.toString()}/h",
                      style: GoogleFonts.martianMono(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}






// // ignore: file_names
// import 'dart:math';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:vehicle_management_and_booking_system/common/helper.dart';
// import 'package:vehicle_management_and_booking_system/models/machinery_model.dart';
// import 'package:vehicle_management_and_booking_system/screens/machinery/machinery_detials.dart';
// import 'package:vehicle_management_and_booking_system/utils/media_query.dart';

// // ignore: library_prefixes
// import 'package:flutter/foundation.dart' as TargetPlatform;

// // ignore: must_be_immutable
// class SingleMachineryWidget extends StatefulWidget {
//   SingleMachineryWidget({
//     required this.machineryDetails,
//     super.key,
//   });
//   MachineryModel machineryDetails;

//   @override
//   State<SingleMachineryWidget> createState() => _SingleMachineryWidgetState();
// }

// class _SingleMachineryWidgetState extends State<SingleMachineryWidget>
//     with SingleTickerProviderStateMixin {
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // dev.log(MediaQuery.of(context).size.height.toString());
//     final Brightness brightnessValue =
//         MediaQuery.of(context).platformBrightness;
//     final isDarkModeOn = brightnessValue == Brightness.dark;
//     return InkWell(
//       onTap: () async {
//         Navigator.of(context).push(
//           MaterialPageRoute(
//             builder: (context) {
//               return DetalleWidget(
//                 model: widget.machineryDetails,
//               );
//             },
//           ),
//         );
//       },
//       child: Card(
//         clipBehavior: Clip.hardEdge,
//         elevation: 10,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             SizedBox(
//               width: screenWidth(context) * 1,
//               height: TargetPlatform.kIsWeb
//                   ? 180
//                   : screenHeight(context) > 846
//                       ? screenHeight(context) * 0.22
//                       : screenHeight(context) * 0.19,
//               child: !TargetPlatform.kIsWeb
//                   ? CachedNetworkImage(
//                       errorWidget: (context, url, error) =>
//                           const Icon(Icons.error),
//                       imageUrl: widget.machineryDetails.images!.last,
//                       fit: BoxFit.cover,
//                     )
//                   : Image.network(
//                       widget.machineryDetails.images!.last,
//                       fit: BoxFit.cover,
//                     ),
//             ),
//             const SizedBox(height: 10),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       const Icon(
//                         Icons.location_on_outlined,
//                         size: 20,
//                       ),
//                       Builder(builder: (context) {
//                         String temp = widget.machineryDetails.location.title;
//                         String city = temp.length > 11
//                             ? "${temp.substring(0, min(9, temp.length))}..."
//                             : temp;
//                         return Text(
//                           //"Islamabad",
//                           city,

//                           // widget.machineryDetails.address, overflow: TextOverflow.ellipsis,maxLines: 1,
//                           style: const TextStyle(fontWeight: FontWeight.bold),
//                         );
//                       }),
//                     ],
//                   ),
//                   Container(
//                     margin: const EdgeInsets.only(right: 10),
//                     child: Row(
//                       children: [
//                         SizedBox(
//                           //  color:  isDarkModeOn ? const Color.fromARGB(255, 111, 108, 108):null,
//                           // height: 40,
//                           //width: screenHeight(context) * 0.15,
//                           child: Padding(
//                             padding: const EdgeInsets.all(0.0),
//                             child: FutureBuilder(
//                               future: Helper.getDistance(
//                                   lat:
//                                       widget.machineryDetails.location.latitude,
//                                   lon: widget
//                                       .machineryDetails.location.longitude),
//                               builder: (context, snapshot) {
//                                 switch (snapshot.connectionState) {
//                                   case ConnectionState.waiting:
//                                     return const Text('Loading....');
//                                   default:
//                                     if (snapshot.hasError) {
//                                       return Text('Error: ${snapshot.error}');
//                                     } else {
//                                       return Text(
//                                         '${snapshot.data} km',
//                                         style: GoogleFonts.firaSans(
//                                             fontWeight: FontWeight.w300),
//                                       );
//                                     }
//                                 }
//                               },
//                             ),
//                           ),
//                         ),
//                         // const Icon(
//                         //   Icons.star,
//                         //   size: 15,
//                         //   color: Colors.amber,
//                         // ),
//                         // Builder(builder: (context) {
//                         //   return Text(
//                         //     widget.machineryDetails.rating.toStringAsFixed(1),
//                         //     style: const TextStyle(
//                         //         fontWeight: FontWeight.w500, fontSize: 14),
//                         //   );
//                         // }),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(
//                 widget.machineryDetails.title.toUpperCase().toString(),
//                 overflow: TextOverflow.ellipsis,
//                 maxLines: 1,
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontFamily: "Quantico",
//                   // color: Colors.black,
//                   fontWeight: FontWeight.w800,
//                 ),
//               ),
//             ),
//             // SizedBox(
//             //   //  color:  isDarkModeOn ? const Color.fromARGB(255, 111, 108, 108):null,
//             //   height: 40,
//             //   width: screenHeight(context) * 0.15,
//             //   child: Card(
//             //     color: isDarkModeOn
//             //         ? const Color.fromARGB(255, 111, 108, 108)
//             //         : null,
//             //     elevation: 2,
//             //     child: Padding(
//             //       padding: const EdgeInsets.all(6.0),
//             //       child: FutureBuilder(
//             //         future: Helper.getDistance(
//             //             lat: widget.machineryDetails.location.latitude,
//             //             lon: widget.machineryDetails.location.longitude),
//             //         builder: (context, snapshot) {
//             //           switch (snapshot.connectionState) {
//             //             case ConnectionState.waiting:
//             //               return const Text('Loading....');
//             //             default:
//             //               if (snapshot.hasError) {
//             //                 return Text('Error: ${snapshot.error}');
//             //               } else {
//             //                 return Text(
//             //                   '${snapshot.data} km',
//             //                   style: GoogleFonts.firaSans(
//             //                       fontWeight: FontWeight.w300),
//             //                 );
//             //               }
//             //           }
//             //         },
//             //       ),

//             //     ),
//             //   ),
//             // ),
//             SizedBox(
//               height: 40,
//               child: Row(
//                 children: [
//                   Builder(builder: (context) {
//                     bool _ratingIsLocked = true; // Locks the RatingBar when true
            
//                     return RatingBar.builder(
//                       initialRating: widget.machineryDetails.rating.toDouble(),
//                       minRating: 1,
//                       itemSize: 20,
//                       direction: Axis.horizontal,
//                       allowHalfRating: true,
//                       itemCount: 5,
//                       itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
//                       itemBuilder: (context, _) => const Icon(
//                         Icons.star,
//                         color: Colors.amber,
//                       ),
//                       ignoreGestures:
//                           _ratingIsLocked, // Set this to true to lock the rating bar
//                       onRatingUpdate: (rating) {
//                         // ignore: dead_code
//                         if (!_ratingIsLocked) {
//                           // Your code for updating the rating
//                         }
//                       },
//                     );
//                   }),SizedBox(width: 5,),
//                   Text(widget.machineryDetails.rating.toString()),
//                 ],
//               ),
//             ),
//             const SizedBox(
//               height: 10,
//             ),
//             Expanded(
//               child: Container(
//                 width: 110,
//                 //height: MediaQuery.of(context).size.height,
//                 //height: size.height,
//                 // clipBehavior: Clip.hardEdge,
//                 //  padding: const EdgeInsets.only(l),

//                 decoration: BoxDecoration(
//                     color: isDarkModeOn
//                         ? const Color.fromARGB(255, 111, 108, 108)
//                         : Colors.yellow,
//                     borderRadius:
//                         BorderRadius.only(topRight: Radius.circular(20))),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 11.0),
//                     child: Text(
//                       "Rs.${widget.machineryDetails.charges.toString()}/h",
//                       style: GoogleFonts.martianMono(),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
