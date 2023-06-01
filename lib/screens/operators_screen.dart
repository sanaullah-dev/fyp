import 'package:flutter/material.dart';

class OperatorSearchScreen extends StatefulWidget {
  const OperatorSearchScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<OperatorSearchScreen> createState() => _OperatorSearchScreenState();
}

class _OperatorSearchScreenState extends State<OperatorSearchScreen> {
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Operator Screen"),
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) {
          return const Divider();
        },
          itemCount: 20,
          itemBuilder: ((context, index) {
            return Container(
              margin: const EdgeInsets.all(8),
              child: ListTile(
                leading: const CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage("assets/images/ic_launcher.png",),
                 // child: Image.asset("assets/images/ic_launcher.png",),
                ),
                title: const Text("Sana Ullah"),
                subtitle: const Text("Skill: Excevator, loader, truck, driving, etc."),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.location_on_outlined),
                    Text("Peshawar"),
                  ],
                ),
              ),
            );
          })),
    );
  }
}
