import 'package:united_natives/pages/prescription/widget/patient_presciption_card.dart';
import 'package:flutter/material.dart';

class PatientProfilePrescriptionTabPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  PatientProfilePrescriptionTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: const Padding(
        padding: EdgeInsets.all(20.0),
        child: PatientPrescriptionCard(),
      ),
    );
  }
}
