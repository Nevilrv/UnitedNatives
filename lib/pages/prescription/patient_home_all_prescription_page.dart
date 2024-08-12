import 'package:united_natives/components/ads_bottom_bar.dart';
import 'package:united_natives/controller/ads_controller.dart';
import 'package:united_natives/pages/prescription/widget/patient_presciption_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PatientHomeAllPrescriptionPage extends StatefulWidget {
  const PatientHomeAllPrescriptionPage({super.key});

  @override
  State<PatientHomeAllPrescriptionPage> createState() =>
      _PatientHomeAllPrescriptionPageState();
}

class _PatientHomeAllPrescriptionPageState
    extends State<PatientHomeAllPrescriptionPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

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
          actions: const <Widget>[],
          title: Text('My Prescriptions',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.titleMedium?.color,
                fontSize: 24,
              ),
              textAlign: TextAlign.center),
          centerTitle: true,
        ),
        body: const Padding(
          padding: EdgeInsets.all(20.0),
          child: PatientPrescriptionCard(),
        ),
      );
    });
  }
}
