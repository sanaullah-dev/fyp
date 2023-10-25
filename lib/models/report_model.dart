import 'package:cloud_firestore/cloud_firestore.dart';

class ReportModel {
  final String reportId;
  final String reportOn;
  final String reportFrom;
  final String machineId;
  final String description;
  final String? requestId;
  List<String>? images;
  final DateTime dateTime;
  final String status;
  final String? comment;

  ReportModel({
    required this.reportId,
    required this.reportOn,
    required this.reportFrom,
    this.requestId,
    required this.machineId,
    required this.description,
    this.images,
    required this.dateTime,
    required this.status,
    this.comment,
  });

  // Factory constructor to create an instance of the model from a JSON map
  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      reportId: json['reportId'],
      reportOn: json['reportOn'],
      requestId: json['requestId'],
      reportFrom: json['reportFrom'],
      machineId: json['machineId'] ?? '',
      description: json['description'] ?? '',
      images: (json['images'] as List?)?.map((item) => item as String).toList(),
      dateTime: (json['dateTime']as Timestamp).toDate(),
      status: json["status"],
           comment: json["comment"] == null ? "" : json["comment"].toString() ,
    );
  }

  // Method to convert the model instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'reportId': reportId,
      'reportOn': reportOn,
      'reportFrom': reportFrom,
      'requestId': requestId,
      'machineId': machineId,
      'description': description,
      'images': images,
      'dateTime': dateTime,
      'status': status,
      'comment': comment,
    };
  }
}
