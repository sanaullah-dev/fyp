import 'dart:async';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' as TargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_management_and_booking_system/app/router.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/request_controller.dart';
import 'package:vehicle_management_and_booking_system/models/machinery_model.dart';
import 'package:vehicle_management_and_booking_system/models/operator_model.dart';
import 'package:vehicle_management_and_booking_system/utils/app_colors.dart';
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
  bool? _isDark;

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
      log(position.latitude.toString() + position.longitude.toString());
      MapScreen.lat = position.latitude;
      MapScreen.lon = position.longitude;
    } catch (e) {
      print(e);
    }
  }

  final Completer<GoogleMapController> _controller = Completer();
  static final LatLng _center = LatLng(MapScreen.lat, MapScreen.lon);
  // void _onMapCreated(GoogleMapController controller) {
  //   if (_controller.isCompleted) {
  //     _controller.complete(controller);
  //   }
  // }
  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    setMapStyle(controller);
  }

  void setMapStyle(GoogleMapController controller) async {
    _isDark = ConstantHelper.darkOrBright(context);
    String style = await DefaultAssetBundle.of(context).loadString(_isDark!
        ? 'assets/map_style_dark.json'
        : 'assets/map_style_light.json');
    controller.setMapStyle(style);
  }

  Future<void> _getMarkers() async {
    final QuerySnapshot<Map<String, dynamic>> markersSnapshot =
        await FirebaseFirestore.instance.collection('machineries').get();

    setState(() {
      _markers = markersSnapshot.docs
          .map(
            (doc) => Marker(
              icon: !TargetPlatform.kIsWeb
                  ? _isDark!
                      ? BitmapDescriptor.fromBytes(MapIcons.markerForDark)
                      : BitmapDescriptor.fromBytes(MapIcons.markerIcon)
                  : MapIcons.destinationIcon,
              //icon: BitmapDescriptor.fromBytes(markerIcon),
              //  icon:   BitmapDescriptor.fromAssetImage(createLocalImageConfiguration(context,size: Size(10, 10)), "assets/images/axcevator/excavator.png") ,
              markerId: MarkerId(doc['machineryId']),
              position: LatLng(
                  doc['location']['latitude'], doc['location']['longitude']),
              infoWindow: InfoWindow(
                title:
                    "Title: ${doc['title']} - Charges: Rs.${doc['charges']}/hr",
                snippet: "Address: ${doc['address']}",
              ),

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
              icon: TargetPlatform.kIsWeb
                  ? MapIcons.iconforperson
                  : MapIcons.iconforpersonMobile,
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
              onTap: () {
                showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (BuildContext context) {
                    OperatorModel operator = OperatorModel.fromJson(doc.data());
                    return _buildOperatorBottomSheet(context,operator);
                  },
                );
              },
            ),
          )
          .toList();
    });

    print(_operatorMarkers.length);
  }

  @override
  void initState() {
    // TODO: implement initState

//_isDark = ConstantHelper.darkOrBright(context);
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        _isDark = ConstantHelper.darkOrBright(context);
       await MapIcons.setAllMarker(context);

        _getOperatorMarkers();
        _getMarkers();

        MapIcons.markerIcon = await MapIcons.getBytesFromAsset(
            'assets/images/axcevator/excavator1.png', 80);
        // MapIcons.personIcon = await MapIcons.getBytesFromAsset("assets/images/iconforperson.png", 80);
        // ignore: use_build_context_synchronously
       // await context.read<RequestController>().checkActiveRequest(context);
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MapScreen.isCheck ? null : getLocation();
    bool isDark = ConstantHelper.darkOrBright(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark ? null : AppColors.accentColor,
        automaticallyImplyLeading: false,
        // backgroundColor: Colors.red,
        title: Text(
          widget.title,
          style: TextStyle(color: isDark ? null : AppColors.blackColor),
        ),
      ),
      body: MapScreen.isCheck == false
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : GoogleMap(
              zoomGesturesEnabled: true,
              zoomControlsEnabled: true,

              // mapType: MapType.,
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
  bool isDark = ConstantHelper.darkOrBright(context);
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Container(
      //height: screenHeight(context) * 0.4,
      //padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: isDark ? Colors.grey : Colors.white,
          borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.all(10),
      child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: const BorderSide(
              color: Colors.pink,
              width: 1.0,
            ),
          ),
          leading: CircleAvatar(
            radius: 30.0,
            backgroundColor: Colors.grey.shade100,
            backgroundImage: machinery["images"] != null
                ? CachedNetworkImageProvider(
                    machinery["images"]!.last.toString(),
                  )
                : null,
          ),
          title: Text(
            machinery["title"],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
              fontSize: 18.0,
            ),
          ),
          subtitle: Text(
            machinery["description"],
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.black54,
              fontSize: 14.0,
            ),
          ),
          trailing: IconButton(
              onPressed: () {
                // final model = MachineryModel.fromJson(machinery);
                Navigator.pushNamed(context, AppRouter.machineryDetailsPage,
                    arguments: machinery);
              },
              icon: const Icon(Icons.arrow_forward_ios_outlined))),
    ),
  );
}

Widget _buildOperatorBottomSheet(BuildContext context, OperatorModel operator) {
  bool isDark = ConstantHelper.darkOrBright(context);
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Container(
      decoration: BoxDecoration(
          color: isDark ? Colors.grey : Colors.white,
          borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.all(10),
      child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: const BorderSide(
              color: Colors.pink,
              width: 1.0,
            ),
          ),
          leading: CircleAvatar(
            radius: 30.0,
            backgroundColor: Colors.grey.shade100,
            backgroundImage: operator.operatorImage != null
                ? CachedNetworkImageProvider(
                    operator.operatorImage!,
                  )
                : null,
          ),
          title: Text(
            operator.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
              fontSize: 18.0,
            ),
          ),
          subtitle: Text(
            operator.summaryOrDescription ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.black54,
              fontSize: 14.0,
            ),
          ),
          trailing: IconButton(
              onPressed: () {
                Navigator.pushNamed(
                    context, 
                    AppRouter.operatorDetailsScreen,
                    arguments: operator
                );
              },
              icon: const Icon(Icons.arrow_forward_ios_outlined))),
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