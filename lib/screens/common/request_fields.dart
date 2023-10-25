import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:vehicle_management_and_booking_system/authentication/controllers/auth_controller.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/machinery_register_controller.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/operator_register_controller.dart';
import 'package:vehicle_management_and_booking_system/models/machinery_model.dart';
import 'package:vehicle_management_and_booking_system/models/request_machiery_model.dart';
import 'package:vehicle_management_and_booking_system/screens/common/drawer_items/send_requests_screen.dart';
import 'package:vehicle_management_and_booking_system/screens/login_signup/model/user_model.dart';

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

  @override
  void dispose() {
    _priceController.dispose();
    _workHoursController.dispose();

    // _certificatesController.dispose();
    _summaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  labelText: 'Offer your price',
                  hintText: "E.g. 3099",
                  border: OutlineInputBorder()),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter price';
                }
                return null;
              },
            ),

            const SizedBox(height: 10.0),

            //
            const SizedBox(height: 16),
            TextFormField(
              controller: _workHoursController,
              decoration: const InputDecoration(
                  labelText: 'Work Time/Hours',
                  helperText: "Enter the number of hours you plan to work (e.g., 4, 8, 24)",

                  border: OutlineInputBorder(),
                  hintText: "E.g. 4,8,24"),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a Hours';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),
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

            Consumer<MachineryRegistrationController>(
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
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 14.0),
                      child: Container(
                        width: 100,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: OutlinedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                var _appUser =
                                    context.read<AuthController>().appUser;
                                final request = RequestModel(
                                  requestId: Uuid().v1(),
                                  machineId: widget.machinery.machineryId,
                                  machineryOwnerUid: widget.machinery.uid,
                                  senderUid: _appUser!.uid,
                                  price: _priceController.text,
                                  description: _summaryController.text,
                                  workOfHours: _workHoursController.text,
                                  dateAdded: Timestamp.now(),
                                );
                                
                                await value.sendRequest(request);
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Request Send"),
                                  ),
                                );
                                // ignore: use_build_context_synchronously
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx){
                                  return SentRequestsScreen(senderUid: _appUser.uid);
                                }));
                              } catch (e) {

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "There was an issue $e",
                                    ),
                                  ),
                                );
                              }
                              // debugPrint('Request Details:');
                              // debugPrint('Request ID: ${request.requestId}');
                              // debugPrint('Machine ID: ${request.machineId}');
                              // debugPrint(
                              //     'Machinery Owner UID: ${request.machineryOwnerUid}');
                              // debugPrint('Sender UID: ${request.senderUid}');
                              // debugPrint('Price: ${request.price}');
                              // debugPrint('Description: ${request.description}');
                              // debugPrint(
                              //     'Work of Hours: ${request.workOfHours}');
                              // debugPrint(
                              //     'Date Added: ${request.dateAdded.toDate()}');
                            }
                          },
                          child: const Text(
                            'Submit Request',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
            }),
          ],
        ),
      ),
    );
  }
}
