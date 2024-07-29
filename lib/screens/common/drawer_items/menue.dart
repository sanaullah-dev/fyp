import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_management_and_booking_system/authentication/controllers/auth_controller.dart';
import 'package:vehicle_management_and_booking_system/screens/common/drawer_items/drawer_screens/about_us.dart';
import 'package:vehicle_management_and_booking_system/screens/common/drawer_items/favorite.dart';
import 'package:vehicle_management_and_booking_system/screens/common/drawer_items/drawer_screens/help.dart';
import 'package:vehicle_management_and_booking_system/screens/common/drawer_items/receive_requests_screen.dart';
import 'package:vehicle_management_and_booking_system/screens/common/drawer_items/send_requests_screen.dart';
import 'package:vehicle_management_and_booking_system/utils/media_query.dart';

class MenuScreen extends StatefulWidget {
  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  var appUser;
  // bool isOpReqeusteExist;
  // bool isMaRequestExist;

  //

  @override
  void initState() {
    // TODO: implement initState
    appUser = context.read<AuthController>().appUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 50),
              children: <Widget>[
                DrawerHeader(
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                      width: 0.1,
                      color: Colors.white,
                    ))),
                    // margin: EdgeInsets.all(0),
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 80.0,
                          height: 80.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color:
                                  Colors.white, // Set the color of the border
                              width: 2.0, // Set the width of the border
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 40.0,
                            backgroundImage: appUser?.profileUrl == null
                                ? null
                                : CachedNetworkImageProvider(
                                    appUser.profileUrl!),
                          ),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            appUser?.name?.toString().toUpperCase() ??
                                'Default Name', // replace 'Default Name' with a sensible default
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            appUser?.mobileNumber?.toString() ??
                                'Default Number',
                            //   appUser.mobileNumber.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    )),

                ListTile(
                  title: const Text('Send Requests',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      )),
                  leading: const Icon(
                    Icons.offline_share,
                    color: Colors.white,
                  ),
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: ((context) {
                      return SentRequestsScreen();
                    })));
                  },
                ),
                ListTile(
                  // contentPadding: EdgeInsets.only(left: 5),
                  title: const Text('Notifications',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      )),
                  leading: const Icon(
                    Icons.notifications,
                    color: Colors.white,
                  ),
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: ((context) {
                      return ReceivedRequestsScreen();
                    })));
                  },
                ),
                // ListTile(
                //   title: Text('Notification',
                //       style: TextStyle(
                //         color: Colors.white,
                //         fontSize: 16,
                //         fontWeight: FontWeight.bold,
                //       )),
                //   leading: Icon(
                //     Icons.notifications,
                //     color: Colors.white,
                //   ),
                //   onTap: () {},
                // ),
                ListTile(
                  title: const Text('Favoirte',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      )),
                  leading: const Icon(
                    Icons.favorite_outline_outlined,
                    color: Colors.white,
                  ),
                  onTap: () async {
                    // await context.read<MachineryRegistrationController>().getAllMachineries();
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: ((context) {
                      return const MyFavoriteMachineriesState();
                    })));
                  },
                ),
                ListTile(
                  title: const Text('Help',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  leading: const Icon(
                    Icons.help_outline_outlined,
                    color: Colors.white,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HelpScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: const Text('Rate Us',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  leading: const Icon(Icons.star_border_outlined,
                      color: Colors.white),
                  onTap: () {},
                ),
              ],
            ),
          ),
          Container(
            width: screenWidth(context),
            //padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(width: 0.1, color: Colors.grey[400]!),
              ),
            ),
            child: ListTile(
              title: const Text('About Us',
                  style: TextStyle(color: Colors.white, fontSize: 16)),
              leading: const Icon(
                Icons.info_outline_rounded,
                color: Colors.white,
              ),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return const AboutUsScreen();
                }));
              },
            ),
          )
        ],
      ),
    );
  }
}
