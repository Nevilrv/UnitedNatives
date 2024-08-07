import 'package:doctor_appointment_booking/model/visited_patient_model.dart';
import 'package:doctor_appointment_booking/pages/prescription/widget/doctor_presciption_card.dart';
import 'package:flutter/material.dart';

class DoctorProfilePrescriptionTabPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Padding(
        padding: EdgeInsets.all(20),
        child: DoctorPrescriptionCard(
          patientData: VisitedPatient(),
        ),
      ),
    );
  }
}
