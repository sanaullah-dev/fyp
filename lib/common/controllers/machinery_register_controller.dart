import 'dart:developer' as dev;
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vehicle_management_and_booking_system/authentication/db/database.dart';
import 'package:vehicle_management_and_booking_system/common/repo/machinery_repo.dart';
import 'package:vehicle_management_and_booking_system/models/machinery_model.dart';
import 'package:vehicle_management_and_booking_system/models/request_machiery_model.dart';
import 'package:vehicle_management_and_booking_system/screens/login_signup/model/user_model.dart';

class MachineryRegistrationController with ChangeNotifier {
  final _repo = MachineryRepo();
  bool isLoading = false;
  final _db = AuthDB();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  // ignore: prefer_typing_uninitialized_variables
  List<MachineryModel>? allMachineries;
  // ignore: prefer_typing_uninitialized_variables
  List<UserModel>? allUsers;
  List<MachineryModel>? favoriteMachineries;
  List<RequestModelForMachieries>? allRequests;
  final ZoomDrawerController zoomDrawerController = ZoomDrawerController();
  bool isCheckMachies = false;


void setIsCheckMachies(bool value){
  isCheckMachies=value;
  notifyListeners();
}



   void setLoading(){
    isLoading=true;
    notifyListeners();
   }
  void zoomtogle() {
    if (zoomDrawerController.isOpen!() != true) {
      zoomDrawerController.open!();
    } else {
      zoomDrawerController.close!();
    }
    notifyListeners();
  }

