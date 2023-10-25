// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' as TargetPlatform;
import 'package:vehicle_management_and_booking_system/app/app.dart';
import 'package:vehicle_management_and_booking_system/app/router.dart';
import 'package:vehicle_management_and_booking_system/authentication/controllers/auth_controller.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/machinery_register_controller.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/request_controller.dart';
import 'package:vehicle_management_and_booking_system/models/machinery_model.dart';
import 'package:vehicle_management_and_booking_system/models/request_machiery_model.dart';
import 'package:vehicle_management_and_booking_system/screens/common/messages_screen.dart';
import 'package:vehicle_management_and_booking_system/screens/login_signup/model/user_model.dart';
import 'package:vehicle_management_and_booking_system/screens/machinery/widgets/show_cancel_dialog.dart';
import 'package:vehicle_management_and_booking_system/utils/app_colors.dart';
import 'package:vehicle_management_and_booking_system/utils/const.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vehicle_management_and_booking_system/utils/media_query.dart';

class TrackOrder extends StatefulWidget {
  TrackOrder({
    super.key,
    required this.request,
  });
  final RequestModelForMachieries request;

  @override
  State<TrackOrder> createState() => _TrackOrderState();
}

class _TrackOrderState extends State<TrackOrder> {
  bool? _isDark;
  // Position? positions;

  late UserModel appUser;
  late MachineryModel machine;
  late UserModel requestSender;
  late UserModel requestReceiver;
  late RequestController requestController;
  late AuthController authController;
  late MachineryRegistrationController machineryRegistrationController;
  RequestController? _requestController;
  GoogleMapController? _googleMapController;
  late final StatusUpdateListener statusListener;

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    _googleMapController = controller;
    setMapStyle(controller);
  }

  void setMapStyle(GoogleMapController controller) async {
    _isDark = ConstantHelper.darkOrBright(context);
    String style = await DefaultAssetBundle.of(context).loadString(_isDark!
        ? 'assets/map_style_dark.json'
        : 'assets/map_style_light.json');
    controller.setMapStyle(style);
  }

  final Completer<GoogleMapController> _controller = Completer();
  // static LatLng? source; // = LatLng(37.335813, -122.032543);
  // static LatLng? destination; //= //LatLng(37.337160, -122.082791);
  // //  LatLng(37.334464, -122.045020);
  // List<LatLng> plylineCoordinates = [];
  // ignore: prefer_typing_uninitialized_variables
  // var currentLocation;
  // bool isLoading = true;
  // late final DatabaseReference database =
  //     FirebaseDatabase.instance.ref().child("Locations");

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Only set the _requestController if it hasn't been set before
    _requestController ??= context.read<RequestController>();
  }
  // Future<void> getCurrentLocation() async {
  //   try {
  //     Position position = await Geolocator.getCurrentPosition(
  //         desiredAccuracy: LocationAccuracy.bestForNavigation);

  //     if (mounted) {
  //       if (widget.request.machineryOwnerUid == appUser!.uid) {
  //         setState(() {
  //           currentLocation = geocoding.Location(
  //             latitude: position.latitude,
  //             longitude: position.longitude,
  //             timestamp: position.timestamp ?? DateTime.now(),
  //           );
  //           database.child(appUser!.uid).set({
  //             'latitude': currentLocation.latitude,
  //             'longitude': currentLocation.longitude,
  //             'timestamp': currentLocation.timestamp?.toIso8601String(),
  //           });
  //           isLoading = false;
  //         });
  //       }
  //       if (widget.request.senderUid == appUser!.uid) {
  //         database
  //             .child(widget.request.machineryOwnerUid)
  //             .onValue
  //             .listen((event) {
  //           var snapshot = event.snapshot;

  //           // Cast snapshot.value to Map<String, dynamic>
  //           var rawData = snapshot.value;
  //           Map<String, dynamic>? data;
  //           if (rawData is Map) {
  //             data = Map<String, dynamic>.from(rawData);
  //           }
  //           if (data != null) {
  //             currentLocation = geocoding.Location(
  //                 latitude: data['latitude'],
  //                 longitude: data['longitude'],
  //                 timestamp: DateTime.parse(data['timestamp']));
  //             setState(() {
  //               isLoading = false;
  //             });
  //           }
  //         });
  //       }
  //     }

  //     GoogleMapController googleMapController = await _controller.future;

  //     positionStream =
  //         Geolocator.getPositionStream().listen((Position position) {
  //       // log("message");

  //       if (widget.request.machineryOwnerUid == appUser!.uid) {
  //         context
  //             .read<RequestController>()
  //             .checkConfirm(context, widget.request.requestId.toString());
  //         database.child(appUser!.uid).set({
  //           'latitude': currentLocation.latitude,
  //           'longitude': currentLocation.longitude,
  //           'timestamp': currentLocation.timestamp?.toIso8601String(),
  //         });
  //       }
  //       double distanceToDestination = Geolocator.distanceBetween(
  //         currentLocation.latitude,
  //         currentLocation.longitude,
  //         destination!.latitude,
  //         destination!.longitude,
  //       );
  //       double distanceToDestination2 = 40;
  //       if (widget.request.machineryOwnerUid != appUser!.uid) {
  //         distanceToDestination2 = Geolocator.distanceBetween(
  //           position.latitude,
  //           position.longitude,
  //           currentLocation!.latitude,
  //           currentLocation!.longitude,
  //         );
  //       }
  //       if (distanceToDestination <= 30 || distanceToDestination2 <= 30) {
  //         // positionStream?.cancel(); // Stop listening to position updates
  //         if (mounted) {
  //           log("sana");
  //           context
  //               .read<RequestController>()
  //               .checkConfirm(context, widget.request.requestId.toString());
  //           setState(() {
  //             isAtDestination = true;
  //           });
  //         }
  //         return;
  //       }
  //       setState(() {});

  //       if (mounted) {
  //         if (widget.request.machineryOwnerUid == appUser!.uid) {
  //           setState(() {
  //             currentLocation = geocoding.Location(
  //               latitude: position.latitude,
  //               longitude: position.longitude,
  //               timestamp: position.timestamp ?? DateTime.now(),
  //             );
  //           });
  //         }
  //       }
  //       if (widget.request.senderUid == appUser!.uid) {
  //         database
  //             .child(widget.request.machineryOwnerUid)
  //             .onValue
  //             .listen((event) {
  //           var snapshot = event.snapshot;

  //           // Cast snapshot.value to Map<String, dynamic>
  //           var rawData = snapshot.value;
  //           Map<String, dynamic>? data;
  //           if (rawData is Map) {
  //             data = Map<String, dynamic>.from(rawData);
  //           }
  //           if (data != null) {
  //             currentLocation = geocoding.Location(
  //                 latitude: data['latitude'],
  //                 longitude: data['longitude'],
  //                 timestamp: DateTime.parse(data['timestamp']));
  //             setState(() {
  //               // isLoading = false;
  //             });
  //           }
  //         });
  //       }
  //       setState(() {

  //       });
  //       // if (mounted) {
  //       //   setState(() {
  //       //     currentLocation = geocoding.Location(
  //       //       latitude: position.latitude,
  //       //       longitude: position.longitude,
  //       //       timestamp: position.timestamp ?? DateTime.now(),
  //       //     );
  //       //   });
  //       // }

  //       googleMapController.animateCamera(
  //         CameraUpdate.newCameraPosition(
  //           CameraPosition(
  //             zoom: 16.5,
  //             target: LatLng(
  //               currentLocation.latitude,
  //               currentLocation.longitude,
  //             ),
  //           ),
  //         ),
  //       );
  //     });
  //     if (widget.request.machineryOwnerUid == appUser!.uid) {
  //       database.child(appUser!.uid).set({
  //         'latitude': currentLocation.latitude,
  //         'longitude': currentLocation.longitude,
  //         'timestamp': currentLocation.timestamp?.toIso8601String(),
  //       });

  //       database.child(appUser!.uid).onValue.listen((event) {
  //         var snapshot = event.snapshot;

  //         // Cast snapshot.value to Map<String, dynamic>
  //         var rawData = snapshot.value;
  //         Map<String, dynamic>? data;
  //         if (rawData is Map) {
  //           data = Map<String, dynamic>.from(rawData);
  //         }
  //         if (data != null) {
  //           currentLocation = geocoding.Location(
  //               latitude: data['latitude'],
  //               longitude: data['longitude'],
  //               timestamp: DateTime.parse(data['timestamp']));

  //           // double? latitude = data['latitude'] as double?;
  //           // double? longitude = data['longitude'] as double?;
  //           // DateTime? timestamp;
  //           // if (data['timestamp'] != null) {
  //           //   timestamp = DateTime.tryParse(data['timestamp'] as String);
  //           // }

  //           // Update UI or Google Map marker with the fetched location.
  //           // Ensure you handle potential null values for latitude, longitude, and timestamp.
  //         }
  //       });
  //     }
  //   } catch (error) {
  //     if (mounted) {
  //       setState(() {
  //         isLoading = false; // Set loading to false if there's an error
  //       });
  //     }
  //   }
  // }

