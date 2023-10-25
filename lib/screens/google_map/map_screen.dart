import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' as TargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vehicle_management_and_booking_system/utils/const.dart';
import 'package:vehicle_management_and_booking_system/utils/media_query.dart';
// ignore: import_of_legacy_library_into_null_safe

// ignore: must_be_immutable
class MapScreen extends StatefulWidget {
  MapScreen({Key? key, required this.title}) : super(key: key);

  var title;
  static var lat;
  static var lon;
  static var isCheck = false;

  @override
  // ignore: library_private_types_in_public_api
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<Marker> _markers = [];
  List<Marker> markers = [];
  List<Marker> _operatorMarkers = [];

  // final latlong.Distance distance = const latlong.Distance();
  // final LatLng currentPOsition = LatLng(MapScreen.lat, MapScreen.lon);
  // double minDistance = double.infinity;
  // Marker? nearestMarker;

  Future getLocation() async {
    try {
      // Ask permission from device
      await Geolocator.requestPermission();
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
      );

      // print(position.latitude);
      // print(position);
      setState(() {
        MapScreen.isCheck = true;
      });
      MapScreen.lat = position.latitude;
      MapScreen.lon = position.longitude;
    } catch (e) {
      print(e);
    }
  }

  final Completer<GoogleMapController> _controller = Completer();
  static final LatLng _center = LatLng(MapScreen.lat, MapScreen.lon);
  void _onMapCreated(GoogleMapController controller) {
    if (_controller.isCompleted) {
      _controller.complete(controller);
    }
  }

  Future<void> _getMarkers() async {
    final QuerySnapshot<Map<String, dynamic>> markersSnapshot =
        await FirebaseFirestore.instance.collection('machineries').get();

    setState(() {
      _markers = markersSnapshot.docs
          .map(
            (doc) => Marker(
              icon: !TargetPlatform.kIsWeb
                  ? BitmapDescriptor.fromBytes(
                      MapIcons.markerIcon,
                    )
                  : MapIcons.destinationIcon,
              //icon: BitmapDescriptor.fromBytes(markerIcon),
              //  icon:   BitmapDescriptor.fromAssetImage(createLocalImageConfiguration(context,size: Size(10, 10)), "assets/images/axcevator/excavator.png") ,
              markerId: MarkerId(doc['machineryId']),
              position: LatLng(
                  doc['location']['latitude'], doc['location']['longitude']),
              infoWindow: InfoWindow(
                  title: doc['title'], snippet: doc['address'], onTap: () {}),
              onTap: () {
                showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (BuildContext context) {
                    return _buildBottomSheet(context, doc.data());
                  },
                );
              },
            ),
          )
          .toList();
    });
  }

  Future<void> _getOperatorMarkers() async {
    final QuerySnapshot<Map<String, dynamic>> operatorSnapshot =
        await FirebaseFirestore.instance.collection('Operators').get();

    setState(() {
      _operatorMarkers = operatorSnapshot.docs
          .map(
            (doc) => Marker(
              icon: TargetPlatform.kIsWeb? MapIcons.iconforperson:MapIcons.iconforpersonMobile,
              markerId: MarkerId(doc['operatorId']),
              position: LatLng(
                  doc['location']['latitude'], doc['location']['longitude']),
              infoWindow:
                  InfoWindow(title: doc['name'], snippet: doc['fullAddress']),
              // onTap: () {
              //   //  showModalBottomSheet(
              //   //   backgroundColor: Colors.transparent,
              //   //   context: context,
              //   //   builder: (BuildContext context) {
              //   //     return _buildOperatorBottomSheet(context, doc.data());
              //   //   },
              //   // );
              // },
            ),
          )
          .toList();
    });

    print(_operatorMarkers.length);
  }

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        MapIcons.setCustomMarkerIcon(context);
        _getOperatorMarkers();
        _getMarkers();

        MapIcons.markerIcon = await MapIcons.getBytesFromAsset(
            'assets/images/axcevator/excavator1.png', 80);
       // MapIcons.personIcon = await MapIcons.getBytesFromAsset("assets/images/iconforperson.png", 80);
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MapScreen.isCheck ? null : getLocation();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // backgroundColor: Colors.red,
        title: Text(
          widget.title,
          style: const TextStyle(
              color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      body: MapScreen.isCheck == false
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : GoogleMap(
              zoomGesturesEnabled: true,
              zoomControlsEnabled: true,

              // mapType: MapType.normal,
              myLocationEnabled: TargetPlatform.kIsWeb ? false : true,
              myLocationButtonEnabled: true,
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(target: _center, zoom: 11),
              markers: Set<Marker>.of(_markers + _operatorMarkers),
            ),
    );
  }
}

Widget _buildBottomSheet(BuildContext context, Map<String, dynamic> machinery) {
  return Container(
    height: screenHeight(context) * 0.4,
    decoration: const BoxDecoration(
      color: Colors.white, // This is the color of the inner container
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    padding: EdgeInsets.all(16),
    child: ListView(
      // mainAxisSize: MainAxisSize.min, // To make the bottom sheet wrap-content
      children: <Widget>[
        Text(
          'Machinery Details',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 16),
        Text(
          'Machinery ID: ${machinery['machineryId']}',
          style: TextStyle(fontSize: 18, color: Colors.grey[700]),
        ),
        Text(
          'Description: ${machinery['description']}',
          style: TextStyle(fontSize: 18, color: Colors.grey[700]),
        ),
        // Add more fields as needed
        SizedBox(height: 24),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green, // This is the color of the button
            foregroundColor: Colors.white, // This is the color of the text
          ),
          onPressed: () {
            // Implement your booking functionality here
          },
          child: Text('Book Now'),
        ),
      ],
    ),
  );
}

  // Widget _buildBottomSheet(BuildContext context, Map<String, dynamic> machinery) {
  //   return Container(
  //     height: screenHeight(context)*0.5,
  //     decoration: BoxDecoration(
     
  //       borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
  //     ),
  //     padding: EdgeInsets.all(16),
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min, // To make the bottom sheet wrap-content
  //       children: <Widget>[
  //         Text(
  //           'Machinery Details',
  //           style: TextStyle(
  //             fontSize: 24,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //         SizedBox(height: 16),
  //         Text(
  //           'Machinery ID: ${machinery['machineryId']}',
  //           style: TextStyle(fontSize: 18),
  //         ),
  //         Text(
  //           'Name: ${machinery['name']}',
  //           style: TextStyle(fontSize: 18),
  //         ),
  //         // Add more fields as needed
  //         SizedBox(height: 24),
  //         ElevatedButton(
  //           onPressed: () {
  //             // Implement your booking functionality here
  //           },
  //           child: Text('Book Now'),
  //         ),
  //       ],
  //     ),
  //   );
  // }