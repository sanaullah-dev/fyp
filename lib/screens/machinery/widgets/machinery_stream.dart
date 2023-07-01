
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vehicle_management_and_booking_system/models/machinery_model.dart';
import 'package:vehicle_management_and_booking_system/screens/machinery/widgets/dashBoard_single_machinery_widget.dart';
import 'package:flutter/foundation.dart' as TargetPlatform;

class MachineryStream extends StatelessWidget {
  const MachineryStream({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("machineries")
          .orderBy("rating", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        final data = snapshot.data?.docs
            .map((e) => MachineryModel.fromJson(e.data()))
            .toList();
       

        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return const SizedBox();
          case ConnectionState.waiting:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case ConnectionState.active:
            return GridView.builder(
                itemCount: data!.length,
              //  shrinkWrap: true,
                gridDelegate:  const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: TargetPlatform.kIsWeb
                      ? 0.7
                      : 0.55, //(itemWidth / itemHeight),

                  // shrinkWrap: true,
                  crossAxisCount: 2, //size.width > 770 ? 4 : 2,
                  crossAxisSpacing: 3,
                  mainAxisSpacing: 5,
                ),
                itemBuilder: (ctx, index) {
                //  log(index.toString());
                 // data.add(data[index] );
                  //data.add(MachineryModel(machineryId: "machineryId", uid: "uid", name: "name", title: "title", model: "model", address: "address", description: "description", size: 626, charges: 21, emergencyNumber: "emergencyNumber", dateAdded: Timestamp.now(), rating:2.1, location: Location(title: "title", latitude: 21.22222, longitude: 31.2222)));
                 // log(data[index].toString());
                  return SingleMachineryWidget(
                    machineryDetails: data[index],
                  );
                });
          
          case ConnectionState.done:
            return const SizedBox();
        }
      },
    );

  }
}

