import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:vehicle_management_and_booking_system/app/router.dart';
import 'package:vehicle_management_and_booking_system/models/machinery_model.dart';
import 'package:vehicle_management_and_booking_system/screens/machinery/Single_machinery_details.dart';
import 'package:vehicle_management_and_booking_system/utils/media_query.dart';

import 'package:flutter/foundation.dart' as TargetPlatform;

// ignore: must_be_immutable
class SingleMachineryWidget extends StatefulWidget {
  SingleMachineryWidget({
    required this.machineryDetails,
    super.key,
  });
  MachineryModel machineryDetails;

  @override
  State<SingleMachineryWidget> createState() => _SingleMachineryWidgetState();
}

class _SingleMachineryWidgetState extends State<SingleMachineryWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 5));
    _animation = Tween<double>(begin: 0, end: 8.8).animate(_controller);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.forward();
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, AppRouter.ma,
            arguments: IndivisualPageArgs(
              machineryDetails: widget.machineryDetails,
            ));
        log(widget.machineryDetails.title);
        // Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
        //   return MachineryDetail(
        //     machineryDetails: widget.machineryDetails,
        //       // image: Image.asset("assets/images/main.png"),
        //      );
        // }));
      },
      child: AnimatedContainer(
        duration: const Duration(seconds: 5),
        curve: Curves.bounceIn,
        height: TargetPlatform.kIsWeb
            ? 200
            : screenHeight(context) > 846
                ? screenHeight(context) * 0.25
                : screenHeight(context) * 0.22,
        child: FadeTransition(
          opacity: _animation,
          child: Card(
            //color: Colors.pink,
            // semanticContainer: true,
            clipBehavior: Clip.hardEdge,
            elevation: 10,
            //shadowColor: Colors.orangeAccent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // SizedBox(height: 10,),
                SizedBox(
                  width: screenWidth(context) * 1,
                  height: TargetPlatform.kIsWeb
                      ? 180
                      : screenHeight(context) > 846
                          ? screenHeight(context) * 0.22
                          : screenHeight(context) * 0.2,
                  // color: Colors.black,
                  child: !TargetPlatform.kIsWeb
                      ? CachedNetworkImage(
                         // placeholder: (context, url) =>
                           //   const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          imageUrl: widget.machineryDetails.images!.last,
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          widget.machineryDetails.images!.last,
                          fit: BoxFit.cover,
                        ),
                ),
                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 20,
                          ),
                          Text(
                            //"Islamabad",
                            widget.machineryDetails.location.title.toString(),
                            // widget.machineryDetails.address, overflow: TextOverflow.ellipsis,maxLines: 1,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 15,
                              color: Colors.amber,
                            ),
                            Text(
                              widget.machineryDetails.rating.toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.machineryDetails.title.toString(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 18,
                      fontFamily: "Quantico",
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text("Model ${widget.machineryDetails.model}"),
                    )),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Container(
                    width: 100,
                    //height: MediaQuery.of(context).size.height,
                    //height: size.height,
                    // clipBehavior: Clip.hardEdge,
                    //  padding: const EdgeInsets.only(l),

                    decoration: const BoxDecoration(
                        color: Colors.yellow,
                        borderRadius:
                            BorderRadius.only(topRight: Radius.circular(20))),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 11.0),
                        child: Text(
                          "Rs. ${widget.machineryDetails.charges}/hr",
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
