// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:provider/provider.dart';
// import 'package:vehicle_management_and_booking_system/authentication/controllers/auth_controller.dart';
// import 'package:vehicle_management_and_booking_system/models/machinery_model.dart';
// import 'package:flutter/foundation.dart' as TargetPlatform;
// import 'package:vehicle_management_and_booking_system/screens/machinery/dashBoard_single_machinery_widget.dart';
// import 'package:vehicle_management_and_booking_system/screens/machinery/widgets/shimmer.dart';
// import 'package:vehicle_management_and_booking_system/utils/const.dart';
// import 'package:vehicle_management_and_booking_system/utils/media_query.dart';

// class MachineryStream extends StatefulWidget {
//   const MachineryStream({
//     super.key,
//   });

//   @override
//   State<MachineryStream> createState() => _MachineryStreamState();
// }

// class _MachineryStreamState extends State<MachineryStream> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     WidgetsBinding.instance.addPostFrameCallback(
//       (timeStamp) async {
//         MapIcons.setCustomMarkerIcon(context);
//         MapIcons.markerIcon = await MapIcons.getBytesFromAsset(
//             'assets/images/axcevator/excavator1.png', 100);
//       },
//     );
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       stream: FirebaseFirestore.instance
//           .collection("machineries")
//           .orderBy("rating", descending: true)
//           .snapshots(),
//       builder: (context, snapshot) {
//         final data = snapshot.data?.docs
//             .map((e) => MachineryModel.fromJson(e.data()))
//             .toList();

//         // Calculate distances and sort by distance and rating
//         // var userLocation = context.read<AuthController>().position;

//         // data!.forEach((machine) {
//         //   final machineLocation = machine.location;
//         //   machine.distance = Geolocator.distanceBetween(
//         //     userLocation.latitude,
//         //     userLocation.longitude,
//         //     machineLocation.latitude,
//         //     machineLocation.longitude,
//         //   );
//         // });

//         // data.sort((a, b) {
//         //   int comp = a.distance.compareTo(b.distance);
//         //   if (comp != 0) return comp;
//         //   return b.rating.compareTo(
//         //       a.rating); // When distance is equal, higher rating first
//         // });

//         switch (snapshot.connectionState) {
//           case ConnectionState.none:
//             return const SizedBox();
//           case ConnectionState.waiting:
//             return SkeletonMachineryWidget();
//           case ConnectionState.active:
//             return GridView.builder(
//                 itemCount: data!.length,
//                 //  shrinkWrap: true,
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   childAspectRatio: TargetPlatform.kIsWeb
//                       ? 0.7
//                       : screenHeight(context) < 700
//                           ? 0.6
//                           : 0.55, //(itemWidth / itemHeight),

//                   // shrinkWrap: true,
//                   crossAxisCount: 2, //size.width > 770 ? 4 : 2,
//                   // crossAxisSpacing: 2,
//                   // mainAxisSpacing: 5,
//                 ),
//                 itemBuilder: (ctx, index) {
//                   //  log(index.toString());
//                   // data.add(data[index] );
//                   //data.add(MachineryModel(machineryId: "machineryId", uid: "uid", name: "name", title: "title", model: "model", address: "address", description: "description", size: 626, charges: 21, emergencyNumber: "emergencyNumber", dateAdded: Timestamp.now(), rating:2.1, location: Location(title: "title", latitude: 21.22222, longitude: 31.2222)));
//                   // log(data[index].toString());
//                   return SingleMachineryWidget(
//                     machineryDetails: data[index],
//                   );
//                 });

//           case ConnectionState.done:
//             return const SizedBox();
//         }
//       },
//     );
//   }
// }

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_management_and_booking_system/authentication/controllers/auth_controller.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/machinery_register_controller.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/operator_register_controller.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/request_controller.dart';
import 'package:vehicle_management_and_booking_system/models/machinery_model.dart';
import 'package:vehicle_management_and_booking_system/screens/machinery/gridview_card.dart';
import 'package:flutter/foundation.dart' as TargetPlatform;
import 'package:vehicle_management_and_booking_system/screens/machinery/widgets/shimmer.dart';
import 'package:vehicle_management_and_booking_system/utils/const.dart';
import 'package:vehicle_management_and_booking_system/utils/media_query.dart';

