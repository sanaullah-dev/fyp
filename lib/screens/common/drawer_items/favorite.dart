import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_management_and_booking_system/app/app.dart';
import 'package:vehicle_management_and_booking_system/authentication/controllers/auth_controller.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/machinery_register_controller.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/operator_register_controller.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/request_controller.dart';
import 'package:vehicle_management_and_booking_system/screens/common/widgets/machinery_favorite.dart';
import 'package:vehicle_management_and_booking_system/screens/common/widgets/operator_favorite.dart';
import 'package:vehicle_management_and_booking_system/utils/app_colors.dart';
import 'package:vehicle_management_and_booking_system/utils/const.dart';
import 'package:vehicle_management_and_booking_system/utils/media_query.dart';

// ignore: must_be_immutable
class MyFavoriteMachineriesState extends StatefulWidget {
  const MyFavoriteMachineriesState({super.key});

  @override
  State<MyFavoriteMachineriesState> createState() =>
      _MyFavoriteMachineriesStateState();
}

class _MyFavoriteMachineriesStateState
    extends State<MyFavoriteMachineriesState> {
  var documentsForMachinery;
  var documentsForOperators;

  bool? setIt;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // await context.read<MachineryRegistrationController>().getFavorites(userId);

      documentsForMachinery = await context
          .read<MachineryRegistrationController>()
          .getFavoritesMachines(context.read<AuthController>().appUser!.uid);
      // ignore: use_build_context_synchronously
      documentsForOperators = await context
          .read<OperatorRegistrationController>()
          .getFavoritesOperators(context.read<AuthController>().appUser!.uid);
      setIt = true;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = ConstantHelper.darkOrBright(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Favorites",
          style: GoogleFonts.quantico(
              fontWeight: FontWeight.w700,
              color: isDark ? null : AppColors.blackColor),
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
      // appBar: AppBar(
      //   title: Text(
      //     "Favorites",
      //     style: GoogleFonts.quantico(fontWeight: FontWeight.w700),
      //   ),
      // ),
      body: setIt != true
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        context
                            .read<RequestController>()
                            .updateIsMachineryFavoritesScreen(value: true);
                        setState(() {});
                      },
                      child: Container(
                        height: 43,
                        width: screenWidth(context) * 0.5,
                        color: context
                                .read<RequestController>()
                                .isMachineryFavoritesScreen
                            ? const Color.fromARGB(255, 193, 190, 190)
                            : null,
                        child: Center(
                            child: Text(
                          "Machinery Favorites",
                          style:
                              GoogleFonts.quantico(fontWeight: FontWeight.w600),
                        )),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        context
                            .read<RequestController>()
                            .updateIsMachineryFavoritesScreen(value: false);
                        setState(() {});
                      },
                      child: Container(
                        height: 40,
                        width: screenWidth(context) * 0.5,
                        color: !context
                                .read<RequestController>()
                                .isMachineryFavoritesScreen
                            ? Colors.grey
                            : null,
                        child: Center(
                            child: Text(
                          "Operator Favorites",
                          style:
                              GoogleFonts.quantico(fontWeight: FontWeight.w600),
                        )),
                      ),
                    )
                  ],
                ),
                context.read<RequestController>().isMachineryFavoritesScreen
                    ? documentsForMachinery.isEmpty
                        ? SizedBox(
                            height: screenHeight(context) * 0.5,
                            child: const Center(
                              child: Text("No Favorite Machinery"),
                            ),
                          )
                        : machineryFavorite(documentsForMachinery, setIt)
                    : documentsForOperators.isEmpty
                        ? SizedBox(
                            height: screenHeight(context) * 0.5,
                            child: const Center(
                              child: Text("No Favorite Operators"),
                            ),
                          )
                        : operatorFavorite(documentsForOperators, setIt),
              ],
            ),
    );
  }
}
