import 'package:doctor_appointment_booking/controller/doctor_homescreen_controller.dart';
import 'package:doctor_appointment_booking/model/api_state_enum.dart';
import 'package:doctor_appointment_booking/model/doctor_get_doctor_Appointments_model.dart';
import 'package:doctor_appointment_booking/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:intl/intl.dart';
import '../../components/custom_profile_item.dart';
import '../../routes/routes.dart';

class PatientVisitPage extends StatefulWidget {
  @override
  _PatientVisitPageState createState() => _PatientVisitPageState();
}

class _PatientVisitPageState extends State<PatientVisitPage> {
  // with AutomaticKeepAliveClientMixin<PatientVisitPage>
  DoctorHomeScreenController _doctorHomeScreenController =
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
            child: controller.doctorAppointmentsModelData?.past?.isEmpty ?? true
                ? Center(
                    child: Container(
                      child: Text(
                        'Nothing to Show!',
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    primary: false,
                    itemCount:
                        controller.doctorAppointmentsModelData?.past?.length ??
                            0,
                    itemBuilder: (BuildContext context, int index) {
                      var _pastAppointmentsDoctor =
                          controller.doctorAppointmentsModelData?.past[index];
                      DateTime appointmentDate = Utils.formattedDate(
                          '${DateTime.parse('${_pastAppointmentsDoctor.appointmentDate} ${_pastAppointmentsDoctor.appointmentTime}')}');

                      return Column(
                        children: [
                          VisitItem(
                            date:
                                '${DateFormat('MMM dd').format(appointmentDate) ?? ""}',
                            time:
                                '${DateFormat('hh:mm a').format(appointmentDate)}',
                            child: GestureDetector(
                              onTap: () {
                                Get.toNamed(Routes.patientvistpage,
                                    arguments: _pastAppointmentsDoctor);
                              },
                              child: CustomProfileItem(
                                onTap: () {
                                  Get.toNamed(Routes.patientvistpage,
                                      arguments: _pastAppointmentsDoctor);
                                },
                                title:
                                    '${_pastAppointmentsDoctor.patientFirstName} ${_pastAppointmentsDoctor.patientLastName}',
                                subTitle:
                                    '${_pastAppointmentsDoctor.purposeOfVisit}',
                                buttonTitle: 'See Full Reports',
                                imagePath:
                                    '${_pastAppointmentsDoctor.patientProfilePic}',
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      );
                    }),
          );
        } else if (controller.doctorAppointmentsModelData.apiState ==
            APIState.COMPLETE_WITH_NO_DATA) {
          return Center(
            child: Container(
              child: Text(
                'Nothing to Show!',
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
          );
        } else if (controller.doctorAppointmentsModelData.apiState ==
            APIState.ERROR) {
          return Center(child: Text("Error"));
        } else if (controller.doctorAppointmentsModelData.apiState ==
            APIState.PROCESSING) {
          return Container(
              // child: Center(
              //   child: CircularProgressIndicator(),
              // ),
              child: Center(
            child: Utils.circular(),
          ));
        } else {
          return Center(
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
      {Key key, @required this.date, @required this.time, @required this.child})
      : super(key: key);

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
                  .subtitle2
                  .copyWith(fontWeight: FontWeight.w700, fontSize: 18),
            ),
            Text(
              time,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
            )
          ],
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: child,
        ),
      ],
    );
  }
}
