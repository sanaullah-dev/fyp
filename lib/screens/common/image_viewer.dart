import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:vehicle_management_and_booking_system/app/app.dart';
import 'package:vehicle_management_and_booking_system/utils/app_colors.dart';
import 'package:vehicle_management_and_booking_system/utils/const.dart';

// ignore: must_be_immutable
class ImageFromUrlViewer extends StatefulWidget {
  ImageFromUrlViewer({super.key, required this.image});
  // ignore: prefer_typing_uninitialized_variables
  var image;
  @override
  State<ImageFromUrlViewer> createState() => _ImageFromUrlViewerState();
}

class _ImageFromUrlViewerState extends State<ImageFromUrlViewer> {
  @override
  Widget build(BuildContext context) {
      bool isDark = ConstantHelper.darkOrBright(context);
      
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "IMAGE",
          style: TextStyle(color: isDark ? null : Colors.black),
        ),
        backgroundColor: isDark ? null : AppColors.accentColor,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              navigatorKey.currentState!.pop();
            },
            icon: Icon(
              Icons.arrow_back_ios_new_sharp,
              color: isDark ? null : AppColors.blackColor,
            )),
      ),
      body: Center(
          child: PhotoView(
              imageProvider:
                  CachedNetworkImageProvider(widget.image.toString(),),)
          // Image.network(
          //   widget.image.toString(),
          // ),
          ),
    );
  }
}