class MachineryStream extends StatefulWidget {
  const MachineryStream({
    super.key,
  });

  @override
  State<MachineryStream> createState() => _MachineryStreamState();
}

class _MachineryStreamState extends State<MachineryStream> {
  late final machineryController;
  late final authController;
  late final operatorController;
  late final requestController;

  // var _appUserUid;

  // double calculateDistance(
  //     Location location, double latitude, double longitude) {
  //   final earthRadius = 6371.0; // in kilometers
  //   final dLat = _degreesToRadians(location.latitude - latitude);
  //   final dLon = _degreesToRadians(location.longitude - longitude);

  //   final a = sin(dLat / 2) * sin(dLat / 2) +
  //       sin(dLon / 2) *
  //           sin(dLon / 2) *
  //           cos(_degreesToRadians(latitude)) *
  //           cos(_degreesToRadians(location.latitude));
  //   final c = 2 * atan2(sqrt(a), sqrt(1 - a));

  //   return earthRadius * c;
  // }

  // double _degreesToRadians(degrees) {
  //   return degrees * pi / 180;
  // }

  // Future<List<QueryDocumentSnapshot>>
  //     getNearestAndHighestRatedMachines() async {
  //   Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.bestForNavigation);
  //   var latitude = position.latitude;
  //   var longitude = position.longitude;
  //   final ref = FirebaseFirestore.instance
  //       .collection('machineries')
  //       .where('uid', isNotEqualTo: appUser);
  //   final snapshots = await ref.get();

  //   List<QueryDocumentSnapshot> sortedDocs = snapshots.docs.toList()
  //     ..sort((a, b) {
  //       final locA = Location.fromJson(a.data()['location']);
  //       final locB = Location.fromJson(b.data()['location']);

  //       // Normalize distance to a 0-1 scale (Assuming max distance is 20000 km)
  //       final distA = calculateDistance(locA, latitude, longitude) / 10;
  //       final distB = calculateDistance(locB, latitude, longitude) / 10;

  //       // Normalize rating to a 0-1 scale (Assuming max rating is 5)
  //       final rateA = a.data()['rating'] / 5;
  //       final rateB = b.data()['rating'] / 5;

  //       // Calculate a combined score based on distance and rating
  //       final scoreA = calculateScore(distA, rateA);
  //       final scoreB = calculateScore(distB, rateB);

  //       // Sort in descending order of combined score
  //       return scoreB.compareTo(scoreA);
  //     });

  //   return sortedDocs;
  // }

  // double calculateScore(double distance, double rating) {
  //   final weightDistance = 0.4; // weight for distance (less is better)
  //   final weightRating = 0.6; // weight for rating (more is better)

  //   // Note that we subtract distance from 1 because a shorter distance is better
  //   return weightDistance * (1 - distance) + weightRating * rating;
  // }

