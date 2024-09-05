import 'package:united_natives/components/past_appointments_list_item_doctor.dart';
import 'package:united_natives/viewModel/doctor_homescreen_controller.dart';
import 'package:united_natives/medicle_center/lib/utils/translate.dart';
import 'package:united_natives/ResponseModel/api_state_enum.dart';
import 'package:united_natives/utils/constants.dart';
import 'package:united_natives/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PastAppointmentsPageDoctor extends StatefulWidget {
  const PastAppointmentsPageDoctor({super.key});

  @override
  State<PastAppointmentsPageDoctor> createState() =>
      _PastAppointmentsPageDoctorState();
}

class _PastAppointmentsPageDoctorState
    extends State<PastAppointmentsPageDoctor> {
  final DoctorHomeScreenController _doctorHomeScreenController =
      Get.find<DoctorHomeScreenController>();

  @override
  void dispose() {
    _doctorHomeScreenController.pastController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20).copyWith(bottom: 5),
          child: TextField(
            controller: _doctorHomeScreenController.pastController,
            autofillHints: const [AutofillHints.name],
            onChanged: (value) {
              _doctorHomeScreenController.searchPastAppointment(value);
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
            onRefresh: _doctorHomeScreenController.getDoctorAppointmentsModel,
            child: SizedBox(
              height: double.maxFinite,
              child: GetBuilder<DoctorHomeScreenController>(
                builder: (controller) {
                  if (controller.doctorAppointmentsModelData.apiState ==
                      APIState.COMPLETE) {
                    return controller.pastAppointmentData.isEmpty
                        ? const Center(
                            child: Text(
                              "You have no appointments!",
                              style: TextStyle(fontSize: 21),
                            ),
                          )
                        : Builder(builder: (context) {
                            return ListView.separated(
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                height: 15,
                              ),
                              itemCount: controller.pastAppointmentData.length,
                              padding: const EdgeInsets.symmetric(
                                      vertical: 35, horizontal: 20)
                                  .copyWith(top: 10),
                              itemBuilder: (context, index) {
                                return PastAppointmentListItemDoctor(
                                    controller.pastAppointmentData[index]);
                              },
                            );
                          });
                  } else if (controller.doctorAppointmentsModelData.apiState ==
                          APIState.COMPLETE_WITH_NO_DATA &&
                      controller.pastAppointmentData.isEmpty) {
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
                    return const Center(
                      child: Text("Error"),
                    );
                  } else if (controller.doctorAppointmentsModelData.apiState ==
                      APIState.PROCESSING) {
                    return /*Center(
                      child: CircularProgressIndicator(),
                    )*/
                        Center(
                      child: Utils.circular(),
                    );
                  } else {
                    return Center(
                      child: Text(
                        "Nothing to show!",
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
