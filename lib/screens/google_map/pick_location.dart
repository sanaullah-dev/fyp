import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_management_and_booking_system/authentication/controllers/auth_controller.dart';

class PickLocation extends StatefulWidget {
  final Function(LatLng) onLocationTapped;

  PickLocation({required this.onLocationTapped});

  @override
  _PickLocationState createState() => _PickLocationState();
}


class _PickLocationState extends State<PickLocation> {
  Position? position;
  late GoogleMapController mapController;
  LatLng? _selectedLocation;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    position = context.read<AuthController>().position;
    _selectedLocation = LatLng(
      position!.latitude, position!.longitude);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Location'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            
            onMapCreated: _onMapCreated,
            onCameraMove: (cameraPosition) {
              _selectedLocation = cameraPosition.target;
            },
            initialCameraPosition: CameraPosition(
              target: _selectedLocation!,
              zoom: 16.5,
            ),
          ),
          const Center(
            
            child: Icon(Icons.location_on, color: Colors.red,),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: () {
                widget.onLocationTapped(_selectedLocation!);
                log(_selectedLocation.toString());
                Navigator.pop(context);
              },
              child: Text('Select This Location'),
            ),
          ),
        ],
      ),
    );
  }
}
