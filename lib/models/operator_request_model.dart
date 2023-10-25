class HiringRequestModel {
  String requestId;
  String operatorId;
  String operatorUid;
  String hirerUserId; // ID of the user making the request
  String startDate;
  String endDate;
  String purpose;
  String paymentDetails;
  String notes;
  DateTime requestDate;
  String status; // e.g. "Pending", "Accepted", "Rejected", "Completed"
  String jobType;
  String companyName;
  DateTime? interViewDateTime;
  String? interViewLocation;
  String? contactNumber;
  bool? isOperatorRatingComplete;
  bool? isHirerRatingComplete;


  HiringRequestModel({
    required this.requestId,
    required this.operatorId,
    required this.operatorUid,
    required this.hirerUserId,
    required this.startDate,
    required this.endDate,
    required this.purpose,
    required this.paymentDetails,
    this.notes = "",
    required this.requestDate,
    this.status = "Pending",
    required this.jobType,
    required this.companyName,
    this.interViewDateTime,
    this.interViewLocation,
    this.contactNumber,
    this.isOperatorRatingComplete,
    this.isHirerRatingComplete,
  });

  factory HiringRequestModel.fromJson(Map<String, dynamic> json) {
    return HiringRequestModel(
      requestId: json['requestId'],
      operatorId: json['operatorId'],
      operatorUid: json['operatorUid'],
      hirerUserId: json['hirerUserId'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      purpose: json['purpose'],
      paymentDetails: json['paymentDetails'],
      notes: json['notes'],
      requestDate: json['requestDate'].toDate(),
      status: json['status'],
      jobType: json['jobType'],
      companyName: json['companyName'],
      interViewDateTime: json['interViewDateTime'].toDate(),
      interViewLocation: json['interViewLocation'],
      contactNumber: json['contactNumber'],
      isOperatorRatingComplete: json['isOperatorRatingComplete'],
      isHirerRatingComplete: json['isHirerRatingComplete']
    );
  }

  Map<String, dynamic> toJson() => {
        'requestId': requestId,
        'operatorId': operatorId,
        'operatorUid': operatorUid,
        'hirerUserId': hirerUserId,
        'startDate': startDate,
        'endDate': endDate,
        'purpose': purpose,
        'paymentDetails': paymentDetails,
        'notes': notes,
        'requestDate': requestDate,
        'status': status,
        'jobType':jobType,
        'companyName' : companyName,
        'interViewDateTime': interViewDateTime,
        'interViewLocation': interViewLocation,
        'contactNumber': contactNumber,
        'isOperatorRatingComplete': isOperatorRatingComplete,
        'isHirerRatingComplete': isHirerRatingComplete

      };
}
