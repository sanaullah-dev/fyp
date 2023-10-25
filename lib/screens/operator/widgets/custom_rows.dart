import 'package:flutter/material.dart';
import 'package:vehicle_management_and_booking_system/utils/media_query.dart';

Widget customTextHeader(String text, bool isDark) {
  return Text(
    text,
    style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: isDark
          ? Colors.white
          : const Color.fromARGB(255, 103, 103, 103),
    ),
  );
}

Widget customTextContent(String text, bool isDark) {
  return SelectableText(
    text,
    textAlign: TextAlign.justify,
    style: TextStyle(
      fontSize: 16,
      //fontWeight: FontWeight.w600,
      color: isDark
          ? Colors.white
          : const Color.fromARGB(255, 103, 103, 103),
    ),
  );
}

Widget customRow(String title, String value, bool isDark, BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      customTextHeader(title, isDark),
      Flexible(
        child: SizedBox(
          width: screenWidth(context) * 0.48,
          child: customTextContent(value, isDark),
        ),
      ),
    ],
  );
}