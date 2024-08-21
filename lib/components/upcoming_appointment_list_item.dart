import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:united_natives/controller/patient_homescreen_controller.dart';
import 'package:united_natives/medicle_center/lib/utils/translate.dart';
import 'package:united_natives/model/appointment.dart';
import 'package:united_natives/utils/utils.dart';

import 'custom_outline_button.dart';

class UpcomingAppointmentListItem extends StatelessWidget {
  final Appointment patientAppoint;

  UpcomingAppointmentListItem(this.patientAppoint, {super.key});

  final PatientHomeScreenController _patientHomeScreenController = Get.find();

  @override
  Widget build(BuildContext context) {
    final time = Utils.formattedDate(
        '${DateTime.parse('${patientAppoint.appointmentDate} ${patientAppoint.appointmentTime}')}');

    return Card(
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: _buildColumn(
                          context: context,
                          title: Translate.of(context)!.translate('date'),
                          subtitle:
                              '${DateFormat('EEEE, dd MMM yyyy').format(time)} ',
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: _buildColumn(
                          context: context,
                          title: Translate.of(context)!.translate('time'),
                          subtitle: DateFormat('hh:mm a').format(time),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                  indent: 10,
                  endIndent: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: _buildColumn(
                          context: context,
                          title: 'Doctor Name',
                          subtitle:
                              '${patientAppoint.doctorFirstName} ${patientAppoint.doctorLastName}',
                        ),
                      ),
                      Expanded(
                        child: _buildColumn(
                          context: context,
                          title: 'Speciality',
                          subtitle: '${patientAppoint.doctorSpeciality}',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          if (patientAppoint.appointmentStatus != '1')
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Column(
                  children: <Widget>[
                    // Container(
                    //   width: double.infinity,
                    //   child: CustomButton(
                    //     text: 'Start'.tr(),
                    //     textSize: 14,
                    //     onPressed: (){
                    //
                    //     },
                    //     padding: EdgeInsets.symmetric(
                    //       vertical: 10,
                    //     ),
                    //   ),
                    // ),

                    /*  Container(
                    width: double.infinity,
                    child: CustomButton(
                      text: 'View Prescription12',
                      textSize: 14,
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(Routes.prescriptionDetail);
                      },
                      padding: EdgeInsets.symmetric(
                        vertical: 13,
                      ),
                    ),
                  ),*/
                    GetBuilder<PatientHomeScreenController>(
                        builder: (controller) {
                      return SizedBox(
                        width: double.infinity,
                        child: patientAppoint.appointmentStatus == '1'
                            ? const SizedBox()
                            : patientAppoint.appointmentStatus == '3'
                                ? CustomOutlineButton(
                                    text: 'Cancelled',
                                    textSize: 14,
                                    onPressed: () {},
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                  )
                                : CustomOutlineButton(
                                    text: Translate.of(context)!
                                        .translate('cancel'),
                                    textSize: 14,
                                    onPressed: () =>
                                        _showAlert(context, () async {
                                      Navigator.of(context).pop();
                                      await _patientHomeScreenController
                                          .cancelAppointmentPatient(
                                              "${patientAppoint.patientId}",
                                              patientAppoint.id);
                                      _patientHomeScreenController
                                          .getVisitedDoctors();
                                    }),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                  ),
                      );
                    }),
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }

  Column _buildColumn({
    required BuildContext context,
    required String title,
    required subtitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }
}

_showAlert(BuildContext context, Function()? onPressed) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          'Cancel Client Appointment',
          style: TextStyle(fontSize: 22),
        ),
        content: const Text(
          "Are You Sure Want To Proceed ?",
          style: TextStyle(fontSize: 20),
        ),
        actions: <Widget>[
          MaterialButton(
              onPressed: onPressed,
              child: const Text(
                "Yes",
                style: TextStyle(fontSize: 20),
              )),
          MaterialButton(
            child: const Text(
              "No",
              style: TextStyle(fontSize: 20),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

onAlertWithCustomContentPressed(context) {
  Alert(
    context: context,
    image: const Image(
      image: AssetImage('assets/images/Doctor.gif'),
    ),
    title: "Coming Soon",
    content: const Column(
      children: <Widget>[],
    ),
    buttons: [
      DialogButton(
        onPressed: () => Navigator.pop(context),
        child: const Text(
          "Okay",
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
      )
    ],
  ).show();
}
