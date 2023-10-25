// import 'package:flutter/material.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:vehicle_management_and_booking_system/utils/media_query.dart';

// class SkeletonMachineryWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey[300]!,
//       highlightColor: Colors.grey[100]!,
//       child: InkWell(
//         child: Card(
//           clipBehavior: Clip.hardEdge,
//           elevation: 10,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               SizedBox(
//                 width: screenWidth(context) * 1,
//                 height: 180,
//                 child: Container(color: const Color.fromARGB(255, 238, 226, 226)),
//               ),
//               const SizedBox(height: 10),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         Icon(Icons.location_on_outlined, size: 20, color: Color.fromARGB(255, 140, 152, 143)),
//                         Container(width: 70, height: 8, color: const Color.fromARGB(255, 71, 69, 69)),
//                       ],
//                     ),
//                     Container(
//                       margin: const EdgeInsets.only(right: 10),
//                       child: Row(
//                         children: [
//                           Icon(Icons.star, size: 15, color: Color.fromARGB(255, 238, 213, 175)),
//                           Container(width: 30, height: 8, color: const Color.fromARGB(255, 159, 110, 110)),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Container(
//                   width: double.infinity,
//                   height: 8.0,
//                   color: const Color.fromARGB(255, 95, 71, 71),
//                 ),
//               ),
//               SizedBox(
//                 height: 40,
//                 width: screenHeight(context) * 0.15,
//                 child: Card(
//                   elevation: 2,
//                   child: Padding(
//                     padding: const EdgeInsets.all(6.0),
//                     child: Container(width: 70, height: 8, color: Color.fromARGB(255, 246, 240, 160)),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Expanded(
//                 child: Container(
//                   width: 110,
//                   decoration: const BoxDecoration(
//                     color: Colors.yellow,
//                     borderRadius: BorderRadius.only(topRight: Radius.circular(20)),
//                   ),
//                   child: Align(
//                     alignment: Alignment.centerLeft,
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 11.0),
//                       child: Container(width: 70, height: 8, color: const Color.fromARGB(255, 180, 20, 20)),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/foundation.dart' as TargetPlatform;
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vehicle_management_and_booking_system/utils/const.dart';
import 'package:vehicle_management_and_booking_system/utils/media_query.dart';

class SkeletonMachineryWidget extends StatelessWidget {
  //final int timer;

  SkeletonMachineryWidget();

  @override
  Widget build(BuildContext context) {
    bool isDark = ConstantHelper.darkOrBright(context);

    Color baseColor = isDark ? Colors.grey[700]! : Colors.grey[300]!;
    Color highlightColor = isDark ? Colors.grey[600]! : Colors.grey[100]!;
    return GridView.builder(
            itemCount: 10, // Assuming skeleton items
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: TargetPlatform.kIsWeb
                  ? 0.7
                  : screenHeight(context) > 700
                      ? 0.55
                      : 0.6,
              crossAxisCount: 2,
            ),
            itemBuilder: (_, __) => Shimmer.fromColors(
              baseColor: baseColor,
              highlightColor: highlightColor,
              child: Container(
                margin: EdgeInsets.all(7.5),
                child: Column(
                  children: <Widget>[
                    // Mimic the machinery image
                    Container(
                      width: double.infinity,
                      height: screenHeight(context)*0.25,
                      color: Colors.white,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.0),
                    ),
                    // Mimic the machinery subtitle
                    Container(
                      width: double.infinity,
                    height: 5,
                      color: Colors.white,
                    ),
                    
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.0),
                    ),
                    // Mimic the machinery title
                    Container(
                      width: double.infinity,
                      height: screenHeight(context)*0.05,
                      color: Colors.white,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.0),
                    ),
                    // Mimic the machinery subtitle
                    Container(
                      width: double.infinity,
                    height: screenHeight(context)*0.02,
                      color: Colors.white,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.0),
                    ),
                    // Mimic some other data
                    Container(
                      width: double.infinity,
                      height: screenHeight(context)*0.05,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}