  List<MachineryModel>? machines;
  @override
  void initState() {
    machineryController = context.read<MachineryRegistrationController>();
    authController = context.read<AuthController>();
    operatorController = context.read<OperatorRegistrationController>();
    requestController = context.read<RequestController>();

    if (machineryController.allMachineries != null) {
      machines = [
        ...machineryController.allMachineries!
            .where((machine) =>
                machine.uid != authController.appUser!.uid )
                // &&
                // machine!.isAvailable != false)
            .toList()
      ];
    }

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
      //  await machineryController.getAllMachineries();
        log("print1");
        await machineryController.fetchAllUsers();
        if (mounted) {
          // Future.delayed(const Duration(seconds: 2), () async {
          await context.read<RequestController>().checkActiveRequest(context);
          // ignore: use_build_context_synchronously
          await context
              .read<MachineryRegistrationController>()
              .getAllRequests();
          //  });

          await operatorController.getNearestAndHighestRatedOperator();
          // ignore: use_build_context_synchronously
          await MapIcons.setAllMarker(context);
          MapIcons.markerIcon = await MapIcons.getBytesFromAsset(
              'assets/images/axcevator/excavator1.png', 100, 100);
          MapIcons.markerForDark = await MapIcons.getBytesFromAsset(
              'assets/images/axcevator/excavatorForDark.png', 100, 100);
          // if (mounted) {
          //   await requestController.checkActiveRequest(context);
          // }
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return context.read<MachineryRegistrationController>().allMachineries ==
            null
        ? SkeletonMachineryWidget()
        : GridView.builder(
            itemCount: machines!.length,
            //  shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: TargetPlatform.kIsWeb
                  ? 0.7
                  : screenHeight(context) > 700
                      ? 0.55
                      : 0.6, //(itemWidth / itemHeight),

              // shrinkWrap: true,
              crossAxisCount: 2, //size.width > 770 ? 4 : 2,
              // crossAxisSpacing: 2,
              // mainAxisSpacing: 5,
            ),
            itemBuilder: (ctx, index) {
              // dev.log(docs[index].data().toString());
              final machinery = machines![index];
              // ignore: unnecessary_null_comparison
              if (machinery == null) {
                return null;
              }
              //dev.log(machinery.model.toString());

              //  log(index.toString());
              // data.add(data[index] );
              //data.add(MachineryModel(machineryId: "machineryId", uid: "uid", name: "name", title: "title", model: "model", address: "address", description: "description", size: 626, charges: 21, emergencyNumber: "emergencyNumber", dateAdded: Timestamp.now(), rating:2.1, location: Location(title: "title", latitude: 21.22222, longitude: 31.2222)));
              // log(data[index].toString());
              return SingleMachineryWidget(
                machineryDetails: machinery,
              );
            });

    //   case ConnectionState.done:
    //     return const SizedBox();
    // }
  }
  
}

// import 'dart:math';
// import 'dart:developer' as dev;
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:provider/provider.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:vehicle_management_and_booking_system/authentication/controllers/auth_controller.dart';
// import 'package:vehicle_management_and_booking_system/common/controllers/machinery_register_controller.dart';
// import 'package:vehicle_management_and_booking_system/models/machinery_model.dart';
// import 'package:vehicle_management_and_booking_system/screens/machinery/gridview_card.dart';
// import 'package:flutter/foundation.dart' as TargetPlatform;
// import 'package:vehicle_management_and_booking_system/screens/machinery/widgets/shimmer.dart';
// import 'package:vehicle_management_and_booking_system/utils/const.dart';
// import 'package:vehicle_management_and_booking_system/utils/media_query.dart';

// class MachineryStream extends StatefulWidget {
//   const MachineryStream({
//     super.key,
//   });

//   @override
//   State<MachineryStream> createState() => _MachineryStreamState();
// }

// class _MachineryStreamState extends State<MachineryStream> {
//   var appUser;

//   double calculateDistance(
//       Location location, double latitude, double longitude) {
//     final earthRadius = 6371.0; // in kilometers
//     final dLat = _degreesToRadians(location.latitude - latitude);
//     final dLon = _degreesToRadians(location.longitude - longitude);

//     final a = sin(dLat / 2) * sin(dLat / 2) +
//         sin(dLon / 2) *
//             sin(dLon / 2) *
//             cos(_degreesToRadians(latitude)) *
//             cos(_degreesToRadians(location.latitude));
//     final c = 2 * atan2(sqrt(a), sqrt(1 - a));

//     return earthRadius * c;
//   }

//   double _degreesToRadians(degrees) {
//     return degrees * pi / 180;
//   }

//   Future<List<QueryDocumentSnapshot>>
//       getNearestAndHighestRatedMachines() async {
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.bestForNavigation);
//     var latitude = position.latitude;
//     var longitude = position.longitude;
//     final ref = FirebaseFirestore.instance
//         .collection('machineries')
//         .where('uid', isNotEqualTo: appUser);
//     final snapshots = await ref.get();

//     List<QueryDocumentSnapshot> sortedDocs = snapshots.docs.toList()
//       ..sort((a, b) {
//         final locA = Location.fromJson(a.data()['location']);
//         final locB = Location.fromJson(b.data()['location']);

//         // Normalize distance to a 0-1 scale (Assuming max distance is 20000 km)
//         final distA = calculateDistance(locA, latitude, longitude) / 10;
//         final distB = calculateDistance(locB, latitude, longitude) / 10;

