// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_management_and_booking_system/app/router.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/machinery_register_controller.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/request_controller.dart';
import 'package:vehicle_management_and_booking_system/models/machinery_model.dart';
import 'package:vehicle_management_and_booking_system/models/request_machiery_model.dart';
import 'package:vehicle_management_and_booking_system/utils/media_query.dart';

Future<void> showCancelDialog(BuildContext context, bool isClient,
    RequestModelForMachieries request) async {
  MachineryModel machine = context
      .read<MachineryRegistrationController>()
      .getMachineById(request.machineId);
  dynamic provider = context.read<RequestController>();
  String? selectedReason;
  TextEditingController otherReasonController = TextEditingController();

  List<String> reasons = isClient
      ? [
          'Machine not as described',
          'Delay in delivery',
          'Concerns about safety \nor quality',
          'Budget constraints',
          'Other'
        ]
      : [
          'Machine unavailable due to \nmaintenance',
          'Unable to deliver to the \nclient\'s location',
          'Concerns about misuse or \npotential damage',
          'Pricing or payment issues',
          'Previous negative experience \nwith the client',
          'Other'
        ];

  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: const Text('Cancel Rental Request'),
        content: Container(
          //height: 100,
          width: screenWidth(context),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              DropdownButton<String>(
                hint: const Text("Select a reason"),
                value: selectedReason,
                underline: Container(),
                items: reasons.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        value,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (newValue) async {
                  selectedReason = newValue;
                  log(selectedReason.toString());
                  Navigator.of(context).pop();

                  if (newValue != 'Other') {
                    try {
                      context
                          .read<MachineryRegistrationController>()
                          .setIsCheckMachies(false);
                      await provider.updateRequestStatus(
                          senderUid: request.senderUid.toString(),
                          receiverUid: request.machineryOwnerUid.toString(),
                          requestId: request.requestId.toString(),
                          status: 'Canceled',
                          comment: newValue.toString());
                      await context
                          .read<MachineryRegistrationController>()
                          .updateMachine(machine, true);
                      await provider.positionStream?.cancel();
                      provider.positionStream = null;
                      await provider.sentRequestsStream?.cancel();
                      provider.sentRequestsStream = null;
                      await provider.receivedRequestsStream?.cancel();
                      provider.receivedRequestsStream = null;
                      await provider.positionStream?.cancel();
                      // ignore: use_build_context_synchronously
                      Navigator.pushReplacementNamed(
                          context, AppRouter.receiverRequest);
                    } catch (e) {
                      log(e.toString());
                    }
                  }

                  if (newValue == 'Other') {
                    // ignore: use_build_context_synchronously
                    showDialog<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Specify the reason'),
                          content: TextField(
                            controller: otherReasonController,
                            decoration: const InputDecoration(
                              hintText: "Explain the reason",
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Submit'),
                              onPressed: () async {
                                String otherReason = otherReasonController.text;
                                log(otherReason);
                                if (otherReason.isNotEmpty) {
                                  try {
                                    context
                                        .read<MachineryRegistrationController>()
                                        .setIsCheckMachies(false);
                                    await provider.updateRequestStatus(
                                        senderUid: request.senderUid.toString(),
                                        receiverUid: request.machineryOwnerUid
                                            .toString(),
                                        requestId: request.requestId.toString(),
                                        status: 'Canceled',
                                        comment: otherReason.toString());
                                    await context
                                        .read<MachineryRegistrationController>()
                                        .updateMachine(machine, true);
                                    var machines = context
                                        .read<MachineryRegistrationController>()
                                        .allMachineries!
                                        .firstWhere((machine) =>
                                            request.machineId ==
                                            machine.machineryId);
                                    isClient
                                        ? await context
                                            .read<
                                                MachineryRegistrationController>()
                                            .updateMachine(machines, true)
                                        : null;
                                    await provider.positionStream?.cancel();
                                    provider.positionStream = null;
                                    await provider.sentRequestsStream?.cancel();
                                    provider.sentRequestsStream = null;
                                    await provider.receivedRequestsStream
                                        ?.cancel();
                                    provider.receivedRequestsStream = null;
                                    await provider.positionStream?.cancel();
                                    // ignore: use_build_context_synchronously
                                    Navigator.pushReplacementNamed(
                                        context, AppRouter.receiverRequest);
                                  } catch (e) {
                                    log(e.toString());
                                  }
                                } else {
                                  // Alert user to fill the reason
                                }
                              },
                            ),
                            TextButton(
                              child: const Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Close'),
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
          ),
        ],
      );
    },
  );
}

String insertNewlineBeforeOverflow(String str, int maxLength) {
  if (str.length <= maxLength) return str;

  String result = '';
  List<String> words = str.split(' ');

  int currentLength = 0;
  for (String word in words) {
    if (currentLength + word.length > maxLength) {
      result += '\n' + word + ' ';
      currentLength = word.length + 1; // +1 for the space
    } else {
      result += word + ' ';
      currentLength += word.length + 1; // +1 for the space
    }
  }
  return result.trim(); // Remove any trailing space
}
