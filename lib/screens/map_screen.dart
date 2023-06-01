import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' as TargetPlatform;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:latlong2/latlong.dart' as latlong;

// ignore: must_be_immutable
class MapScreen extends StatefulWidget {
  MapScreen({Key? key, required this.title}) : super(key: key);

  var title;
  static var lat;
  static var lon;
  static var isCheck = false;

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<Marker> _markers = [];
  List<Marker> markers = [];
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
    _controller.complete(controller);
  }

  Future<void> _getMarkers() async {
    final QuerySnapshot<Map<String, dynamic>> markersSnapshot =
        await FirebaseFirestore.instance.collection('machineries').get();

    setState(() {
      _markers = markersSnapshot.docs
          .map(
            (doc) => Marker(
              markerId: MarkerId(doc['machineryId']),
              position: LatLng(
                  doc['location']['latitude'], doc['location']['longitude']),
              infoWindow:
                  InfoWindow(title: doc['title'], snippet: doc['address']),
            ),
          )
          .toList();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        _getMarkers();
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
              //zoomControlsEnabled: true,
              // mapType: MapType.normal,
              myLocationEnabled: TargetPlatform.kIsWeb ? false : true,
              myLocationButtonEnabled: true,
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(target: _center, zoom: 11),
              markers: Set<Marker>.of(_markers),
              // markers: {
              //   const Marker(
              //       markerId: MarkerId("ali"),
              //       position: LatLng(34.052736, 71.426322)),
              //    Marker(
              //      icon: BitmapDescriptor.defaultMarkerWithHue(85),
              //   // infoWindow: InfoWindow.noText,

              //       markerId: const MarkerId("Sanii"),
              //       position: const LatLng(34.020365, 71.550513)),

              // },
            ),
    );
  }
}
