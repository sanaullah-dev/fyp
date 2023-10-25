import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vehicle_management_and_booking_system/models/request_machiery_model.dart';

void showRequestDetails(
    BuildContext context, RequestModelForMachieries request) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Request Details"),
        content: SingleChildScrollView(
            child: ListBody(
          children: <Widget>[
            _buildContainer("Request ID: ${request.requestId}"),
            _buildContainer("Status: ${request.status ?? 'N/A'}"),
            _buildContainer("Machine ID: ${request.machineId}"),
            _buildContainer(
                "Machinery Owner UID: ${request.machineryOwnerUid}"),
            _buildContainer("Sender UID: ${request.senderUid}"),
            _buildContainer("Price: ${request.price}"),
            _buildContainer("Description: ${request.description}"),
            _buildContainer("Work of Hours: ${request.workOfHours}"),
            _buildContainer(
                "Date Added: ${DateFormat('dd-MM-yyyy').format(request.dateAdded.toDate())}"),
            _buildContainer(
                "Source Location: ${request.sourcelocation.latitude}, ${request.sourcelocation.longitude}"),
            if (request.destinationLocation != null)
              _buildContainer(
                  "Destination Location: ${request.destinationLocation!.latitude}, ${request.destinationLocation!.longitude}"),
            _buildContainer("Comment: ${request.comment ?? 'N/A'}"),
            _buildContainer(
                "Request Sender Mobile Number: ${request.mobileNumber ?? 'N/A'}"),
          ],
        )),
        actions: <Widget>[
          TextButton(
            child: Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
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
      style: TextStyle(fontSize: 16.0, color: Colors.black),
    ),
  );
}
