import 'package:flutter/material.dart';
import 'package:vehicle_management_and_booking_system/app/app.dart';
import 'package:vehicle_management_and_booking_system/utils/app_colors.dart';
import 'package:vehicle_management_and_booking_system/utils/const.dart';
import 'package:vehicle_management_and_booking_system/utils/media_query.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  @override
  Widget build(BuildContext context) {
    bool isDark = ConstantHelper.darkOrBright(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "About Us",
            style: TextStyle(color: isDark ? null : Colors.black),
          ),
          backgroundColor: isDark ? null : AppColors.accentColor,
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: () {
                navigatorKey.currentState!.pop();
              },
              icon: Icon(
                Icons.arrow_back_ios_new_sharp,
                color: isDark ? null : AppColors.blackColor,
              )),
        ),
        body: Stack(
          children: [
            SizedBox(
              height: screenHeight(context),
              width: screenWidth(context),
              child: Image.asset(
                "assets/images/machineryImages/document (2).jpeg",
                fit: BoxFit.cover,
              ),
            ),
            Center(
              child: SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      color: Colors.black.withOpacity(0.8),
                      child: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Who We Are",
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                            SizedBox(height: 16),
                            Text(
                              "We are a platform that connects people and organizations to heavy machinery and operators for their construction needs.",
                              textAlign: TextAlign.justify,
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(height: 32),
                            Text("Our Mission",
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                            SizedBox(height: 16),
                            Text(
                              "To make the search and booking of heavy machinery as easy as possible.",
                              textAlign: TextAlign.justify,
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(height: 32),
                            Text("Our Vision",
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                            SizedBox(height: 16),
                            Text(
                              "To be the leading platform for heavy machinery and operator rentals, providing unmatched service and efficiency.",
                              textAlign: TextAlign.justify,
                              style: TextStyle(color: Colors.white),
                            ),
                            // SizedBox(height: 32),
                            // Text("Contact Us",
                            //     style: TextStyle(
                            //         fontSize: 24,
                            //         fontWeight: FontWeight.bold,
                            //         color: Colors.white)),
                            // SizedBox(height: 16),
                            // Text(
                            //   "Email: qaisarjamal@gmail.com",
                            //   style: TextStyle(color: Colors.white),
                            // ),
                            //  Text(
                            //   "Email: sana.dev11211@gmail.com",
                            //   style: TextStyle(color: Colors.white),
                            // ),
                            // Text(
                            //   "Phone: +92 (311) 1733776",
                            //   style: TextStyle(color: Colors.white),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
