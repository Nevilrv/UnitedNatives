import 'package:united_natives/viewModel/doctor_homescreen_controller.dart';
import 'package:united_natives/ResponseModel/api_state_enum.dart';
import 'package:united_natives/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../components/upcoming_appointment_list_item_doctor.dart';

class UpcomingAppointmentsPageDoctor extends StatefulWidget {
  const UpcomingAppointmentsPageDoctor({super.key});

  @override
  State<UpcomingAppointmentsPageDoctor> createState() =>
      _UpcomingAppointmentsPageDoctorState();
}

class _UpcomingAppointmentsPageDoctorState
    extends State<UpcomingAppointmentsPageDoctor> {
  final DoctorHomeScreenController _doctorHomeScreenController =
      Get.find<DoctorHomeScreenController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: _doctorHomeScreenController.getDoctorAppointmentsModel,
          child: SizedBox(
              height: double.maxFinite,
              child: GetBuilder<DoctorHomeScreenController>(
                builder: (controller) {
                  if (_doctorHomeScreenController
                          .doctorAppointmentsModelData.apiState ==
                      APIState.COMPLETE) {
                    return (controller.doctorAppointmentsModelData.upcoming
                                ?.isEmpty ??
                            true)
                        ? const Center(
                            child: Text(
                              "You have no appointments!",
                              style: TextStyle(fontSize: 21),
                            ),
                          )
                        : Builder(builder: (context) {
                            controller.doctorAppointmentsModelData.upcoming
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
                              separatorBuilder: (context, index) {
                                return const SizedBox(
                                  height: 15,
                                );
                              },
                              itemCount: controller.doctorAppointmentsModelData
                                      .upcoming?.length ??
                                  0,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 35, horizontal: 20),
                              itemBuilder: (context, index) {
                                return UpcomingAppointmentListItemDoctor(
                                  controller.doctorAppointmentsModelData
                                      .upcoming![index],
                                  controller
                                      .doctorAppointmentsModelData.upcoming!
                                      .map((e) =>
                                          "${e.appointmentDate} ${e.appointmentTime}")
                                      .toList(),
                                );
                              },
                            );
                          });
                  } else if (controller.doctorAppointmentsModelData.apiState ==
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
              )),
        ),
        GetBuilder<DoctorHomeScreenController>(
          builder: (controller) {
            return controller.startLoader
                ? Container(
                    color: Colors.black12.withOpacity(0.06),
                    child: /*Center(
                      child: CircularProgressIndicator(),
                    ),*/
                        Center(
                      child: Utils.circular(),
                    ))
                : const SizedBox();
          },
        )
      ],
    );

    // return (_doctorHomeScreenController.doctorHomePageModelData?.value?.data
    //                 ?.upcomingAppointments?.length !=
    //             null &&
    //         (_doctorHomeScreenController.doctorHomePageModelData?.value?.data
    //                     ?.upcomingAppointments?.length ??
    //                 0) >
    //             0)
    //     ? Obx(
    //         () => ListView.separated(
    //           physics: AlwaysScrollableScrollPhysics(),
    //           separatorBuilder: (context, index) => SizedBox(
    //             height: 15,
    //           ),
    //           itemCount: _doctorHomeScreenController.doctorHomePageModelData
    //                   ?.value?.data?.upcomingAppointments?.length ??
    //               0,
    //           padding: EdgeInsets.symmetric(
    //             vertical: 35,
    //             horizontal: 20,
    //           ),
    //           itemBuilder: (context, index) {
    //             return UpcomingAppointmentListItemDoctor(
    //                 _doctorHomeScreenController.doctorHomePageModelData?.value
    //                         ?.data?.upcomingAppointments[index] ??
    //                     "");

    //           },
    //         ),
    //       )
    //     : Center(
    //         child: Text("Nothing to Show!"),
    //       );
  }
}
