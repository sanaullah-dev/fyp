import 'package:cloud_firestore/cloud_firestore.dart';

class OperatorModel {
  String operatorId;
  String uid;
  String name;
  String years;
  String mobileNumber;
  String emergencyNumber;
  String? operatorImage;
  String gender;
  String fullAddress;
  String email;
  String education;
  String skills;
  //String certificates;
  String summaryOrDescription;
  Timestamp dateAdded;
  dynamic rating;
  Locations location;
  bool isAvailable;
  List<RatingForOperator>? allRatings; // Add this
  bool? isHired;
  List<HiringRecordForOperator>? hiringRecordForOperator; // Add this
  // String HirerUid;

  OperatorModel({
    required this.operatorId,
    required this.uid,
    required this.fullAddress,
    this.operatorImage,
    required this.name,
    required this.years,
    required this.mobileNumber,
    required this.emergencyNumber,
    required this.gender,
    required this.email,
    required this.education,
    required this.skills,
    //required this.certificates,
    required this.summaryOrDescription,
    required this.dateAdded,
    required this.rating,
    required this.location,
    required this.isAvailable,
    this.allRatings,
    this.hiringRecordForOperator,
    this.isHired,
  });

  factory OperatorModel.fromJson(Map<String, dynamic> json) {
    return OperatorModel(
      fullAddress: json['fullAddress'],
      operatorId: json['operatorId'],
      uid: json['uid'],
      operatorImage: json['operatorImage'],
      name: json['name'],
      years: json['years'],
      mobileNumber: json['mobileNumber'],
      emergencyNumber: json['emergencyNumber'],
      gender: json['gender'],
      email: json['email'],
      education: json['education'],
      skills: json['skills'] ?? '',
      //certificates: json['certificates'],
      summaryOrDescription: json['summaryOrDescription'],
      dateAdded: json['dateAdded'],
      rating: json['rating'],
      location: Locations.fromJson(json['location']),
      isAvailable: json['isAvailable'],
      allRatings: (json['allRatings'] as List<dynamic>?)
          ?.map((e) => RatingForOperator.fromJson(e as Map<String, dynamic>))
          .toList(),
      hiringRecordForOperator:
          (json['hiringRecordForOperator'] as List<dynamic>?)
              ?.map((e) =>
                  HiringRecordForOperator.fromJson(e as Map<String, dynamic>))
              .toList(),

isHired: json['isHired'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "operatorId": operatorId,
      "fullAddress": fullAddress,
      "uid": uid,
      'name': name,
      "operatorImage": operatorImage,
      'location': location,
      'years': years,
      'mobileNumber': mobileNumber,
      'emergencyNumber': emergencyNumber,
      'gender': gender,
      'email': email,
      'education': education,
      'skills': skills,
      //'certificates': certificates,
      'summaryOrDescription': summaryOrDescription,
      "dateAdded": dateAdded,
      // ignore: equal_keys_in_map
      'location': location.toJson(),
      "rating": rating,
      "isAvailable": isAvailable,
      'allRatings': allRatings?.map((e) => e.toJson()).toList(),
      'hiringRecordForOperator':
          hiringRecordForOperator?.map((e) => e.toJson()).toList(),
          'isHired': isHired,
    };
  }
}

class Locations {
  String title;
  double latitude;
  double longitude;

  Locations({
    required this.title,
    required this.latitude,
    required this.longitude,
  });

  factory Locations.fromJson(Map<String, dynamic> json) {
    return Locations(
      title: json['title'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'latitude': latitude,
        'longitude': longitude,
      };
}

class RatingForOperator {
  final String userId; // User's unique identifier
  final double value; // Rating value given by the user (e.g., 4.5 out of 5)
  final Timestamp date;
  final String comment; // Date when the user rated

  RatingForOperator({
    required this.userId,
    required this.value,
    required this.date,
    required this.comment,
  });

  factory RatingForOperator.fromJson(Map<String, dynamic> json) {
    return RatingForOperator(
      userId: json['userId'],
      value: (json['value'] as num).toDouble(),
      comment: json['comment'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() =>
      {'userId': userId, 'value': value, 'date': date, 'comment': comment};
}

class HiringRecordForOperator {
  final String hirerUid; // User's unique identifier
  final String requestId;
  final Timestamp startDate; // Rating value given by the user (e.g., 4.5 out of 5)
   Timestamp? endDate;

  HiringRecordForOperator({
    required this.hirerUid,
    required this.requestId,
    required this.startDate,
     this.endDate,
  });

  factory HiringRecordForOperator.fromJson(Map<String, dynamic> json) {
    return HiringRecordForOperator(
      hirerUid: json['hirerUid'],
      requestId: json['requestId'],
      startDate: json['startDate'],
      endDate: json['endDate'],
    );
  }

  Map<String, dynamic> toJson() => {
        'hirerUid': hirerUid,
        'requestId': requestId,
        'startDate': startDate,
        'endDate': endDate,
      };
}
