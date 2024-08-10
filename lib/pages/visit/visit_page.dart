import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:united_natives/controller/patient_homescreen_controller.dart';
import 'package:united_natives/model/api_state_enum.dart';
import 'package:united_natives/model/appointment.dart';
import '../../components/custom_profile_item.dart';
import '../../routes/routes.dart';
import '../../utils/utils.dart';

class VisitPage extends StatefulWidget {
  const VisitPage({super.key});

  @override
  State<VisitPage> createState() => _VisitPageState();
}

class _VisitPageState extends State<VisitPage> {
  // with AutomaticKeepAliveClientMixin<VisitPage> {
  final PatientHomeScreenController _patientHomeScreenController = Get.find()
    ..getVisitedDoctors();
  @override
  Widget build(BuildContext context) {
    // super.build(context);
    return RefreshIndicator(
      onRefresh: _patientHomeScreenController.getVisitedDoctors,
      child: Obx(() {
        if (_patientHomeScreenController
                .visitedDoctorUpcomingPastData.value.apiState ==
            APIState.COMPLETE) {
          return Obx(
            () => (_patientHomeScreenController
                        .visitedDoctorUpcomingPastData.value.past?.isEmpty ??
                    true)
                ? const Center(
                    child: Text(
                      "No data!",
                      style: TextStyle(fontSize: 21),
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    primary: false,
                    physics: const AlwaysScrollableScrollPhysics(),
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 15,
                    ),
                    itemCount: _patientHomeScreenController
                            .visitedDoctorUpcomingPastData.value.past?.length ??
                        0,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 25),
                    itemBuilder: (context, index) {
                      Appointment doctor = _patientHomeScreenController
                          .visitedDoctorUpcomingPastData.value.past![index];

                      DateTime appointmentDate = Utils.formattedDate(
                          '${DateTime.parse('${doctor.appointmentDate} ${doctor.appointmentTime}')}');

                      final time = DateFormat('h:mm a').format(appointmentDate);

                      return VisitItem(
                        date: DateFormat('MMM dd').format(appointmentDate),
                        time: time.toString(),
                        child: GestureDetector(
                          onTap: () {
                            Get.toNamed(Routes.visitDetail, arguments: doctor);
                          },
                          child: CustomProfileItem(
                            onTap: () {
                              Get.toNamed(Routes.visitDetail,
                                  arguments: doctor);
                            },
                            title: doctor.doctorFirstName!,
                            subTitle: doctor.doctorSpeciality!,
                            buttonTitle: 'See Full Reports',
                            imagePath: doctor.doctorProfilePic!,
                          ),
                        ),
                      );
                    },
                  ),
          );
        } else if (_patientHomeScreenController
                .visitedDoctorUpcomingPastData.value.apiState ==
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
        } else if (_patientHomeScreenController
                .visitedDoctorUpcomingPastData.value.apiState ==
            APIState.ERROR) {
          return const Center(child: Text("Error"));
        } else if (_patientHomeScreenController
                .visitedDoctorUpcomingPastData.value.apiState ==
            APIState.PROCESSING) {
          return Center(
            child: Utils.circular(),
          );
        } else {
          return const Center(
            child: Text(""),
          );
        }
      }),
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
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            Text(
              time,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
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
