import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_management_and_booking_system/app/app.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/machinery_register_controller.dart';
import 'package:vehicle_management_and_booking_system/models/machinery_model.dart';
import 'package:vehicle_management_and_booking_system/models/operator_model.dart';
import 'package:vehicle_management_and_booking_system/screens/login_signup/model/user_model.dart';
import 'package:vehicle_management_and_booking_system/utils/app_colors.dart';
import 'package:vehicle_management_and_booking_system/utils/const.dart';

class AllReviewsScreen extends StatelessWidget {
  final String? uid; // User ID of the user whose ratings you want to fetch
  final MachineryModel? machine;
  final String? operatorId;
  final String title;

  // ignore: prefer_const_constructors_in_immutables
  AllReviewsScreen(
      {super.key,
      this.uid,
      this.machine,
      required this.title,
      this.operatorId});

  Future<UserModel?> fetchUserFromFirebase(String uid) async {
    final DocumentReference userRef =
        FirebaseFirestore.instance.collection('users').doc(uid);
    final DocumentSnapshot<Object?> doc = await userRef.get();
    if (doc.exists) {
      // Deserialize the document to UserModel
      return UserModel.fromJson(doc.data()! as Map<String, dynamic>);
    }
    return null;
  }

  Future<MachineryModel?> fetchMachineryReview(String machineryId) async {
    try {
      final DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('machineries')
          .doc(machineryId)
          .get();

      if (docSnapshot.exists) {
        Map<String, dynamic> docData =
            docSnapshot.data() as Map<String, dynamic>;
        MachineryModel machineryModel = MachineryModel.fromJson(docData);
        return machineryModel;
      } else {
        print("Document does not exist");
        return null;
      }
    } catch (e) {
      print("Error fetching machinery review: $e");
      return null;
    }
  }

  Future<OperatorModel?> fetchOperatorReviews(String operatorId) async {
    try {
      final DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('Operators')
          .doc(operatorId)
          .get();

      if (docSnapshot.exists) {
        Map<String, dynamic> docData =
            docSnapshot.data() as Map<String, dynamic>;
        OperatorModel operatorModel = OperatorModel.fromJson(docData);
        return operatorModel;
      } else {
        print("Document does not exist");
        return null;
      }
    } catch (e) {
      print("Error fetching machinery review: $e");
      return null;
    }
  }

  late final List allRatings;
  @override
  Widget build(BuildContext context) {
    bool _isDark = ConstantHelper.darkOrBright(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            title,
            style: TextStyle(color: _isDark ? null : Colors.black),
          ),
          backgroundColor: _isDark ? null : AppColors.accentColor,
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: () {
                navigatorKey.currentState!.pop();
              },
              icon: Icon(
                Icons.arrow_back_ios_new_sharp,
                color: _isDark ? null : AppColors.blackColor,
              )),
        ),
        body: FutureBuilder(
            future: operatorId != null
                ? fetchOperatorReviews(operatorId!)
                : machine != null
                    ? fetchMachineryReview(machine!.machineryId)
                    : fetchUserFromFirebase(uid!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text("An error occurred"));
              }

              List? allRatings; // Declare it here, do not use "late"

              if (snapshot.hasData) {
                if (snapshot.data is UserModel) {
                  allRatings =
                      (snapshot.data as UserModel).allRatings; // Removed "!"
                } else if (snapshot.data is MachineryModel) {
                  allRatings = (snapshot.data as MachineryModel)
                      .allRatings; // Removed "!"
                } else if (snapshot.data is OperatorModel) {
                  allRatings = (snapshot.data as OperatorModel)
                      .allRatings; // Removed "!"
                }
              }

              if (allRatings == null || allRatings.isEmpty) {
                return Center(child: Text("No reviews available."));
              }
              // Sort allRatings by date
              allRatings.sort((a, b) => b.date
                  .compareTo(a.date)); 
              return ListView.builder(
                  itemCount: allRatings.length,
                  itemBuilder: (context, index) {
                    final review = allRatings![index];
                    var ratingUser = context
                        .read<MachineryRegistrationController>()
                        .getUser(review.userId);
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: Column(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 16.0, top: 10),
                                child: Row(
                                  // mainAxisAlignment: MainAxisAlignment.star,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ratingUser.profileUrl != null
                                        ? CircleAvatar(
                                            backgroundImage:
                                                CachedNetworkImageProvider(
                                            // imageUrl:
                                            ratingUser.profileUrl.toString(),
                                         
                                          ))
                                        : CircleAvatar(
                                            child: Text(ratingUser.name[0])),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      ratingUser.name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Builder(builder: (context) {
                                    bool _ratingIsLocked =
                                        true; // Locks the RatingBar when true

                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(left: 16.0),
                                      child: RatingBar.builder(
                                        initialRating: review.value,
                                        minRating: 1,
                                        itemSize: 20,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemPadding: const EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        itemBuilder: (context, _) => const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        ignoreGestures:
                                            _ratingIsLocked, // Set this to true to lock the rating bar
                                        onRatingUpdate: (rating) {
                                          // ignore: dead_code
                                          if (!_ratingIsLocked) {
                                            // Your code for updating the rating
                                          }
                                        },
                                      ),
                                    );
                                  }),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    DateFormat('dd MMM yyyy')
                                        .format(review.date.toDate())
                                        .toString(),
                                  )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Container(
                                    margin: EdgeInsets.fromLTRB(7, 0, 0, 0),
                                    child: Text(
                                      review.comment,
                                      textAlign: TextAlign.justify,
                                    )),
                              ),
                            ]),
                      ),
                    );
                  });
            }));
  }
}


    // final List<Rating> allRatingss;
              // if (snapshot.connectionState == ConnectionState.waiting) {
              //   return Center(child: CircularProgressIndicator());
              // }
              // if (snapshot.hasError) {
              //   return Center(child: Text("An error occurred"));
              // }
              // if (snapshot.hasData) {
              //   if (snapshot.data is UserModel) {
              //     allRatings = (snapshot.data as UserModel).allRatings!;
              //     // Rest of the code
              //   } else if (snapshot.data is MachineryModel) {
              //     allRatings = (snapshot.data as MachineryModel).allRatings!;
              //     // Rest of the code
              //   }
              // }





