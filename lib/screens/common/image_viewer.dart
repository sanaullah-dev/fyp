import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

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
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("IMAGE"),

      ),
      body: Center(
          child: PhotoView(
              imageProvider:
                  CachedNetworkImageProvider(widget.image.toString()))
          // Image.network(
          //   widget.image.toString(),
          // ),
          ),
    );
  }
}
