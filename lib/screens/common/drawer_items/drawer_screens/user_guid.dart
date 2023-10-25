import 'package:flutter/material.dart';
import 'package:vehicle_management_and_booking_system/app/app.dart';
import 'package:vehicle_management_and_booking_system/utils/app_colors.dart';
import 'package:vehicle_management_and_booking_system/utils/const.dart';
import 'package:vehicle_management_and_booking_system/utils/media_query.dart';

class UserGuideScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      bool isDark = ConstantHelper.darkOrBright(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "User Guide",
            style: TextStyle(color: isDark ? null : Colors.black),
          ),
          backgroundColor: isDark ? null : AppColors.accentColor,
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: () {
                navigatorKey.currentState!.pop();
              },
              icon: Icon(
                Icons.arrow_back_ios_new_sharp,
                color: isDark ? null : AppColors.blackColor,
              )),
        ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Title and Description
            Container(
              padding: const EdgeInsets.all(16),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'How to use the app',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'This guide will help you understand how to use the app effectively.',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            // Video 1
            videoCard(context,'Video 1: Introduction', 'Learn the basics of our app',"https://media.istockphoto.com/id/1508714772/photo/landscape-gardener-filling-garden-with-new-soil.webp?b=1&s=170667a&w=0&k=20&c=O7UJgqZnbMje2fTFo79zuUkuNl75UpocnzCYJjY9yZw="),
            // Video 2
            videoCard(context,'Video 2: Features Overview',
                'Explore all features of our app',"https://media.istockphoto.com/id/1508714772/photo/landscape-gardener-filling-garden-with-new-soil.webp?b=1&s=170667a&w=0&k=20&c=O7UJgqZnbMje2fTFo79zuUkuNl75UpocnzCYJjY9yZw="),
                 videoCard(context,'Video 2: Features Overview',
                'Explore all features of our app',"https://focus.belfasttelegraph.co.uk/thumbor/wDok4Sx8TMv_R1ghvaU-2E7ZRT8=/550x550/smart/prod-mh-ireland/699358ae-953b-11ed-bcad-0210609a3fe2.JPG"),
            // Video 3
            videoCard(context,'Video 3: Request to the Machiery owner', 'Machiery Request',"https://as1.ftcdn.net/v2/jpg/05/19/60/76/1000_F_519607657_Mq6SEYb2d1W59DX7aCyGJE0p6lqBtmJt.jpg"),
              videoCard(context,'Video 3: Request to the Operator', 'Operator Request',"https://focus.belfasttelegraph.co.uk/thumbor/wDok4Sx8TMv_R1ghvaU-2E7ZRT8=/550x550/smart/prod-mh-ireland/699358ae-953b-11ed-bcad-0210609a3fe2.JPG"),
            // ... Add more videos
          ],
        ),
      ),
    );
  }

  Widget videoCard(BuildContext context, String title, String description,String url) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Placeholder for video
            Container(
              height: 200,
              width: screenWidth(context),
              color: Colors.grey[300],
              child:  Image.network(url,fit: BoxFit.cover,),
            ),
            const SizedBox(height: 8),
            // Title
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            // Description
            Text(
              description,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
