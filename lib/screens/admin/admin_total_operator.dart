import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_management_and_booking_system/app/router.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/operator_register_controller.dart';
import 'package:vehicle_management_and_booking_system/models/operator_model.dart';
import 'package:vehicle_management_and_booking_system/utils/app_colors.dart';
import 'package:vehicle_management_and_booking_system/utils/const.dart';

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
  late List<OperatorModel> operators;
  late List<OperatorModel> searchOperators;

  @override
  void initState() {
    // TODO: implement initState
    operators = [
      ...context.read<OperatorRegistrationController>().allOperators
    ];
    super.initState();
  }

  bool _isSearching = false;

  void _filterOperators(String value) {
    if (value.isNotEmpty) {
      searchOperators = [
        ...operators.where((operator) {
          return operator.name.toLowerCase().contains(value.toLowerCase()) ||
              operator.location.title
                  .toLowerCase()
                  .contains(value.toLowerCase()) ||
              operator.operatorId.toString().contains(value) ||
              operator.uid.contains(value) ||
              operator.rating.toString().contains(value);
        }).toList()
      ];
    } else {
      searchOperators = [...operators];
    }
    setState(() {});
  }

  String searchValue = '';
  @override
  Widget build(BuildContext context) {
    // log(widget.isthisAdmin.toString());
    bool isDark = ConstantHelper.darkOrBright(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // backgroundColor:
        //     isDark || widget.isthisAdmin == true ? null : AppColors.accentColor,
        // You can add a leading button to control the drawer
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? null : AppColors.blackColor,
          ),
          onPressed: () async {
            Navigator.pop(context);
          },
        ),
        title: _isSearching
            ? TextField(
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(5),
                      hintText: "Name, Skill, City, Rating, Uid",
                    focusColor: Colors.white,
                    border: OutlineInputBorder(),
                    
                    focusedBorder: OutlineInputBorder()),
                onChanged: (value) {
                  setState(() {
                    searchValue = value;
                    _filterOperators(value);
                  });

                  log(operators.length.toString());
                },
              )
            : const Text(
                "Operators",

                //style: TextStyle(color: isDark ? null : AppColors.blackColor),
              ),
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
               color: isDark ? null : AppColors.blackColor,
            ),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                searchOperators = [...operators];

                // Call some method here if search is cancelled
                if (!_isSearching) {
                  log("Search bar was hidden");
                }
              });
            },
          ),
        ],
      ),
      body: _isSearching ? operatorLists(searchOperators) : operatorLists(operators),
    );
  }

  ListView operatorLists(List<OperatorModel> listOfOperators) {
    return ListView.separated(
      separatorBuilder: (context, index) {
        return const Divider();
      },
      itemCount: listOfOperators.length,
      itemBuilder: ((context, index) {
        final OperatorModel operator = listOfOperators[index];
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
                content: const Text("Are you sure to delete this Operator?"),
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
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(e.toString()),
                          duration: const Duration(seconds: 4),
                        ));
                      }
                      // ignore: use_build_context_synchronously
                      Navigator.of(ctx).pop();
                    },
                    child: const Text("Yes"),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: const Text("No"),
                  ),
                ],
              ),
            );
          },
          onTap: () {
            Navigator.pushNamed(context, AppRouter.operatorDetailsScreen,
                arguments: operator);
            // Navigator.of(context)
            //     .push(MaterialPageRoute(builder: (context) {
            //   return OperatorDetailsScreen(
            //     operator: operator,
            //   );
            // }));
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
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
                    decoration: const BoxDecoration(shape: BoxShape.circle),
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
                  const Icon(Icons.location_on_outlined),
                  Text(operator.location.title.toString()),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
