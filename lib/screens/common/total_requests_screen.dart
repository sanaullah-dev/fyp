// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class RequestsScreen extends StatefulWidget {
//   final String userId;

//   RequestsScreen({required this.userId});

//   @override
//   State<RequestsScreen> createState() => _RequestsScreenState();
// }

// class _RequestsScreenState extends State<RequestsScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Booking Requests'),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('users')
//             .doc(widget.userId)
//             .collection('bookingRequests')
//             .snapshots(),
//         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.hasError) {
//             return Text('Something went wrong');
//           }

//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Text("Loading");
//           }

//           return ListView(
//             children: snapshot.data!.docs.map((DocumentSnapshot document) {
//               Map<String, dynamic> data =
//                   document.data() as Map<String, dynamic>;
//               return ListTile(
//                 title: Text(
//                     'Booking Request: ${data['requestDetails']}'), // use appropriate field key
//                 subtitle: Text('Status: ${data['status']}'),
//                 trailing: Wrap(
//                   spacing: 12, // space between two icons
//                   children: <Widget>[
//                     IconButton(
//                       icon: Icon(Icons.check),
//                       onPressed: () {
//                         // update request status to 'Accepted'
//                         document.reference.update({'status': 'Accepted'});
//                       },
//                       color: data['status'] == 'Accepted' ? Colors.green : null,
//                     ),
//                     IconButton(
//                       icon: Icon(Icons.close),
//                       onPressed: () {
//                         // update request status to 'Rejected'
//                         document.reference.update({'status': 'Rejected'});
//                       },
//                       color: data['status'] == 'Rejected' ? Colors.red : null,
//                     ),
//                   ],
//                 ),
//               );
//             }).toList(),
//           );
//         },
//       ),
//     );
//   }
// }
