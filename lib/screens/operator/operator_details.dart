// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:vehicle_management_and_booking_system/models/operator_model.dart';

// class OperatorDetailsScreen extends StatefulWidget {
//    OperatorDetailsScreen({Key? key,required this.Details }) : super(key: key);
//   OperatorModel Details;
//   @override
//   State<OperatorDetailsScreen> createState() => _OperatorDetailsScreenState();
// }

// class _OperatorDetailsScreenState extends State<OperatorDetailsScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Operator Details'),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Center(
//               child: Container(
//                 width: 140.0,
//                 height: 140.0,
//                 decoration: BoxDecoration(
//                   color: Colors.lightBlue,
//                   image:  DecorationImage(
//                     image: NetworkImage(widget.Details.operatorImage.toString())

//                   ),
//                   borderRadius: BorderRadius.circular(80.0),
//                   border: Border.all(
//                     color: Colors.white,
//                     width: 10.0,
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20.0),
//             Text(
//               "John Doe",
//               style: Theme.of(context).textTheme.headline5,
//             ),
//             const SizedBox(height: 5.0),
//             Text(
//               "10 years of experience",
//               style: Theme.of(context).textTheme.subtitle1,
//             ),
//             const SizedBox(height: 5.0),
//             Text(
//               "Rating: ★★★★☆",
//               style: Theme.of(context).textTheme.subtitle1,
//             ),
//             const SizedBox(height: 20.0),
//             Text(
//               "Skills",
//               style: Theme.of(context).textTheme.headline6,
//             ),
//             const SizedBox(height: 10.0),
//             Text(
//               "• Heavy Machinery Operation\n• Maintenance\n• Safety Compliance",
//               textAlign: TextAlign.left,
//             ),
//             const SizedBox(height: 20.0),
//             Text(
//               "Availability",
//               style: Theme.of(context).textTheme.headline6,
//             ),
//             const SizedBox(height: 10.0),
//             Text(
//               "• Monday to Friday\n• 9AM - 5PM",
//               textAlign: TextAlign.left,
//             ),
//             const SizedBox(height: 20.0),
//             ElevatedButton(
//               onPressed: () {},
//               child: const Text('Hire this Operator'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vehicle_management_and_booking_system/models/operator_model.dart';
import 'package:vehicle_management_and_booking_system/screens/google_map/single_machiney_map.dart';
import 'package:vehicle_management_and_booking_system/utils/const.dart';
import 'package:vehicle_management_and_booking_system/utils/media_query.dart';
// import your OperatorModel

// ignore: must_be_immutable
class OperatorDetailsScreen extends StatefulWidget {
  OperatorDetailsScreen({super.key, required this.operator});
  late OperatorModel operator;
  @override
  State<OperatorDetailsScreen> createState() => _OperatorDetailScreenState();
}

