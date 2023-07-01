// ignore_for_file: file_names

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_management_and_booking_system/authentication/controllers/auth_controller.dart';
import 'package:vehicle_management_and_booking_system/models/machinery_model.dart';
import 'package:flutter/foundation.dart' as TargetPlatform;
import 'package:vehicle_management_and_booking_system/utils/const.dart';

class MachineryDetail extends StatelessWidget {
  final MachineryModel machineryDetails;

  const MachineryDetail({super.key, required this.machineryDetails});

  @override
  Widget build(BuildContext context) {
   // log("message");
    return Scaffold(
      appBar: AppBar(
        title: const Text('Machinery Details'),
      ),
      body: ListView(
        //crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Display images at the top
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: machineryDetails.images?.length ?? 0,
              itemBuilder: (context, index) {
                return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.grey,
                          width: 1,
                        ),
                      ),
                      child: !TargetPlatform.kIsWeb
                          ? CachedNetworkImage(
                              // placeholder: (context, url) =>
                              //   const Center(child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              imageUrl: machineryDetails.images![index],
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              machineryDetails.images![index],
                              fit: BoxFit.cover,
                            ),
                      //Image.network(machineryDetails.images![index])),
                    ));
              },
            ),
          ),
          const SizedBox(height: 16),
          // Display machinery details
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  machineryDetails.title,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Model:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  machineryDetails.model,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 16),
                Text(
                  machineryDetails.description,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Location:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 200,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        machineryDetails.location.latitude,
                        machineryDetails.location.longitude,
                      ),
                      zoom: 15,
                    ),
                    // ignore: prefer_collection_literals
                    markers: Set<Marker>.from([
                      Marker(
                        icon: !TargetPlatform.kIsWeb
                  ? BitmapDescriptor.fromBytes(
                      MapIcons.markerIcon,
                    )
                  : MapIcons.destinationIcon,
                        markerId: MarkerId(machineryDetails.location.title),
                        infoWindow: InfoWindow(
                            title: machineryDetails.title.toString(),
                            snippet:
                                machineryDetails.location.title.toString()),
                        position: LatLng(
                          machineryDetails.location.latitude,
                          machineryDetails.location.longitude,
                        ),
                      ),
                    ]),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Address:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  machineryDetails.address,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Charges:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  ' \$${machineryDetails.charges.toString()} Per Hour',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          const Spacer(),
          // Confirm button at the bottom
         context.read<AuthController>().appUser!.uid != machineryDetails.uid? Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                // Perform action on confirm button press
              },
              child: const Text('Request'),
            ),
          ): const SizedBox(),
        ],
      ),
    );
  }
}

class IndivisualPageArgs {
  MachineryModel machineryDetails;
  IndivisualPageArgs({required this.machineryDetails});
}
