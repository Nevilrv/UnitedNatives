import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:united_natives/components/ads_bottom_bar.dart';
import 'package:united_natives/controller/ads_controller.dart';
import 'package:united_natives/controller/doctor_homescreen_controller.dart';
import 'package:united_natives/controller/patient_homescreen_controller.dart';
import 'package:united_natives/utils/utils.dart';
import 'package:html/parser.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  String? privacyData;
  AdsController adsController = Get.find();
  @override
  Widget build(BuildContext context) {
    if (Config.getUserType() == "1") {
      privacyData = "";
      final PatientHomeScreenController patientHomeScreenController =
          Get.find();
      privacyData = patientHomeScreenController
          .aboutUsPrivacyPolicyModel.value.data?.privacyPolicy;
    } else {
      privacyData = "";
      final DoctorHomeScreenController doctorHomeScreenController = Get.find();
      privacyData = doctorHomeScreenController
          .aboutUsPrivacyPolicyDoctorModel.value.data?.privacyPolicy;
    }

    return GetBuilder<AdsController>(
      builder: (ads) {
        return Scaffold(
          bottomNavigationBar: AdsBottomBar(
            ads: ads,
            context: context,
          ),
          appBar: AppBar(
            title: Text(
              'Privacy Policy',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleMedium?.color,
                  fontSize: 24),
              textAlign: TextAlign.center,
            ),
            centerTitle: true,
            //backgroundColor: Colors.white,
            elevation: 1,
          ),
          backgroundColor: Theme.of(context).canvasColor,
          body: LayoutBuilder(
            builder:
                (BuildContext context, BoxConstraints viewportConstraints) {
              return ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(height: 20),
                          HtmlWidget(
                            privacyData.toString(),
                            textStyle: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