//   Future _load() async {
//     var value = context.read<RequestController>();

//     // database = FirebaseDatabase.instance.ref().child(appUser!.uid);
//     LatLng src = LatLng(
//       widget.request.sourcelocation.latitude,
//       widget.request.sourcelocation.longitude,
//     );
//     LatLng dtn = LatLng(
//       widget.request.destinationLocation!.latitude,
//       widget.request.destinationLocation!.longitude,
//     );
// //MapIcons.setCustomMarkerIcons(context);
//     if (widget.request.machineryOwnerUid == appUser!.uid) {
//       // source = src;
//       // destination = dtn;
//       value.setSourceDestination(sourceArgument: src, destinations: dtn);
//     }
//     if (widget.request.senderUid == appUser!.uid) {
//       // source = dtn;
//       // destination = src;
//       value.setSourceDestination(sourceArgument: dtn, destinations: src);
//     }

//     MapIcons.setCustomMarkerIcons(context);
//     MapIcons.setAllMarker(context);
//     value.getCurrentLocation();
//     value.listenForConfirm(context, widget.request.requestId);
//     // getCurrentLocation();
//     // getPolyPoint();
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     appUser = context.read<AuthController>().appUser!;

//     machine = context
//         .read<MachineryRegistrationController>()
//         .getMachineById(widget.request.machineId);
//     requestSender = context
//         .read<MachineryRegistrationController>()
//         .getUser(widget.request.senderUid);
//     requestReceiver = context
//         .read<MachineryRegistrationController>()
//         .getUser(widget.request.machineryOwnerUid);
//     context
//         .read<RequestController>()
//         .setRequestAndUser(requests: widget.request, user: appUser!);

