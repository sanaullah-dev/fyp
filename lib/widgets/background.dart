import 'package:flutter/material.dart';
import 'package:vehicle_management_and_booking_system/screens/login_signup/fade_animation.dart';

class Background extends StatelessWidget {
  final Widget child;

  const Background({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SizedBox(
      width: double.infinity,
      height: size.height,
      //color: Colors.pink,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: Image.asset(
              "assets/images/top1.png",
              fit: BoxFit.cover,
              //width: size.width,
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: Image.asset(
              "assets/images/top2.png",
              fit: BoxFit.cover, // width: size.width
            ),
          ),
          Positioned(
            top: 50,
            right: 5,
            child: FadeAnimation(
              delay: 1,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.orangeAccent.withOpacity(0.80),
                    width: 0.5,
                  ),
                ),
                child: const FittedBox(
                  fit: BoxFit.cover,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.transparent,
                    backgroundImage: AssetImage(
                      'assets/images/main.png',
                    ),
                  ),
                ),
              ),
            ),

            // CircleAvatar(
            //   radius: 60,
            //   //backgroundColor: Colors.transparent,
            //   child: Image.asset(
            //     fit: BoxFit.cover,
            //     "assets/images/main.png",
            //    width: 300,
            //    // width: size.width * 0.50
            //
            //   ),
            // ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              "assets/images/bottom1.png",
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Image.asset(
              "assets/images/bottom2.png",
              fit: BoxFit.cover,
            ),
          ),
          child
        ],
      ),
    );
  }
}
