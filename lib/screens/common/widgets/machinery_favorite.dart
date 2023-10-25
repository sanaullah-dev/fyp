import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vehicle_management_and_booking_system/models/machinery_model.dart';
import 'package:vehicle_management_and_booking_system/screens/machinery/machinery_detials.dart';

Widget machineryFavorite(var documents, var setIt){
  return  Expanded(
            child: setIt == null
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      final MachineryModel machine = documents[index];
                      // log(machine.toString());
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return DetalleWidget(model: machine);
                              }));
                              // TODO: Navigate to machinery detail screen
                            },
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 20.0,
                              horizontal: 16.0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(
                                color: Colors.grey.shade400,
                                width: 1.0,
                              ),
                            ),
                            leading: CircleAvatar(
                              radius: 30.0,
                              backgroundColor: Colors.grey.shade100,
                              backgroundImage: machine.images != null
                                  ? CachedNetworkImageProvider(
                                      machine.images!.last.toString(),
                                    )
                                  : null,
                            ),
                            title: Text(
                              machine.title.toUpperCase(),
                              style: GoogleFonts.quantico(fontSize: 18,fontWeight: FontWeight.w800)
                            ),
                            subtitle: Text(
                              machine.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14.0,
                              ),
                            ),
                            trailing: Text("Rs. ${machine.charges}/h")),
                      );
                    },
                  ),
          );
}