import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/operator_register_controller.dart';
import 'package:vehicle_management_and_booking_system/common/helper.dart';
import 'package:vehicle_management_and_booking_system/models/operator_model.dart';
import 'package:vehicle_management_and_booking_system/screens/operator/operator_details.dart';
import 'package:vehicle_management_and_booking_system/screens/operator/widgets/list_shimmer.dart';

class OperatorSearchScreen extends StatefulWidget {
  const OperatorSearchScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<OperatorSearchScreen> createState() => _OperatorSearchScreenState();
}

class _OperatorSearchScreenState extends State<OperatorSearchScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
List<OperatorModel> _allOperators = [];


  double calculateDistance(
      Locations location, double latitude, double longitude) {
    final earthRadius = 6371.0; // in kilometers
    final dLat = _degreesToRadians(location.latitude - latitude);
    final dLon = _degreesToRadians(location.longitude - longitude);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        sin(dLon / 2) *
            sin(dLon / 2) *
            cos(_degreesToRadians(latitude)) *
            cos(_degreesToRadians(location.latitude));
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  double _degreesToRadians(degrees) {
    return degrees * pi / 180;
  }

  Future<List<QueryDocumentSnapshot>>
      getNearestAndHighestRatedOperator() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    var latitude = position.latitude;
    var longitude = position.longitude;
    final ref = FirebaseFirestore.instance.collection('Operators');
    final snapshots = await ref.get();

    List<QueryDocumentSnapshot> sortedDocs = snapshots.docs.toList()
      ..sort((a, b) {
        final locA = Locations.fromJson(a.data()['location']);
        final locB = Locations.fromJson(b.data()['location']);

        // Normalize distance to a 0-1 scale (Assuming max distance is 20000 km)
        final distA = calculateDistance(locA, latitude, longitude) / 10;
        final distB = calculateDistance(locB, latitude, longitude) / 10;

        // Normalize rating to a 0-1 scale (Assuming max rating is 5)
        final rateA = a.data()['rating'] / 5;
        final rateB = b.data()['rating'] / 5;

        // Calculate a combined score based on distance and rating
        final scoreA = calculateScore(distA, rateA);
        final scoreB = calculateScore(distB, rateB);

        // Sort in descending order of combined score
        return scoreB.compareTo(scoreA);
      });

    return sortedDocs;
  }

  double calculateScore(double distance, double rating) {
    final weightDistance = 0.4; // weight for distance (less is better)
    final weightRating = 0.6; // weight for rating (more is better)

    // Note that we subtract distance from 1 because a shorter distance is better
    return weightDistance * (1 - distance) + weightRating * rating;
  }


@override
  void initState() {
    // TODO: implement initState
    _allOperators = context.read<OperatorRegistrationController>().allOperators;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Operators"),
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
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return OperatorDetailsScreen(
                          operator: operator,
                        );
                      }));
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
                        leading: CircleAvatar(
                          radius: 30.0,
                          backgroundColor: Colors.grey.shade100,
                          // ignore: sort_child_properties_last
                          child: Container(
                              clipBehavior: Clip.antiAlias,
                              decoration:
                                  const BoxDecoration(shape: BoxShape.circle),
                              child: CachedNetworkImage(
                                imageUrl: operator.operatorImage!,
                                // placeholder: (context, url) =>
                                //     const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              )),
                        ),
                        title: Text(operator.name.toUpperCase().toString()),
                        subtitle: Text(
                            "Work Experience: ${operator.years.toString()} Years"),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.location_on_outlined),
                                Builder(builder: (context) {
                                  String temp = operator.location.title;
                                  String city = temp.length > 9
                                      ? "${temp.substring(0, min(9, temp.length))}..."
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
                  );
                }))
        
    );
  }
}
