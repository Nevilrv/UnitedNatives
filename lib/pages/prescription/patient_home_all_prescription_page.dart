import 'package:doctor_appointment_booking/components/ads_bottom_bar.dart';
import 'package:doctor_appointment_booking/controller/ads_controller.dart';
import 'package:doctor_appointment_booking/pages/prescription/widget/patient_presciption_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PatientHomeAllPrescriptionPage extends StatefulWidget {
  @override
  State<PatientHomeAllPrescriptionPage> createState() =>
      _PatientHomeAllPrescriptionPageState();
}

class _PatientHomeAllPrescriptionPageState
    extends State<PatientHomeAllPrescriptionPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  AdsController adsController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdsController>(builder: (ads) {
      return Scaffold(
        bottomNavigationBar: AdsBottomBar(
          ads: ads,
          context: context,
        ),
        key: scaffoldKey,
        appBar: AppBar(
          actions: <Widget>[],
          title: Text('My Prescriptions',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.subtitle1.color,
                fontSize: 24,
              ),
              textAlign: TextAlign.center),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: PatientPrescriptionCard(),
        ),
      );
    });
  }
}
