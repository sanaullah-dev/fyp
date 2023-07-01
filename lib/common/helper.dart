import 'dart:convert';
import 'dart:io';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tuple/tuple.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' as TargetPlatform;
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:vehicle_management_and_booking_system/models/machinery_model.dart';

class Helper {

 //  bool _isGettingLocation = false;

  static String getFormattedDateTime(DateTime date) {
    return "${date.day}-${date.month}-${date.year} ${getFormattedTime(date)}";
  }

  static String getFormattedTime(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }

  // image upload
  static Future<String> uploadImage(
      {required String id, required XFile file, required String ref}) async {
        try {
      // ignore: no_leading_underscores_for_local_identifiers
      FirebaseStorage _storage = FirebaseStorage.instance;
        log(file.path);
      TaskSnapshot taskSnapshot =
          await _storage.ref(ref).putFile(File(file.path));
          log(id);
        log(ref);   
      final url = await taskSnapshot.ref.getDownloadURL();

      return url;
    } on FirebaseException {
      rethrow;
    }
  }

  static Future<String> uploadWebImage(
      {required String id, required Uint8List file, required String ref}) async {
        try {
      // ignore: no_leading_underscores_for_local_identifiers
      FirebaseStorage _storage = FirebaseStorage.instance;
       // log(file.path);
      TaskSnapshot taskSnapshot =
          await _storage.ref(ref).putData(file);
          log(id);
        log(ref);   
      final url = await taskSnapshot.ref.getDownloadURL();

      return url;
    } on FirebaseException {
      rethrow;
    }
  }

  static Future<void> deleteImage({required String url}) async {
    final _storage = FirebaseStorage.instance;
    final ref = _storage.refFromURL(url);
    await _storage.ref(ref.fullPath).delete();
  }


 static Future<Tuple2<String,Location>> getCurrentLocation() async {
   var _selectedAddress;
   var location;
     // _isGettingLocation = true;
  
    LocationPermission permission;
    // ignore: no_leading_underscores_for_local_identifiers
    bool _serviceEnabled;

    _serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!_serviceEnabled) {
      return Future.error("Location services are disabled.");
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);

    // setState(() {
    //   _isGettingLocation = false;
    // });
    final lat = position.latitude;
    final lon = position.longitude;

    if (!TargetPlatform.kIsWeb) {
      List<geocoding.Placemark> placemarks =
          await geocoding.placemarkFromCoordinates(lat, lon);
      // log(placemarks[0].toString());
      log("${placemarks[0].subLocality}, ${placemarks[0].subAdministrativeArea}, ${placemarks[0].country}");
     
        _selectedAddress =
            "${placemarks[0].subLocality}, ${placemarks[0].subAdministrativeArea}, ${placemarks[0].country}";
        location = Location(
          title: placemarks[0].locality.toString(),
          latitude: position.latitude,
          longitude: position.longitude,
        );
    
    } else if (TargetPlatform.kIsWeb) {
      const apiKey = 'AIzaSyAXGWwbvlDHQzc13kITch4lvsL7TnWEm3c';
      final url =
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lon&key=$apiKey';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'OK') {
          final placemark = data['results'][4];

         //log("${placemark["formatted_address"]}");
        // log(placemark["address_components"][2]["long_name"].toString()); //, ${placemark.subAdministrativeArea}, ${placemark.country}");
           
            _selectedAddress = placemark["formatted_address"];
            location = Location(
              title: placemark["address_components"][2]["long_name"].toString(),
              latitude: position.latitude,
              longitude: position.longitude,
            );
       
          //  log(placemark['formatted_address']);
        } else {
          log('Error fetching placemark: ${data['status']}');
        }
      } else {
        log('Failed to fetch placemark. HTTP status code: ${response.statusCode}');
      }
    }
    return Tuple2(_selectedAddress, location);
   
  }






}
