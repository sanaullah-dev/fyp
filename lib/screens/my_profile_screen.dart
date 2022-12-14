import 'package:flutter/material.dart';
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("My Profile"),),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              alignment: Alignment.center,
              child: const CircleAvatar(
                radius: 80,
                backgroundImage: AssetImage("assets/images/main.png"),
                //NetworkImage("https://e7.pngegg.com/pngimages/799/987/png-clipart-computer-icons-avatar-icon-design-avatar-heroes-computer-wallpaper-thumbnail.png"),
              ),
            ),
          ),
          const SizedBox(height: 20,),
          buildContainer(size,"Name: ","Sana ullah"),
          const SizedBox(height: 8,),
           buildContainer(size,"Email: ","Sanullah@gmail.com" ),
          const SizedBox(height: 8,),
           buildContainer(size, "Contact: ","03111111111"),
          const SizedBox(height: 8,),
           buildContainer(size,"Since: ","2000"),
          const SizedBox(height: 8,),
          buildContainer(size,"Description:  ","Hi! its me Sana ullah from City University of Science and information Technology"),
        ],

      ),
    );
  }

  Card buildContainer(Size size, var title, var subtitle) {

    return Card(
      elevation: 5,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
            //color: Colors.white,
            width: double.infinity,
            height: title== "Description:  "? size.height * 0.2: size.height *0.05,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(title.toString()+subtitle.toString(), style: const TextStyle(fontSize: 20),),

            ),

          ),
    );
  }
}
