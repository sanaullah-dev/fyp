// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;
// import 'package:vehicle_management_and_booking_system/models/machinery_model.dart';

// class ComplaintScreen extends StatefulWidget {
//   ComplaintScreen({super.key, required this.machine});
//   MachineryModel machine;
//   @override
//   _ComplaintScreenState createState() => _ComplaintScreenState();
// }

// class _ComplaintScreenState extends State<ComplaintScreen> {
//   final _descriptionController = TextEditingController();
//   final _callNumberController = TextEditingController();

//   @override
//   void initState() {
//     // TODO: implement initState
//     //  machine = context
//     //     .read<MachineryRegistrationController>()
//     //     .allMachineries!
//     //     .firstWhere(
//     //         (element) => element.machineryId == widget.request.machineId);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Complaint'),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               Card(
//                 child: ListTile(
//                   leading: CircleAvatar(
//                       backgroundImage: CachedNetworkImageProvider(
//                     // imageUrl:
//                     widget.machine.images!.last.toString(),
//                     errorListener: () {
//                       log("error");
//                     },
//                   )),
//                   title: Text(widget.machine.title),
//                   subtitle: Text(widget.machine.charges.toString()),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _descriptionController,
//                 decoration: const InputDecoration(
//                   labelText: 'Description',
//                 ),
//                 //maxLines: 5,
//               ),
//               const SizedBox(height: 16.0),
//               TextFormField(
//                 controller: _callNumberController,
//                 decoration: const InputDecoration(
//                   labelText: 'Complaint call number',
//                 ),
//               ),

//               // Submit button
//               const SizedBox(height: 16.0),
//               const ElevatedButton(
//                 onPressed: null,
//                 child: Text('Submit complaint'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
