import 'package:cloud_firestore/cloud_firestore.dart';

class OperatorModel {
  String operatorId;
  String uid;
  String name;
  String years;
  String mobileNumber;
  String emergencyNumber;
  String? profilePicture;
  String gender;
  String email;
  String education;
  String skills;
  String certificates;
  String summaryOrDescription;
  
  Timestamp dateAdded;
  double rating;
  Location location;

  OperatorModel({
    required this.operatorId,
    required this.uid,
   
    this.profilePicture,
    required this.name,
    required this.years,
    required this.mobileNumber,
    required this.emergencyNumber,
    required this.gender,
    required this.email,
    required this.education,
    required this.skills,
    required this.certificates,
    required this.summaryOrDescription,
    required this.dateAdded,
    required this.rating,
    required this.location

  });

  factory OperatorModel.fromJson(Map<String, dynamic> json) {
    return OperatorModel(
      operatorId: json['operatorId'],
      uid: json['uid'],
      profilePicture: json['profilePicture'],
      name: json['name'],
      years: json['years'],
      mobileNumber: json['mobileNumber'],
      emergencyNumber: json['emergencyNumber'],
      gender: json['gender'],
      email: json['email'],
      education: json['education'],
      skills: json['skills'] ?? '',
      certificates: json['certificates'],
      summaryOrDescription: json['summaryOrDescription'],
        dateAdded: json['dateAdded'],
        rating: json['rating'],
        location: Location.fromJson(json['location']),
      
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "operatorId": operatorId,
      "uid": uid,
      'name': name,
      "profilePicture": profilePicture,
      'location': location,
      'years': years,
      'mobileNumber': mobileNumber,
      'emergencyNumber': emergencyNumber,
      'gender': gender,
      'email': email,
      'education': education,
      'skills': skills,
      'certificates': certificates,
      'summaryOrDescription': summaryOrDescription,
      "dateAdded": dateAdded,
        // ignore: equal_keys_in_map
      'location': location.toJson(),
      "rating": rating,
    };
  }

  
}
class Location {
  String title;
  double latitude;
  double longitude;

  Location({
    required this.title,
    required this.latitude,
    required this.longitude,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
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