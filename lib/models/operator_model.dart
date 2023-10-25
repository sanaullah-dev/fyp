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

  OperatorModel(
      {required this.operatorId,
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
      required this.location});

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
