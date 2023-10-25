import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_management_and_booking_system/app/app.dart';
import 'package:vehicle_management_and_booking_system/app/router.dart';
import 'package:vehicle_management_and_booking_system/authentication/controllers/auth_controller.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/machinery_register_controller.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/operator_register_controller.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/request_controller.dart';
import 'package:vehicle_management_and_booking_system/models/operator_model.dart';
import 'package:vehicle_management_and_booking_system/models/operator_request_model.dart';
import 'package:vehicle_management_and_booking_system/screens/common/drawer_items/drawer_screens/request_details.dart';
import 'package:vehicle_management_and_booking_system/screens/login_signup/model/user_model.dart';
import 'package:vehicle_management_and_booking_system/screens/operator/operator_details.dart';
import 'package:vehicle_management_and_booking_system/utils/app_colors.dart';
import 'package:vehicle_management_and_booking_system/utils/const.dart';

class HiringDetailsScreen extends StatefulWidget {
  final OperatorModel operatorModel;

  const HiringDetailsScreen({required this.operatorModel, Key? key})
      : super(key: key);

  @override
  State<HiringDetailsScreen> createState() => _HiringDetailsScreenState();
}

class _HiringDetailsScreenState extends State<HiringDetailsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = ConstantHelper.darkOrBright(context);
    UserModel appUser = context.read<AuthController>().appUser!;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            navigatorKey.currentState!.pop();
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? null : AppColors.blackColor,
          ),
        ),
        backgroundColor: isDark ? null : AppColors.accentColor,
        title: GestureDetector(
          onTap: () {
             widget.operatorModel.hiringRecordForOperator!.last
                                      .endDate ==
                                  null &&
                              widget.operatorModel.hiringRecordForOperator!.last
                                      .hirerUid ==
                                  appUser.uid
                          ? Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                              return OperatorDetailsScreen(
                                operator: widget.operatorModel,
                                status: "Hiring Completed",
                              );
                            }))
                          : Navigator.pushNamed(
                              context, AppRouter.operatorDetailsScreen,
                              arguments: widget.operatorModel);
          },
          child: Text(
             widget.operatorModel.name.toUpperCase(),
            // "My Hiring Details",
            style: TextStyle(color: isDark ? null : AppColors.blackColor),
          ),
        ),
      ),
      body: widget.operatorModel.hiringRecordForOperator == null ||
              widget.operatorModel.hiringRecordForOperator!.isEmpty
          ? const Center(child: Text('No Hiring Details'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount:
                        widget.operatorModel.hiringRecordForOperator!.length,
                    itemBuilder: (context, index) {
                      var hiringRecord =
                          widget.operatorModel.hiringRecordForOperator![index];

                      if (hiringRecord.hirerUid != appUser.uid) {
                        if (widget.operatorModel.uid != appUser.uid) {
                          return const SizedBox();
                        }
                      }
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: MediaQuery.of(context).size.width / 3,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1.0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          'Start Date: ${DateFormat('dd-MMM-yyyy hh:mm a').format(hiringRecord.startDate.toDate())}',
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      const SizedBox(height: 30),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          'End Date: ${hiringRecord.endDate != null ? DateFormat('dd-MMM-yyyy hh:mm a').format(hiringRecord.endDate!.toDate()) : "Till Now"}',
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        HiringRequestModel? requestModel =
                                            context
                                                .read<RequestController>()
                                                .allHiringRequests
                                                .firstWhere(
                                                  (element) =>
                                                      element.requestId ==
                                                      hiringRecord.requestId,
                                                );
                                        UserModel sender = context
                                            .read<
                                                MachineryRegistrationController>()
                                            .allUsers!
                                            .firstWhere((element) =>
                                                element.uid ==
                                                requestModel.hirerUserId);
                                        OperatorModel operatorModel = context
                                            .read<
                                                OperatorRegistrationController>()
                                            .allOperators
                                            .firstWhere((operator) =>
                                                operator.operatorId ==
                                                requestModel.operatorId);

                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        RequestDetailsScreen(
                                                          hiringRequest:
                                                              requestModel,
                                                          sender: sender,
                                                          operatorModel:
                                                              operatorModel,
                                                        )));
                                      },
                                      icon: const Icon(
                                          Icons.info_outline_rounded))
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // widget.operatorModel.uid == appUser.uid?SizedBox():
                // Container(
                //   color: Colors.orange,
                //   child: ListTile(
                //     title: Text(widget.operatorModel.name),
                //     subtitle: const Text("Operator"),
                //     onTap: () {
                //       widget.operatorModel.hiringRecordForOperator!.last
                //                       .endDate ==
                //                   null &&
                //               widget.operatorModel.hiringRecordForOperator!.last
                //                       .hirerUid ==
                //                   appUser.uid
                //           ? Navigator.of(context)
                //               .push(MaterialPageRoute(builder: (context) {
                //               return OperatorDetailsScreen(
                //                 operator: widget.operatorModel,
                //                 status: "Hiring Completed",
                //               );
                //             }))
                //           : Navigator.pushNamed(
                //               context, AppRouter.operatorDetailsScreen,
                //               arguments: widget.operatorModel);
                //     },
                //   ),
                // ),
              ],
            ),
    );
  }
}
