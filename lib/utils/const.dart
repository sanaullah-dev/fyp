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

class MapIcons {
  static dynamic markerIcon;

  static Future<Uint8List> getBytesFromAsset(String path, int width, [int? height]) async {
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
  static BitmapDescriptor iconforperson = BitmapDescriptor.defaultMarker;
  static BitmapDescriptor iconforpersonMobile = BitmapDescriptor.defaultMarker;






  static void setCustomMarkerIcons(BuildContext context) async {
   
    iconforpersonMobile = await getBitmapDescriptorFromAssets(
        "assets/images/placeholder_837427.png", 80, 80); // adjust the size here
  }

  static Future<BitmapDescriptor> getBitmapDescriptorFromAssets(
      String path, int width, int height) async {
    final Uint8List bytes =
        await getBytesFromAsset(path, width, height);
    return BitmapDescriptor.fromBytes(bytes);
  }







  static void setCustomMarkerIcon(context) {
    setCustomMarkerIcons(context);
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
              size: const Size(30.0, 30.0),
            ),
            "assets/images/axcevator/excavator1.png")
        .then(
      (icon) {
        destinationIcon = icon;
      },
    );
    BitmapDescriptor.fromAssetImage(
            createLocalImageConfiguration(
              context,
              size: const Size(40.0, 40.0),
            ),
            "assets/images/axcevator/golden.png")
        .then(
      (icon) {
        currentLocationIcon = icon;
      },
    );

    BitmapDescriptor.fromAssetImage(
            createLocalImageConfiguration(
              context,
              size:  Size(30.0, 30.0),
            ),
            "assets/images/placeholder_837427.png")
        .then(
      (icon) {
        iconforperson = icon;
      },
    );
  }
}

// class snackBarr{

//   static void showSnackBarMessage(String message, BuildContext context) {
//     final snackBar = SnackBar(
//       content: Text(message),
//       duration: const Duration(seconds: 4),
//     );
//     ScaffoldMessenger.of(context).showSnackBar(snackBar);
//   }
// }

class ConstantHelper {


 static bool darkOrBright(BuildContext context) {
    final Brightness brightnessValue =
        MediaQuery.of(context).platformBrightness;
    final isDarkModeOn = brightnessValue == Brightness.dark;
    return isDarkModeOn;
  }







static String timeAgo(DateTime date) {
  final now = DateTime.now();
  final difference = now.difference(date);

  String time;

  if (difference.inMinutes < 1) {
    time = 'just now';
  } else if (difference.inMinutes < 60) {
    time = '${difference.inMinutes}m ago';
  } else if (difference.inHours < 24) {
    time = '${difference.inHours}h ago';
  } else if (difference.inDays < 7) {
    time = '${difference.inDays}d ago';
  } else if (difference.inDays < 30) {
    time = '${difference.inDays ~/ 7}w ago';
  } else if (difference.inDays < 365) {
    time = '${difference.inDays ~/ 30}mo ago';
  } else {
    time = '${difference.inDays ~/ 365}y ago';
  }

  return time;
}

}
