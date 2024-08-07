import 'package:doctor_appointment_booking/components/ads_bottom_bar.dart';
import 'package:doctor_appointment_booking/controller/ads_controller.dart';
import 'package:doctor_appointment_booking/controller/doctor_homescreen_controller.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/utils/translate.dart';
import 'package:doctor_appointment_booking/model/api_state_enum.dart';
import 'package:doctor_appointment_booking/model/patient_detail_model.dart';
import 'package:doctor_appointment_booking/model/visited_patient_model.dart';
import 'package:doctor_appointment_booking/routes/routes.dart';
import 'package:doctor_appointment_booking/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;

class PatientListVisitDetailPage extends StatefulWidget {
  final PatientData patientData;

  PatientListVisitDetailPage({Key key, this.patientData}) : super(key: key);

  @override
  State<PatientListVisitDetailPage> createState() =>
      _PatientListVisitDetailPageState();
}

class _PatientListVisitDetailPageState
    extends State<PatientListVisitDetailPage> {
  final DoctorHomeScreenController doctorHomeScreenController =
      Get.find<DoctorHomeScreenController>();

  @override
  void initState() {
    // TODO: implement initState
    doctorHomeScreenController.getVisitedPatient(
        patientId: widget.patientData.patientId);
    super.initState();
  }

  AdsController adsController = Get.find();
  Widget build(BuildContext context) {
    return GetBuilder<AdsController>(builder: (ads) {
      return Scaffold(
        bottomNavigationBar: AdsBottomBar(
          ads: ads,
          context: context,
        ),
        appBar: AppBar(
          title: Text(
            Translate.of(context).translate('visit_detail'),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.subtitle1.color,
              fontSize: 24,
            ),
            textAlign: TextAlign.center,
          ),
          centerTitle: true,
        ),
        body: GetBuilder<DoctorHomeScreenController>(
          builder: (controller) {
            if (controller.visitedPatientModelData.apiState ==
                APIState.COMPLETE) {
              return ListView.separated(
                padding: EdgeInsets.all(20),
                itemCount: controller
                        ?.visitedPatientModelData?.visitedPatient?.length ??
                    0,
                itemBuilder: (context, index) {
                  VisitedPatient patient =
                      controller.visitedPatientModelData.visitedPatient[index];
                  String address = '';

                  if (patient.city.isNotEmpty && patient.state.isNotEmpty) {
                    address = '${patient.city}, ${patient.state}';
                  } else if (patient.city.isNotEmpty && patient.state.isEmpty) {
                    address = '${patient.city}';
                  } else if (patient.city.isEmpty && patient.state.isNotEmpty) {
                    address = '${patient.state}';
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Card(
                        // padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                        // decoration: BoxDecoration(
                        //   borderRadius: BorderRadius.circular(4),
                        //   border: Border.all(width: 1, color: Colors.grey[200]),
                        // ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 20),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  // CircleAvatar(
                                  //   backgroundColor: Colors.transparent,
                                  //   radius: 30,
                                  //   backgroundImage: NetworkImage(
                                  //     '${patient.patientProfilePic}',
                                  //   ),
                                  // ),

                                  Utils().patientProfile(
                                    patient?.patientProfilePic ?? "",
                                    patient.patientSocialPic ?? "",
                                    30,
                                  ),

                                  SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "${patient.patientFirstName} ${patient.patientLastName}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2
                                              .copyWith(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 20,
                                              ),
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        if (patient
                                            .purposeOfVisit.isNotEmpty) ...[
                                          Text(
                                            '${patient.purposeOfVisit}',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontFamily: 'NunitoSans',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 2,
                                          ),
                                        ],
                                        if (patient
                                            .patientEmail.isNotEmpty) ...[
                                          Text(
                                            '${patient.patientEmail}',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontFamily: 'NunitoSans',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 2,
                                          ),
                                        ],
                                        if (patient
                                            .patientMobile.isNotEmpty) ...[
                                          Text(
                                            '${patient.patientMobile}',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontFamily: 'NunitoSans',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 2,
                                          ),
                                        ],
                                        if (patient.dob.isNotEmpty) ...[
                                          Text(
                                            'DOB : ${DateFormat('d MMM, yyyy').format( // to get month name from date
                                                DateTime.parse(patient?.dob).toLocal()) ?? ""}',
                                            // '${patient.dob}',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontFamily: 'NunitoSans',
                                                fontWeight: FontWeight.w400),
                                          ),
                                          SizedBox(
                                            height: 2,
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Divider(
                                height: 1,
                                color: Colors.grey[400],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.calendar_today,
                                      color: Colors.grey[400],
                                    ),
                                    SizedBox(
                                      width: 25,
                                    ),
                                    Expanded(
                                      child: Text(
                                        '${DateFormat('EEEE, dd MMM yyyy, hh:mm a').format(Utils.formattedDate('${DateTime.parse('${patient.appointmentDate} ${patient.appointmentTime}')}'))}',
                                        // '${patient.appointmentTime} - ${patient.appointmentDate}',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (address.isNotEmpty) ...[
                                SizedBox(
                                  height: 15,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.location_on,
                                        color: Colors.grey[400],
                                      ),
                                      SizedBox(
                                        width: 25,
                                      ),
                                      Expanded(
                                        child: Text(
                                          address,
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              SizedBox(
                                height: 15,
                              ),
                              InkWell(
                                onTap: () {
                                  print(
                                      'APPOINTMENT ID ID====>${patient.appointmentId}');
                                  Navigator.of(context).pushNamed(
                                      Routes.doctorprescriptionpage,
                                      // arguments: _doctorHomeScreenController
                                      //     ?.doctorHomePageModelData
                                      //     ?.value
                                      //     ?.data
                                      //     ?.pastAppointments,

                                      arguments: patient);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.event_note,
                                        color: Colors.grey[400],
                                      ),
                                      SizedBox(
                                        width: 25,
                                      ),
                                      Text(
                                        Translate.of(context)
                                            .translate('See Prescriptions'),
                                        style: Theme.of(context)
                                            .textTheme
                                            .button
                                            .copyWith(fontSize: 18),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Icon(
                                        Icons.arrow_forward,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // SizedBox(
                      //   height: 20,
                      // ),
                      // CustomProfileItem(
                      //   onTap: () {
                      //     print('PATIENT ID====>${widget.patient.patientId}');
                      //     Navigator.of(context)
                      //         .pushNamed(Routes.doctorprescriptionpage,
                      //             // arguments: _doctorHomeScreenController
                      //             //     ?.doctorHomePageModelData
                      //             //     ?.value
                      //             //     ?.data
                      //             //     ?.pastAppointments,
                      //
                      //             arguments: widget.patient.patientId);
                      //   },
                      //   title: Translate.of(context)
                      //       .translate('Client Prescriptions'),
                      //   subTitle: 'Consulting',
                      //   subTitle2: 'given at September 14, 2020',
                      //   appointmentDate: '',
                      //   buttonTitle:
                      //       Translate.of(context).translate('See Prescriptions'),
                      //   imagePath: 'assets/images/icon_examination.png',
                      // ),
                      // SizedBox(
                      //   height: 20,
                      // ),
                      // SizedBox(
                      //   height: 20,
                      // ),
                    ],
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(height: 10);
                },
              );
            } else if (controller.visitedPatientModelData.apiState ==
                APIState.COMPLETE_WITH_NO_DATA) {
              return Center(
                child: Text(
                  "No data!",
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              );
            } else if (controller.visitedPatientModelData.apiState ==
                APIState.ERROR) {
              return Center(
                child: Text("Error"),
              );
            } else if (controller.visitedPatientModelData.apiState ==
                APIState.PROCESSING) {
              // return Center(
              //   child: CircularProgressIndicator(),
              // );
              return Center(
                child: Utils.circular(),
              );
            } else {
              return Center(
                child: Text(""),
              );
            }
          },
        ),
      );
    });
  }
}
