import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:intl/intl.dart';
import 'package:united_natives/controller/doctor_homescreen_controller.dart';
import 'package:united_natives/model/api_state_enum.dart';
import 'package:united_natives/utils/utils.dart';

import '../../components/custom_profile_item.dart';
import '../../routes/routes.dart';

class PatientVisitPage extends StatefulWidget {
  const PatientVisitPage({super.key});

  @override
  State<PatientVisitPage> createState() => _PatientVisitPageState();
}

class _PatientVisitPageState extends State<PatientVisitPage> {
  // with AutomaticKeepAliveClientMixin<PatientVisitPage>
  final DoctorHomeScreenController _doctorHomeScreenController =
      Get.find<DoctorHomeScreenController>()..getDoctorAppointmentsModel();
  @override
  Widget build(BuildContext context) {
    // super.build(context);
    return GetBuilder<DoctorHomeScreenController>(
      builder: (controller) {
        if (controller.doctorAppointmentsModelData.apiState ==
            APIState.COMPLETE) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: controller.doctorAppointmentsModelData.past?.isEmpty ?? true
                ? Center(
                    child: Text(
                      'Nothing to Show!',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    primary: false,
                    itemCount:
                        controller.doctorAppointmentsModelData.past?.length ??
                            0,
                    itemBuilder: (BuildContext context, int index) {
                      var pastAppointmentsDoctor =
                          controller.doctorAppointmentsModelData.past?[index];
                      DateTime appointmentDate = Utils.formattedDate(
                          '${DateTime.parse('${pastAppointmentsDoctor?.appointmentDate} ${pastAppointmentsDoctor?.appointmentTime}')}');

                      return Column(
                        children: [
                          VisitItem(
                            date: DateFormat('MMM dd').format(appointmentDate),
                            time: DateFormat('hh:mm a').format(appointmentDate),
                            child: GestureDetector(
                              onTap: () {
                                Get.toNamed(Routes.patientvistpage,
                                    arguments: pastAppointmentsDoctor);
                              },
                              child: CustomProfileItem(
                                onTap: () {
                                  Get.toNamed(Routes.patientvistpage,
                                      arguments: pastAppointmentsDoctor);
                                },
                                title:
                                    '${pastAppointmentsDoctor?.patientFirstName} ${pastAppointmentsDoctor?.patientLastName}',
                                subTitle:
                                    '${pastAppointmentsDoctor?.purposeOfVisit}',
                                buttonTitle: 'See Full Reports',
                                imagePath:
                                    '${pastAppointmentsDoctor?.patientProfilePic}',
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      );
                    }),
          );
        } else if (controller.doctorAppointmentsModelData.apiState ==
            APIState.COMPLETE_WITH_NO_DATA) {
          return Center(
            child: Text(
              'Nothing to Show!',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          );
        } else if (controller.doctorAppointmentsModelData.apiState ==
            APIState.ERROR) {
          return const Center(child: Text("Error"));
        } else if (controller.doctorAppointmentsModelData.apiState ==
            APIState.PROCESSING) {
          return Center(
            child: Utils.circular(),
          );
        } else {
          return const Center(
            child: Text(""),
          );
        }
      },
    );
  }

  bool get wantKeepAlive => true;
}

class VisitItem extends StatelessWidget {
  final String date;
  final String time;
  final Widget child;

  const VisitItem(
      {super.key, required this.date, required this.time, required this.child});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              date,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontWeight: FontWeight.w700, fontSize: 18),
            ),
            Text(
              time,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
            )
          ],
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: child,
        ),
      ],
    );
  }
}
