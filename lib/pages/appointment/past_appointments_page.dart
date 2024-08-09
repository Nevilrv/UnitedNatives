import 'package:united_natives/controller/patient_homescreen_controller.dart';
import 'package:united_natives/medicle_center/lib/utils/translate.dart';
import 'package:united_natives/model/api_state_enum.dart';
import 'package:united_natives/utils/constants.dart';
import 'package:united_natives/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/past_appointments_list_item.dart';

class PastAppointmentsPage extends StatefulWidget {
  const PastAppointmentsPage({super.key});

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
          padding: const EdgeInsets.all(20).copyWith(bottom: 5),
          child: TextField(
            controller: _patientHomeScreenController.pastController,
            autofillHints: const [AutofillHints.name],
            onChanged: (value) {
              _patientHomeScreenController.searchPastAppointment(value);
            },
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: const BorderSide(color: kColorBlue, width: 0.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: BorderSide(color: Colors.grey[300]!, width: 0.5),
              ),
              filled: true,
              fillColor: Colors.grey[250],
              contentPadding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 15,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey[400],
                size: 30,
              ),
              hintText: Translate.of(context)?.translate('search_messages'),
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 22),
            ),
            cursorWidth: 1,
            maxLines: 1,
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _patientHomeScreenController.getVisitedDoctors,
            child: Obx(
              () {
                if (_patientHomeScreenController
                        .visitedDoctorUpcomingPastData.value.apiState ==
                    APIState.COMPLETE) {
                  return Obx(
                    () => (_patientHomeScreenController
                            .pastAppointmentData.isEmpty)
                        ? const Center(
                            child: Text(
                              "You have no appointments!",
                              style: TextStyle(fontSize: 21),
                            ),
                          )
                        : Builder(builder: (context) {
                            return ListView.separated(
                              physics: const AlwaysScrollableScrollPhysics(),
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                height: 15,
                              ),
                              itemCount: _patientHomeScreenController
                                  .pastAppointmentData.length,
                              padding: const EdgeInsets.symmetric(
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
              },
            ),
          ),
        ),
      ],
    );
  }
}
