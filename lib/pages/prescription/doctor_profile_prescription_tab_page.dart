import 'package:united_natives/ResponseModel/visited_patient_model.dart';
import 'package:united_natives/pages/prescription/widget/doctor_presciption_card.dart';
import 'package:flutter/material.dart';

class DoctorProfilePrescriptionTabPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  DoctorProfilePrescriptionTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: DoctorPrescriptionCard(
          patientData: VisitedPatient(),
        ),
      ),
    );
  }
}
