import 'dart:developer';
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
  static dynamic markerForDark;

  static BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  static BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  static BitmapDescriptor iconforperson = BitmapDescriptor.defaultMarker;
  static BitmapDescriptor iconforpersonMobile = BitmapDescriptor.defaultMarker;

  static BitmapDescriptor icon1 = BitmapDescriptor.defaultMarker;
  static BitmapDescriptor icon2person = BitmapDescriptor.defaultMarker;
  static BitmapDescriptor currentLocationForTraking =
      BitmapDescriptor.defaultMarker;

  static BitmapDescriptor icon1ForWeb = BitmapDescriptor.defaultMarker;
  static BitmapDescriptor icon2personForWeb = BitmapDescriptor.defaultMarker;
  static BitmapDescriptor currentLocationForTrakingForWeb =
      BitmapDescriptor.defaultMarker;

  static Future<void> setCustomMarkerIcons(BuildContext context) async {
    try {
      iconforpersonMobile = await getBitmapDescriptorFromAssets(
          "assets/images/placeholder_837427.png",
          80,
          80); // adjust the size here
      icon1 = await getBitmapDescriptorFromAssets(
          "assets/images/axcevator/Icon1.png", 80, 80); // adjust the size here
      icon2person = await getBitmapDescriptorFromAssets(
          "assets/images/axcevator/Icon2.png", 80, 80); // adjust the size here
      currentLocationForTraking = await getBitmapDescriptorFromAssets(
          "assets/images/axcevator/personOrangeIcon.png", 80, 80);
    } catch (e) {
      log(e.toString());
    }
  }

  static Future<BitmapDescriptor> getBitmapDescriptorFromAssets(
      String path, int width, int height) async {
    try {
      final Uint8List bytes = await getBytesFromAsset(path, width, height);
      return BitmapDescriptor.fromBytes(bytes);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  static Future<Uint8List> getBytesFromAsset(String path, int width,
      [int? height]) async {
    try {
      ByteData data = await rootBundle.load(path);
      ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
          targetWidth: width);
      ui.FrameInfo fi = await codec.getNextFrame();
      return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
          .buffer
          .asUint8List();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  static Future<void> setAllMarker(context) async {
    try {
      log("setcustomerMarkerIcon");
      await setCustomMarkerIcons(context);

    await  BitmapDescriptor.fromAssetImage(
              createLocalImageConfiguration(context,
                  size: const Size(40.0, 40.0)),
              // "assets/images/axcevator/excavator1.png")
              "assets/images/axcevator/excavator1.png")
          .then(
        (icon) {
          sourceIcon = icon;
        },
      );

    await  BitmapDescriptor.fromAssetImage(
              createLocalImageConfiguration(context,
                  size: const Size(30.0, 30.0)),
              "assets/images/axcevator/excavatorForWeb.png")
          .then(
        (icon) {
          destinationIcon = icon;
        },
      );

    await  BitmapDescriptor.fromAssetImage(
              createLocalImageConfiguration(context,
                  size: const Size(30.0, 45.0)),
              "assets/images/axcevator/Icon1.png")
          .then(
        (icon) {
          icon1ForWeb = icon;
        },
      );

     await BitmapDescriptor.fromAssetImage(
              createLocalImageConfiguration(context,
                  size: const Size(30.0, 45.0)),
              "assets/images/axcevator/Icon2.png")
          .then(
        (icon) {
          icon2personForWeb = icon;
        },
      );
    await  BitmapDescriptor.fromAssetImage(
              createLocalImageConfiguration(context,
                  size: const Size(30.0, 30.0)),
              "assets/images/axcevator/personOrangeIcon.png")
          .then(
        (icon) {
          currentLocationForTrakingForWeb = icon;
        },
      );

      //  BitmapDescriptor.fromAssetImage(
      //         createLocalImageConfiguration(context,
      //             size: const Size(100.0, 100.0)),
      //         "assets/images/axcevator/Icon1.png")
      //     .then(
      //   (icon) {
      //     distinationForTracking = icon;
      //   },
      // );
      // BitmapDescriptor.fromAssetImage(
      //         createLocalImageConfiguration(context,
      //             size: const Size(30.0, 30.0)),
      //         "assets/images/axcevator/excavator (1).png")
      //     .then(
      //   (icon) {
      //     log("@@@@@@@@@@@@@@@@");
      //     destinationIconForDark = icon;
      //   },
      // );

   await   BitmapDescriptor.fromAssetImage(
              createLocalImageConfiguration(context,
                  size: const Size(30.0, 30.0)),
              "assets/images/placeholder_837427.png")
          .then(
        (icon) {
          iconforperson = icon;
        },
      );
    } catch (e) {
      log(e.toString());
    }
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


  static Color textColors(String status) {
    switch (status) {
      case 'Accepted':
        return Colors.blue;

      case 'Activated':
        return Colors.blue;

      case 'Confirm':
        return Colors.orange;

      case 'Canceled':
        return Colors.red;

      case 'Time Out':
        return Colors.red;

      case 'Completed':
        return Colors.blue;

      default:
        return Colors.blue;
    }
  }
}


