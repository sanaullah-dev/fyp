import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/operator_register_controller.dart';
import 'package:vehicle_management_and_booking_system/models/operator_model.dart';
import 'package:vehicle_management_and_booking_system/screens/operator/operator_details.dart';

class TotalOperatorsAdminScreen extends StatefulWidget {
  const TotalOperatorsAdminScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<TotalOperatorsAdminScreen> createState() =>
      _TotalOperatorsAdminScreenState();
}

class _TotalOperatorsAdminScreenState extends State<TotalOperatorsAdminScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Operators"),
      ),
      body: StreamBuilder(
          stream:
              FirebaseFirestore.instance.collection('Operators').snapshots(),
          builder: (context, snapshot) {
            // if (snapshot.hasError) {
            //   return Text("Some went wrong");
            // }
            // if (snapshot.connectionState == ConnectionState.waiting) {
            //   return Center(child: CircularProgressIndicator());
            // }
            // // dev.log("sana");
            // final documents = snapshot.data;

            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text("Not Regestered Any Operators"),
              );
            }

            final List<DocumentSnapshot> documents = snapshot.data!.docs;

            return ListView.separated(
                separatorBuilder: (context, index) {
                  return const Divider();
                },
                itemCount: documents.length,
                itemBuilder: ((context, index) {
                  final OperatorModel operator = OperatorModel.fromJson(
                      documents[index].data() as Map<String, dynamic>);
                  return GestureDetector(
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Row(
                            children: [
                              Text("Detete\t"),
                              Icon(
                                Icons.warning_outlined,
                                color: Colors.red,
                              )
                            ],
                          ),
                          content: const Text(
                              "Are you sure to delete this Operator?"),
                          actions: <Widget>[
                            OutlinedButton(
                              onPressed: () async {
                                try {
                                  await context
                                      .read<OperatorRegistrationController>()
                                      .deleteOperator(
                                          operatorId: operator.operatorId,
                                          images: operator.operatorImage!);
                                  const snackBar = SnackBar(
                                    content: Text("Operator Removed"),
                                    duration: Duration(seconds: 4),
                                  );
                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                } catch (e) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(e.toString()),
                                    duration: Duration(seconds: 4),
                                  ));
                                }
                                // ignore: use_build_context_synchronously
                                Navigator.of(ctx).pop();
                              },
                              child: Text("Yes"),
                            ),
                            OutlinedButton(
                              onPressed: () {
                                Navigator.of(ctx).pop();
                              },
                              child: Text("No"),
                            ),
                          ],
                        ),
                      );
                    },
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

                          //     // Image(
                          //     //     image:  CachedNetworkImageProvider( operator.operatorImage!
                          //     //         ),
                          //     //     errorBuilder: (context, error, stackTrace) =>
                          //     //         Icon(Icons.error),
                          //     //   ) as ImageProvider

                          //     // CachedNetworkImage(
                          //     //     imageUrl: operator.operatorImage!,
                          //     //     placeholder: (context, url) =>
                          //     //         const CircularProgressIndicator(),
                          //     //     errorWidget: (context, url, error) =>
                          //     //         const Icon(Icons.error),
                          //     //   )

                          // backgroundImage: operator.operatorImage != null
                          //     ? CachedNetworkImageProvider(
                          //         operator.operatorImage.toString(),
                          //       )
                          //     : null,
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
