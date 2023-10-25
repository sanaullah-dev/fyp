import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vehicle_management_and_booking_system/models/operator_model.dart';
import 'package:vehicle_management_and_booking_system/screens/google_map/single_machiney_map.dart';
import 'package:vehicle_management_and_booking_system/utils/media_query.dart';

Widget infoText(String title, String content, bool isDark) {
  return Column(
    //mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
        title == "Rating"?SizedBox():
      Builder(builder: (context) {
        String temp = title;
        String text = temp.length > 10
            ? "${temp.substring(0, min(10, temp.length))}..."
            : temp;
        return Text(
          text,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.grey,
            fontSize: 12,
          ),
        );
      }),
      title == "Rating"
          ? Container(
    
      height: 30,
      decoration: BoxDecoration(
        color: const Color(0x00FFFFFF),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: Colors.orange,// Color(0xFF7F8788),
          width: 2,
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
              child: Row(
                  // mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      content,
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(width: 5,),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2.0),
                      child: Icon(
                        Icons.star,
                        color:Colors.orange,
                        size: 16,
                      ),
                    )
                  ],
                ),),
      ),
          )
          : Text(
            content,
            style: TextStyle(
              color: isDark
                  ? Colors.white
                  : const Color.fromARGB(255, 84, 84, 84),
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
      const SizedBox(height: 20),
    ],
  );
}

Widget findHereButton(BuildContext context, OperatorModel operator) {
  return GestureDetector(
    onTap: () {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => SingleMachineMap(
            loc: operator,
            isOperator: true,
          ),
        ),
      );
    },
    child: Container(
      width: screenWidth(context) * 0.3,
      height: 30,
      decoration: BoxDecoration(
        color: const Color(0x00FFFFFF),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: const Color(0xFF7F8788),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 3),
            child: Icon(
              Icons.map_outlined,
              color: Colors.orange,
              size: 18,
            ),
          ),
          Flexible(
            child: Text(
              " Find here",
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.firaSans(fontWeight: FontWeight.w300),
            ),
          ),
        ],
      ),
    ),
  );
}
