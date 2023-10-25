import 'package:cloud_firestore/cloud_firestore.dart';

class RequestModel {
  String requestId;
  String? status;
  String machineId;
  String machineryOwnerUid;
  String senderUid;
  String price;
  String description;
  String workOfHours;
  Timestamp dateAdded;

  RequestModel({
    required this.requestId,
    this.status,
    required this.machineId,
    required this.machineryOwnerUid,
    required this.senderUid,
    required this.price,
    required this.description,
    required this.workOfHours,
    required this.dateAdded,
  });

  // Factory constructor to create an instance of RequestModel from a Map
  factory RequestModel.fromMap(Map<String, dynamic> map) {
    return RequestModel(
      requestId: map['requestId'],
      status: map['status'],
      machineId: map['machineId'],
      machineryOwnerUid: map['machineryOwnerUid'],
      senderUid: map['senderUid'],
      price: map['price'],
      description: map['description'],
      workOfHours: map['workOfHours'],
      dateAdded: map['dateAdded'],
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
      'workOfHours':workOfHours
    };
  }
}
