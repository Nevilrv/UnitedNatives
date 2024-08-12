import 'package:united_natives/components/ads_bottom_bar.dart';
import 'package:united_natives/controller/ads_controller.dart';
import 'package:united_natives/controller/doctor_homescreen_controller.dart';
import 'package:united_natives/medicle_center/lib/utils/translate.dart';
import 'package:united_natives/model/doctor_get_doctor_Appointments_model.dart';
import 'package:united_natives/model/visited_patient_model.dart';
import 'package:united_natives/routes/routes.dart';
import 'package:united_natives/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;

import '../../components/custom_profile_item.dart';

class PatientVisitDetailPage extends StatefulWidget {
  final PatientAppoint? patient;

  const PatientVisitDetailPage({super.key, this.patient});

  @override
  State<PatientVisitDetailPage> createState() => _PatientVisitDetailPageState();
}

class _PatientVisitDetailPageState extends State<PatientVisitDetailPage> {
  final DoctorHomeScreenController _doctorHomeScreenController = Get.find();

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
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
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
                                widget.patient?.patientProfilePic ?? "",
                                widget.patient?.patientSocialProfilePic ?? "",
                                30),

                            const SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "${widget.patient?.patientFirstName} ${widget.patient?.patientLastName}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 18),
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    '${widget.patient?.purposeOfVisit}',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'NunitoSans',
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Divider(
                          height: 1,
                          color: Colors.grey[200],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.calendar_today,
                                color: Colors.grey[300],
                              ),
                              const SizedBox(
                                width: 25,
                              ),
                              Expanded(
                                child: Text(
                                  DateFormat('EEEE, dd MMM yyyy, hh:mm a')
                                      .format(Utils.formattedDate(
                                          '${DateTime.parse('${widget.patient?.appointmentDate} ${widget.patient?.appointmentTime}')}')),
                                  // '${patient.appointmentTime} - ${patient.appointmentDate}',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.location_on,
                                color: Colors.grey[300],
                              ),
                              const SizedBox(
                                width: 25,
                              ),
                              const Expanded(
                                child: Text(
                                  'St. Anthony Street 15A. Moscow',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    VisitedPatient patientData = VisitedPatient(
                        patientId: widget.patient?.patientId,
                        appointmentId: widget.patient?.appointmentId);

                    Navigator.of(context)
                        .pushNamed(Routes.doctorprescriptionpage,
                            // arguments: _doctorHomeScreenController
                            //     ?.doctorHomePageModelData
                            //     ?.value
                            //     ?.data
                            //     ?.pastAppointments,
                            arguments: patientData);
                  },
                  child: CustomProfileItem(
                    onTap: () {
                      VisitedPatient patientData = VisitedPatient(
                          patientId: widget.patient?.patientId,
                          appointmentId: widget.patient?.appointmentId);

                      Navigator.of(context)
                          .pushNamed(Routes.doctorprescriptionpage,
                              // arguments: _doctorHomeScreenController
                              //     ?.doctorHomePageModelData
                              //     ?.value
                              //     ?.data
                              //     ?.pastAppointments,
                              arguments: patientData);
                    },
                    title: Translate.of(context)!
                        .translate('Client Prescriptions'),
                    subTitle: 'Consulting',
                    subTitle2: 'given at September 14, 2020',
                    buttonTitle:
                        Translate.of(context)!.translate('See Prescriptions'),
                    imagePath: 'assets/images/icon_examination.png',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
