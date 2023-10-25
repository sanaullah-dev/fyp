// To parse this JSON data, do

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

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      uid: json["uid"],
      name: json["name"],
      email: json["email"],
      mobileNumber: json["mobileNumber"],
      languages: json["languages"],
      profileUrl: json["profileUrl"],
      blockOrNot: json['blockOrNot'],
      androidDeviceInfo: json["androidDeviceInfo"],
      ioSDeviceInfo: json['ioSDeviceInfo'],
      fcm: json['fcm']
      );
      

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "name": name,
        "email": email,
        "mobileNumber": mobileNumber,
        "languages": languages,
        "profileUrl": profileUrl,
        "blockOrNot": blockOrNot,
        "ioSDeviceInfo": ioSDeviceInfo,
        "androidDeviceInfo": androidDeviceInfo,
        "fcm": fcm
      };
}
