import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vehicle_management_and_booking_system/models/operator_model.dart';
import 'package:vehicle_management_and_booking_system/screens/operator/operator_details.dart';

class MyRegisteredOperators extends StatefulWidget {
  const MyRegisteredOperators({super.key});

  @override
  State<MyRegisteredOperators> createState() => _MyRegisteredOperatorsState();
}

class _MyRegisteredOperatorsState extends State<MyRegisteredOperators> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Registered Operator"),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: firestore
              .collection('Operators')
              .where('uid', isEqualTo: currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text("Not Regestered Any Operator"),
              );
            }

            final List<DocumentSnapshot> documents = snapshot.data!.docs;

            return ListView.separated(
                separatorBuilder: (context, index) {
                  return const Divider();
                },
                itemCount: documents!.length,
                itemBuilder: ((context, index) {
                  final OperatorModel operator = OperatorModel.fromJson(
                      documents[index].data() as Map<String, dynamic>);
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return OperatorDetailsScreen(
                          operator: operator,
                        );
                      }));
                    },
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(
                            color: Colors.grey.shade400,
                            width: 1.0,
                          ),
                        ),
                        leading: CircleAvatar(
                          radius: 30.0,
                          backgroundColor: Colors.grey.shade100,
                          // ignore: sort_child_properties_last
                          child: Container(
                              clipBehavior: Clip.antiAlias,
                              decoration:
                                  const BoxDecoration(shape: BoxShape.circle),
                              child: CachedNetworkImage(
                                imageUrl: operator.operatorImage!,
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              )),
                        ),
                        title: Text(operator.name.toUpperCase().toString()),
                        subtitle: Text(operator.skills.toString()),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.location_on_outlined),
                            Text(operator.location.title.toString()),
                          ],
                        ),
                      ),
                    ),
                  );
                }));
          }),
    );
  }
}
