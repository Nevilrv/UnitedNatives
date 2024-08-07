import 'package:doctor_appointment_booking/components/ads_bottom_bar.dart';
import 'package:doctor_appointment_booking/controller/ads_controller.dart';
import 'package:doctor_appointment_booking/pages/resources/about_native_american_screen.dart';
import 'package:doctor_appointment_booking/pages/resources/about_the_app_screen.dart';
import 'package:doctor_appointment_booking/pages/resources/about_the_ihapp_screen.dart';
import 'package:doctor_appointment_booking/pages/resources/guideline_who_screen.dart';
import 'package:doctor_appointment_booking/pages/resources/health_recommandation_screen.dart';
import 'package:doctor_appointment_booking/pages/resources/newsletter_screen.dart';
import 'package:doctor_appointment_booking/pages/resources/thank_you_sponser_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'announcment_screen.dart';

class ShowAllScreen extends StatefulWidget {
  const ShowAllScreen({Key key}) : super(key: key);

  @override
  State<ShowAllScreen> createState() => _ShowAllScreenState();
}

class _ShowAllScreenState extends State<ShowAllScreen> {
  List screenData = [
    'News Letter',
    'Announcement',
    'About The App',
    'About The United Natives App',
    'About Native American',
    // 'Upcoming Event',
    'Thank You Sponser',
    'Health Recommendation',
    'Guideline Of WHO',
  ];

  List screen = [
    NewsLetterScreen(),
    AnnoucMentScreen(),
    AboutAppScreen(),
    IhAppScreen(),
    AboutNativeAmericanScreen(),
    // EventScreen(),
    ThankYouScreen(),
    HealthScreen(),
    GuideLineScreen(),
  ];
  int selector = 0;
  int randomAd;
  bool adShow = true;
  AdsController adsController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdsController>(builder: (ads) {
      return Scaffold(
        bottomNavigationBar: AdsBottomBar(
          ads: ads,
          context: context,
        ),
        appBar: AppBar(
          title: Text(
            'Resources',
            style: TextStyle(fontSize: 27),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        backgroundColor: Colors.grey.shade300,
        body: ListView.builder(
          itemCount: screen.length,
          itemBuilder: (BuildContext context, int index) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selector = index;
                    });
                    print(selector);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return screen[index];
                    }));
                  },
                  child: Container(
                    height: 80,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        // color: Color(0xff2e83f8),
                        color: selector == index
                            ? Color(0xff2e83f8)
                            : Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Color(0xffe8e8e8),
                              blurRadius: 5.0,
                              offset: Offset(0, 5)),
                          //   BoxShadow(color: Colors.white, offset: Offset(-5, 0)),
                          //BoxShadow(color: Colors.white, offset: Offset(5, 0)),
                        ]),
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Text(
                          '${screenData[index]}',
                          style: TextStyle(
                              color: selector == index
                                  ? Colors.white
                                  : Color(0xff2e83f8),
                              fontWeight: FontWeight.w600,
                              fontSize: 20),
                        ),
                        Spacer(),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 18,
                          color: selector == index
                              ? Colors.white
                              : Color(0xff2e83f8),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