class _OperatorDetailScreenState extends State<OperatorDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    bool isDark = ConstantHelper.darkOrBright(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("OPERATOR INFORMATION"),
        elevation: 0,
        backgroundColor: isDark
            ? Color.fromARGB(255, 171, 166, 166)
            : const Color.fromARGB(255, 206, 214, 219),
      ),
      backgroundColor: isDark
          ? Color.fromARGB(255, 171, 166, 166)
          : const Color.fromARGB(255, 206, 214, 219),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(left: 5, right: 5),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color.fromARGB(255, 111, 108, 108)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, top: 10, bottom: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.operator.name.toUpperCase().toString(),
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? Colors.white
                                  : Color.fromARGB(255, 109, 109, 108),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "City",
                            style: TextStyle(
                                color: isDark ? Colors.white : Colors.grey,
                                fontSize: 12),
                          ),
                          Text(
                            widget.operator.location.title.toString(),
                            style: TextStyle(
                              color: isDark
                                  ? Colors.white
                                  : Color.fromARGB(255, 84, 84, 84),
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Experience",
                            style: TextStyle(
                                color: isDark ? Colors.white : Colors.grey,
                                fontSize: 12),
                          ),
                          Text(
                            "${widget.operator.years} Years",
                            style: TextStyle(
                              color: isDark
                                  ? Colors.white
                                  : Color.fromARGB(255, 84, 84, 84),
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Rating",
                            style: TextStyle(
                                color: isDark ? Colors.white : Colors.grey,
                                fontSize: 12),
                          ),
                          Text(
                            "${widget.operator.rating}",
                            style: TextStyle(
                              color: isDark
                                  ? Colors.white
                                  : Color.fromARGB(255, 84, 84, 84),
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) {
                                    return SingleMachineMap(
                                      loc: widget.operator,
                                      isOperator: true,
                                    );
                                  },
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 5, 0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 5, 0),
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
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          const Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
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
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.firaSans(
                                                  fontWeight: FontWeight.w300),
                                              //maxLines: 1
                                              // softWrap: true,
                                              // style:
                                              //     FlutterFlowTheme.of(
                                              //             context)
                                              //         .bodySmall
                                              //         .override(
                                              //           fontFamily:
                                              //               'Lato',
                                              //           fontSize: 12,
                                              //           fontWeight:
                                              //               FontWeight
                                              //                   .w300,
                                              //         ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      height: screenHeight(context) * 0.3,
                      width: screenWidth(context) * 0.4,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: CachedNetworkImage(
                            height: screenHeight(context) * 1,
                            width: screenWidth(context),
                            // placeholder: (context, url) =>
                            //   const Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                            imageUrl: widget.operator.operatorImage!,
                            fit: BoxFit.cover,
                          )),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 30,
              ),
              Container(
                margin: const EdgeInsets.only(left: 5, right: 5),
                decoration: BoxDecoration(
                    color: isDark
                        ? const Color.fromARGB(255, 111, 108, 108)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Description",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? Colors.white
                                  : Color.fromARGB(255, 103, 103, 103)),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text(
                          widget.operator.summaryOrDescription.toString(),
                          style: TextStyle(
                              fontSize: 16,
                              color: isDark
                                  ? Colors.white
                                  : const Color.fromARGB(255, 117, 116, 116)),
                          textAlign: TextAlign.justify,
                        )
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: 30,
              ),
              Container(
                padding: EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color.fromARGB(255, 111, 108, 108)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "EMAIL:",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? Colors.white
                                  : Color.fromARGB(255, 103, 103, 103)),
                        ),
                        Flexible(
                          child: SizedBox(
                            width: screenWidth(context) * 0.48,
                            child: Text(
                              widget.operator.email.toString(),
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? Colors.white
                                      : Color.fromARGB(255, 103, 103, 103)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight(context) * 0.03),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "PHONE:",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? Colors.white
                                  : Color.fromARGB(255, 103, 103, 103)),
                        ),
                        Flexible(
                          child: SizedBox(
                            width: screenWidth(context) * 0.48,
                            child: Text(
                              widget.operator.mobileNumber.toString(),
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? Colors.white
                                      : Color.fromARGB(255, 103, 103, 103)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight(context) * 0.03),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "ADDRESS:",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? Colors.white
                                  : Color.fromARGB(255, 103, 103, 103)),
                        ),
                        Flexible(
                          child: SizedBox(
                            width: screenWidth(context) * 0.48,
                            child: Text(
                              widget.operator.fullAddress.toString(),
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? Colors.white
                                      : Color.fromARGB(255, 103, 103, 103)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),

              Container(
                padding: EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color.fromARGB(255, 111, 108, 108)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    // Education row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "EDUCATION:",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? Colors.white
                                  : Color.fromARGB(255, 103, 103, 103)),
                        ),
                        Flexible(
                          child: SizedBox(
                            width: screenWidth(context) * 0.48,
                            child: Text(
                              "${widget.operator.education.toString()}",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? Colors.white
                                      : Color.fromARGB(255, 103, 103, 103)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight(context) * 0.03),

                    // Skill row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "SKILL:",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? Colors.white
                                  : Color.fromARGB(255, 103, 103, 103)),
                        ),
                        Flexible(
                          child: SizedBox(
                            width: screenWidth(context) * 0.48,
                            child: Text(
                              widget.operator.skills.toString(),
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? Colors.white
                                      : Color.fromARGB(255, 103, 103, 103)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight(context) * 0.03),

                    // Gender row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "GENDER:",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? Colors.white
                                  : Color.fromARGB(255, 103, 103, 103)),
                        ),
                        Flexible(
                          child: SizedBox(
                            width: screenWidth(context) * 0.48,
                            child: Text(
                              widget.operator.gender.toString(),
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? Colors.white
                                      : Color.fromARGB(255, 103, 103, 103)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ListTile(
              //   title: Text('Emergency Number'),
              //   subtitle: Text(widget.operator.emergencyNumber),
              // ),
              // ListTile(
              //   title: Text('Gender'),
              //   subtitle: Text(widget.operator.gender),
              // ),

              // ListTile(
              //   title: Text('Education'),
              //   subtitle: Text(widget.operator.education),
              // ),
              // ListTile(
              //   title: Text('Skills'),
              //   subtitle: Text(widget.operator.skills),
              // ),

              // ListTile(
              //   title: Text('Date Added'),
              //   subtitle: Text(
              //       widget.operator.dateAdded.toDate().toIso8601String()),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
