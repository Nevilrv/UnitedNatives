import 'package:doctor_appointment_booking/pages/prescription/widget/patient_presciption_card.dart';
import 'package:flutter/material.dart';

class PatientProfilePrescriptionTabPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: PatientPrescriptionCard(),
      ),
    );
  }
}
