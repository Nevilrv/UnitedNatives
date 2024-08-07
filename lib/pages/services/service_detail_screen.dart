import 'package:doctor_appointment_booking/components/ads_bottom_bar.dart';
import 'package:doctor_appointment_booking/controller/ads_controller.dart';
import 'package:doctor_appointment_booking/data/pref_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ServiceDetailScreen extends StatefulWidget {
  final String image;
  final String title;
  final String description;

  ServiceDetailScreen({Key key, this.image, this.title, this.description})
      : super(key: key);

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  AdsController adsController = Get.find();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdsController>(builder: (ads) {
      return Scaffold(
        bottomNavigationBar: AdsBottomBar(
          ads: ads,
          context: context,
        ),
        body: SafeArea(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Get.width * 0.03),
                child: ListView(
                  children: [
                    headerView(
                        image: widget.image,
                        title: widget.title,
                        context: context),
                    // Get.width * 0.05
                    /*Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Get.width * 0.05,
                            vertical: Get.height * 0.012),
                        child: Text(
                          'Description',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: Get.width * 0.055,
                              fontWeight: FontWeight.bold),
                        ),
                      ),*/
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: Get.width * 0.05),
                      child: tab1(description: widget.description),
                    ),
                  ],
                ))),
      );
    });
  }

  Column tab1({String description}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          description ?? '',
          style: TextStyle(fontSize: Get.height * 0.023),
        ),
      ],
    );
  }

  Widget headerView({String image, String title, BuildContext context}) {
    bool _isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                // width: Get.width,
                height: Get.height * 0.25,

                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(image == null || image == ''
                            ? 'https://www.safefood.net/getmedia/8b0483a1-ea59-4a74-857d-675a9cfecc80/medical-conditions.jpg?w=2048&h=1152&ext=.jpg&width=1360&resizemode=force'
                            : image),
                        fit: BoxFit.fill),
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Get.width * 0.05, vertical: Get.height * 0.012),
              child: Text(
                '${title ?? ""}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: _isDark ? Colors.white : Colors.black,
                    fontSize: Get.height * 0.08,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              width: Get.width * 2,
              height: 2,
              margin: EdgeInsets.symmetric(horizontal: 20),
              color: Colors.black12,
            ),
            SizedBox(
              height: Get.height * 0.015,
            )
          ],
        ),
        Positioned(
          top: Get.height * 0.03,
          left: Get.width * 0.05,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: CircleAvatar(
              backgroundColor: Colors.black.withOpacity(0.5),
              radius: Get.height * 0.02,
              child: Center(
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Container buildContainer({
    String title,
    Color colorName,
    Color colorText,
  }) {
    return Container(
      height: 40,
      // width: 50,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 4),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      child: Text(
        "$title",
        style: TextStyle(
            color: colorText == null ? Colors.black : colorText, fontSize: 20),
      ),

      decoration: BoxDecoration(
          color: colorName,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              spreadRadius: 1,
              offset: Offset(0.5, 0.5),
            )
          ],
          borderRadius: BorderRadius.circular(8)),
    );
  }

  Container buildContainerButton({
    String title,
    Color colorName,
    Color colorText,
  }) {
    return Container(
      height: 50,
      // width: 50,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 4),
      margin: EdgeInsets.only(bottom: 25, right: 25, left: 25, top: 10),
      child: Text(
        "$title",
        style: TextStyle(color: colorText, fontSize: 20),
      ),

      decoration: BoxDecoration(
          color: colorName,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              spreadRadius: 1,
              offset: Offset(0.5, 0.5),
            )
          ],
          borderRadius: BorderRadius.circular(8)),
    );
  }
}
