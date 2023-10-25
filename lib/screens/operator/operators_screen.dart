// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'dart:math' as mth;
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_management_and_booking_system/app/router.dart';
import 'package:vehicle_management_and_booking_system/authentication/controllers/auth_controller.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/machinery_register_controller.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/operator_register_controller.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/request_controller.dart';
import 'package:vehicle_management_and_booking_system/common/helper.dart';
import 'package:vehicle_management_and_booking_system/models/operator_model.dart';
import 'package:vehicle_management_and_booking_system/screens/google_map/single_machiney_map.dart';
import 'package:vehicle_management_and_booking_system/utils/app_colors.dart';
import 'package:vehicle_management_and_booking_system/utils/const.dart';

class OperatorSearchScreen extends StatefulWidget {
  const OperatorSearchScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<OperatorSearchScreen> createState() => _OperatorSearchScreenState();
}

class _OperatorSearchScreenState extends State<OperatorSearchScreen> {
  //final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<OperatorModel> _allOperators = [];

  @override
  void initState() {
    // TODO: implement initState
    // _allOperators = [...context.read<OperatorRegistrationController>().allOperators];
    _allOperators = [
      ...context
          .read<OperatorRegistrationController>()
          .allOperators
          .where((operator) =>
              operator.uid != context.read<AuthController>().appUser!.uid &&
              operator.isAvailable != false)
          .toList()
    ];
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (mounted) {
        await context
            .read<OperatorRegistrationController>()
            .getNearestAndHighestRatedOperator();
        setState(() {});
      }
    });
  }

  bool _isSearching = false;
  String searchValue = '';

  void _filterOperators(String value) {
    if (value.isNotEmpty) {
      _allOperators = [
        ..._allOperators.where((operator) {
          return (operator.name.toLowerCase().contains(value.toLowerCase()) ||
                  operator.skills.toLowerCase().contains(value.toLowerCase()) ||
                  operator.rating.toString().contains(value.toLowerCase()) ||
                  operator.location.title
                      .toLowerCase()
                      .contains(value.toLowerCase())) &&
              operator.isAvailable != false;
        }).toList()
      ];
    } else {
      _allOperators = [
        ...context
            .read<OperatorRegistrationController>()
            .allOperators
            .where((operator) =>
                operator.uid != context.read<AuthController>().appUser!.uid &&
                operator.isAvailable != false)
            .toList()
      ];
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = ConstantHelper.darkOrBright(context);
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: isDark ? null : AppColors.accentColor,
          title: _isSearching
              ? SizedBox(
                  height: 40,
                  child: TextField(
                    style:
                        TextStyle(color: isDark ? null : AppColors.blackColor),
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            // borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                color: isDark
                                    ? Colors.white
                                    : AppColors.blackColor)),
                        contentPadding: const EdgeInsets.only(
                            left: 3, right: 2, bottom: 2, top: 2),
                        hintText: "Name, Skill, City, Rating",
                        hintStyle: TextStyle(
                            color: isDark ? null : AppColors.blackColor),
                        focusColor: isDark ? null : AppColors.blackColor,
                        border: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: isDark
                                    ? Colors.white
                                    : AppColors.blackColor))),
                    onChanged: (value) {
                      setState(() {
                        searchValue = value;
                        _filterOperators(value);
                      });

                      log(_allOperators.length.toString());
                    },
                  ),
                )
              : Text(
                  "Operators",
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
        body: ListView.separated(
            separatorBuilder: (context, index) {
              return const Divider();
            },
            itemCount: _allOperators.length,
            itemBuilder: ((context, index) {
              final OperatorModel operator = _allOperators[index];

              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, AppRouter.operatorDetailsScreen,
                      arguments: operator);
                },
                child: Container(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(
                        color: Colors.grey.shade400,
                        width: 1.0,
                      ),
                    ),
                    //  tileColor: AppColors.background,
                    leading: CircleAvatar(
                      backgroundColor: isDark ? null : AppColors.accentColor,
                      radius: 35.0,
                      //  backgroundColor: Colors.orange,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(200),
                        child: kIsWeb
                            ? Image.network(
                                operator.operatorImage.toString(),
                                width: 55.0, // diameter 70
                                height: 55.0, // diameter 70
                                fit: BoxFit.cover,
                              )
                            : CachedNetworkImage(
                                width: 55.0, // diameter 70
                                height: 55.0, // diameter 70
                                fit: BoxFit.cover,
                                imageUrl: operator.operatorImage!,
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                      ),
                    ),
                    title: Text(
                      operator.name.toUpperCase().toString(),
                      style: GoogleFonts.quantico(
                          fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text(
                        "Work Experience: ${operator.years.toString()} Years"),
                    trailing: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => SingleMachineMap(
                              loc: operator,
                              isOperator: true,
                            ),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.location_on_outlined),
                              Builder(builder: (context) {
                                String temp = operator.location.title;
                                String city = temp.length > 9
                                    ? "${temp.substring(0, mth.min(9, temp.length))}..."
                                    : temp;
                                return Text(
                                  //"Islamabad",
                                  city,

                                  // widget.machineryDetails.address, overflow: TextOverflow.ellipsis,maxLines: 1,
                                );
                              }),
                            ],
                          ),
                          FutureBuilder(
                              future: Helper.getDistance(
                                  lat: operator.location.latitude,
                                  lon: operator.location.longitude),
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
                        ],
                      ),
                    ),
                  ),
                ),
              );
            })));
  }
}





  // double calculateDistance(
  //     Locations location, double latitude, double longitude) {
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
  //     getNearestAndHighestRatedOperator() async {
  //   Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.bestForNavigation);
  //   var latitude = position.latitude;
  //   var longitude = position.longitude;
  //   final ref = FirebaseFirestore.instance.collection('Operators');
  //   final snapshots = await ref.get();

  //   List<QueryDocumentSnapshot> sortedDocs = snapshots.docs.toList()
  //     ..sort((a, b) {
  //       final locA = Locations.fromJson(a.data()['location']);
  //       final locB = Locations.fromJson(b.data()['location']);

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