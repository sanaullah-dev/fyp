import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_management_and_booking_system/authentication/controllers/auth_controller.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/machinery_register_controller.dart';
import 'package:vehicle_management_and_booking_system/screens/common/drawer_items/favorite.dart';
import 'package:vehicle_management_and_booking_system/screens/common/drawer_items/receive_requests_screen.dart';
import 'package:vehicle_management_and_booking_system/screens/common/drawer_items/send_requests_screen.dart';
import 'package:vehicle_management_and_booking_system/screens/common/user_total_machineris.dart';
import 'package:vehicle_management_and_booking_system/utils/media_query.dart';

class MenuScreen extends StatefulWidget {
  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  var appUser;

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
              padding: EdgeInsets.only(top: 50),
              children: <Widget>[
                DrawerHeader(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                      width: 0.1,
                      color: Colors.white,
                    ))),
                    // margin: EdgeInsets.all(0),
                    padding: EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 40.0,
                          backgroundImage: appUser.profileUrl == null
                              ? null
                              : CachedNetworkImageProvider(
                                  appUser.profileUrl!,

                                  // placeholder: (context, url) =>
                                  //     const CircularProgressIndicator(),
                                ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            appUser.name.toString().toUpperCase(),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            appUser.mobileNumber.toString(),
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    )),
              
                ListTile(
                  title: Text('Send Requests',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      )),
                  leading: Icon(
                    Icons.offline_share,
                    color: Colors.white,
                  ),
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: ((context) {
                      return SentRequestsScreen(
                        senderUid: appUser.uid,
                      );
                    })));
                  },
                ), 
                 ListTile(
                 // contentPadding: EdgeInsets.only(left: 5),
                  title: Text('Notifications',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      )),
                  leading: Icon(
                    Icons.notifications,
                    color: Colors.white,
                  ),
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: ((context) {
                      return ReceivedRequestsScreen(
                        receiverUid: appUser.uid,
                      );
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
                  title: Text('Favoirte',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      )),
                  leading: Icon(
                    Icons.favorite_outline_outlined,
                    color: Colors.white,
                  ),
                   onTap: () async{
                 // await context.read<MachineryRegistrationController>().getAllMachineries();
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: ((context) {
                      return MyFavoriteMachineriesState(
                       
                      );
                    })));
                  },
                ),
                ListTile(
                  title: Text('Help',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  leading: Icon(
                    Icons.help_outline_outlined,
                    color: Colors.white,
                  ),
                  onTap: () {},
                ),
                ListTile(
                  title: Text('Rate Us',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  leading:
                      Icon(Icons.star_border_outlined, color: Colors.white),
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
              title: Text('About Us',
                  style: TextStyle(color: Colors.white, fontSize: 16)),
              leading: Icon(
                Icons.info_outline_rounded,
                color: Colors.white,
              ),
              onTap: () {},
            ),
          )
        ],
      ),
    );
  }
}
