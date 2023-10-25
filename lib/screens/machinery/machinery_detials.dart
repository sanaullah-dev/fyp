import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_management_and_booking_system/authentication/controllers/auth_controller.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/machinery_register_controller.dart';
import 'package:vehicle_management_and_booking_system/common/helper.dart';
import 'package:vehicle_management_and_booking_system/models/machinery_model.dart';
import 'package:vehicle_management_and_booking_system/screens/common/drawer_items/drawer_screens/report_screen.dart';
import 'package:vehicle_management_and_booking_system/screens/common/profile_screen.dart';
import 'package:vehicle_management_and_booking_system/screens/common/request_fields.dart';
import 'package:vehicle_management_and_booking_system/screens/common/reviews_screen.dart';
import 'package:vehicle_management_and_booking_system/screens/google_map/single_machiney_map.dart';
import 'package:vehicle_management_and_booking_system/screens/common/image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vehicle_management_and_booking_system/screens/login_signup/model/user_model.dart';
import 'package:vehicle_management_and_booking_system/screens/machinery/complaint_screen.dart';
import 'package:vehicle_management_and_booking_system/utils/const.dart';
import 'package:vehicle_management_and_booking_system/utils/media_query.dart';
// ignore: library_prefixes

// ignore: must_be_immutable
class DetalleWidget extends StatefulWidget {
  DetalleWidget({
    super.key,
    required this.model,
  });

  MachineryModel model;

  @override
  // ignore: library_private_types_in_public_api
  _DetalleWidgetState createState() => _DetalleWidgetState();
}

class _DetalleWidgetState extends State<DetalleWidget> {
//  final scaffoldKey = GlobalKey<ScaffoldState>();
  var _appUser;
  bool? _isFavorite;

  String getStatusString(bool isAvailable) {
    if (isAvailable == true) {
      return 'Available';
    } else if (isAvailable == false) {
      return 'UnAvailable';
    }
    return 'Unknown';
  }

