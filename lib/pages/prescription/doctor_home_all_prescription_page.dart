import 'package:united_natives/components/ads_bottom_bar.dart';
import 'package:united_natives/viewModel/ads_controller.dart';
import 'package:united_natives/medicle_center/lib/utils/translate.dart';
import 'package:united_natives/ResponseModel/visited_patient_model.dart';
import 'package:united_natives/pages/prescription/widget/doctor_presciption_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DoctorPrescriptionPage extends StatefulWidget {
  final VisitedPatient? patientData;

  const DoctorPrescriptionPage({super.key, this.patientData});

  @override
  State<DoctorPrescriptionPage> createState() => _DoctorPrescriptionPageState();
}

class _DoctorPrescriptionPageState extends State<DoctorPrescriptionPage> {
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
          surfaceTintColor: Colors.transparent,
          title: Text(
            Translate.of(context)!.translate('Client Prescriptions'),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.titleMedium?.color,
              fontSize: 24,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: DoctorPrescriptionCard(
            patientData: widget.patientData ?? VisitedPatient(),
          ),
        ),
      );
    });
  }
}
