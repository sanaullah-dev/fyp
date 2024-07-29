import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_management_and_booking_system/app/router.dart';
import 'package:vehicle_management_and_booking_system/authentication/controllers/auth_controller.dart';
import 'package:vehicle_management_and_booking_system/common/repo/machinery_repo.dart';
import 'package:vehicle_management_and_booking_system/common/repo/request_repo.dart';
import 'package:vehicle_management_and_booking_system/models/operator_request_model.dart';
import 'package:vehicle_management_and_booking_system/models/report_model.dart';
import 'package:vehicle_management_and_booking_system/models/request_machiery_model.dart';
import 'package:vehicle_management_and_booking_system/screens/login_signup/model/user_model.dart';
import 'package:vehicle_management_and_booking_system/utils/const.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
// import 'package:flutter/foundation.dart' as TargetPlatform;
// import 'package:http/http.dart' as http;

class RequestController with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _repo = RequestRepo();
  final _machineRepo = MachineryRepo();
  bool? isSendRequestExist;
  bool? isReceivedRequestExist;
  StreamSubscription<Position>? positionStream;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? sentRequestsStream;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
      receivedRequestsStream;
  bool isLoading = false;
  bool isLoadingForTracking = true;
  // ignore: prefer_typing_uninitialized_variables
  var currentLocation;
  late final DatabaseReference database =
      FirebaseDatabase.instance.ref().child("Locations");
  RequestModelForMachieries? request;
  LatLng? source; // = LatLng(37.335813, -122.032543);
  LatLng? destination; //= //LatLng(37.337160, -122.082791);
  //  LatLng(37.334464, -122.045020);
  List<LatLng> plylineCoordinates = [];
  UserModel? _appUser;
  bool isAtDestination = false;
  bool isMachineryFavoritesScreen = true;
  List<HiringRequestModel> allHiringRequests = [];

  void updateIsMachineryFavoritesScreen({required bool value}) {
    isMachineryFavoritesScreen = value;
    notifyListeners();
  }

  // void loading(bool state) {
  //   isLoading = state;
  //   notifyListeners();
  // }

  //get currentLocationSet => currentLocation;

  // void setCurrentLocation(var crntLocation) {
  //   currentLocation = crntLocation;
  //   notifyListeners();
  // }

  void setRequestAndUser(
      {required RequestModelForMachieries requests, required UserModel user}) {
    request = requests;
    _appUser = user;
  }

  void setSourceDestination(
      {required LatLng sourceArgument, required LatLng destinations}) {
    source = sourceArgument;
    destination = destinations;
    notifyListeners();
  }

  Future<RequestModelForMachieries?> getRequestIfActive(
      String receiverUid) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection('users')
        .doc(receiverUid)
        .collection('received_requests')
        .where('status', isEqualTo: 'Activated')
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      // Returns the first active request if found
      log("Activated Exist");
      return RequestModelForMachieries.fromMap(snapshot.docs.first.data());
    }

    // If no active request is found, return null
    return null;
  }

  Future<void> updateRequest(
      {required RequestModelForMachieries request,
      required Position position,
      required String status}) async {
    try {
      request.destinationLocation =
          LatLng(position.latitude, position.longitude);
      request.status = status;
      await _repo.updateRequest(request);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }

  Future<void> checkActiveRequest(BuildContext context) async {
    log("checkActive call");
    try {
      var uid = context.read<AuthController>().appUser!.uid;

      // Listening for changes in received_requests
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('received_requests')
          .where('status', isEqualTo: 'Activated')
          .snapshots()
          .listen((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          RequestModelForMachieries request =
              RequestModelForMachieries.fromMap(snapshot.docs.first.data());
          FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .collection('received_requests')
              .doc(request.requestId)
              .snapshots()
              .listen((snapshot) {
            if (snapshot.exists && snapshot.data() != null) {
              var status = snapshot.data()!['status'];
              if (status == 'Activated') {
                Navigator.pushNamed(context, AppRouter.trackOrder,
                    arguments: request);
              }
            }
          });
        }
      });

      // Listening for changes in sent_requests
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('sent_requests')
          .where('status', isEqualTo: 'Activated')
          .snapshots()
          .listen((snapshot) async {
        if (snapshot.docs.isNotEmpty) {
          await MapIcons.setAllMarker(context);
          RequestModelForMachieries request =
              RequestModelForMachieries.fromMap(snapshot.docs.first.data());
          FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .collection('sent_requests')
              .doc(request.requestId)
              .snapshots()
              .listen((snapshot) {
            if (snapshot.exists && snapshot.data() != null) {
              var status = snapshot.data()!['status'];
              if (status == 'Activated') {
                Navigator.pushNamed(context, AppRouter.trackOrder,
                    arguments: request);
              }
            }
          });
        }
      });
    } catch (e) {
      log(e.toString());
    }
  }

  // Future<void> checkActiveRequest(BuildContext context) async {
  //   log("checkActive call");
  //   try {
  //     var uid = context.read<AuthController>().appUser!.uid;
  //     QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
  //         .instance
  //         .collection('users')
  //         .doc(uid)
  //         .collection('received_requests')
  //         .where('status', isEqualTo: 'Activated')
  //         .limit(1)
  //         .get();
  //     RequestModel request;

  //     QuerySnapshot<Map<String, dynamic>> snapshot2 = await FirebaseFirestore
  //         .instance
  //         .collection('users')
  //         .doc(uid)
  //         .collection('sent_requests')
  //         .where('status', isEqualTo: 'Activated')
  //         .limit(1)
  //         .get();
  //     RequestModel request2;

  //     if (snapshot2.docs.isNotEmpty) {
  //       MapIcons.setAllMarker(context);
  //       // Returns the first active request if found

  //       request2 = RequestModel.fromMap(snapshot2.docs.first.data());

  //       FirebaseFirestore.instance
  //           .collection('users')
  //           .doc(request2.machineryOwnerUid)
  //           .collection('received_requests')
  //           .doc(request2.requestId)
  //           .snapshots()
  //           .listen((snapshot) {
  //         if (snapshot.exists && snapshot.data() != null) {
  //           var status = snapshot.data()!['status'];
  //           if (status == 'Activated') {
  //             Navigator.pushNamed(context, AppRouter.trackOrder,
  //                 arguments: request2);
  //           }
  //         }
  //       });
  //     }

  //     if (snapshot.docs.isNotEmpty) {
  //       // Returns the first active request if found

  //       request = RequestModel.fromMap(snapshot.docs.first.data());

  //       FirebaseFirestore.instance
  //           .collection('users')
  //           .doc(request.machineryOwnerUid)
  //           .collection('received_requests')
  //           .doc(request.requestId)
  //           .snapshots()
  //           .listen((snapshot) {
  //         if (snapshot.exists && snapshot.data() != null) {
  //           var status = snapshot.data()!['status'];
  //           if (status == 'Activated') {
  //             Navigator.pushNamed(context, AppRouter.trackOrder,
  //                 arguments: request);
  //           }
  //         }
  //       });
  //     }
  //   } catch (e) {
  //     log(e.toString());
  //   }
  // }

  // Future<void> checkConfirm(BuildContext context, String id) async {
  //   try {
  //     var uid = context.read<AuthController>().appUser!.uid;
  //     QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
  //         .instance
  //         .collection('users')
  //         .doc(uid)
  //         .collection('received_requests')
  //         .where("requestId", isEqualTo: id)
  //         .where('status', isEqualTo: 'Confirm')
  //         .limit(1)
  //         .get();
  //     RequestModel request;

  //     QuerySnapshot<Map<String, dynamic>> snapshot2 = await FirebaseFirestore
  //         .instance
  //         .collection('users')
  //         .doc(uid)
  //         .collection('sent_requests')
  //         .where("requestId", isEqualTo: id)
  //         .where('status', isEqualTo: 'Confirm')
  //         .limit(1)
  //         .get();
  //     RequestModel request2;

  //     if (snapshot2.docs.isNotEmpty) {
  //       // Returns the first active request if found
  //       log("Confirm sender Exist");
  //       request2 = RequestModel.fromMap(snapshot2.docs.first.data());

  //       FirebaseFirestore.instance
  //           .collection('users')
  //           .doc(request2.machineryOwnerUid)
  //           .collection('received_requests')
  //           .doc(request2.requestId)
  //           .snapshots()
  //           .listen((snapshot) {
  //         if (snapshot.exists && snapshot.data() != null) {
  //           var status = snapshot.data()!['status'];
  //           if (status == 'Confirm') {
  //             positionStream?.cancel();
  //             notifyListeners();
  //             if (Navigator.canPop(context)) {
  //               Navigator.pushReplacementNamed(context, AppRouter.sendRequest);
  //             }
  //           }
  //         }
  //       });
  //     }

  //     if (snapshot.docs.isNotEmpty) {
  //       // Returns the first active request if found
  //       log("confirm Exist");
  //       request = RequestModel.fromMap(snapshot.docs.first.data());

  //       FirebaseFirestore.instance
  //           .collection('users')
  //           .doc(request.machineryOwnerUid)
  //           .collection('received_requests')
  //           .doc(request.requestId)
  //           .snapshots()
  //           .listen((snapshot) {
  //         if (snapshot.exists && snapshot.data() != null) {
  //           var status = snapshot.data()!['status'];
  //           if (status == 'Confirm') {
  //              positionStream?.cancel();
  //              notifyListeners();
  //             if (Navigator.canPop(context)) {
  //               Navigator.pushReplacementNamed(context, AppRouter.sendRequest);
  //             }
  //           }
  //         }
  //       });
  //     }
  //   } catch (e) {
  //     log(e.toString());
  //   }
  // }

  // Future<void> checkConfirm(BuildContext context, String id) async {
  //   final uid = context.read<AuthController>().appUser!.uid;
  //   final firestore = FirebaseFirestore.instance;

  //   try {
  //     // Check 'sent_requests'
  //     final senderRequest = await _getRequestByStatus(
  //         firestore, uid, 'sent_requests', id, 'Confirm');
  //     if (senderRequest != null) {
  //       // ignore: use_build_context_synchronously
  //       _listenForStatusChangeAndNavigate(
  //           context,
  //           senderRequest.machineryOwnerUid,
  //           'received_requests',
  //           senderRequest.requestId,
  //           'Confirm');
  //       return; // Exit early if a match is found
  //     }

  //     // Check 'received_requests'
  //     final receiverRequest = await _getRequestByStatus(
  //         firestore, uid, 'received_requests', id, 'Confirm');
  //     if (receiverRequest != null) {
  //       // ignore: use_build_context_synchronously
  //       _listenForStatusChangeAndNavigate(
  //           context,
  //           receiverRequest.machineryOwnerUid,
  //           'received_requests',
  //           receiverRequest.requestId,
  //           'Confirm');
  //     }
  //   } catch (e) {
  //     log(e.toString());
  //   }
  // }

  // Future<RequestModel?> _getRequestByStatus(
  //     FirebaseFirestore firestore,
  //     String uid,
  //     String collectionName,
  //     String requestId,
  //     String status) async {
  //   final snapshot = await firestore
  //       .collection('users')
  //       .doc(uid)
  //       .collection(collectionName)
  //       .where("requestId", isEqualTo: requestId)
  //       .where('status', isEqualTo: status)
  //       .limit(1)
  //       .get();

  //   if (snapshot.docs.isNotEmpty) {
  //     return RequestModel.fromMap(snapshot.docs.first.data());
  //   }
  //   return null;
  // }

  // void _listenForStatusChangeAndNavigate(BuildContext context, String ownerId,
  //     String collectionName, String requestId, String targetStatus) {
  //   FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(ownerId)
  //       .collection(collectionName)
  //       .doc(requestId)
  //       .snapshots()
  //       .listen((snapshot) {
  //     if (snapshot.exists &&
  //         snapshot.data() != null &&
  //         snapshot.data()!['status'] == targetStatus) {
  //       if (Navigator.canPop(context)) {
  //         positionStream?.cancel();
  //         positionStream = null;
  //         sentRequestsStream?.cancel();
  //         sentRequestsStream = null;
  //         receivedRequestsStream?.cancel();
  //         receivedRequestsStream = null;
  //         Navigator.pushReplacementNamed(context, AppRouter.sendRequest);
  //       }
  //     }
  //   });
  // }

  Future<void> isSendReceivedRequestExist({required String uid}) async {
    try {
      isReceivedRequestExist = await _repo.isReceivedRequestExist(uid: uid);
      // notifyListeners();
      isSendRequestExist = await _repo.isSendRequestExist(uid: uid);
      notifyListeners();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> checkForTimeOut(
      {required List<RequestModelForMachieries> allRequests}) async {
    try {
      _repo.checkForTimeOut(allRequests: allRequests);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateRequestStatus(
      {required String senderUid,
      required String receiverUid,
      required String requestId,
      required String status,
      String? comment}) async {
    try {
      _repo.updateRequestStatus(
          senderUid: senderUid,
          receiverUid: receiverUid,
          requestId: requestId,
          status: status,
          comment: comment);
    } catch (e) {
      rethrow;
    }
  }

  // Future<void> getCurrentLocation() async {
  //   try {
  //     Position position = await Geolocator.getCurrentPosition(
  //         desiredAccuracy: LocationAccuracy.bestForNavigation);
  //     currentLocation = geocoding.Location(
  //       latitude: position.latitude,
  //       longitude: position.longitude,
  //       timestamp: position.timestamp ?? DateTime.now(),
  //     );
  //     notifyListeners();
  //     log("getlocation");
  //     _updateCurrentLocation(position);
  //     log("updatedddd");

  //     _setUpListerners();

  //     notifyListeners();
  //   } catch (error) {
  //     log(error.toString());
  //     //setState(() {
  //     isLoading = false; // Set loading to false if there's an error
  //     notifyListeners();
  //     // });
  //   }
  // }

  // void _updateCurrentLocation(Position position) {
  //   // setState(() {

  //   currentLocation = geocoding.Location(
  //     latitude: position.latitude,
  //     longitude: position.longitude,
  //     timestamp: position.timestamp ?? DateTime.now(),
  //   );

  //   if (request!.machineryOwnerUid == _appUser!.uid) {
  //     _updateDatabaseWithLocation(_appUser!.uid);
  //   }
  //   isLoading = false;

  //   notifyListeners();
  // }

  // void _updateDatabaseWithLocation(String uid) {
  //   database.child(uid).set({
  //     'latitude': currentLocation.latitude,
  //     'longitude': currentLocation.longitude,
  //     'timestamp': currentLocation.timestamp?.toIso8601String(),
  //   });
  // }

  // void _setUpListerners() {
  //   _listenForOwnerUpdates();
  //   _listenForSenderUpdates();
  //   Future.delayed(Duration(seconds: 2), () {
  //     _listenForPositionStream();
  //   });

  //   getPolyPoint();
  // }

  // void _listenForOwnerUpdates() {
  //   if (request!.machineryOwnerUid == _appUser!.uid) {
  //     database.child(_appUser!.uid).onValue.listen((event) {
  //       _processDatabaseEvent(event);
  //       notifyListeners();
  //     });
  //   }
  // }

  // void _listenForSenderUpdates() {
  //   if (request!.senderUid == _appUser!.uid) {
  //     database.child(request!.machineryOwnerUid).onValue.listen((event) {
  //       _processDatabaseEvent(event);
  //       notifyListeners();
  //     });
  //   }
  // }

  // void _processDatabaseEvent(DatabaseEvent event) async {
  //   DataSnapshot snapshot = event.snapshot;

  //   var rawData = snapshot.value;
  //   if (rawData is Map) {
  //     Map<String, dynamic> data = Map<String, dynamic>.from(rawData);

  //     _updateLocationFromDatabaseData(data);
  //   }
  // }

  // void _updateLocationFromDatabaseData(Map<String, dynamic> data) {
  //   currentLocation = geocoding.Location(
  //       latitude: data['latitude'],
  //       longitude: data['longitude'],
  //       timestamp: DateTime.parse(data['timestamp']));
  //   isLoading = false;
  //   notifyListeners();
  // }

  // // Position? lastPosition;
  // void _listenForPositionStream() {
  //   positionStream = Geolocator.getPositionStream().listen((Position position) {
  //     //if (lastPosition == null ||
  //     // _distanceBetween(lastPosition!, position) >= 10) {
  //     _handlePositionUpdates(position);
  //     // lastPosition = position;
  //     // }
  //   });
  // }

  // // double _distanceBetween(Position pos1, Position pos2) {
  // //   return Geolocator.distanceBetween(
  // //     pos1.latitude,
  // //     pos1.longitude,
  // //     pos2.latitude,
  // //     pos2.longitude,
  // //   );
  // // }

  // void _handlePositionUpdates(Position position) async {
  //   if (request!.machineryOwnerUid == _appUser!.uid) {
  //     database.child(_appUser!.uid).set({
  //       'latitude': currentLocation.latitude,
  //       'longitude': currentLocation.longitude,
  //       'timestamp': currentLocation.timestamp?.toIso8601String(),
  //     });

  //     currentLocation = geocoding.Location(
  //       latitude: position.latitude,
  //       longitude: position.longitude,
  //       timestamp: position.timestamp ?? DateTime.now(),
  //     );
  //     notifyListeners();
  //   }

  //   var distance1 = Geolocator.distanceBetween(
  //       currentLocation.latitude,
  //       currentLocation.longitude,
  //       request!.sourcelocation.latitude,
  //       request!.sourcelocation.longitude);
  //   if (request!.machineryOwnerUid == _appUser!.uid) {
  //     log(distance1.toString());
  //     if (distance1 <= 30) {
  //       positionStream?.cancel();
  //       isAtDestination = true;
  //       sentRequestsStream?.cancel();
  //       receivedRequestsStream?.cancel();
  //       notifyListeners();
  //       // await context.read<RequestController>().positionStream?.cancel();
  //     }
  //   }
  //   if (request!.senderUid == _appUser!.uid) {
  //     var distance = Geolocator.distanceBetween(
  //         currentLocation.latitude,
  //         currentLocation.longitude,
  //         destination!.latitude,
  //         destination!.longitude);
  //     log(distance.toString());
  //     if (distance <= 30 || distance1 <= 30) {
  //       log(distance.toString());
  //       positionStream?.cancel();
  //       sentRequestsStream?.cancel();
  //       receivedRequestsStream?.cancel();
  //       isAtDestination = true;
  //       notifyListeners();
  //       // await context.read<RequestController>().positionStream?.cancel();
  //     }
  //   }

  //   // if (widget.request.senderUid == appUser!.uid) {
  //   // var distance = Geolocator.distanceBetween(
  //   //     widget.request..latitude,
  //   //     widget.request.sourcelocation.longitude,
  //   //     position.latitude,
  //   //     position.longitude);
  //   // if (distance <= 30) {
  //   //   log(distance.toString());
  //   //   context.read<RequestController>().positionStream?.cancel();
  //   //   isAtDestination = true;
  //   //   // await context.read<RequestController>().positionStream?.cancel();
  //   // }
  //   // }

  //   // ... (rest of your logic, including distance calculations)

  //   // GoogleMapController googleMapController = await _controller.future;

  //   // googleMapController.animateCamera(
  //   //   CameraUpdate.newCameraPosition(
  //   //     CameraPosition(
  //   //       zoom: 16.5,
  //   //       target: LatLng(
  //   //         currentLocation.latitude,
  //   //         currentLocation.longitude,
  //   //       ),
  //   //     ),
  //   //   ),
  //   // );
  //   notifyListeners();
  // }

  // Future<void> getPolyPoint() async {
  //   PolylinePoints polylinePoints = PolylinePoints();
  //   PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
  //     "AIzaSyCLbJLS9F81c-2Qu1WcztJ2LdO10MgVCvk",
  //     request!.senderUid == _appUser!.uid
  //         ? PointLatLng(source!.latitude, source!.longitude)
  //         : PointLatLng(destination!.latitude, destination!.longitude),
  //     request!.senderUid == _appUser!.uid
  //         ? PointLatLng(destination!.latitude, destination!.longitude)
  //         : PointLatLng(source!.latitude, source!.longitude),
  //   );
  //   plylineCoordinates.clear();
  //   if (result.points.isNotEmpty) {
  //     for (var element in result.points) {
  //       plylineCoordinates.add(LatLng(element.latitude, element.longitude));
  //     }
  //   }
  //   notifyListeners();
  // }
  Future<void> getCurrentLocation() async {
    try {
      isLoadingForTracking = true;
      notifyListeners();
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
      _updateCurrentLocation(position);
      //  notifyListeners();
      //await getPolyPoint();
      _setUpListeners();
    } catch (error) {
      log(error.toString());
      isLoadingForTracking = false;
      notifyListeners();
    }
  }

  void _updateCurrentLocation(Position position) {
    currentLocation = geocoding.Location(
      latitude: position.latitude,
      longitude: position.longitude,
      timestamp: position.timestamp ?? DateTime.now(),
    );
    notifyListeners();
    if (request!.machineryOwnerUid == _appUser!.uid) {
      _updateDatabaseWithLocation(_appUser!.uid);
    }
    isLoadingForTracking = false;
    notifyListeners();
  }

  void _updateDatabaseWithLocation(String uid) {
    database.child(uid).set({
      'latitude': currentLocation.latitude,
      'longitude': currentLocation.longitude,
      'timestamp': currentLocation.timestamp?.toIso8601String(),
    });
  }

  void _setUpListeners() {
    _listenForUpdatesBasedOnRole();
    Future.delayed(const Duration(seconds: 2), _listenForPositionStream);
    getPolyPoint();
  }

  void _listenForUpdatesBasedOnRole() {
    String uidToListenTo = (request!.machineryOwnerUid == _appUser!.uid)
        ? _appUser!.uid
        : request!.machineryOwnerUid;
    database.child(uidToListenTo).onValue.listen((event) {
      // final statusListener = StatusUpdateListener(uid: _appUser!.uid, requestId: request!.requestId);
      // statusListener.startListening();
      log("database6");
      
      _processDatabaseEvent(event);
      isLoadingForTracking = false;
      notifyListeners();
    });
  }

  void _processDatabaseEvent(DatabaseEvent event) {
    DataSnapshot snapshot = event.snapshot;
    var rawData = snapshot.value;
    if (rawData is Map) {
      Map<String, dynamic> data = Map<String, dynamic>.from(rawData);
      _updateLocationFromDatabaseData(data);
    }
  }

  void _updateLocationFromDatabaseData(Map<String, dynamic> data) {
    currentLocation = geocoding.Location(
        latitude: data['latitude'],
        longitude: data['longitude'],
        timestamp: DateTime.parse(data['timestamp']));
    isLoadingForTracking = false;
    notifyListeners();
  }

  void _listenForPositionStream() {
    positionStream =
        Geolocator.getPositionStream().listen(_handlePositionUpdates);
  }

  void _handlePositionUpdates(Position position) async {
    log("position");
    await getPolyPoint();
    if (request!.machineryOwnerUid == _appUser!.uid) {
      _updateDatabaseWithLocation(_appUser!.uid);
      currentLocation = geocoding.Location(
        latitude: position.latitude,
        longitude: position.longitude,
        timestamp: position.timestamp ?? DateTime.now(),
      );
      notifyListeners();
    }
    _checkDistanceForCancellations(position);
  }

  void _checkDistanceForCancellations(Position position) {
    var distance1 = Geolocator.distanceBetween(
        currentLocation.latitude,
        currentLocation.longitude,
        request!.sourcelocation.latitude,
        request!.sourcelocation.longitude);
    log(distance1.toString());
    bool cancelCondition = distance1 <= 30;

    // if (request!.senderUid == _appUser!.uid) {
    //   var distance = Geolocator.distanceBetween(
    //       currentLocation.latitude,
    //       currentLocation.longitude,
    //       destination!.latitude,
    //       destination!.longitude);
    //   cancelCondition = cancelCondition || (distance <= 30);
    // }

    if (cancelCondition) {
      _cancelAllStreams();
      isAtDestination = true;
      notifyListeners();
    }
  }

  void _cancelAllStreams() {
    positionStream?.cancel();
    positionStream = null;
    sentRequestsStream?.cancel();
    sentRequestsStream = null;
    receivedRequestsStream?.cancel();
    receivedRequestsStream = null;
    notifyListeners();
  }

  Future<void> getPolyPoint() async {
    try {
      // if (TargetPlatform.kIsWeb) {
      //     await Geolocator.requestPermission();

      //   List<LatLng>? poly = await GoogleMapsGeocodingApi.getRouteCoordinates(
      //     // "AIzaSyCLbJLS9F81c-2Qu1WcztJ2LdO10MgVCvk", // Use a config or environment variable for the key
      //     // "AIzaSyDyCtN4KYInCI8NXHKvYNVq4YPNk7e8o70",
      //     "AIzaSyDyCtN4KYInCI8NXHKvYNVq4YPNk7e8o70",
      //     // "AIzaSyCLbJLS9F81c-2Qu1WcztJ2LdO10MgVCvk",
      //     // "AIzaSyC1LSG-RbtWDwajBhTiuF_-n8MwLLwDqfk",
      //     LatLng(
      //       request!.senderUid == _appUser!.uid
      //           ? source!.latitude
      //           : destination!.latitude,
      //       request!.senderUid == _appUser!.uid
      //           ? source!.longitude
      //           : destination!.longitude,
      //     ),
      //     LatLng(
      //       request!.senderUid == _appUser!.uid
      //           ? destination!.latitude
      //           : source!.latitude,
      //       request!.senderUid == _appUser!.uid
      //           ? destination!.longitude
      //           : source!.longitude,
      //     ),
            
      //   );
      //   plylineCoordinates = poly!;
      //   print(poly.toString());
      //   notifyListeners();
      // } else {
        PolylinePoints polylinePoints = PolylinePoints();
        PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
          // "AIzaSyCLbJLS9F81c-2Qu1WcztJ2LdO10MgVCvk", // Use a config or environment variable for the key
          // "AIzaSyDyCtN4KYInCI8NXHKvYNVq4YPNk7e8o70",
          //"AIzaSyDyCtN4KYInCI8NXHKvYNVq4YPNk7e8o70",
           "AIzaSyCLbJLS9F81c-2Qu1WcztJ2LdO10MgVCvk",
          // "AIzaSyC1LSG-RbtWDwajBhTiuF_-n8MwLLwDqfk",
          PointLatLng(
            request!.senderUid == _appUser!.uid
                ? source!.latitude
                : destination!.latitude,
            request!.senderUid == _appUser!.uid
                ? source!.longitude
                : destination!.longitude,
          ),
          PointLatLng(
            request!.senderUid == _appUser!.uid
                ? destination!.latitude
                : source!.latitude,
            request!.senderUid == _appUser!.uid
                ? destination!.longitude
                : source!.longitude,
          ),
          travelMode: TravelMode.driving
        );

        plylineCoordinates.clear();
        if (result.points.isNotEmpty) {
          for (var element in result.points) {
            plylineCoordinates.add(LatLng(element.latitude, element.longitude));
          }
          notifyListeners();
        }
      //}
      isLoadingForTracking = false;
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
    log(plylineCoordinates.toString());
  }

  // void listenForConfirm(BuildContext context, String id) {
  //   try {
  //     var uid = context.read<AuthController>().appUser!.uid;

  //     // Listening for changes in received_requests with 'Confirm' status
  //     receivedRequestsStream = FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(uid)
  //         .collection('received_requests')
  //         .where("requestId", isEqualTo: id)
  //         .where('status', isEqualTo: 'Confirm')
  //         .snapshots()
  //         .listen((snapshot) {
  //       if (snapshot.docs.isNotEmpty) {
  //         log("confirm Exist");
  //         RequestModel request =
  //             RequestModel.fromMap(snapshot.docs.first.data());
  //         FirebaseFirestore.instance
  //             .collection('users')
  //             .doc(request.machineryOwnerUid)
  //             .collection('received_requests')
  //             .doc(request.requestId)
  //             .snapshots()
  //             .listen((snapshot) async {
  //           if (snapshot.exists && snapshot.data() != null) {
  //             var status = snapshot.data()!['status'];
  //             if (status == 'Confirm') {
  //               positionStream?.cancel();
  //               receivedRequestsStream?.cancel();
  //               sentRequestsStream?.cancel();
  //               if (Navigator.canPop(context)) {
  //                 Navigator.pushReplacementNamed(
  //                     context, AppRouter.bottomNavigationBar);
  //               }
  //             }
  //           }
  //         });
  //       }
  //     });

  //     // Listening for changes in sent_requests with 'Confirm' status
  //     sentRequestsStream = FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(uid)
  //         .collection('sent_requests')
  //         .where("requestId", isEqualTo: id)
  //         .where('status', isEqualTo: 'Confirm')
  //         .snapshots()
  //         .listen((snapshot) {
  //       if (snapshot.docs.isNotEmpty) {
  //         log("Confirm sender Exist");
  //         RequestModel request2 =
  //             RequestModel.fromMap(snapshot.docs.first.data());
  //         FirebaseFirestore.instance
  //             .collection('users')
  //             .doc(request2.machineryOwnerUid)
  //             .collection('received_requests')
  //             .doc(request2.requestId)
  //             .snapshots()
  //             .listen((snapshot) async {
  //           if (snapshot.exists && snapshot.data() != null) {
  //             var status = snapshot.data()!['status'];
  //             if (status == 'Confirm') {
  //               positionStream?.cancel();
  //               receivedRequestsStream?.cancel();
  //               sentRequestsStream?.cancel();
  //               if (Navigator.canPop(context)) {
  //                 Navigator.pushReplacementNamed(
  //                     context, AppRouter.bottomNavigationBar);
  //               }
  //             }
  //           }
  //         });
  //       }
  //     });
  //   } catch (e) {
  //     log(e.toString());
  //   }
  // }

//good listener

  // void listenForStatusUpdates(BuildContext context, String id) {
  //   try {
  //     var uid = context.read<AuthController>().appUser!.uid;

  //     // Create a helper function to handle status changes
  //     void handleStatusChange(String status) {
  //       if (status == 'Confirm' || status == 'Canceled') {
  //         positionStream?.cancel();
  //         receivedRequestsStream?.cancel();
  //         sentRequestsStream?.cancel();
  //         if (Navigator.canPop(context)) {
  //           Navigator.pushReplacementNamed(
  //               context, AppRouter.bottomNavigationBar);
  //         }
  //       }
  //     }

  //     // Listening for changes in received_requests with 'Confirm' or 'Canceled' status
  //     receivedRequestsStream = FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(uid)
  //         .collection('received_requests')
  //         .where("requestId", isEqualTo: id)
  //         .where('status', whereIn: ['Confirm', 'Canceled'])
  //         .snapshots()
  //         .listen((snapshot) {
  //           if (snapshot.docs.isNotEmpty) {
  //             log("status change detected in received_requests");
  //             RequestModel request =
  //                 RequestModel.fromMap(snapshot.docs.first.data());
  //             FirebaseFirestore.instance
  //                 .collection('users')
  //                 .doc(request.machineryOwnerUid)
  //                 .collection('received_requests')
  //                 .doc(request.requestId)
  //                 .snapshots()
  //                 .listen((snapshot) {
  //               if (snapshot.exists && snapshot.data() != null) {
  //                 receivedRequestsStream?.cancel();
  //                 sentRequestsStream?.cancel();
  //                 handleStatusChange(snapshot.data()!['status']);
  //               }
  //             });
  //           }
  //         });

  //     // Listening for changes in sent_requests with 'Confirm' or 'Canceled' status
  //     sentRequestsStream = FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(uid)
  //         .collection('sent_requests')
  //         .where("requestId", isEqualTo: id)
  //         .where('status', whereIn: ['Confirm', 'Canceled'])
  //         .snapshots()
  //         .listen((snapshot) {
  //           if (snapshot.docs.isNotEmpty) {
  //             log("status change detected in sent_requests");
  //             RequestModel request2 =
  //                 RequestModel.fromMap(snapshot.docs.first.data());
  //             FirebaseFirestore.instance
  //                 .collection('users')
  //                 .doc(request2.machineryOwnerUid)
  //                 .collection('received_requests')
  //                 .doc(request2.requestId)
  //                 .snapshots()
  //                 .listen((snapshot) {
  //               if (snapshot.exists && snapshot.data() != null) {
  //                 sentRequestsStream?.cancel();
  //                 receivedRequestsStream?.cancel();

  //                 handleStatusChange(snapshot.data()!['status']);
  //               }
  //             });
  //           }
  //         });
  //   } catch (e) {
  //     log(e.toString());
  //   }
  // }

  Future<void> addMessage(
      String requestId, Map<String, dynamic> messageData) async {
    try {
      await _repo.addMessage(requestId, messageData);
    } catch (e) {
      if (kDebugMode) {
        print("Error adding message: $e");
      }
      rethrow;
    }
  }

  Future<void> sendHiringRequest({required HiringRequestModel request}) async {
    try {
      isLoading = true;
      notifyListeners();
      await _repo.sendHiringRequest(request: request);
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
      if (kDebugMode) {
        log("Error adding message: $e");
      }
      rethrow;
    }
  }

  Future<void> updateOperatorRequest(
      {required HiringRequestModel request}) async {
    try {
      isLoading = true;
      notifyListeners();
      await _repo.updateOperatorRequest(request);
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();

      log(e.toString());
      rethrow;
    }
  }

  Future<void> requestComplete(
      String requestId, String uid, String status, String collection,
      {bool? isOperator}) async {
    try {
      isLoading = true;
      notifyListeners();
      await _repo.requestComplete(requestId, uid, status, collection,
          isOperator: isOperator);
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
      log(e.toString());
      rethrow;
    }
  }

  double userRating({required List<RatingForUser> userRating}) {
    try {
      return _repo.userRating(userRating: userRating);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> reportSubmition(BuildContext context,
      {required ReportModel report,
      required List<dynamic> images,
      required String collection,
      required String fireStoreCollectionForReport}) async {
    List<String> imageUrls;
    try {
      isLoading = true;
      notifyListeners();
      if (!kIsWeb) {
        imageUrls = await Future.wait(
          images.map(
            (image) => _machineRepo.uploadFile(
              image: image,
              id: report.reportId,
              uid: report.reportFrom,
              collectionName: collection,
            ),
          ),
        );
        log(imageUrls.toString());

        report.images = imageUrls;
      } else {
        imageUrls = await Future.wait(
          images.map(
            (image) => _machineRepo.uploadWebFile(
              image: image,
              id: report.reportId,
              uid: report.reportFrom,
              collectionName: collection,
            ),
          ),
        );
        report.images = imageUrls;
      }
      // details.images != null || details.images!.isNotEmpty?
      await _repo.reportSubmition(
        report: report,
        fireStoreCollectionForReport: fireStoreCollectionForReport,
      ); //: throw Exception("Image Required");
      isLoading = false;
      notifyListeners();

      // return imageUrls;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateReportWithCommentAndStatus(
      {required String reportId,
      required String comment,
      required bool isThisMachineriesReports}) async {
    try {
      await _repo.updateReportWithCommentAndStatus(
          reportId: reportId,
          comment: comment,
          isThisMachineriesReports: isThisMachineriesReports);
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print(e.message);
      }
      rethrow;
    }
  }

  // Future<void> updatePaymentDetails(
  //     String requestId, String updatedPaymentDetails) async {
  //   try {
  //     await _repo.updatePaymentDetails(requestId, updatedPaymentDetails);

  //     print('Payment details updated successfully.');
  //   } catch (e) {
  //     print('Error updating payment details: $e');
  //     rethrow;
  //     // Handle the error as needed, e.g., show an error message to the user
  //   }
  // }

  Future<void> getCombinedHiringRequestsForOperator(String operatorUid) async {
    try {
      allHiringRequests =
          await _repo.getCombinedHiringRequestsForOperator(operatorUid);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateRequestRatingStatus(
      {required String requestId,
      required String uid,
      required String collection,
      required bool isOperatorRatingComplete,
      required bool isHirerRatingComplete}) async {
    try {
      await _repo.updateRequestRatingStatus(
          requestId: requestId,
          uid: uid,
          collection: collection,
          isOperatorRatingComplete: isOperatorRatingComplete,
          isHirerRatingComplete: isHirerRatingComplete);
    } catch (e) {
      log(e.toString());
    }
  }
}
