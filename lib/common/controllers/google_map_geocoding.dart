import 'dart:convert';
import 'dart:developer';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class GoogleMapsGeocodingApi {
  static Future<List<LatLng>?> getRouteCoordinates(
      String apiKey, LatLng startPoint, LatLng endPoint) async {
    String baseUrl =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${startPoint.latitude},${startPoint.longitude}&destination=${endPoint.latitude},${endPoint.longitude}&key=$apiKey';

    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        // headers: {
        //   'Access-Control-Allow-Origin':
        //       '*', // Allow any origin to access the resource
        //   'Access-Control-Allow-Methods':
        //       'GET, POST, PUT, DELETE, OPTIONS', // Allow these HTTP methods
        //   'Access-Control-Allow-Headers':
        //       'Origin, Content-Type, X-Auth-Token', // Allow these custom headers
        // },
      );
      if (response.statusCode == 200) {
      //  log(response.body);
        final json = jsonDecode(response.body);
        final routes = json['routes'] as List;

        if (routes.isNotEmpty) {
          final legs = routes[0]['legs'] as List;

          if (legs.isNotEmpty) {
            final steps = legs[0]['steps'] as List;

            if (steps.isNotEmpty) {
              final polyline = steps[0]['polyline']['points'] as String;
              return decodePolyline(polyline);
            }
          }
        }
      } else {
        log('Failed to call Google Maps Geocoding API.');
        throw Exception('Failed to call Google Maps Geocoding API.');
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
    return null;
  }

  static List<LatLng> decodePolyline(String encoded) {
    List<PointLatLng> points =
        PolylinePoints().decodePolyline(encoded).map((e) {
      return PointLatLng(e.latitude, e.longitude);
    }).toList();

    return points
        .map((point) => LatLng(point.latitude, point.longitude))
        .toList();
  }
}
