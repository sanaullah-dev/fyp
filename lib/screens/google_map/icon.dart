// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'dart:ui' as ui;

// Future<BitmapDescriptor> _createMarkerImageFromWidget(BuildContext context) async {
//   final Completer<ui.Image> completer = Completer();
//   final double size = 80.0;

//   final widget = Container(
//     width: size,
//     height: size,
//     decoration: BoxDecoration(
//       color: Colors.red, // Set your desired background color
//       shape: BoxShape.circle,
//     ),
//     child: Image.asset("assets/images/axcevator/excavator1.png"),
//   );

//   final pictureRecorder = ui.PictureRecorder();
//   final canvas = Canvas(pictureRecorder);
//   final painter = (_MarkerPainter(widget));
//   painter.paint(canvas, Size(size, size));
//   final picture = pictureRecorder.endRecording();
//   picture.toImage(size.toInt(), size.toInt()).then((image) => completer.complete(image));

//   final data = await (await completer.future).toByteData(format: ui.ImageByteFormat.png);
//   return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
// }

// class _MarkerPainter extends CustomPainter {
//   final Widget widget;

//   _MarkerPainter(this.widget);

//   // @override
//   void paint(Canvas canvas, Size size) {
//     final recorder = ui.PictureRecorder();
//     final canvas = Canvas(recorder, Rect.fromPoints(Offset(0.0, 0.0), Offset(size.width, size.height)));
//     widget.build(Context(
//       owner: PipelineOwner(),
//       buildContext: null,
//       ancestors: [],
//     )).paint(Context(
//       owner: PipelineOwner(),
//       buildContext: null,
//       ancestors: [],
//       canvas: canvas,
//       size: size,
//     ));
//     canvas.drawPicture(recorder.endRecording());
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => false;
// }
