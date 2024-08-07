import 'package:doctor_appointment_booking/controller/patient_homescreen_controller.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/utils/translate.dart';
import 'package:doctor_appointment_booking/model/api_state_enum.dart';
import 'package:doctor_appointment_booking/utils/constants.dart';
import 'package:doctor_appointment_booking/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/past_appointments_list_item.dart';

class PastAppointmentsPage extends StatefulWidget {
  @override
  State<PastAppointmentsPage> createState() => _PastAppointmentsPageState();
}

class _PastAppointmentsPageState extends State<PastAppointmentsPage> {
  final PatientHomeScreenController _patientHomeScreenController =
      Get.find<PatientHomeScreenController>()..getVisitedDoctors();

  @override
  void dispose() {
    _patientHomeScreenController.pastController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(20).copyWith(bottom: 5),
          child: TextField(
            controller: _patientHomeScreenController.pastController,
            autofillHints: [AutofillHints.name],
            onChanged: (value) {
              _patientHomeScreenController.searchPastAppointment(value);
            },
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: BorderSide(color: kColorBlue, width: 0.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: BorderSide(color: Colors.grey[300], width: 0.5),
              ),
              filled: true,
              fillColor: Colors.grey[250],
              contentPadding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 15,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey[400],
                size: 30,
              ),
              hintText: Translate.of(context).translate('search_messages'),
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 22),
            ),
            cursorWidth: 1,
            maxLines: 1,
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _patientHomeScreenController.getVisitedDoctors,
            child: Obx(() {
              if (_patientHomeScreenController
                      .visitedDoctorUpcomingPastData.value.apiState ==
                  APIState.COMPLETE) {
                return Obx(
                  () => (_patientHomeScreenController
                              .pastAppointmentData?.isEmpty ??
                          true)
                      ? Center(
                          child: Container(
                            child: Text(
                              "You have no appointments!",
                              style: TextStyle(fontSize: 21),
                            ),
                          ),
                        )
                      : Builder(builder: (context) {
                          return ListView.separated(
                            physics: AlwaysScrollableScrollPhysics(),
                            separatorBuilder: (context, index) => SizedBox(
                              height: 15,
                            ),
                            itemCount: _patientHomeScreenController
                                    .pastAppointmentData?.length ??
                                0,
                            padding: EdgeInsets.symmetric(
                                    vertical: 35, horizontal: 20)
                                .copyWith(top: 5),
                            itemBuilder: (context, index) {
                              return PastAppointmentListItem(
                                  _patientHomeScreenController
                                      .pastAppointmentData[index]);
                            },
                          );
                        }),
                );
              } else if (_patientHomeScreenController
                          .visitedDoctorUpcomingPastData.value.apiState ==
                      APIState.COMPLETE_WITH_NO_DATA &&
                  _patientHomeScreenController.pastAppointmentData.isEmpty) {
                return Center(
                  child: Container(
                    child: Text(
                      "You have no appointments!",
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              } else if (_patientHomeScreenController
                      .visitedDoctorUpcomingPastData.value.apiState ==
                  APIState.ERROR) {
                return Center(child: Text("Error"));
              } else if (_patientHomeScreenController
                      .visitedDoctorUpcomingPastData.value.apiState ==
                  APIState.PROCESSING) {
                return Container(
                  // child: Center(
                  //   child: CircularProgressIndicator(),
                  // ),
                  child: Center(
                    child: Utils.circular(),
                  ),
                );
              } else {
                return Center(
                  child: Text(""),
                );
              }
            }),
          ),
        ),
      ],
    );
  }
}
