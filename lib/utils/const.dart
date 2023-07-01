import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum LoadingState {
  idle,
  processing,
  error,
  loaded,
}


class MapIcons{


static dynamic markerIcon;

 static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

 static BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  static BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  static BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;
  static void setCustomMarkerIcon(context) {
    BitmapDescriptor.fromAssetImage(
      createLocalImageConfiguration(
        context,
        size: const Size(40.0, 40.0),
      ),
      //const ImageConfiguration(size: Size(10, 10)),
      "assets/images/axcevator/excavator1.png",
    ).then(
      (icon) {
        sourceIcon = icon;
      },
    );
    BitmapDescriptor.fromAssetImage(
             createLocalImageConfiguration(
        context,
        size: const Size(40.0, 40.0),
      ), "assets/images/axcevator/excavator1.png")
        .then(
      (icon) {
        destinationIcon = icon;
      },
    );
    BitmapDescriptor.fromAssetImage(
             createLocalImageConfiguration(
        context,
        size: const Size(40.0, 40.0),
      ), "assets/images/axcevator/golden.png")
        .then(
      (icon) {
        currentLocationIcon = icon;
      },
    );
  }




}