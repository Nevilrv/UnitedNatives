import 'dart:developer';
import 'package:united_natives/components/upcoming_appointment_list_item.dart';
import 'package:united_natives/controller/patient_homescreen_controller.dart';
import 'package:united_natives/model/api_state_enum.dart';
import 'package:united_natives/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpcomingAppointmentsPage extends StatefulWidget {
  const UpcomingAppointmentsPage({super.key});

  @override
  State<UpcomingAppointmentsPage> createState() =>
      _UpcomingAppointmentsPageState();
}

class _UpcomingAppointmentsPageState extends State<UpcomingAppointmentsPage> {
  final PatientHomeScreenController _patientHomeScreenController =
      Get.find<PatientHomeScreenController>()..getVisitedDoctors();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: _patientHomeScreenController.getVisitedDoctors,
          child: Obx(() {
            if (_patientHomeScreenController
                    .visitedDoctorUpcomingPastData.value.apiState ==
                APIState.COMPLETE) {
              log('_patientHomeScreenController==========>>>>>${_patientHomeScreenController.visitedDoctorUpcomingPastData.value.upcoming}');

              return Obx(
                () => (_patientHomeScreenController
                            .visitedDoctorUpcomingPastData
                            .value
                            .upcoming
                            ?.isEmpty ??
                        true)
                    ? Center(
                        child: Text(
                          "You have no appointments!",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh:
                            _patientHomeScreenController.getVisitedDoctors,
                        child: Builder(builder: (context) {
                          _patientHomeScreenController
                              .visitedDoctorUpcomingPastData.value.upcoming
                              ?.sort(
                            (a, b) {
                              String dateA =
                                  "${b.appointmentDate} ${b.appointmentTime}";
                              String dateB =
                                  "${a.appointmentDate} ${a.appointmentTime}";
                              return DateTime.parse(dateA)
                                  .compareTo(DateTime.parse(dateB));
                            },
                          );

                          return ListView.separated(
                            physics: const AlwaysScrollableScrollPhysics(),
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              height: 15,
                            ),
                            itemCount: _patientHomeScreenController
                                    .visitedDoctorUpcomingPastData
                                    .value
                                    .upcoming
                                    ?.length ??
                                0,
                            padding: const EdgeInsets.symmetric(
                              vertical: 35,
                              horizontal: 20,
                            ),
                            itemBuilder: (context, index) {
                              return UpcomingAppointmentListItem(
                                  _patientHomeScreenController
                                      .visitedDoctorUpcomingPastData
                                      .value
                                      .upcoming![index]);
                            },
                          );
                        }),
                      ),
              );
            } else if (_patientHomeScreenController
                    .visitedDoctorUpcomingPastData.value.apiState ==
                APIState.COMPLETE_WITH_NO_DATA) {
              return Center(
                child: Text(
                  "You have no appointments!",
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
              return const Center(
                child: Text("Error"),
              );
            } else if (_patientHomeScreenController
                    .visitedDoctorUpcomingPastData.value.apiState ==
                APIState.PROCESSING) {
              return /*Center(
                child: CircularProgressIndicator(),
              )*/
                  Center(
                child: Utils.circular(),
              );
            } else {
              return const Center(
                child: Text(""),
              );
            }
          }),
        ),
        GetBuilder<PatientHomeScreenController>(
          builder: (controller) {
            return controller.startLoader
                ? Container(
                    color: Colors.black12.withOpacity(0.06),
                    child: /*Center(
                      child: CircularProgressIndicator(),
                    )*/
                        Center(
                      child: Utils.circular(),
                    ),
                  )
                : const SizedBox();
          },
        )
      ],
    );
  }
}
