
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonOperatorWidget extends StatelessWidget {
  //final int timer;

  SkeletonOperatorWidget();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
                itemCount: 20, // Assuming skeleton items
                itemBuilder: (_, __) => Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
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
                      ),
                      title: Container(
                        width: double.infinity,
                        height: 8.0,
                        color: Colors.white,
                      ),
                      subtitle: Container(
                        margin: EdgeInsets.only(top: 5.0),
                        width: double.infinity,
                        height: 8.0,
                        color: Colors.white,
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 2.0),
                            width: 100.0,
                            height: 8.0,
                            color: Colors.white,
                          ),
                          Container(
                            width: 40.0,
                            height: 8.0,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
  }
}

