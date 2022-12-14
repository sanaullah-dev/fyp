import 'package:flutter/material.dart';

class MachineryDetailScreen extends StatefulWidget {
  MachineryDetailScreen({super.key, required this.image, required this.title});

  Image image = Image.asset("assets/images/ic_launcher.png");
  String title;

  @override
  State<MachineryDetailScreen> createState() => _MachineryDetailScreenState();
}

class _MachineryDetailScreenState extends State<MachineryDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details: "+widget.title),
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: ListView(
          children: [
            Container(
              alignment: Alignment.center,
              width: 200,
              height: 200,
              child: widget.image,
            ),
            Text(
              widget.title,
              style: TextStyle(fontSize: 20),
            ),
            const Text(
              "DX140LCR-7",
              style: TextStyle(fontSize: 20),
            ),
            const Text(
              "The new DX140LC-7 14.6 tonne and DX140LCR-7 15.9 tonne crawler models. Both excavators are now powered by the Doosan D34 4-cylinder Stage V diesel engine providing 87.2 kW (117 HP) of power at 2000 RPM",
            textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
