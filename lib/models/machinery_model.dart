import 'package:cloud_firestore/cloud_firestore.dart';

class MachineryModel {
  MachineryModel({
    required this.machineryId,
    required this.uid,
    required this.title,
    required this.model,
    required this.address,
    required this.description,
    required this.size,
    required this.charges,
    required this.emergencyNumber,
    this.images,
    required this.dateAdded,
    required this.rating,
    required this.location,
    
  });

 
  String machineryId;
  String uid;
  String title;
  String model;
  String address;
  String description;
  int size;
  int charges;
  String emergencyNumber;
  List<String>? images;
  Timestamp dateAdded;
  dynamic rating;
  Location location;
  var distance;

  factory MachineryModel.fromJson(Map<String, dynamic> json) => MachineryModel(
        machineryId: json['machineryId'],
        uid: json['uid'],
        title: json['title'],
        model: json['model'],
        address: json['address'],
        description: json['description'],
        size: json['size'],
        charges: json['charges'],
        emergencyNumber: json['emergencyNumber'],
        images:
            (json['images'] as List<dynamic>).map((e) => e.toString()).toList(),
        dateAdded: json['dateAdded'],
        rating: json['rating'],
        location: Location.fromJson(json['location']),
      );

  Map<String, dynamic> toJson() => {
        "machineryId": machineryId,
        "uid": uid,
        'title': title,
        "model": model,
        'location': location,
        'address': address,
        'description': description,
        'size': size,
        'charges': charges,
        'emergencyNumber': emergencyNumber,
        'images': images,
        "dateAdded": dateAdded,
        // ignore: equal_keys_in_map
        'location': location.toJson(),
        "rating": rating,
      };
}

class Location {
  String title;
  dynamic latitude;
  dynamic longitude;

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