  //double distanceInMeters = Geolocator.distanceBetween(widget.model.location.latitude, 6.9437819, 52.3546274, 4.8285838);
//var lat = widget.model.location.latitude;
  @override
  void initState() {
    _appUser = context.read<AuthController>().appUser;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _isFavorite = await context
          .read<MachineryRegistrationController>()
          .isMachineryFavorited(_appUser.uid, widget.model.machineryId);
      setState(() {});
    });
    super.initState();
    // _model = createModel(context, () => DetalleModel());
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
    //   await Geolocator.requestPermission();
    //   position = await Geolocator.getCurrentPosition(
    //     desiredAccuracy: LocationAccuracy.bestForNavigation,
    //   );
    // });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = ConstantHelper.darkOrBright(context);
    var providr = context.read<MachineryRegistrationController>();
    UserModel owner = context
        .read<MachineryRegistrationController>()
        .getUser(widget.model.uid);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // key: scaffoldKey,
      // backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      // backgroundColor: Colors.black,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          GestureDetector(
            onLongPress: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return ReportScreen(
                  machine: widget.model,
                //  machine: widget.model,
                );
              }));
            
            },
            child: Container(
              width: screenWidth(context),
              height: screenHeight(context), //*0.95,
              decoration: const BoxDecoration(
                color: Colors
                    .orange, // FlutterFlowTheme.of(context).secondaryBackground,
              ),
              child: Stack(
                children: [
                  Container(
                    width: screenWidth(context),
                    height: screenHeight(context),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.grey
                          : Colors.white, //FlutterFlowTheme.of(context)
                      // .secondaryBackground,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: screenWidth(context),
                          height: screenHeight(context) * 0.4,
                          decoration: const BoxDecoration(
                            color: Colors
                                .blue, // FlutterFlowTheme.of(context).secondaryBackground,
                          ),
                          child: Stack(
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return ImageFromUrlViewer(
                                            image: widget.model.images!.last,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  child: Hero(
                                    tag: 'grid_view_machine',
                                    child: CachedNetworkImage(
                                      height: screenHeight(context) * 1,
                                      width: screenWidth(context),
                                      // placeholder: (context, url) =>
                                      //   const Center(child: CircularProgressIndicator()),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                      imageUrl: widget.model.images!.last,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                  // Image.network(
                                  //   widget.model.images!.last.toString(),
                                  //   width: screenWidth(context),
                                  //   height: screenHeight(context) * 1,
                                  //   fit: BoxFit.cover,
                                  // ),
                                  ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    10, 10, 0, 0),
                                child: SafeArea(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              // context
                                              //     .read<
                                              //         MachineryRegistrationController>()
                                              //     .setIsCheckMachies(false);
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              width: 40,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                gradient: const LinearGradient(
                                                  colors: [
                                                    Color(0x47878383),
                                                    Color(0xA0D8D4D4)
                                                  ],
                                                  stops: [0, 1],
                                                  begin: AlignmentDirectional(
                                                      0, -1),
                                                  end: AlignmentDirectional(
                                                      0, 1),
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: const Icon(
                                                Icons.arrow_back_ios,
                                                color: Colors
                                                    .orange, //FlutterFlowTheme.of(
                                                //     context)
                                                // .primaryBtnText,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              var isFavorited = await providr
                                                  .isMachineryFavorited(
                                                      _appUser.uid,
                                                      widget.model.machineryId);
                                              log(isFavorited.toString());

                                              if (isFavorited) {
                                                // ignore: use_build_context_synchronously
                                                await providr
                                                    .removeMachineryFromFavorites(
                                                        widget
                                                            .model.machineryId);
                                                //  providr.removeLocalFavorite(widget.model.machineryId);
                                                log('Machinery is removed from favorites');
                                                _isFavorite = false;
                                              } else {
                                                await providr.addToFavorites(
                                                    widget.model);
                                                //  providr.addLocalFavorite(widget.model);
                                                log('Machinery is added to favorites');
                                                _isFavorite = true;
                                              }

                                              setState(() {});
                                            },
                                            child: Container(
                                              width: 40,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                gradient: const LinearGradient(
                                                  colors: [
                                                    Color(0x47878383),
                                                    Color(0xA0D8D4D4)
                                                  ],
                                                  stops: [0, 1],
                                                  begin: AlignmentDirectional(
                                                      0, -1),
                                                  end: AlignmentDirectional(
                                                      0, 1),
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child:
                                                  Builder(builder: (context) {
                                                return Icon(
                                                  _isFavorite == false ||
                                                          _isFavorite == null
                                                      ? Icons.favorite_border
                                                      : Icons.favorite,
                                                  color: Colors.orange,
                                                  size: 22,
                                                );
                                              }),
                                            ),
                                          )

                                          // GestureDetector(
                                          //   onTap: () async {
                                          //     bool isFavorited = await context
                                          //         .read<
                                          //             MachineryRegistrationController>()
                                          //         .isMachineryFavorited(
                                          //             widget.model.uid,
                                          //             widget.model.machineryId);

                                          //     if (isFavorited) {
                                          //       log('Machinery is already in favorites');
                                          //     } else {
                                          //       await context
                                          //           .read<
                                          //               MachineryRegistrationController>()
                                          //           .addToFavorites(widget.model);
                                          //     }
                                          //   },
                                          //   child: Container(
                                          //     width: 40,
                                          //     height: 40,
                                          //     decoration: BoxDecoration(
                                          //       gradient: const LinearGradient(
                                          //         colors: [
                                          //           Color(0x47878383),
                                          //           Color(0xA0D8D4D4)
                                          //         ],
                                          //         stops: [0, 1],
                                          //         begin:
                                          //             AlignmentDirectional(0, -1),
                                          //         end: AlignmentDirectional(0, 1),
                                          //       ),
                                          //       borderRadius:
                                          //           BorderRadius.circular(10),
                                          //     ),
                                          //     child: const Icon(
                                          //       Icons.favorite_border,
                                          //       color: Colors
                                          //           .orange, // FlutterFlowTheme.of(
                                          //       //         context)
                                          //       //     .primaryBtnText,
                                          //       size: 22,
                                          //     ),
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: const AlignmentDirectional(0, 1),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        //bottomLeft: Radius.circular(0),
                        //bottomRight: Radius.circular(0),
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      child: SizedBox(
                        height: screenHeight(context) * 0.8,
                        child: SingleChildScrollView(
                          child: Container(
                            margin: EdgeInsets.only(
                                top: screenHeight(context) * 0.1),
                            width: screenWidth(context),
                            // height: screenHeight(context),
                            // height: screenHeight(context) * 0.7,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.grey
                                  : Colors.white, //FlutterFlowTheme.of(context)
                              //  .primaryBackground,
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(0),
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  20, 30, 0, 0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 70,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(widget.model.title,
                                                style: const TextStyle(
                                                    fontFamily: "Quantico",
                                                    // fontWeight: FontWeight.bold,
                                                    fontSize: 22)),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 30,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'PKR ${widget.model.charges.toString()}/h',
                                              style: GoogleFonts.lato(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w800,
                                                color: Colors.orange,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          widget.model.address,
                                          style: const TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w200,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 15, 0, 0),
                                    child: Wrap(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (ctx) {
                                                  return SingleMachineMap(
                                                    loc: widget.model,
                                                    isOperator: false,
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 0, 10, 0),
                                            child: Container(
                                              width: screenWidth(context) * 0.3,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                color: const Color(0x00FFFFFF),
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                border: Border.all(
                                                  color:
                                                      const Color(0xFF7F8788),
                                                  width: 2,
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                3, 0, 3, 0),
                                                    child: Icon(
                                                      Icons.map_outlined,
                                                      color: Colors.orange,
                                                      size: 18,
                                                    ),
                                                  ),
                                                  Flexible(
                                                    child: Text(
                                                      " Find here",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style:
                                                          GoogleFonts.firaSans(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return AllReviewsScreen(
                                                  machine: widget.model,
                                                  title: "Machine Feedback");
                                            }));
                                          },
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 0, 10, 0),
                                            child: Container(
                                              width: screenWidth(context) * 0.2,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                color: const Color(0x00FFFFFF),
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                border: Border.all(
                                                  color:
                                                      const Color(0xFF7F8788),
                                                  width: 2,
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                3, 0, 0, 0),
                                                    child: Icon(
                                                      Icons.star,
                                                      color: Colors.orange,
                                                      size: 18,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            3, 0, 0, 0),
                                                    child: Text(
                                                      "${widget.model.rating.toStringAsFixed(1)}/5",
                                                      style:
                                                          GoogleFonts.firaSans(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 0, 10, 0),
                                          child: Container(
                                            //width: screenWidth(context) * 0.28,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              color: const Color(0x00FFFFFF),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              border: Border.all(
                                                color: const Color(0xFF7F8788),
                                                width: 2,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(3, 0, 3, 0),
                                                  child: Icon(
                                                    Icons.location_on_outlined,
                                                    color: Colors.orange,
                                                    size: 18,
                                                  ),
                                                ),
                                                FutureBuilder(
                                                    future: Helper.getDistance(
                                                        lat: widget.model
                                                            .location.latitude,
                                                        lon: widget
                                                            .model
                                                            .location
                                                            .longitude),
                                                    builder:
                                                        (context, snapshot) {
                                                      switch (snapshot
                                                          .connectionState) {
                                                        case ConnectionState
                                                              .waiting:
                                                          return const Text(
                                                              'Loading....');
                                                        default:
                                                          if (snapshot
                                                              .hasError) {
                                                            return Text(
                                                                'Error: ${snapshot.error}');
                                                          } else {
                                                            return Text(
                                                              '${snapshot.data} km  ',
                                                              style: GoogleFonts
                                                                  .firaSans(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300),
                                                            );
                                                          }
                                                      }
                                                    }),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 10, 5, 0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(0, 0, 5, 0),
                                                child: Container(
                                                  width: screenWidth(context) *
                                                      0.27,
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0x00FFFFFF),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                    border: Border.all(
                                                      color: const Color(
                                                          0xFF7F8788),
                                                      width: 2,
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                              3, 0, 0, 0),
                                                      child: Text(
                                                        "Model ${widget.model.model.toString()}",
                                                        style: GoogleFonts
                                                            .firaSans(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 10, 10, 0),
                                          child: Container(
                                            // width: screenWidth(context) * 0.27,
                                            height: 30,
                                            constraints: const BoxConstraints(
                                                minWidth: 50, maxWidth: 80),
                                            decoration: BoxDecoration(
                                              color: const Color(0x00FFFFFF),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              border: Border.all(
                                                color: const Color(0xFF7F8788),
                                                width: 2,
                                              ),
                                            ),
                                            child: Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(3, 0, 0, 0),
                                                child: Text(
                                                  "Size ${widget.model.size.toString()}",
                                                  style: GoogleFonts.firaSans(
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 10, 10, 0),
                                          child: Container(
                                            // width: screenWidth(context) * 0.27,
                                            height: 30,
                                            constraints: const BoxConstraints(
                                                minWidth: 50, maxWidth: 90),
                                            decoration: BoxDecoration(
                                              color: const Color(0x00FFFFFF),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              border: Border.all(
                                                color: const Color(0xFF7F8788),
                                                width: 2,
                                              ),
                                            ),
                                            child: Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(3, 0, 0, 0),
                                                child: Text(
                                                  "${getStatusString(widget.model.isAvailable)}",
                                                  style: GoogleFonts.firaSans(
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 30, 0, 0),
                                    child: Text(
                                      'Descripcion',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              16), //FlutterFlowTheme.of(context)
                                      //     .titleMedium,
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 10, 0, 0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 0, 20, 0),
                                            child: Text(
                                                widget.model.description
                                                    .toString(),
                                                textAlign:
                                                    TextAlign.justify, // style:
                                                style: GoogleFonts.firaSans(
                                                    color: isDark
                                                        ? Colors.white
                                                        : const Color.fromARGB(
                                                            154, 0, 0, 0))),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 30, 0, 0),
                                    child: Text(
                                      'Images',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                      // style: FlutterFlowTheme.of(context)
                                      //     .titleMedium,
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenHeight(context) * 0.16,
                                    child: ListView.builder(
                                        itemCount: widget.model.images!.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 20, 20, 0),
                                            child: Container(
                                              padding: const EdgeInsets.all(
                                                  0.2), // Border width
                                              decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: SizedBox.fromSize(
                                                  size: const Size.fromRadius(
                                                      48), // Image radius
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .push(
                                                        MaterialPageRoute(
                                                          builder: (context) {
                                                            return ImageFromUrlViewer(
                                                              image: widget
                                                                      .model
                                                                      .images![
                                                                  index],
                                                            );
                                                          },
                                                        ),
                                                      );
                                                    },
                                                    child: CachedNetworkImage(
                                                      width: 100.0,
                                                      height: 100.0,
                                                      // placeholder: (context, url) =>
                                                      //   const Center(child: CircularProgressIndicator()),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          const Icon(
                                                              Icons.error),
                                                      imageUrl: widget
                                                          .model.images![index],
                                                      fit: BoxFit.cover,
                                                    ),
                                                    //  Image.network(
                                                    //   widget.model.images![index],
                                                    //   width: 100,
                                                    //   height: 100,
                                                    //   fit: BoxFit.cover,
                                                    // ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                  const SizedBox(
                                    height: 40,
                                  ),

                                  // future: FirebaseFirestore.instance
                                  //     .collection("users")
                                  //     .doc(widget.model.uid)
                                  //     .get(),

                                  //   AsyncSnapshot<DocumentSnapshot>
                                  //       snapshot) {
                                  // if (snapshot.connectionState ==
                                  //     ConnectionState.waiting) {
                                  //   return const CircularProgressIndicator();
                                  // }

                                  // if (snapshot.hasError) {
                                  //   return Text("Error: ${snapshot.error}");
                                  // }

                                  // var dataMap = snapshot.data!.data()
                                  //     as Map<String, dynamic>;
                                  // var data = UserModel.fromJson(dataMap);

                                  ListTile(
                                    onTap: () {
                                      providr.isCheckMachies
                                          ? null
                                          : Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: ((context) {
                                              return ProfileScreen(
                                                  person: owner);
                                            })));
                                    },
                                    contentPadding: EdgeInsets.zero,
                                    leading: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: ((context) {
                                          return ImageFromUrlViewer(
                                              image: owner.profileUrl);
                                        })));
                                      },
                                      child: owner.profileUrl != null
                                          ? CircleAvatar(
                                              backgroundImage:
                                                  CachedNetworkImageProvider(
                                              // imageUrl:
                                              owner.profileUrl.toString(),
                                           
                                            ))
                                          : CircleAvatar(
                                              child: Text(owner.name[0])),
                                    ),
                                    title: Text(
                                        (owner.name.toString()).toUpperCase()),
                                    subtitle: Builder(builder: (context) {
                                      // var dateAndTime =
                                      //     Helper.getFormattedDateTime(widget
                                      //         .model.dateAdded
                                      //         .toDate());
                                      return Text(owner.email.toString());
                                    }),
                                    trailing: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(ConstantHelper.timeAgo(
                                          widget.model.dateAdded.toDate())),
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 20,
                                  ),
                                  providr.isCheckMachies
                                      ? const SizedBox()
                                      : context
                                                  .read<AuthController>()
                                                  .appUser!
                                                  .uid ==
                                              widget.model.uid
                                          ? const SizedBox()
                                          : Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 20.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  owner.isAvailable == true
                                                      ? Navigator.of(context)
                                                          .push(
                                                          MaterialPageRoute(
                                                            builder: (ctx) =>
                                                                RequestFields(
                                                                    machinery:
                                                                        widget
                                                                            .model),
                                                          ),
                                                        )
                                                      : null;
                                                },
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: 56,
                                                  decoration: BoxDecoration(
                                                    gradient:
                                                        const LinearGradient(
                                                      colors: [
                                                        Colors.orangeAccent,
                                                        Colors.deepOrange,
                                                      ],
                                                      stops: [0, 1],
                                                      begin:
                                                          AlignmentDirectional(
                                                              -0.34, 1),
                                                      end: AlignmentDirectional(
                                                          0.34, -1),
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      owner.isAvailable
                                                          ? 'Book Now'
                                                          : "Not Available",
                                                      style: GoogleFonts
                                                          .libreBaskerville(
                                                        color: Colors.white,
                                                        fontSize: 17,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                  SizedBox(
                                    height: screenHeight(context) * 0.05,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