//     // provider = context.read<MachineryRegistrationController>();
//     // MapIcons.setCustomMarkerIcon(context);
//     // positions = context.read<AuthController>().position;
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
//       _load();
//     });
//     super.initState();
//   }

  @override
  void initState() {
    super.initState();

    // Storing context.read values in instance variables for single-time retrieval
    authController = context.read<AuthController>();
    machineryRegistrationController =
        context.read<MachineryRegistrationController>();
    requestController = context.read<RequestController>();
//machineryRegistrationController.isLoading =
    appUser = authController.appUser!;
//machineryRegistrationController.setLoading();
    machine = context
        .read<MachineryRegistrationController>()
        .getMachineById(widget.request.machineId);
    requestSender =
        machineryRegistrationController.getUser(widget.request.senderUid);
    requestReceiver = machineryRegistrationController
        .getUser(widget.request.machineryOwnerUid);

    requestController.setRequestAndUser(
        requests: widget.request, user: appUser);
    context.read<MachineryRegistrationController>().setIsCheckMachies(true);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _load();
    });
  }

  Future _load() async {
    requestController.getCurrentLocation();
    LatLng src = LatLng(
      widget.request.sourcelocation.latitude,
      widget.request.sourcelocation.longitude,
    );
    LatLng dtn = LatLng(
      widget.request.destinationLocation!.latitude,
      widget.request.destinationLocation!.longitude,
    );

    if (widget.request.machineryOwnerUid == appUser.uid) {
      requestController.setSourceDestination(
          sourceArgument: src, destinations: dtn);
    }
    if (widget.request.senderUid == appUser.uid) {
      requestController.setSourceDestination(
          sourceArgument: dtn, destinations: src);
    }
    log(widget.request.requestId);

    await MapIcons.setCustomMarkerIcons(context);
    await MapIcons.setAllMarker(context);
    ;
    statusListener = StatusUpdateListener(
        uid: appUser.uid,
        requestId: widget.request.requestId,
        machine: machine);
    statusListener.startListening(context);
    //requestController.listenForStatusUpdates(context, widget.request.requestId);
    // Future.delayed(Duration(seconds: 5), () async {
    //   requestController.getPolyPoint();
    //   setState(() {});
    // });
  }

  @override
  void dispose() {
    // TODO: implement dispose

    _requestController?.positionStream?.cancel();
    _requestController?.sentRequestsStream?.cancel();
    _requestController?.receivedRequestsStream?.cancel();

    statusListener.dispose();

    super.dispose();
  }

  double currentZoom = 16.5;

  void zoomIn() {
    if (currentZoom < 19) {
      // 19 or any maximum zoom level you want
      currentZoom += 1;
      _googleMapController?.animateCamera(CameraUpdate.zoomTo(currentZoom));
    }
  }

  void zoomOut() {
    if (currentZoom > 1) {
      // 1 or any minimum zoom level you want
      currentZoom -= 1;
      _googleMapController?.animateCamera(CameraUpdate.zoomTo(currentZoom));
    }
  }

  @override
  Widget build(BuildContext context) {
    bool _isDark = ConstantHelper.darkOrBright(context);
    // var provider = context.read<RequestController>();
    // if (context.read<RequestController>().isLoading) {
    // return const Scaffold(
    //   body: Center(
    //       child:
    //           CircularProgressIndicator()), // Show progress indicator while loading
    // );
    // }

    return Consumer<RequestController>(builder: (context, provider, _) {
      if (provider.isLoadingForTracking) {
        return const Scaffold(
          body: Center(
              child:
                  CircularProgressIndicator()), // Show progress indicator while loading
        );
      }
      return WillPopScope(
        onWillPop: () => Future(() => true),
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "Track Order",
              style: TextStyle(color: _isDark ? null : Colors.black),
            ),
            backgroundColor: _isDark ? null : AppColors.accentColor,
            automaticallyImplyLeading: false,
            // leading: IconButton(
            //     onPressed: () {
            //       Navigator.pop(context);
            //     },
            //     icon: Icon(
            //       Icons.arrow_back_ios_new_sharp,
            //       color: _isDark ? null : AppColors.blackColor,
            //     )),
          ),
          // appBar: AppBar(
          //   automaticallyImplyLeading: true,
          //   title: Text(
          //     'Track Order',
          //     style: TextStyle(
          //         color: _isDark == true ? Colors.white : Colors.black,
          //         fontSize: 16),
          //   ),
          // ),
          body: Stack(
            children: [
              Builder(builder: (context) {
                if (mounted) {
                  LatLng newLocation = LatLng(
                      provider.currentLocation!.latitude!,
                      provider.currentLocation.longitude);
                  _googleMapController?.animateCamera(
                      CameraUpdate.newLatLngZoom(newLocation, currentZoom));
                }
                return GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(provider.currentLocation!.latitude,
                        provider.currentLocation!.longitude),
                    zoom: 16.5,
                  ),
                  zoomControlsEnabled: false,
                  // cameraTargetBounds: CameraTargetBounds.unbounded,
                  // minMaxZoomPreference: const MinMaxZoomPreference(10, 17),
                  onMapCreated: _onMapCreated,
                  polylines: {
                    Polyline(
                      polylineId: const PolylineId('poly_id'),
                      points:provider.plylineCoordinates,//  [LatLng(34.03282, 71.60499), LatLng(34.03246, 71.6059), LatLng(34.03224, 71.60654), LatLng(34.0323, 71.60665), LatLng(34.03231, 71.60681), LatLng(34.03227, 71.60696), LatLng(34.03217, 71.60707), LatLng(34.03204, 71.60711), LatLng(34.03191, 71.60707), LatLng(34.03181, 71.60696), LatLng(34.03177, 71.60685), LatLng(34.03176, 71.60677), LatLng(34.03178, 71.60666), LatLng(34.03155, 71.606), LatLng(34.03125, 71.60544), LatLng(34.03093, 71.60486), LatLng(34.03048, 71.6041), LatLng(34.03009, 71.6034), LatLng(34.0298, 71.60289), LatLng(34.02946, 71.60235), LatLng(34.02891, 71.60137), LatLng(34.02855, 71.60137), LatLng(34.02818, 71.6014), LatLng(34.02785, 71.60149), LatLng(34.02776, 71.60151), LatLng(34.0277, 71.60149), LatLng(34.02766, 71.60152), LatLng(34.02766, 71.60219), LatLng(34.02764, 71.60253), LatLng(34.02767, 71.60258), LatLng(34.02771, 71.6026)],//provider.plylineCoordinates,
                      color: Colors.orange,
                      width: 5,
                    )
                  },
                  markers: {
                    Marker(
                      icon: TargetPlatform.kIsWeb
                          ? MapIcons.currentLocationForTrakingForWeb
                          : MapIcons.currentLocationForTraking,
                      markerId: const MarkerId("CurrentLocation"),
                      infoWindow: const InfoWindow(title: "current Location"),
                      position: LatLng(provider.currentLocation.latitude,
                          provider.currentLocation.longitude),
                    ),
                    Marker(
                      icon: !TargetPlatform.kIsWeb
                          ? widget.request.machineryOwnerUid == appUser.uid
                              ? MapIcons.icon2person
                              : widget.request.senderUid == appUser.uid
                                  ? MapIcons.icon1
                                  : BitmapDescriptor.defaultMarker
                          : widget.request.machineryOwnerUid == appUser.uid
                              ? MapIcons.icon2personForWeb
                              : widget.request.senderUid == appUser.uid
                                  ? MapIcons.icon1ForWeb
                                  : BitmapDescriptor.defaultMarker,
                      infoWindow: const InfoWindow(title: "Source"),
                      markerId: const MarkerId("Source"),
                      position: provider.source!,
                      //  icon: MapIcons.sourceIcon
                    ),
                    Marker(
                      infoWindow: InfoWindow(
                          title: widget.request.machineryOwnerUid == appUser.uid
                              ? "Source"
                              : "distination"),
                      icon: !TargetPlatform.kIsWeb
                          ? widget.request.machineryOwnerUid == appUser.uid
                              ? MapIcons.icon1
                              : widget.request.senderUid == appUser.uid
                                  ? MapIcons.icon2person
                                  : BitmapDescriptor.defaultMarker
                          : widget.request.machineryOwnerUid == appUser.uid
                              ? MapIcons.icon1ForWeb
                              : widget.request.senderUid == appUser.uid
                                  ? MapIcons.icon2personForWeb
                                  : BitmapDescriptor.defaultMarker,
                      markerId: const MarkerId('Destination'),
                      position: provider.destination!,
                    )
                  },
                );
              }),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                    height: screenHeight(context) * 0.3,
                    width: screenWidth(context),
                    decoration: BoxDecoration(
                        color: _isDark ? Colors.grey : Colors.white,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            // crossAxisAlignment: CrossAxisAlignment.baseline,
                            // mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  final phoneNumber =
                                      widget.request.machineryOwnerUid ==
                                              appUser.uid
                                          ? widget.request.mobileNumber!
                                          : requestReceiver.mobileNumber;
                                  final Uri launchUri = Uri(
                                    scheme: 'tel',
                                    path: phoneNumber,
                                  );
                                  await launchUrl(launchUri);
                                },
                                child: Container(
                                  width:
                                      40, // adjust width and height to your needs
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        30), // half of width/height for a circle
                                    color: Colors.white, // Card color
                                    boxShadow: [
                                      // Optional, to give elevation similar to Card
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 1,
                                        blurRadius: 3,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.call,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ),
                              ),
                              widget.request.machineryOwnerUid == appUser.uid
                                  ? Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Colors.orange, width: 1.0),
                                      ),
                                      child: CircleAvatar(
                                        radius:
                                            49, // Reduce a little to accommodate the border
                                        backgroundImage:
                                            requestSender.profileUrl != null
                                                ? CachedNetworkImageProvider(
                                                    requestSender.profileUrl
                                                        .toString(),
                                                   
                                                  )
                                                : null,
                                        child: requestSender.profileUrl == null
                                            ? Text(requestSender.name[0])
                                            : null,
                                      ),
                                    )
                                  : Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Colors.orange, width: 1.0),
                                      ),
                                      child: CircleAvatar(
                                        radius:
                                            49, // Reduce a little to accommodate the border
                                        backgroundImage:
                                            requestReceiver.profileUrl != null
                                                ? CachedNetworkImageProvider(
                                                    requestReceiver.profileUrl
                                                        .toString(),
                                                  
                                                  )
                                                : null,
                                        child:
                                            requestReceiver.profileUrl == null
                                                ? Text(requestReceiver.name[0])
                                                : null,
                                      ),
                                    ),
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Send Message'),
                                        content: Text(
                                            'Choose an option to send a message:'),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('In-App Message'),
                                            onPressed: () {
                                              context
                                                  .read<
                                                      MachineryRegistrationController>()
                                                  .setIsCheckMachies(true);
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (ctx) {
                                                return MessagesScreen(
                                                    request: widget.request);
                                              })); // Close the dialog
                                            },
                                          ),
                                          TextButton(
                                            child: Text('SMS Message'),
                                            onPressed: () async {
                                              final phoneNumber = widget.request
                                                          .machineryOwnerUid ==
                                                      appUser.uid
                                                  ? widget.request.mobileNumber!
                                                  : requestReceiver
                                                      .mobileNumber;

                                              final Uri smsUri = Uri(
                                                  scheme: 'sms',
                                                  path: phoneNumber);

                                              if (await canLaunch(
                                                  smsUri.toString())) {
                                                await launch(smsUri.toString());
                                              } else {
                                                print(
                                                    'Could not launch $smsUri');
                                              }

                                              Navigator.of(context)
                                                  .pop(); // Close the dialog
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  width:
                                      40, // adjust width and height to your needs
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        30), // half of width/height for a circle
                                    color: Colors.white, // Card color
                                    boxShadow: [
                                      // Optional, to give elevation similar to Card
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 1,
                                        blurRadius: 3,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.message_outlined,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          widget.request.machineryOwnerUid == appUser.uid
                              ? Center(
                                  child: Text(
                                  requestSender.name.toUpperCase(),
                                  style: GoogleFonts.quantico(fontSize: 20),
                                ))
                              : Center(
                                  child: Text(
                                  requestReceiver.name.toUpperCase(),
                                  style: GoogleFonts.quantico(fontSize: 20),
                                )),
                          const Divider(
                            thickness: 1,
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                20, 10, 20, 0),
                            // padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Offer price",
                                      style: TextStyle(
                                          color: !_isDark ? Colors.grey : null),
                                    ),
                                    Text("${provider.request!.price} PKR")
                                  ],
                                ),
                                const VerticalDivider(
                                  thickness: 1,
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Total distance",
                                      style: TextStyle(
                                          color: !_isDark ? Colors.grey : null),
                                    ),
                                    Builder(builder: (context) {
                                      double distanceInMeters =
                                          Geolocator.distanceBetween(
                                              provider.destination!.latitude,
                                              provider.destination!.longitude,
                                              provider.source!.latitude,
                                              provider.source!.longitude);
                                      double distanceInKm =
                                          distanceInMeters / 1000;
                                      double totoalDitance = double.parse(
                                          (distanceInKm).toStringAsFixed(2));

                                      return Text("$totoalDitance km");
                                    })
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          OutlinedButton(
                              onPressed: () {
                                context
                                    .read<MachineryRegistrationController>()
                                    .setIsCheckMachies(true);
                                Navigator.pushNamed(
                                    context, AppRouter.machineryDetailsPage,
                                    arguments: machine);
                              },
                              child: const Text("View Machinery")),
                          // ListTile(
                          //   // shape: const OutlineInputBorder(),
                          //   leading: const Icon(
                          //     Icons.contact_phone_outlined,
                          //     size: 40,
                          //   ),
                          //   title:
                          //       widget.request.machineryOwnerUid == appUser!.uid
                          //           ? Text(requestSender!.name)
                          //           : Text(requestReceiver!.name),
                          //   subtitle:
                          //       widget.request.machineryOwnerUid == appUser!.uid
                          //           ? Text(widget.request.mobileNumber!)
                          //           : Text(requestReceiver!.mobileNumber),

                          //   trailing: IconButton(
                          //     icon: const Icon(Icons.phone_enabled_outlined),
                          // onPressed: () async {
                          //   final phoneNumber =
                          //       widget.request.machineryOwnerUid ==
                          //               appUser!.uid
                          //           ? widget.request.mobileNumber!
                          //           : requestReceiver!.mobileNumber;
                          //   final Uri launchUri = Uri(
                          //     scheme: 'tel',
                          //     path: phoneNumber,
                          //   );
                          //   await launchUrl(launchUri);
                          // },
                          //   ),
                          // ),
                          // const Divider(),
                          // ListTile(
                          //   shape: const OutlineInputBorder(),
                          //   leading: const Icon(
                          //     Icons.email_outlined,
                          //     size: 40,
                          //   ),
                          //   title:
                          //       widget.request.machineryOwnerUid == appUser!.uid
                          //           ? Text(requestSender!.email)
                          //           : Text(requestReceiver!.email),
                          //   trailing: IconButton(
                          //     icon: const Icon(Icons.attach_email_outlined),
                          //     onPressed: () async {
                          //       final emailUri = Uri(
                          //         scheme: 'mailto',
                          //         path:
                          //             '${requestSender!.email}?subject=Example Subject&body=Hello, this is an example email body',
                          //       );
                          //       log(emailUri.toString());

                          //       if (await canLaunchUrl(emailUri)) {
                          //         await canLaunchUrl(emailUri);
                          //       } else {
                          //         ScaffoldMessenger.of(context).showSnackBar(
                          //           const SnackBar(
                          //               content: Text(
                          //                   'Could not launch email client')),
                          //         );
                          //       }
                          //     },
                          //   ),
                          // ),
                        ],
                      ),
                    )),
              ),
              Positioned(
                top: 16, // Adjust to your desired position
                right: 16, // Adjust to your desired position
                child: FutureBuilder<GoogleMapController>(
                  future: _controller.future,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            color: _isDark ? Colors.grey : Colors.grey,
                            child: Center(
                              child: IconButton(
                                icon: Icon(
                                  Icons.zoom_in,
                                  color: _isDark ? Colors.white : Colors.white,
                                ),
                                onPressed: zoomIn,
                              ),
                            ),
                          ),
                          Container(
                            height: 1,
                            color: Colors.white,
                          ),
                          //Divider(thickness: 0.01,),
                          Container(
                            height: 40,
                            width: 40,
                            color: _isDark ? Colors.grey : Colors.grey,
                            child: IconButton(
                              icon: Icon(
                                Icons.zoom_out,
                                color: _isDark ? Colors.white : Colors.white,
                              ),
                              onPressed: zoomOut,
                            ),
                          ),
                        ],
                      );
                    }
                    return const SizedBox
                        .shrink(); // Return an empty widget if controller is not available
                  },
                ),
              ),
              Positioned(
                bottom: screenHeight(context) * 0.3,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          showCancelDialog(
                              context,
                              widget.request.machineryOwnerUid == appUser.uid
                                  ? false
                                  : true,
                              widget.request);
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                              color: _isDark ? Colors.grey : Colors.orange,
                              width: 2), // Border color
                          // Foreground
                          shape: const RoundedRectangleBorder(
                            // Button shape
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                          // Color when the button is disabled
                        ),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                              color: _isDark
                                  ? Colors.grey
                                  : Colors.orange), // Text color
                        ),
                      ),
                      const SizedBox(width: 20),
                      Visibility(
                        visible:
                            context.read<RequestController>().isAtDestination ||
                                widget.request.machineryOwnerUid == appUser.uid,
                        child: Center(
                          child: ElevatedButton(
                            // onPressed: () async {
                            //   try {
                            //     await provider.updateRequestStatus(
                            //         senderUid:
                            //             widget.request.senderUid.toString(),
                            //         receiverUid: widget
                            //             .request.machineryOwnerUid
                            //             .toString(),
                            //         requestId:
                            //             widget.request.requestId.toString(),
                            //         status: 'Confirm');

                            // await provider.positionStream?.cancel();
                            // provider.positionStream = null;
                            // await provider.sentRequestsStream?.cancel();
                            // provider.sentRequestsStream = null;
                            // await provider.receivedRequestsStream?.cancel();
                            // provider.receivedRequestsStream = null;
                            // await provider.positionStream?.cancel();
                            // appUser.uid == machine.uid
                            //     ? Navigator.pushReplacementNamed(
                            //         context, AppRouter.receiverRequest)
                            //     : (await context
                            //             .read<
                            //                 MachineryRegistrationController>()
                            //             .hasUserRatedMachinery(appUser.uid,
                            //                 machine.machineryId))
                            //         ? Navigator.pushReplacementNamed(
                            //             context,
                            //             AppRouter.bottomNavigationBar)
                            //         : showDialog(
                            //             context: context,
                            //             barrierDismissible:
                            //                 true, // set to false if you want to force a rating
                            //             builder: (context) =>
                            //                 dialog(context, machine),
                            //           );
                            //   } catch (e) {
                            //     if (kDebugMode) {
                            //       print('Failed to update status: $e');
                            //     }
                            //     await provider.positionStream?.cancel();
                            //     provider.positionStream = null;
                            //     await provider.sentRequestsStream?.cancel();
                            //     provider.sentRequestsStream = null;
                            //     await provider.receivedRequestsStream?.cancel();
                            //     provider.receivedRequestsStream = null;
                            //     await provider.positionStream?.cancel();
                            //     // Optionally, handle the exception further based on your needs.
                            //   }
                            // },
                            onPressed: () async {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Confirmation'),
                                  content: const Text(
                                      'Are you sure you want to confirm?'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('Cancel'),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Dismiss the dialog and do nothing
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('Confirm'),
                                      onPressed: () async {
                                        Navigator.of(context)
                                            .pop(); // Dismiss the dialog
                                        // Your existing logic goes here
                                        try {
                                          context
                                              .read<
                                                  MachineryRegistrationController>()
                                              .setIsCheckMachies(false);
                                          await provider.updateRequestStatus(
                                            senderUid: widget.request.senderUid
                                                .toString(),
                                            receiverUid: widget
                                                .request.machineryOwnerUid
                                                .toString(),
                                            requestId: widget.request.requestId
                                                .toString(),
                                            status: 'Confirm',
                                          );
                                          await context
                                              .read<
                                                  MachineryRegistrationController>()
                                              .updateMachine(machine, true);
                                          await provider.positionStream
                                              ?.cancel();
                                          provider.positionStream = null;
                                          await provider.sentRequestsStream
                                              ?.cancel();
                                          provider.sentRequestsStream = null;
                                          await provider.receivedRequestsStream
                                              ?.cancel();
                                          provider.receivedRequestsStream =
                                              null;
                                          await provider.positionStream
                                              ?.cancel();
                                          appUser.uid == machine.uid
                                              ? Navigator.pushReplacementNamed(
                                                  context,
                                                  AppRouter.receiverRequest)
                                              // : (await context
                                              //         .read<
                                              //             MachineryRegistrationController>()
                                              //         .hasUserRatedMachinery(
                                              //             appUser.uid,
                                              //             machine.machineryId))
                                              //     ?
                                              : Navigator.pushReplacementNamed(
                                                  context,
                                                  AppRouter.sendRequest);
                                          // : showCustomRatingDialog(
                                          //     context, machine);
                                        } catch (e) {
                                          if (kDebugMode) {
                                            print(
                                                'Failed to update status: $e');
                                          }
                                          await provider.positionStream
                                              ?.cancel();
                                          provider.positionStream = null;
                                          await provider.sentRequestsStream
                                              ?.cancel();
                                          provider.sentRequestsStream = null;
                                          await provider.receivedRequestsStream
                                              ?.cancel();
                                          provider.receivedRequestsStream =
                                              null;
                                          await provider.positionStream
                                              ?.cancel();
                                          // Optionally, handle the exception further based on your needs.
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },

                            child: const Text('Confirm Arrival'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

// @override
// void dispose() {
//   positionStream?.cancel();
//   super.dispose();
// }

// double distanceToDestination2 = 40;
//     double distanceToDestination = 40;

//     if (widget.request.senderUid == appUser!.uid) {
//       distanceToDestination = Geolocator.distanceBetween(
//         currentLocation.latitude,
//         currentLocation.longitude,
//         destination!.latitude,
//         destination!.longitude,
//       );
//     }

//     if (widget.request.machineryOwnerUid != appUser!.uid) {
//       distanceToDestination2 = Geolocator.distanceBetween(
//         position.latitude,
//         position.longitude,
//         currentLocation!.latitude,
//         currentLocation!.longitude,
//       );
//     }
//     if (distanceToDestination <= 30 || distanceToDestination2 <= 30) {
//       // positionStream?.cancel(); // Stop listening to position updates
//       if (mounted) {
//         log("sana");
//         context
//             .read<RequestController>()
//             .checkConfirm(context, widget.request.requestId.toString());
//         setState(() {
//           isAtDestination = true;
//         });
//       }
//       // return;
//     }

// void locationListen() {
//   log("locationListen().toString()");
//   if (widget.request.senderUid == appUser!.uid) {
//     database.child(widget.request.machineryOwnerUid).onValue.listen((event) {
//       var snapshot = event.snapshot;

//       // Cast snapshot.value to Map<String, dynamic>
//       var rawData = snapshot.value;
//       Map<String, dynamic>? data;
//       if (rawData is Map) {
//         data = Map<String, dynamic>.from(rawData);
//       }
//       if (data != null) {
//         currentLocation = geocoding.Location(
//             latitude: data['latitude'],
//             longitude: data['longitude'],
//             timestamp: DateTime.parse(data['timestamp']));
//         setState(() {});
//       }
//     });
//   }
// }
// ignore: unnecessary_null_comparison
// if (widget.request != null)
//   Text('Machine ID: ${widget.request.machineId}'),
// if (widget.request != null)
//   Text('Price: ${widget.request.price}'),
// if (widget.request != null)
//   Text('Work Hours: ${widget.request.workOfHours}'),
// if (machine != null)
//   Text('Machine Title: ${machine!.title}'),
// if (destinationUser != null)
//   Text('Destination User Email: ${destinationUser!.email}'),
// if (sourceUser != null)
//   Text('Source User Email: ${sourceUser!.email}'),

// Widget zoomControls(GoogleMapController controller) {
//   return Column(
//     children: [
//       IconButton(
//         icon: const Icon(Icons.zoom_in),
//         onPressed: zoomIn
//       ),
//       IconButton(
//         icon: const Icon(Icons.zoom_out),
//         onPressed: () {
//           controller.animateCamera(CameraUpdate.zoomOut());
//         },
//       ),
//     ],
//   );
// }
class StatusUpdateListener {
  final String uid;
  final String requestId;
  final MachineryModel machine;
  StreamSubscription? receivedRequestsStream;
  StreamSubscription? sentRequestsStream;

  StatusUpdateListener(
      {required this.uid, required this.requestId, required this.machine});

  void handleStatusChange(DocumentSnapshot snapshot, BuildContext context,
      MachineryModel machine) async {
    if (snapshot.exists && snapshot.data() != null) {
      var data = snapshot.data() as Map<String, dynamic>;
      var status = data['status'];

      if (status == 'Confirm' || status == 'Canceled') {
        dispose(); // Dispose of the listeners
        if (Navigator.canPop(context)) {
          // uid == machine.uid
          //     ?
          context
              .read<MachineryRegistrationController>()
              .setIsCheckMachies(false);
          Navigator.pushReplacementNamed(
              context, AppRouter.bottomNavigationBar);
          // : (await context
          //         .read<MachineryRegistrationController>()
          //         .hasUserRatedMachinery(uid, machine.machineryId))
          //     ?
          //  Navigator.pushReplacementNamed(
          //     context, AppRouter.bottomNavigationBar);
          // : showCustomRatingDialog(context, machine);
        }
      }
    }
  }

  void startListening(BuildContext context) {
    log("SANA");
    // Listening for changes in received_requests with 'Confirm' or 'Canceled' status
    receivedRequestsStream = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('received_requests')
        .where("requestId", isEqualTo: requestId)
        .where('status', whereIn: ['Confirm', 'Canceled'])
        .snapshots()
        .listen((snapshot) {
          log("message");
          if (snapshot.docs.isNotEmpty) {
            log("status change detected in received_requests");
            handleStatusChange(snapshot.docs.first, context, machine);
          }
        });

    // Listening for changes in sent_requests with 'Confirm' or 'Canceled' status
    sentRequestsStream = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('sent_requests')
        .where("requestId", isEqualTo: requestId)
        .where('status', whereIn: ['Confirm', 'Canceled'])
        .snapshots()
        .listen((snapshot) {
          log("2222");
          if (snapshot.docs.isNotEmpty) {
            log("status change detected in sent_requests");
            handleStatusChange(snapshot.docs.first, context, machine);
          }
        });
  }

  void dispose() {
    receivedRequestsStream?.cancel();
    sentRequestsStream?.cancel();
    //  statusListener.dispose();
  }
}

// // Usage in your widget or class
// final statusListener = StatusUpdateListener(uid: 'YOUR_UID', requestId: 'YOUR_REQUEST_ID');
// statusListener.startListening(context);

// // Ensure to dispose when not needed
// statusListener.dispose();
// Widget dialog(BuildContext context, MachineryModel machine) {
//   return Container(
//     height: 100,
//     color: Colors.white,
//     width: 200,
//     child: Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         CircleAvatar(
//           radius: 50,
//         ),
//         Text(
//           "Rating Dialog",
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
//         ),
//         Text(
//             'Tap a star to set your rating. Add more description here if you want.'),
//         RatingBar.builder(
//           initialRating: 3,
//           minRating: 1,
//           direction: Axis.horizontal,
//           allowHalfRating: true,
//           itemCount: 5,
//           itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
//           itemBuilder: (context, _) => Icon(
//             Icons.star,
//             color: Colors.amber,
//           ),
//           onRatingUpdate: (rating) {
//             log(rating.toString());
//           },
//         ),
//       ],
//     ),
//   );

// //    RatingDialog(
// //     starSize: 30,
// //     initialRating: 1.0,
// //     // your app's name?
// //     title: const Text(
// //       'Rating Dialog',
// //       textAlign: TextAlign.center,
// //       style: TextStyle(
// //         fontSize: 25,
// //         fontWeight: FontWeight.bold,
// //       ),
// //     ),
// //     // encourage your user to leave a high rating?
// //     message: const Text(
// //       'Tap a star to set your rating. Add more description here if you want.',
// //       textAlign: TextAlign.center,
// //       style: TextStyle(fontSize: 15),
// //     ),

// //     // your app's logo?
// //     image: machine.images!.last != null
// //         ? CircleAvatar(
// //             radius: 50,
// //             backgroundImage: CachedNetworkImageProvider(
// //               // imageUrl:
// //               machine.images!.last.toString(),
// //               errorListener: () {
// //                 log("error");
// //               },
// //             ))
// //         : CircleAvatar(child: Text(machine!.title[0])),
// //     submitButtonText: 'Submit',
// //     showCloseButton: true,
// //     commentHint: 'tell us your comment',
// // submitButtonTextStyle: TextStyle(),
// //     onCancelled: () {navigatorKey.currentState!.pushReplacementNamed(AppRouter.bottomNavigationBar);},
// //     onSubmitted: (response) async {
// if (response.comment.trim().isEmpty || response.comment.length < 3) {
//   print("Error: Comment is too short or empty");
//   // Optionally display an error to the user here.
//   return;
// }
// print('rating: ${response.rating}, comment: ${response.comment}');
// var appUser = context.read<AuthController>().appUser;

// if (appUser != null && appUser.uid.isNotEmpty) {
//   // Check for null in the rating response
//   if (response.comment.isNotEmpty) {
//     Rating rating = Rating(
//         userId: appUser.uid,
//         value: response.rating.toDouble(),
//         date: Timestamp.now(),
//         comment: response.comment);

//     await context
//         .read<MachineryRegistrationController>()
//         .addRatingToMachinery(machine.machineryId, rating);
//   } else {
//     print("Error: Rating value or comment is null or empty");
//     // Optionally display an error to the user
//   }
// } else {
//   print("Error: appUser or its uid is null");
//   // Optionally display an error to the user
// }

// navigatorKey.currentState!.pop(context); // Move the pop command here
// navigatorKey.currentState!
//     .pushReplacementNamed(AppRouter.bottomNavigationBar);
// //     },
// //   );
// }
