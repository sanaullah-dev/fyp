import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vehicle_management_and_booking_system/models/operator_model.dart';
import 'package:vehicle_management_and_booking_system/screens/operator/operator_details.dart';

Widget operatorFavorite(var operatorDocument, var setIt){
  return  Expanded(
            child: setIt == null
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: operatorDocument.length,
                    itemBuilder: (context, index) {
                      final OperatorModel operator = operatorDocument[index];
                      // log(machine.toString());
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return OperatorDetailsScreen(operator: operator);
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
                              backgroundImage: operator.operatorImage != null
                                  ? CachedNetworkImageProvider(
                                      operator.operatorImage!.toString(),
                                    )
                                  : null,
                            ),
                            title: Text(
                              operator.name.toUpperCase(),
                              style: GoogleFonts.quantico(fontSize: 18,fontWeight: FontWeight.w800)
                            ),
                            subtitle: Text(
                              "Experience: ${operator.years}",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14.0,
                              ),
                            ),
                            trailing: Text("${operator.location.title.toString()}")),
                      );
                    },
                  ),
          );
}