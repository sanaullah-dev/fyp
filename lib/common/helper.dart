import 'dart:convert';
import 'dart:developer';

import 'package:tuple/tuple.dart';

// ignore: library_prefixes
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:vehicle_management_and_booking_system/models/machinery_model.dart';
import 'package:vehicle_management_and_booking_system/models/operator_model.dart';

class Helper {
  //  bool _isGettingLocation = false;

  static String getFormattedDateTime(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year} ${getFormattedTime(date)}";
  }

  static String getFormattedTime(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }

  static Future<Tuple2<List<String>, dynamic>> getCurrentLocation(
      {required bool operator}) async {
    List<String> selectedAddress = [];
    String title;
    dynamic location;
    // _isGettingLocation = true;

    LocationPermission permission;
    // ignore: no_leading_underscores_for_local_identifiers
    bool _serviceEnabled;

    _serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!_serviceEnabled) {
      permission = await Geolocator.requestPermission();
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

    final lat = position.latitude;
    final lon = position.longitude;

    const apiKey = 'AIzaSyAXGWwbvlDHQzc13kITch4lvsL7TnWEm3c';
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lon&key=$apiKey';
    // 'https://maps.googleapis.com/maps/api/geocode/json?latlng=34.053444,71.584913&key=$apiKey';
    log(url.toString());
    log(url);
    // final url2 =
    //     "https://maps.googleapis.com/maps/api/directions/json?origin=34.0326183,71.605875&destination=34.0277326,71.6024996&key=AIzaSyDyCtN4KYInCI8NXHKvYNVq4YPNk7e8o70";
    // final response2 = await http.get(Uri.parse(url2));
    // final data2 = jsonDecode(response2.body);
    // log(data2.toString());

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'OK') {
        final placemark = data['results'][3];

        for (var result in data['results']) {
          selectedAddress.add(result['formatted_address']);
        }
        title = placemark["address_components"][3]["long_name"].toString();

        log(title);
        location = !operator
            ? Location(
                title: title.toString(),
                latitude: position.latitude,
                longitude: position.longitude,
              )
            : Locations(
                title: title.toString(),
                latitude: position.latitude,
                longitude: position.longitude,
              );
      } else {
        log('Error fetching placemark: ${data['status']}');
      }
    } else {
      log('Failed to fetch placemark. HTTP status code: ${response.statusCode}');
    }
    // }
    return Tuple2(selectedAddress, location);
  }

  static Future<dynamic> getDistance(
      {required dynamic lat, required dynamic lon}) async {
    dynamic totoalDitance;
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);

    double distanceInMeters = Geolocator.distanceBetween(
        position.latitude, position.longitude, lat, lon);
    double distanceInKm = distanceInMeters / 1000;
    totoalDitance = double.parse((distanceInKm).toStringAsFixed(2));

    return totoalDitance;
  }
}