//         // Normalize rating to a 0-1 scale (Assuming max rating is 5)
//         final rateA = a.data()['rating'] / 5;
//         final rateB = b.data()['rating'] / 5;

//         // Calculate a combined score based on distance and rating
//         final scoreA = calculateScore(distA, rateA);
//         final scoreB = calculateScore(distB, rateB);

//         // Sort in descending order of combined score
//         return scoreB.compareTo(scoreA);
//       });

//     return sortedDocs;
//   }

//   double calculateScore(double distance, double rating) {
//     final weightDistance = 0.4; // weight for distance (less is better)
//     final weightRating = 0.6; // weight for rating (more is better)

//     // Note that we subtract distance from 1 because a shorter distance is better
//     return weightDistance * (1 - distance) + weightRating * rating;
//   }

//    List<MachineryModel>? machines;
//   @override
//   void initState() {
//     // TODO: implement initState
//     machines = context.read<MachineryRegistrationController>().allMachineries;
//     appUser = context.read<AuthController>().appUser!.uid;
//     WidgetsBinding.instance.addPostFrameCallback(
//       (timeStamp) async {
//         // await context.read<MachineryRegistrationController>().getAllMachineries();
//          await   context.read<MachineryRegistrationController>().fetchAllUsers();

//         MapIcons.setCustomMarkerIcon(context);
//         MapIcons.markerIcon = await MapIcons.getBytesFromAsset(
//             'assets/images/axcevator/excavator1.png', 100);
//       },
//     );
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<QueryDocumentSnapshot>>(
//       future: getNearestAndHighestRatedMachines(),
//       builder: (context, AsyncSnapshot<List<QueryDocumentSnapshot>> snapshot) {
//         if (snapshot.hasError) {
//           return Text("Some went wrong");
//         }
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return SkeletonMachineryWidget();
//         }
//         // dev.log("sana");
//         final docs = snapshot.data;
//         // final data = docs
//         //   snapshot.docs
//         // .map((doc) => MapEntry(doc, calculateDistance(doc.data()['location'], latitude, longitude)))
//         // .toList()..sort((a, b) => a.value.compareTo(b.value))
//         // .map((entry) => entry.key)
//         // .toList();
//         // snapshot.data?.docs
//         //     .map((e) => MachineryModel.fromJson(e.data()))
//         //     .toList();
//         //dev.log("sana");

//         // switch (snapshot.connectionState) {
//         //   case ConnectionState.none:
//         //     return const SizedBox();
//         //   case ConnectionState.waiting:
//         //    //dev.log("sana");
//         //     return const Center(
//         //       child: CircularProgressIndicator(),
//         //     );
//         //   case ConnectionState.active:
//         //   // dev.log("sana");
//         return GridView.builder(
//             itemCount: docs!.length,
//             //  shrinkWrap: true,
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               childAspectRatio: TargetPlatform.kIsWeb
//                   ? 0.7
//                   : screenHeight(context) > 700
//                       ? 0.55
//                       : 0.6, //(itemWidth / itemHeight),

//               // shrinkWrap: true,
//               crossAxisCount: 2, //size.width > 770 ? 4 : 2,
//               // crossAxisSpacing: 2,
//               // mainAxisSpacing: 5,
//             ),
//             itemBuilder: (ctx, index) {
//               // dev.log(docs[index].data().toString());
//               final doc = docs[index];

//               final data = doc.data() as Map<String, dynamic>;
//               final machinery = MachineryModel.fromJson(data);
//               //dev.log(machinery.model.toString());

//               //  log(index.toString());
//               // data.add(data[index] );
//               //data.add(MachineryModel(machineryId: "machineryId", uid: "uid", name: "name", title: "title", model: "model", address: "address", description: "description", size: 626, charges: 21, emergencyNumber: "emergencyNumber", dateAdded: Timestamp.now(), rating:2.1, location: Location(title: "title", latitude: 21.22222, longitude: 31.2222)));
//               // log(data[index].toString());
//               return SingleMachineryWidget(
//                 machineryDetails: machinery,
//               );
//             });

//         //   case ConnectionState.done:
//         //     return const SizedBox();
//         // }
//       },
//     );
//   }
// }
