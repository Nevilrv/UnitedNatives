import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:united_natives/components/ads_bottom_bar.dart';
import 'package:united_natives/viewModel/ads_controller.dart';
import 'package:united_natives/viewModel/doctor_homescreen_controller.dart';
import 'package:united_natives/viewModel/patient_homescreen_controller.dart';
import 'package:united_natives/utils/utils.dart';

class AboutUNH extends StatefulWidget {
  final String? aboutUs;
  const AboutUNH({super.key, this.aboutUs});

  @override
  State<AboutUNH> createState() => _AboutUNHState();
}

class _AboutUNHState extends State<AboutUNH> {
  AdsController adsController = Get.find();

  String? data;

  @override
  void initState() {
    data = widget.aboutUs;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (Config.getUserType() == "1") {
      data = "";
      final PatientHomeScreenController patientHomeScreenController =
          Get.find();
      data = patientHomeScreenController
          .aboutUsPrivacyPolicyModel.value.data?.aboutUnh;
    } else {
      data = "";
      final DoctorHomeScreenController doctorHomeScreenController = Get.find();
      doctorHomeScreenController.aboutUsPrivacyPolicy();

      data = doctorHomeScreenController
          .aboutUsPrivacyPolicyDoctorModel.value.data?.aboutUnh;
    }
    log('data==========>>>>>$data');
    return GetBuilder<AdsController>(builder: (ads) {
      return Scaffold(
        bottomNavigationBar: AdsBottomBar(
          ads: ads,
          context: context,
        ),
        appBar: AppBar(
            surfaceTintColor: Colors.transparent,
            title: Text('About Us',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.titleMedium?.color,
                    fontSize: 24),
                textAlign: TextAlign.center),
            centerTitle: true,
            //backgroundColor: Colors.white,
            elevation: 1),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                HtmlWidget(
                  data.toString(),
                  textStyle: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      );
    });
  }
}
