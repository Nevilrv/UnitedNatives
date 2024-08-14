import 'package:united_natives/components/ads_bottom_bar.dart';
import 'package:united_natives/controller/ads_controller.dart';
import 'package:united_natives/controller/doctor_homescreen_controller.dart';
import 'package:united_natives/medicle_center/lib/utils/translate.dart';
import 'package:united_natives/model/api_state_enum.dart';
import 'package:united_natives/model/patient_detail_model.dart';
import 'package:united_natives/model/visited_patient_model.dart';
import 'package:united_natives/routes/routes.dart';
import 'package:united_natives/utils/constants.dart';
import 'package:united_natives/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;

class PatientListVisitDetailPage extends StatefulWidget {
  final PatientData? patientData;

  const PatientListVisitDetailPage({super.key, this.patientData});

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
        patientId: widget.patientData?.patientId);
    super.initState();
  }

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
            Translate.of(context)!.translate('visit_detail'),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.titleMedium?.color,
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
                padding: const EdgeInsets.all(20),
                itemCount:
                    controller.visitedPatientModelData.visitedPatient?.length ??
                        0,
                itemBuilder: (context, index) {
                  VisitedPatient? patient =
                      controller.visitedPatientModelData.visitedPatient?[index];
                  String address = '';

                  if (patient!.city!.isNotEmpty && patient.state!.isNotEmpty) {
                    address = '${patient.city}, ${patient.state}';
                  } else if (patient.city!.isNotEmpty &&
                      patient.state!.isEmpty) {
                    address = '${patient.city}';
                  } else if (patient.city!.isEmpty &&
                      patient.state!.isNotEmpty) {
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
                                    patient.patientProfilePic ?? "",
                                    patient.patientSocialPic ?? "",
                                    30,
                                  ),

                                  const SizedBox(
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
                                              .titleSmall
                                              ?.copyWith(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 20,
                                              ),
                                        ),
                                        const SizedBox(
                                          height: 2,
                                        ),
                                        if (patient
                                            .purposeOfVisit!.isNotEmpty) ...[
                                          Text(
                                            '${patient.purposeOfVisit}',
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontFamily: 'NunitoSans',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 2,
                                          ),
                                        ],
                                        if (patient
                                            .patientEmail!.isNotEmpty) ...[
                                          Text(
                                            '${patient.patientEmail}',
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontFamily: 'NunitoSans',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 2,
                                          ),
                                        ],
                                        if (patient
                                            .patientMobile!.isNotEmpty) ...[
                                          Text(
                                            '${patient.patientMobile}',
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontFamily: 'NunitoSans',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 2,
                                          ),
                                        ],
                                        if (patient.dob!.isNotEmpty) ...[
                                          Text(
                                            'DOB : ${DateFormat('d MMM, yyyy').format( // to get month name from date
                                                DateTime.parse(patient.dob!).toLocal())}',
                                            // '${patient.dob}',
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontFamily: 'NunitoSans',
                                                fontWeight: FontWeight.w400),
                                          ),
                                          const SizedBox(
                                            height: 2,
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Divider(
                                height: 1,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(
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
                                    const SizedBox(
                                      width: 25,
                                    ),
                                    Expanded(
                                      child: Text(
                                        DateFormat('EEEE, dd MMM yyyy, hh:mm a')
                                            .format(Utils.formattedDate(
                                                '${DateTime.parse('${patient.appointmentDate} ${patient.appointmentTime}')}')),
                                        // '${patient.appointmentTime} - ${patient.appointmentDate}',
                                        style: const TextStyle(
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
                                const SizedBox(
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
                                      const SizedBox(
                                        width: 25,
                                      ),
                                      Expanded(
                                        child: Text(
                                          address,
                                          style: const TextStyle(
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
                              const SizedBox(
                                height: 15,
                              ),
                              InkWell(
                                onTap: () {
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
                                      const SizedBox(
                                        width: 25,
                                      ),
                                      Text(
                                        Translate.of(context)!
                                            .translate('See Prescriptions'),
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge
                                            ?.copyWith(
                                                fontSize: 18,
                                                color: kColorBlue),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      const Icon(
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
                  return const SizedBox(height: 10);
                },
              );
            } else if (controller.visitedPatientModelData.apiState ==
                APIState.COMPLETE_WITH_NO_DATA) {
              return Center(
                child: Text(
                  "No data!",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              );
            } else if (controller.visitedPatientModelData.apiState ==
                APIState.ERROR) {
              return const Center(
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
              return const Center(
                child: Text(""),
              );
            }
          },
        ),
      );
    });
  }
}
