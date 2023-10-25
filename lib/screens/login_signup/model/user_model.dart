// To parse this JSON data, do

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.mobileNumber,
    required this.languages,
    this.profileUrl,
    this.blockOrNot,
    this.ioSDeviceInfo,
    this.androidDeviceInfo,
    this.fcm,
    this.allRatings,
    this.blockingComments,
   required this.isAvailable
  });

  String uid;
  String name;
  String email;
  String? ioSDeviceInfo;
  String? androidDeviceInfo;
  bool? blockOrNot;
  String mobileNumber;
  String languages;
  String? profileUrl;
  String? fcm;
  List<RatingForUser>? allRatings; // Add this
  List<String>? blockingComments;
  bool isAvailable;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        uid: json["uid"],
        name: json["name"],
        email: json["email"],
        isAvailable: json['isAvailable'],
        mobileNumber: json["mobileNumber"],
        languages: json["languages"],
        profileUrl: json["profileUrl"],
        blockOrNot: json['blockOrNot'],
        androidDeviceInfo: json["androidDeviceInfo"],
        ioSDeviceInfo: json['ioSDeviceInfo'],
        blockingComments: List<String>.from(
            json['blockingComments'] ?? []), // Changed this line

        fcm: json['fcm'],
        allRatings: (json['allRatings'] as List<dynamic>?)
            ?.map((e) => RatingForUser.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "name": name,
        "email": email,
        "isAvailable":isAvailable,
        "mobileNumber": mobileNumber,
        "languages": languages,
        "profileUrl": profileUrl,
        "blockOrNot": blockOrNot,
        "ioSDeviceInfo": ioSDeviceInfo,
        "androidDeviceInfo": androidDeviceInfo,
       'blockingComments': blockingComments,  // Changed th
        "fcm": fcm,
        'allRatings': allRatings?.map((e) => e.toJson()).toList(),
      };
}

class RatingForUser {
  final String userId; // User's unique identifier
  final double value; // Rating value given by the user (e.g., 4.5 out of 5)
  final Timestamp date;
  final String comment; // Date when the user rated

  RatingForUser({
    required this.userId,
    required this.value,
    required this.date,
    required this.comment,
  });

  factory RatingForUser.fromJson(Map<String, dynamic> json) {
    return RatingForUser(
      userId: json['userId'],
      value: (json['value'] as num).toDouble(),
      comment: json['comment'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'value': value,
        'date': date,
        'comment': comment,
      };
}
