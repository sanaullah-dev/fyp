import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RequestModelForMachieries {
  String requestId;
  String? status;
  String machineId;
  String machineryOwnerUid;
  String senderUid;
  String price;
  String description;
  String workOfHours;
  Timestamp dateAdded;
  LatLng sourcelocation;
  LatLng? destinationLocation;
  String? comment;
  String? mobileNumber;

  RequestModelForMachieries(
      {required this.requestId,
      this.status,
      required this.machineId,
      required this.machineryOwnerUid,
      required this.senderUid,
      required this.price,
      required this.description,
      required this.workOfHours,
      required this.dateAdded,
      required this.sourcelocation,
      this.destinationLocation,
      this.mobileNumber,
      this.comment});

  // Factory constructor to create an instance of RequestModel from a Map
  factory RequestModelForMachieries.fromMap(Map<String, dynamic> map) {
    return RequestModelForMachieries(
      requestId: map['requestId'],
      status: map['status'],
      machineId: map['machineId'],
      machineryOwnerUid: map['machineryOwnerUid'],
      senderUid: map['senderUid'],
      price: map['price'],
      description: map['description'],
      workOfHours: map['workOfHours'],
      dateAdded: map['dateAdded'],
      comment: map['comment'],
      mobileNumber: map['mobileNumber'],
      destinationLocation:  map['destinationLocation'] != null
        ? LatLng(
            map['destinationLocation']['latitude'],
            map['destinationLocation']['longitude'],
          )
        : null,
      sourcelocation: LatLng(
        map['sourcelocation']['latitude'],
        map['sourcelocation']['longitude'],
      ), // The 'location' field will be non-null here, so you can use '!'
    );
  }

  // Method to convert an instance of RequestModel to a Map
  Map<String, dynamic> toMap() {
    return {
      'requestId': requestId,
      'status': status,
      'machineId': machineId,
      'machineryOwnerUid': machineryOwnerUid,
      'senderUid': senderUid,
      'price': price,
      'description': description,
      'dateAdded': dateAdded,
      'workOfHours': workOfHours,
      'mobileNumber': mobileNumber,
      'comment': comment ?? '',
      'destinationLocation':  destinationLocation != null
        ? {
            'latitude': destinationLocation!.latitude,
            'longitude': destinationLocation!.longitude,
          }
        : null,
      'sourcelocation': {
        'latitude': sourcelocation.latitude,
        'longitude': sourcelocation.longitude,
      },
    };
  }
}
