import 'package:doctor_appointment_booking/components/ads_bottom_bar.dart';
import 'package:doctor_appointment_booking/controller/ads_controller.dart';
import 'package:doctor_appointment_booking/controller/doctor_homescreen_controller.dart';
import 'package:doctor_appointment_booking/controller/patient_homescreen_controller.dart';
import 'package:doctor_appointment_booking/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';

class AboutUNH extends StatefulWidget {
  String aboutUs;
  AboutUNH({Key key, this.aboutUs}) : super(key: key);

  @override
  State<AboutUNH> createState() => _AboutUNHState();
}

class _AboutUNHState extends State<AboutUNH> {
  AdsController adsController = Get.find();

  Widget build(BuildContext context) {
    if (Config.getUserType() == "1") {
      widget.aboutUs = "";
      final PatientHomeScreenController patientHomeScreenController =
          Get.find();
      widget.aboutUs = patientHomeScreenController
          .aboutUsPrivacyPolicyModel?.value?.data?.aboutUnh;
    } else {
      widget.aboutUs = "";
      final DoctorHomeScreenController doctorHomeScreenController = Get.find();
      doctorHomeScreenController.aboutUsPrivacyPolicy();

      widget.aboutUs = doctorHomeScreenController
          .aboutUsPrivacyPolicyDoctorModel?.value?.data?.aboutUnh;
      print('ABOUT US=${widget.aboutUs}  ');
      print(
          'ABOUT US=${doctorHomeScreenController.aboutUsPrivacyPolicyDoctorModel?.value?.data}');
    }

    print('ABOUT_US_DATA=======>>>>>${widget.aboutUs}');

    return GetBuilder<AdsController>(builder: (ads) {
      return Scaffold(
        bottomNavigationBar: AdsBottomBar(
          ads: ads,
          context: context,
        ),
        appBar: AppBar(
            title: Text('About Us',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.subtitle1.color,
                    fontSize: 24),
                textAlign: TextAlign.center),
            centerTitle: true,
            //backgroundColor: Colors.white,
            elevation: 1),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 20),
                Html(
                  data: widget.aboutUs ?? '',
                  /*style: {
                    "tr": Style(
                      border: Border(bottom: BorderSide(color: Colors.grey)),
                    ),
                    "th": Style(
                      padding: EdgeInsets.all(6),
                      backgroundColor: Colors.grey,
                    ),
                  }*/
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      );
    });
  }
}