//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("All Reviews"),
//       ),
//       body: FutureBuilder(
//         future:  fetchUserFromFirebase(uid),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text("An error occurred"));
//           }
//           if (!snapshot.hasData || snapshot.data!.allRatings == null) {
//             return Center(child: Text("No reviews available."));
//           }
//           final List<RatingForUser> allRatings = snapshot.data!.allRatings!;
          // return ListView.builder(
          //   itemCount: allRatings.length,
          //   itemBuilder: (context, index) {
          //     final review = allRatings[index];
          //     var ratingUser = context
          //         .read<MachineryRegistrationController>()
          //         .getUser(review.userId);
          //     return Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: Card(
          //         child: Column(
          //             // mainAxisAlignment: MainAxisAlignment.start,
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               Padding(
          //                 padding: const EdgeInsets.only(left: 16.0, top: 10),
          //                 child: Row(
          //                   // mainAxisAlignment: MainAxisAlignment.star,
          //                   crossAxisAlignment: CrossAxisAlignment.center,
          //                   children: [
          //                     ratingUser.profileUrl != null
          //                         ? CircleAvatar(
          //                             backgroundImage:
          //                                 CachedNetworkImageProvider(
          //                             // imageUrl:
          //                             ratingUser.profileUrl.toString(),
          //                             errorListener: () {
          //                               log("error");
          //                             },
          //                           ))
          //                         : CircleAvatar(
          //                             child: Text(ratingUser.name[0])),
          //                     SizedBox(
          //                       width: 10,
          //                     ),
          //                     Text(
          //                       ratingUser.name,
          //                       style: TextStyle(
          //                           fontWeight: FontWeight.bold, fontSize: 20),
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //               SizedBox(
          //                 height: 10,
          //               ),
          //               Row(
          //                 children: [
          //                   Builder(builder: (context) {
          //                     bool _ratingIsLocked =
          //                         true; // Locks the RatingBar when true

          //                     return Padding(
          //                       padding: const EdgeInsets.only(left: 16.0),
          //                       child: RatingBar.builder(
          //                         initialRating: review.value,
          //                         minRating: 1,
          //                         itemSize: 20,
          //                         direction: Axis.horizontal,
          //                         allowHalfRating: true,
          //                         itemCount: 5,
          //                         itemPadding: const EdgeInsets.symmetric(
          //                             horizontal: 4.0),
          //                         itemBuilder: (context, _) => const Icon(
          //                           Icons.star,
          //                           color: Colors.amber,
          //                         ),
          //                         ignoreGestures:
          //                             _ratingIsLocked, // Set this to true to lock the rating bar
          //                         onRatingUpdate: (rating) {
          //                           // ignore: dead_code
          //                           if (!_ratingIsLocked) {
          //                             // Your code for updating the rating
          //                           }
          //                         },
          //                       ),
          //                     );
          //                   }),
          //                   SizedBox(width: 20,),
          //                   Text(
          //                     DateFormat('dd MMM yyyy')
          //                         .format(review.date.toDate())
          //                         .toString(),
          //                   )
          //                 ],
          //               ),
          //               Padding(
          //                 padding: const EdgeInsets.all( 15.0),
          //                 child: Container(
          //                   margin: EdgeInsets.fromLTRB(7, 0, 0, 0),
          //                   child: Text(review.comment,textAlign: TextAlign.justify,)),
          //               ),
          //             ]),
          //       ),
          //     );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
