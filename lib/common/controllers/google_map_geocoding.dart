// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class GoogleMapsGeocodingApi {
  static Future<List<LatLng>?> getRouteCoordinates(
      String apiKey, LatLng startPoint, LatLng endPoint) async {
  //  String baseUrl = '';
try{
    String url = 
        'https://maps.googleapis.com/maps/api/directions/json?origin=${startPoint.latitude},${startPoint.longitude}&destination=${endPoint.latitude},${endPoint.longitude}&key=AIzaSyAXGWwbvlDHQzc13kITch4lvsL7TnWEm3c';

    print(url.toString());
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final directions = jsonDecode(response.body);
      final legs = directions['routes'][0]['legs'];
      final steps = legs[0]['steps'];

      final coordinates = steps
          .map((step) {
            final polyline = step['polyline'];
            final points = polyline['points'].split('_').map((point) {
              final latitude = double.parse(point.substring(0, 10)) / 10000000;
              final longitude = double.parse(point.substring(10)) / 10000000;
              return LatLng(latitude, longitude);
            }).toList();
            return points;
          })
          .expand((points) => points)
          .toList();

      return coordinates;
    } else {
      throw Exception(
          'Failed to get route coordinates: ${response.statusCode}');
    }
}catch(e){
  log(e.toString());
  rethrow;
}
      }
}

// import 'dart:async';
// import 'dart:convert';
// import 'dart:developer';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:http/http.dart' as http;

// class GoogleMapsGeocodingApi {
//   static Future<List<LatLng>?> getRouteCoordinates(
//       String apiKey, LatLng startPoint, LatLng endPoint) async {
//     String baseUrl = 'https://maps.googleapis.com/maps/api/directions/json';

//     Uri uri = Uri.parse(
//         '$baseUrl?origin=${startPoint.latitude},${startPoint.longitude}&destination=${endPoint.latitude},${endPoint.longitude}&key=$apiKey');

//     final request = http.Request('GET', uri);
//     request.headers['Access-Control-Allow-Origin'] = '*';

//     final response = await request.send();

//     if (response.statusCode == 200) {
//       final body = await response.stream.toBytes();
//       final json = jsonDecode(body as String);
// log(json.toString());
//       final routes = json['routes'] as List;
//       if (routes.isNotEmpty) {
//         final legs = routes[0]['legs'] as List;
//         if (legs.isNotEmpty) {
//           final steps = legs[0]['steps'] as List;
//           if (steps.isNotEmpty) {
//             final polyline = steps[0]['polyline']['points'] as String;
//             return decodePolyline(polyline);
//           }
//         }
//       }
//     } else {
//       throw Exception('Failed to call Google Maps Geocoding API.');
//     }
//   }


//   static List<LatLng> decodePolyline(String encoded) {
//     List<PointLatLng> points =
//         PolylinePoints().decodePolyline(encoded).map((e) {
//       return PointLatLng(e.latitude, e.longitude);
//     }).toList();

//     return points.map((point) => LatLng(point.latitude, point.longitude)).toList();
//   }
// }

