// To parse this JSON data, do

class UserModel {
  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.mobileNumber,
    required this.languages,
    this.profileUrl,
    

  });

  String uid;
  String name;
  String email;
  String mobileNumber;
  String languages;
  String? profileUrl;
  

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        uid: json["uid"],
        name: json["name"],
        email: json["email"],
        mobileNumber: json["mobileNumber"],
        languages: json["languages"],
        profileUrl: json["profileUrl"],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "name": name,
        "email": email,
        "mobileNumber": mobileNumber,
        "languages": languages,
        "profileUrl": profileUrl,
      };
}
