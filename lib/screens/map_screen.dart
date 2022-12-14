import 'dart:async';
import 'package:flutter/foundation.dart' as TargetPlatform;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  List<Marker> markers = [];
  Future getLocation() async {
    try {
      // Ask permission from device
      await Geolocator.requestPermission();
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
      );
      print(position.latitude);
      print(position);
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
              myLocationEnabled: TargetPlatform.kIsWeb ? false : true,
               myLocationButtonEnabled:true,
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(target: _center, zoom: 10),
              markers: {
                const Marker(
                    markerId: MarkerId("ali"),
                    position: LatLng(34.052736, 71.426322)),
                 Marker(
                   icon: BitmapDescriptor.defaultMarkerWithHue(85),
                // infoWindow: InfoWindow.noText,

                    markerId: MarkerId("Sanii"),
                    position: LatLng(34.020365, 71.550513)),

              },
            ),
    );
  }
}
