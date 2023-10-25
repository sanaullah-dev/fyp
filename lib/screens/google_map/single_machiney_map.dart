import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/foundation.dart' as TargetPlatform;
import 'package:vehicle_management_and_booking_system/utils/const.dart';

// ignore: must_be_immutable
class SingleMachineMap extends StatefulWidget {
  SingleMachineMap({required this.loc, required this.isOperator});
  // ignore: prefer_typing_uninitialized_variables
  var loc;
  bool isOperator;
  @override
  State<SingleMachineMap> createState() => _SingleMachineMapState();
}

class _SingleMachineMapState extends State<SingleMachineMap> {

@override
  void initState() {
    // TODO: implement initState
   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
     MapIcons.setCustomMarkerIcons(context);
   });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  widget.loc.location.latitude,
                  widget.loc.location.longitude,
                ),
                zoom: 15,
              ),
              // ignore: prefer_collection_literals
              markers: Set<Marker>.from(
                [
                  Marker(
                    onTap: () {},
                    icon: !TargetPlatform.kIsWeb
                        ? widget.isOperator
                            ? MapIcons.iconforpersonMobile
                            : BitmapDescriptor.fromBytes(MapIcons.markerIcon)
                        : widget.isOperator
                            ? MapIcons.iconforperson
                            : MapIcons.destinationIcon,
                    markerId: MarkerId(widget.loc.location.title),
                    infoWindow: InfoWindow(
                        title: widget.isOperator? widget.loc.name.toString(): widget.loc.title.toString(),
                        snippet: widget.loc.location.title.toString()),
                    position: LatLng(
                      widget.loc.location.latitude,
                      widget.loc.location.longitude,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 0, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0x47878383), Color(0xA0D8D4D4)],
                          stops: [0, 1],
                          begin: AlignmentDirectional(0, -1),
                          end: AlignmentDirectional(0, 1),
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.orange, //FlutterFlowTheme.of(
                        //     context)
                        // .primaryBtnText,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Visibility(
            //   visible: visibily,
            //   child: Positioned(
            //     bottom: 0,
            //     left: 0,
            //     right: 0,
            //     child: GestureDetector(
            //       onTapUp: (details) {},
            //       onTapDown: (details) {},
            //       child: Container(
            //         height: screenHeight(context) * 0.45,
            //         width: screenWidth(context),
            //         decoration: const BoxDecoration(
            //               color: Color.fromARGB(255, 246, 239, 239), //FlutterFlowTheme.of(context)
            //               //  .primaryBackground,
            //               borderRadius: BorderRadius.only(
            //                 bottomLeft: Radius.circular(0),
            //                 bottomRight: Radius.circular(0),
            //                 topLeft: Radius.circular(30),
            //                 topRight: Radius.circular(30),
            //               ),
            //             ),
            //       ),
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
