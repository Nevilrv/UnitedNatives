import 'package:doctor_appointment_booking/components/past_appointments_list_item_doctor.dart';
import 'package:doctor_appointment_booking/controller/doctor_homescreen_controller.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/utils/translate.dart';
import 'package:doctor_appointment_booking/model/api_state_enum.dart';
import 'package:doctor_appointment_booking/utils/constants.dart';
import 'package:doctor_appointment_booking/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PastAppointmentsPageDoctor extends StatefulWidget {
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
          padding: EdgeInsets.all(20).copyWith(bottom: 5),
          child: TextField(
            controller: _doctorHomeScreenController.pastController,
            autofillHints: [AutofillHints.name],
            onChanged: (value) {
              _doctorHomeScreenController.searchPastAppointment(value);
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
            onRefresh: _doctorHomeScreenController.getDoctorAppointmentsModel,
            child: Container(
              height: double.maxFinite,
              child: GetBuilder<DoctorHomeScreenController>(
                builder: (controller) {
                  if (controller.doctorAppointmentsModelData.apiState ==
                      APIState.COMPLETE) {
                    return controller.pastAppointmentData.isEmpty ?? true
                        ? Center(
                            child: Text(
                              "You have no appointments!",
                              style: TextStyle(fontSize: 21),
                            ),
                          )
                        : Builder(builder: (context) {
                            return ListView.separated(
                              separatorBuilder: (context, index) => SizedBox(
                                height: 15,
                              ),
                              itemCount:
                                  controller.pastAppointmentData.length ?? 0,
                              padding: EdgeInsets.symmetric(
                                      vertical: 35, horizontal: 20)
                                  .copyWith(top: 10),
                              itemBuilder: (context, index) {
                                return PastAppointmentListItemDoctor(
                                    controller.pastAppointmentData[index] ??
                                        "");
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
                            .headline6
                            .copyWith(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    );
                  } else if (controller.doctorAppointmentsModelData.apiState ==
                      APIState.ERROR) {
                    return Center(
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
                            .headline6
                            .copyWith(fontSize: 20),
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