  Future<void> getAllRequests() async {
    dev.log("sana");
    QuerySnapshot machineryRequestQuerySnapshot =
        await _firestore.collection('machinery_requests').orderBy('dateAdded',descending: true).get();

    allRequests = machineryRequestQuerySnapshot.docs.map((doc) {
      return RequestModelForMachieries.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();
   dev.log(allRequests!.length.toString());
    //   for(var request in allRequests!){
    //   dev.log("${request.dateAdded.toString()}\n");
    // }
    notifyListeners();
   
    // Print all requests
    // for (final request in allRequests!) {
    //   print('Request Id: ${request.requestId}');
    //   print('Machine Id: ${request.machineId}');
    //   print('Machinery Owner Uid: ${request.machineryOwnerUid}');
    //   print('Sender Uid: ${request.senderUid}');
    //   print('Price: ${request.price}');
    //   print('Description: ${request.description}');
    //   print('Work of Hours: ${request.workOfHours}');
    //   print('Date Added: ${request.dateAdded}');
    //   print('-----------------------------------');
    // }
  }
  // Future<void> getAllMachineries() async {
  //   final ref = FirebaseFirestore.instance
  //       .collection('machineries');
  //   final snapshots = await ref.get();
  //   final docs = snapshots.docs;

  //   // Map each document to `MachineryModel` and store in `allMachineries`
  //   allMachineries =
  //       docs.map((doc) => MachineryModel.fromJson(doc.data())).toList();
  // }

// MachineryModel getMachineById(String id) {
//   return allMachineries!.firstWhere((machine) => machine.machineryId == id);
// }

  double calculateDistance(
      Location location, double latitude, double longitude) {
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

  Future<void> getAllMachineries() async {

    try {
      dev.log("called");
      await Geolocator.requestPermission();
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
      var latitude = position.latitude;
      var longitude = position.longitude;
      final ref = FirebaseFirestore.instance
          .collection('machineries'); // You will need to specify 'appUser'
      final snapshots = await ref.get();

      // List of documents sorted by the combined score of distance and rating
      List<QueryDocumentSnapshot<Map<String, dynamic>>> sortedDocs =
          snapshots.docs.toList()
            ..sort((a, b) {
              final locA = Location.fromJson(a.data()['location']);
              final locB = Location.fromJson(b.data()['location']);

              // Normalize distance to a 0-1 scale (Assuming max distance is 20000 km)
              final distA = calculateDistance(locA, latitude, longitude) / 10;
              final distB = calculateDistance(locB, latitude, longitude) / 10;

              // Normalize rating to a 0-1 scale (Assuming max rating is 5)
              final rateA = (a.data()['rating'] as num).toDouble() / 5.0;
              final rateB = (b.data()['rating'] as num).toDouble() / 5.0;

            // final rateA = a.data()['rating'] / 5;
            // final rateB = b.data()['rating'] / 5;

              // Calculate a combined score based on distance and rating
              final scoreA = calculateScore(distA, rateA);
              final scoreB = calculateScore(distB, rateB);

              // Sort in descending order of combined score
              return scoreB.compareTo(scoreA);
            });

      // Map each sorted document to `MachineryModel` and store in `allMachineries`
      allMachineries =
          sortedDocs.map((doc) => MachineryModel.fromJson(doc.data())).toList();

      // List favorites = await getFavorites(_db.isCurrentUser()!.uid);

      // favoriteMachineries = allMachineries
      //     .where((machine) => favorites.contains(machine.machineryId))
      //     .toList();

      notifyListeners();
    } catch (e) {
      dev.log(e.toString()+"1");
    }
  }

  Future<List<MachineryModel>> getFavoritesMachines(String userId) async {
    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(userId).get();

    // Check if the document exists and if it has data before checking for 'favorites'
    if (userDoc.exists && userDoc.data() is Map<String, dynamic>) {
      Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
      if (data.containsKey('favorites')) {
        List<dynamic> favorites = data['favorites'];
        // var favorite =
        //     favorites.map((favorite) => favorite.toString()).toList();

        favoriteMachineries = [...allMachineries!
            .where((machine) => favorites.contains(machine.machineryId))
            .toList()];

        notifyListeners();
        return favoriteMachineries!;
      }
    }
    // return an empty list if the document doesn't exist or it doesn't contain the 'favorites' field
    return [];
  }

  

  void addLocal(MachineryModel machinery) {
    // Only add if the machinery isn't already in the favorites list
    if (!allMachineries!
        .any((machine) => machine.machineryId == machinery.machineryId)) {
      allMachineries!.add(machinery);
      notifyListeners();
    }
  }

  // void removeLocalFavorite(String machineryId) {
  //   // Only remove if the machinery is in the favorites list
  //   if (favoriteMachineries!
  //       .any((machinery) => machinery.machineryId == machineryId)) {
  //     favoriteMachineries!
  //         .removeWhere((machinery) => machinery.machineryId == machineryId);
  //     notifyListeners();
  //   }
  // }

  // Future<List<String>> getFavorites() async {
  //   try {
  //     DocumentSnapshot doc = await _firestore
  //         .collection('users')
  //         .doc(_db.isCurrentUser()!.uid)
  //         .get();

  //     if (doc.exists) {
  //       List<String> machineryIds =  List<String>.from(doc['favorites']);
  //       return machineryIds;
  //     } else {
  //       return [];
  //     }
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  double calculateScore(double distance, double rating) {
    final weightDistance = 0.4; // weight for distance (less is better)
    final weightRating = 0.6; // weight for rating (more is better)

    // Note that we subtract distance from 1 because a shorter distance is better
    return weightDistance * (1 - distance) + weightRating * rating;
  }

  Future<void> fetchAllUsers() async {
    final querySnapshot = await _firestore.collection('users').get();

    allUsers = querySnapshot.docs
        .map((doc) => UserModel.fromJson(doc.data()))
        .toList();
    notifyListeners();
   
  }

  Future<void> uploadMachinery(BuildContext context,
      {required MachineryModel details,
      required List<dynamic> images,
      required String collection}) async {
    List<String> imageUrls;
    try {
      isLoading = true;
      notifyListeners();
      if (!kIsWeb) {
        imageUrls = await Future.wait(
          images.map(
            (image) => _repo.uploadFile(
              image: image,
              id: details.machineryId,
              uid: details.uid,
              collectionName: collection,
            ),
          ),
        );
        dev.log(imageUrls.toString());

        details.images = imageUrls;
      } else {
        imageUrls = await Future.wait(
          images.map(
            (image) => _repo.uploadWebFile(
              image: image,
              id: details.machineryId,
              uid: details.uid,
              collectionName: collection,
            ),
          ),
        );
        details.images = imageUrls;
      }
      // details.images != null || details.images!.isNotEmpty?
      await _repo.uploadMachinery(
          machine: details); //: throw Exception("Image Required");
      isLoading = false;
      notifyListeners();

      // return imageUrls;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // String distanse = "0.0";
  // Future<void> getDistance(
  //     {required startLatitude,
  //     required startLongitude,
  //     required endLatitude,
  //     required endLongitude}) async {
  //   double distanceInMeters = Geolocator.distanceBetween(
  //       startLatitude, startLongitude, endLatitude, endLongitude);
  //   log(distanceInMeters.toString());

  //   String
  //       Url = //"https://maps.googleapis.com/maps/api/distancematrix/json?destinations=34.0277427,71.6025374&origins=42.496228,-101.852071&key=AIzaSyAXGWwbvlDHQzc13kITch4lvsL7TnWEm3c";
  //       'https://maps.googleapis.com/maps/api/distancematrix/json?destinations=${startLatitude},${startLongitude}&origins=${endLatitude},${endLongitude}&key=AIzaSyAXGWwbvlDHQzc13kITch4lvsL7TnWEm3c';
  //   try {
  //     log("message1");
  //     print(Url);
  //     final response = await http.get(
  //       Uri.parse(Url),
  //     );
  //     log("message2");
  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       log(data.toString());
  //       distanse = data['rows'][0]['elements'][0]['distance']['text'];
  //       notifyListeners();
  //       // return kiloMeter;
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  Future<void> deleteMachine(
      {required String machineId, required List<String> images}) async {
    try {
      await _repo.removeMachineFromFavorites(machineId);
      dev.log("favorit remove");
      await _repo.deleteRequestsOfMachinery(
          machineId: machineId, requests: allRequests!);
      dev.log("delete requests remove");
      await _db.removeMachinery(machineId: machineId);
      dev.log("remove machine remove");
      await _deleteImages(imageUrls: images);
      dev.log("delete images remove");
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _deleteImages({required List<String> imageUrls}) async {
    await Future.wait(imageUrls.map((url) => _db.deleteImage(url: url)));
  }

  Future<void> _removeMachineFromFavorite(String machineId) async {}

  // image upload
  Future<String> uploadImage(
      {required String id, required XFile file, required String ref}) async {
    try {
      // ignore: no_leading_underscores_for_local_identifiers
      FirebaseStorage _storage = FirebaseStorage.instance;
      dev.log(file.path.toString());
      TaskSnapshot taskSnapshot =
          await _storage.ref(ref).putFile(File(file.path));
      dev.log(id.toString());
      dev.log(ref.toString());
      await Future.delayed(const Duration(seconds: 5));
      final url = await taskSnapshot.ref.getDownloadURL();

      return url;
    } on FirebaseException {
      rethrow;
    }
  }

  Future<String> uploadWebImage(
      {required String id,
      required Uint8List file,
      required String ref}) async {
    try {
      // ignore: no_leading_underscores_for_local_identifiers
      FirebaseStorage _storage = FirebaseStorage.instance;
      // log(file.path);
      TaskSnapshot taskSnapshot = await _storage.ref(ref).putData(file);
      dev.log(id);
      dev.log(ref);
      final url = await taskSnapshot.ref.getDownloadURL();

      return url;
    } on FirebaseException {
      rethrow;
    }
  }

  Future<void> sendRequest(RequestModelForMachieries request) async {
    try {
      isLoading = true;
      notifyListeners();
      await _repo.sendRequest(request);
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> addToFavorites(MachineryModel machine) async {
    try {
      isLoading = true;

      await _repo.addToFavorites(machine);
      isLoading = false;
    } catch (e) {
      isLoading = false;
      rethrow;
    }
  }

  // Future<bool> isMachineryFavorited(String userId, String machineryId) async {
  //   try {
  //     DocumentSnapshot userDoc =
  //         await _firestore.collection('users').doc(userId).get();

  //     List<dynamic> favorites = await userDoc.get('favorites');

  //     // If favorites contains the machineryId, return true. Otherwise, return false.
  //     return  favorites.contains(machineryId);
  //   } catch (e) {
  //     print(e);
  //     return false;
  //   }
  // }
  Future<bool> isMachineryFavorited(String userId, String machineryId) async {
    try {
      isLoading = true;
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();
      if (!userDoc.exists) {
        print('UserDoc does not exist');
        isLoading = false;
        return false;
      }

      Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;
      if (data == null || !data.containsKey('favorites')) {
        print('Data is null or favorites field does not exist');
        isLoading = false;
        return false;
      }

      List<dynamic> favorites = data['favorites'];

      print('favorites: $favorites');
      print('machineryId: $machineryId');

      // If favorites contains the machineryId, return true. Otherwise, return false.
      isLoading = false;
      return favorites.contains(machineryId);
    } catch (e) {
      isLoading = false;
      print('Error in isMachineryFavorited: $e');
      return false;
    }
  }

  Future<void> removeMachineryFromFavorites(String machineryId) async {
    try {
      isLoading = true;
      // Get all users who have this machinery in their favorites
      QuerySnapshot usersQuery = await _firestore
          .collection('users')
          .where('favorites', arrayContains: machineryId)
          .get();

      // Get all user document IDs from the query
      List<String> userIds = usersQuery.docs.map((doc) => doc.id).toList();

      // For each user, update the 'favorites' field to remove the machineryId
      for (String userId in userIds) {
        await _firestore.collection('users').doc(userId).update({
          'favorites': FieldValue.arrayRemove([machineryId])
        });
      }
      isLoading = false;
    } catch (e) {
      isLoading = false;
      rethrow;
    }
  }

  MachineryModel getMachineById(String machineryId) {
    return allMachineries!
        .firstWhere((machine) => machineryId == machine.machineryId);
  }

  UserModel getUser(String uid) {
    return allUsers!.firstWhere((temp) => uid == temp.uid);
  }

  Future<bool> hasUserRatedMachinery(String uid, String machineryId) async {
    try {
      return await _repo.hasUserRatedMachinery(uid, machineryId);
    } catch (e) {
      dev.log(e.toString());
      rethrow;
    }
  }

  Future<void> addRatingToMachinery(String machineryId, Rating rating) async {
    try {
    await  _repo.addRatingToMachinery(machineryId, rating);
    } catch (e) {
      dev.log(e.toString());
    }
  }

  Future<void> updateMachine(MachineryModel machine, bool value) async {
    try {
     await _repo.updateMachine(machine, value);
    } catch (e) {
      dev.log(e.toString());
    }
  }


   Future<void> addUserRating(String uid, RatingForUser rating) async {
    try {
      // Reference to the machinery document
    await _repo.addUserRating(uid, rating);
    } on FirebaseException catch (e) {
      print(e.toString());
      throw Exception("Error adding rating.");
    }
  }



Future<void> updateAllMachinesAvailability(String uid, bool isAvailable) async {
  try {
   await _repo.updateAllMachinesAvailability(uid, isAvailable);
  } on FirebaseException catch (e) {
    // Handle errors appropriately for your application
    dev.log("Error updating all machines: $e");
   rethrow;
  }
}


}
