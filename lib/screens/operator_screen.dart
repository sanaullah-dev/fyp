import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Operator Screen"),
      ),
      body: ListView.builder(
          itemCount: 20,
          itemBuilder: ((context, index) {
            return Container(
              margin: EdgeInsets.all(8),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage("assets/images/ic_launcher.png",),
                 // child: Image.asset("assets/images/ic_launcher.png",),
                ),
                title: Text("Sana Ullah"),
                trailing: Text(index.toString()),
              ),
            );
          })),
    );
  }
}
