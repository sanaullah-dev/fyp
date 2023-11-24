// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:vehicle_management_and_booking_system/app/app.dart';
import 'package:vehicle_management_and_booking_system/app/router.dart';
import 'package:vehicle_management_and_booking_system/authentication/controllers/auth_controller.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/machinery_register_controller.dart';
import 'package:vehicle_management_and_booking_system/models/machinery_model.dart';
import 'package:vehicle_management_and_booking_system/models/request_machiery_model.dart';

import 'package:vehicle_management_and_booking_system/screens/login_signup/model/user_model.dart';
import 'package:vehicle_management_and_booking_system/utils/app_colors.dart';
import 'package:vehicle_management_and_booking_system/utils/const.dart';
import 'package:vehicle_management_and_booking_system/utils/media_query.dart';
import 'package:vehicle_management_and_booking_system/utils/notification_method.dart';
import 'package:http/http.dart' as http;

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

// ignore: must_be_immutable
class RequestFields extends StatefulWidget {
  RequestFields({super.key, required this.machinery});
  MachineryModel machinery;

  @override
  // ignore: library_private_types_in_public_api
  _RequestFieldsState createState() => _RequestFieldsState();
}

class _RequestFieldsState extends State<RequestFields> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _workHoursController = TextEditingController();
  final TextEditingController _summaryController = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  // final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
  //     GlobalKey<ScaffoldMessengerState>();

  @override
  void dispose() {
    // Dispose your controllers
    _priceController.dispose();
    _workHoursController.dispose();
    _summaryController.dispose();
    _phoneNumber.dispose();

    // Focus.of(context).unfocus();
    super.dispose();
  }

  // This method handles the Submit Request logic.
  Future<void> _submitRequest() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Are you sure you want to send the request?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog

                await _sendMachineRequest(); // Send the machine request
              },
            ),
          ],
        );
      },
    );
  }

// This method handles the Unavailable logic.
  void _showUnavailable() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Machine is UnAvailable"),
        backgroundColor: Colors.orange,
      ),
    );
  }

// This method sends the machine request and shows the result as a SnackBar.
  Future<void> _sendMachineRequest() async {
    try {
      // ... Your existing logic to send the machine request ...
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
      var sourceLocation = LatLng(position.latitude, position.longitude);

      if (_formKey.currentState!.validate()) {
        // Create RequestModel
        var appUser = context.read<AuthController>().appUser;
        final request = RequestModelForMachieries(
            sourcelocation: sourceLocation,
            requestId: const Uuid().v1(),
            machineId: widget.machinery.machineryId,
            machineryOwnerUid: widget.machinery.uid,
            senderUid: appUser!.uid,
            price: _priceController.text,
            description: _summaryController.text,
            workOfHours: _workHoursController.text,
            mobileNumber: _phoneNumber.text,
            dateAdded: Timestamp.now());

        // Fetch user information
        UserModel user = context
            .read<MachineryRegistrationController>()
            .getUser(widget.machinery.uid);

        await context
            .read<MachineryRegistrationController>()
            .sendRequest(request);
        context.read<MachineryRegistrationController>().isLoading = true;
        NotificationMethod notificationMethod = NotificationMethod();
        // Send notification
        await notificationMethod.sendNotification(
            fcm: user.fcm.toString(),
            title: appUser.name,
            body: "Check Machine booking offer",
            type: "machine");
        context.read<MachineryRegistrationController>().isLoading = false;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Request Sent")),
        );

        Navigator.pushNamed(context, AppRouter.bottomNavigationBar);
      }
    } catch (e) {
      log(e.toString());

      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(content: Text("There was an issue: $e")),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration.zero, _getAllMachineries);
    super.initState();
  }
void _getAllMachineries() async {
  widget.machinery = context.read<MachineryRegistrationController>().getMachineById(widget.machinery.machineryId);

}
  @override
  Widget build(BuildContext context) {
    bool isDark = ConstantHelper.darkOrBright(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Book Now",
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
      body: Consumer<MachineryRegistrationController>(
          builder: (context, value, _) {
        return value.isLoading
            ? const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.amber,
                  ),
                ),
              )
            : Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          labelText: 'Offer Your Price',
                          hintText: "E.g. 99999",
                          border: OutlineInputBorder()),

                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ], // Only allow digits to be entered
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter price';
                        }
                        return null;
                      },
                    ),

                    // const SizedBox(height: 10.0),

                    //
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _workHoursController,
                      decoration: const InputDecoration(
                          labelText: 'Work Time/Hours',
                          helperText:
                              "Enter the number of hours you plan to work (e.g., 4, 8, 24)",
                          border: OutlineInputBorder(),
                          hintText: "E.g. 4,8,24"),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ], // O
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a Hours';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Active Mobile Number',
                        hintText: '03XX-XXXXXXX',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        Pattern pattern = r'^(03[0-9]{2})([0-9]{7})$';
                        RegExp regex = RegExp(pattern.toString());
                        if (!regex.hasMatch(value!) || value.isEmpty)
                          return 'Invalid mobile number';
                        else
                          return null;
                      },
                      controller: _phoneNumber,
                    ),
                    const SizedBox(
                      height: 16,
                    ),

                    TextFormField(
                      textAlign: TextAlign.justify,
                      controller: _summaryController,
                      decoration: const InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder()),
                      maxLines: 10,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a summary/description';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    Padding(
                      padding: EdgeInsets.only(
                          bottom: 14.0, right: screenWidth(context) * 0.5),
                      child: Container(
                        // width: ,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isDark ? null : AppColors.accentColor,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                  color:
                                      isDark ? Colors.grey : Colors.transparent)
                              //shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(10))
                              ),
                          onPressed: widget.machinery.isAvailable
                              ? _submitRequest
                              : _showUnavailable,
                          child: Text(
                            'Submit',
                            style: TextStyle(
                              fontSize: 18,
                              color: isDark ? null : AppColors.blackColor,
                            ),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              );
      }),
    );
  }
}