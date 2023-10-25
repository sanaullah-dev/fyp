import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:vehicle_management_and_booking_system/app/app.dart';
import 'package:vehicle_management_and_booking_system/authentication/controllers/auth_controller.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/machinery_register_controller.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/request_controller.dart';
import 'package:vehicle_management_and_booking_system/models/operator_model.dart';
import 'package:vehicle_management_and_booking_system/models/operator_request_model.dart';
import 'package:vehicle_management_and_booking_system/screens/login_signup/model/user_model.dart';
import 'package:vehicle_management_and_booking_system/utils/app_colors.dart';
import 'package:vehicle_management_and_booking_system/utils/const.dart';
import 'package:vehicle_management_and_booking_system/utils/notification_method.dart';

// ignore: must_be_immutable
class RequestForm extends StatefulWidget {
  RequestForm({super.key, required this.operator});
  OperatorModel operator;
  @override
  // ignore: library_private_types_in_public_api
  _RequestFormState createState() => _RequestFormState();
}

class _RequestFormState extends State<RequestForm> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController startDate = TextEditingController();
  TextEditingController endDate = TextEditingController();
  TextEditingController purpose = TextEditingController();
  TextEditingController payment = TextEditingController();
  TextEditingController notes = TextEditingController();
  TextEditingController companyName = TextEditingController();
   DateTime interViewDateTime = DateTime.now();
  TextEditingController interViewLocation = TextEditingController();
  TextEditingController contactNumber = TextEditingController();
  String? jobType;
  late DateTime _selectedDateTime = DateTime.now();
  late DateTime _selectedStartDateTime;
  late DateTime _selectedEndDateTime;
  late UserModel appUser;

  @override
  void initState() {
    // TODO: implement initState
    appUser = context.read<AuthController>().appUser!;
    contactNumber.text = appUser!.mobileNumber;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = ConstantHelper.darkOrBright(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.operator.name,
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Company Name',
                      hintText: 'Enter the company name \n(if Individual type No)',
                      border: OutlineInputBorder(),
                    ),
                    controller: companyName,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the company name';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16), //  can adjust this as needed

                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Job Type',
                      hintText: 'Select the type of job',
                      border: OutlineInputBorder(),
                    ),
                    value: jobType,
                    onChanged: (String? newValue) {
                      setState(() {
                        jobType = newValue;
                      });
                    },
                    items: <String>['Full-time', 'Part-time']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a job type';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Purpose of Hiring',
                      hintText: 'Why are you hiring this person?',
                      border: OutlineInputBorder(),
                    ),
                    controller: purpose,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the purpose of hiring';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16), // can adjust this as needed

                  TextFormField(
                    readOnly: true,
                    keyboardType: TextInputType.datetime,
                    decoration: const InputDecoration(
                      labelText: 'Start Date',
                      hintText: 'Enter start date (e.g., dd/mm/yyyy)',
                      border: OutlineInputBorder(),
                    ),
                    controller: startDate,
                    onTap: () {
                      // Show date picker
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      ).then((selectedDate) {
                        if (selectedDate != null) {
                          // Show time picker
                          showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          ).then((selectedTime) {
                            if (selectedTime != null) {
                              // Combine date and time
                              DateTime selectedDateTime = DateTime(
                                selectedDate.year,
                                selectedDate.month,
                                selectedDate.day,
                                selectedTime.hour,
                                selectedTime.minute,
                              );

                              // Validate if the selected date and time are in the future
                              if (selectedDateTime.isAfter(DateTime.now())) {
                                setState(() {
                                  _selectedStartDateTime = selectedDateTime;
                                  startDate.text =
                                      DateFormat('dd/MM/yyyy hh:mm a')
                                          .format(selectedDateTime);
                                });
                              } else {
                                // Show error message if the selected date and time are in the past
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title:
                                          const Text('Invalid Date and Time'),
                                      content: const Text(
                                          'Please select a future date and time.'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            }
                          });
                        }
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an end date';
                      }
                      // RegExp regex = RegExp(
                      //     r'^([0-2][0-9]|(3)[0-1])(\/)(((0)[0-9])|((1)[0-2]))(\/)\d{4}$');
                      // if (!regex.hasMatch(value)) {
                      //   return 'Enter a valid date in dd/mm/yyyy format';
                      // }
                      return null;
                    },
                  ),

                  const SizedBox(height: 10),
                  TextFormField(
                    readOnly: true,
                    keyboardType: TextInputType.datetime,
                    decoration: const InputDecoration(
                      labelText: 'End Date',
                      hintText: 'Enter end date (e.g., dd/mm/yyyy)',
                      border: OutlineInputBorder(),
                    ),
                    controller: endDate,
                    onTap: () {
                      // Show date picker
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      ).then((selectedDate) {
                        if (selectedDate != null) {
                          // Show time picker
                          showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          ).then((selectedTime) {
                            if (selectedTime != null) {
                              // Combine date and time
                              DateTime selectedDateTime = DateTime(
                                selectedDate.year,
                                selectedDate.month,
                                selectedDate.day,
                                selectedTime.hour,
                                selectedTime.minute,
                              );

                              // Validate if the selected date and time are in the future
                              if (selectedDateTime.isAfter(DateTime.now())) {
                                setState(() {
                                  _selectedEndDateTime = selectedDateTime;
                                  endDate.text =
                                      DateFormat('dd/MM/yyyy hh:mm a')
                                          .format(selectedDateTime);
                                });
                              } else {
                                // Show error message if the selected date and time are in the past
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title:
                                          const Text('Invalid Date and Time'),
                                      content: const Text(
                                          'Please select a future date and time.'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            }
                          });
                        }
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an end date';
                      }
                      // RegExp regex = RegExp(
                      //     r'^([0-2][0-9]|(3)[0-1])(\/)(((0)[0-9])|((1)[0-2]))(\/)\d{4}$');
                      // if (!regex.hasMatch(value)) {
                      //   return 'Enter a valid date in dd/mm/yyyy format';
                      // }
                      return null;
                    },
                  ),

                  const SizedBox(height: 10),
                  TextFormField(
                    // keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Payment',
                      hintText: 'Enter the payment amount or details',
                      border: OutlineInputBorder(),
                    ),
                    controller: payment,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter payment details';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Special Instructions or Notes',
                      hintText: 'Enter any special instructions or notes',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    controller: notes,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter payment details';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  TextFormField(
                    readOnly: true,
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(
                      labelText: 'Interview Date and Time',
                      hintText: 'Interview (dd/mm/yyyy hh:mm AM/PM)',
                      border: OutlineInputBorder(),
                    ),
                    controller: TextEditingController(
                        text: _selectedDateTime != null
                            ? DateFormat('dd/MM/yyyy hh:mm a')
                                .format(_selectedDateTime!)
                            : ''),
                    onTap: () {
                      // Show date picker
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      ).then((selectedDate) {
                        if (selectedDate != null) {
                          // Show time picker
                          showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          ).then((selectedTime) {
                            if (selectedTime != null) {
                              // Combine date and time
                              DateTime selectedDateTime = DateTime(
                                selectedDate.year,
                                selectedDate.month,
                                selectedDate.day,
                                selectedTime.hour,
                                selectedTime.minute,
                              );

                              // Validate if the selected date and time are in the future
                              if (selectedDateTime.isAfter(DateTime.now())) {
                                setState(() {
                                  _selectedDateTime = selectedDateTime;
                                });
                              } else {
                                // Show error message if the selected date and time are in the past
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title:
                                          const Text('Invalid Date and Time'),
                                      content: const Text(
                                          'Please select a future date and time.'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            }
                          });
                        }
                      });
                    },
                    validator: (value) {
                      if (_selectedDateTime != null &&
                          _selectedDateTime!.isBefore(DateTime.now())) {
                        return 'Please select a future date and time';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Interview Location',
                      hintText: 'Streer#-Landmark-City',
                      border: OutlineInputBorder(),
                    ),
                   //maxLines: 3,
                    controller: interViewLocation,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter payment details';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    // initialValue: appUser!.mobileNumber.toString(),
                    decoration: const InputDecoration(
                      labelText: 'Contact Number',
                      hintText: '+923XXXXXXXXX',
                      border: OutlineInputBorder(),
                    ),
                    // maxLines: 3,
                    controller: contactNumber,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter payment details';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Consumer<RequestController>(builder: (context, value, _) {
                    return value.isLoading == true
                        ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(child: CircularProgressIndicator()),
                            ],
                          )
                        : ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                bool confirmRequest = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Confirm Details'),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: <Widget>[
                                            _buildContainer(
                                                "Start Date: ${startDate.text}"),
                                            _buildContainer(
                                                "End Date: ${endDate.text}"),
                                            _buildContainer(
                                                "Purpose: ${purpose.text}"),
                                            _buildContainer(
                                                "Job Type: $jobType"),
                                            _buildContainer(
                                                "Company Name: ${companyName.text}"),
                                            _buildContainer(
                                                "Payment Details: ${payment.text}"),
                                            _buildContainer(
                                                "Notes: ${notes.text}"),
                                            _buildContainer(
                                                "Interview Date & Time: ${interViewDateTime}"),
                                            _buildContainer(
                                                "Interview Location: ${interViewLocation.text}"),
                                            _buildContainer(
                                                "Mobile Number: ${contactNumber.text}"),
                                          ],
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(false); // Not confirmed
                                          },
                                          child: const Text('No'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(true); // Confirmed
                                          },
                                          child: const Text('Yes'),
                                        ),
                                      ],
                                    );
                                  },
                                );

                                if (confirmRequest == true) {
                                  try {
                                    final operatorFcm = context
                                        .read<MachineryRegistrationController>()
                                        .getUser(widget.operator.uid);
                                    final appUser =
                                        context.read<AuthController>().appUser;
                                    HiringRequestModel request =
                                        HiringRequestModel(
                                            requestId: const Uuid().v1(),
                                            operatorId:
                                                widget.operator.operatorId,
                                            operatorUid: widget.operator.uid,
                                            hirerUserId: appUser!.uid,
                                            startDate: startDate.text,
                                            endDate: endDate.text,
                                            purpose: purpose.text,
                                            jobType: jobType!,
                                            companyName: companyName.text,
                                            paymentDetails: payment.text,
                                            notes: notes.text,
                                            requestDate: DateTime.now(),
                                            interViewDateTime:
                                                interViewDateTime,
                                            interViewLocation:
                                                interViewLocation.text,
                                            contactNumber: contactNumber.text);

                                    await value.sendHiringRequest(
                                        request: request);
                                    final notificationMethod =
                                        NotificationMethod();

                                    notificationMethod.sendNotification(
                                      fcm: operatorFcm.fcm.toString(),
                                      title: appUser.name,
                                      body: 'Hiring Request',
                                      type: "hiring",
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Your Request has been sent')),
                                    );
                                    startDate.clear();
                                    endDate.clear();
                                    purpose.clear();
                                    payment.clear();
                                    notes.clear();
                                    Navigator.pop(context);
                                  } catch (e) {
                                    log("error is: $e");
                                  }
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              side: BorderSide(
                                width: 0.5,
                                color: isDark
                                    ? Colors.white
                                    : AppColors.accentColor,
                              ),
                              backgroundColor: isDark
                                  ? AppColors.primaryColor
                                  : AppColors.accentColor,
                            ),
                            child: Text(
                              'Submit Request',
                              style: TextStyle(
                                  color: isDark ? null : AppColors.blackColor),
                            ),
                          );
                    //  ElevatedButton(
                    //     onPressed: () async {
                    //       if (_formKey.currentState!.validate()) {
                    //         try {
                    //           final operatorFcm = context
                    //               .read<MachineryRegistrationController>()
                    //               .getUser(widget.operator.uid);
                    //           final appUser =
                    //               context.read<AuthController>().appUser;
                    //           HiringRequestModel request =
                    //               HiringRequestModel(
                    //             requestId: const Uuid().v1(),
                    //             // this can be empty since Firestore will generate an ID for us
                    //             operatorId: widget.operator.operatorId,
                    //             operatorUid: widget.operator.uid,
                    //             hirerUserId: appUser!
                    //                 .uid, // you'd retrieve this from your authentication system
                    //             startDate: startDate.text,
                    //             endDate: endDate.text,
                    //             purpose: purpose.text,
                    //             jobType: jobType!,
                    //             companyName: companyName.text,
                    //             paymentDetails: payment.text,
                    //             notes: notes.text,
                    //             requestDate: DateTime.now(),
                    //             interViewDateTime: interViewDateTime.text,
                    //             interViewLocation: interViewLocation.text,
                    //           );

                    //           await value.sendHiringRequest(
                    //               request: request);
                    //           final notificationMethod =
                    //               NotificationMethod();

                    //           notificationMethod.sendNotification(
                    //               fcm: operatorFcm.fcm.toString(),
                    //               title: appUser.name,
                    //               body: 'Hiring Request',
                    //               type: "hiring");
                    //           ScaffoldMessenger.of(context).showSnackBar(
                    //               const SnackBar(
                    //                   content: Text(
                    //                       'Your Request has been sent')));
                    //           startDate.clear();
                    //           endDate.clear();
                    //           purpose.clear();
                    //           payment.clear();
                    //           notes.clear();
                    //           // ignore: use_build_context_synchronously
                    //           Navigator.pop(context);
                    //         } catch (e) {
                    //           log("error is: $e");
                    //         }
                    //       }
                    //     },
                    //     style: ElevatedButton.styleFrom(
                    //       side: BorderSide(
                    //           width: 0.5,
                    //           color: isDark
                    //               ? Colors.white
                    //               : AppColors.accentColor),
                    //       backgroundColor: isDark
                    //           ? AppColors.primaryColor
                    //           : AppColors.accentColor,
                    //     ),
                    //     child: Text(
                    //       'Submit Request',
                    //       style: TextStyle(
                    //           color: isDark ? null : AppColors.blackColor),
                    //     ),
                    //   );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildContainer(String text) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 8.0),
    padding: const EdgeInsets.all(10.0),
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(5.0),
      border: Border.all(
        color: Colors.grey.shade400,
      ),
    ),
    child: SelectableText(
      text,
      style: const TextStyle(fontSize: 16.0, color: Colors.black),
    ),
  );
}
