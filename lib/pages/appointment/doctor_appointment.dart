import 'package:doctor_appointment_booking/components/ads_bottom_bar.dart';
import 'package:doctor_appointment_booking/controller/ads_controller.dart';
import 'package:doctor_appointment_booking/controller/doctor_homescreen_controller.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/utils/translate.dart';
import 'package:doctor_appointment_booking/pages/appointment/past_appointments_page_doctor.dart';
import 'package:doctor_appointment_booking/pages/appointment/upcoming_appointments_page_doctor.dart';
import 'package:doctor_appointment_booking/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;

import '../../utils/constants.dart';

class MyAppointmentsDoctor extends StatefulWidget {
  @override
  _MyAppointmentsDoctorState createState() => _MyAppointmentsDoctorState();
}

class _MyAppointmentsDoctorState extends State<MyAppointmentsDoctor> {
  static const _kTabTextStyle = TextStyle(
    color: kColorPrimaryDark,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
  );

  static const _kUnselectedTabTextStyle = TextStyle(
    color: Colors.grey,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
  );

  DoctorHomeScreenController doctorHomeScreenController =
      Get.find<DoctorHomeScreenController>()..getDoctorAppointmentsModel();

  AdsController adsController = Get.find();
  DoctorHomeScreenController _doctorHomeScreenController =
      Get.put(DoctorHomeScreenController());

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   _doctorHomeScreenController.pastAppointmentData = [];
  //   super.dispose();
  // }

  ///For calender
  // List<Meeting> _getDataSource() {
  //   final List<Meeting> meetings = <Meeting>[];
  //   print(
  //       '===>${_doctorHomeScreenController.doctorAppointmentsModelData?.upcoming?.length}');
  //
  //   try {
  //     _doctorHomeScreenController.doctorAppointmentsModelData?.upcoming
  //         ?.forEach((element) {
  //       print('--element.patientFirstName--${element.patientFirstName}');
  //
  //       if (element.appointmentStatus != '1') return;
  //
  //       String stringDatetime =
  //           element.appointmentDate + ' ' + element.appointmentTime;
  //
  //       final DateTime startTime = DateTime.parse(stringDatetime);
  //       final DateTime endTime = startTime.add(const Duration(hours: 1));
  //       meetings.add(Meeting('${element.patientFirstName}', startTime, endTime,
  //           const Color(0xFF0F8644), false));
  //     });
  //   } catch (e) {
  //     print('ERROR====>${e}');
  //   }
  //   return meetings;
  // }

  @override
  Widget build(BuildContext context) {
    debugPrint(
        '_doctorHomeScreenController==========>>>>>$_doctorHomeScreenController');
    print('hello...');

    return GetBuilder<AdsController>(builder: (ads) {
      return Scaffold(
        bottomNavigationBar: AdsBottomBar(
          ads: ads,
          context: context,
        ),
        appBar: AppBar(
          title: Text(
            Translate.of(context).translate('my_appointments'),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.subtitle1.color,
              fontSize: 24,
            ),
            textAlign: TextAlign.center,
          ),
          elevation: 0,
          actions: [
            // if (_doctorHomeScreenController
            //         .doctorAppointmentsModelData?.upcoming?.isNotEmpty ??
            //     false)

            ///For calender
            // IconButton(
            //   onPressed: () {
            //     showDialog(
            //       context: context,
            //       builder: (context) {
            //         return Container(
            //           color: Colors.white,
            //           height: 500,
            //           width: 250,
            //           padding: EdgeInsets.all(20).copyWith(right: 0),
            //           child: Column(
            //             mainAxisSize: MainAxisSize.max,
            //             children: [
            //               Row(
            //                 mainAxisSize: MainAxisSize.max,
            //                 crossAxisAlignment: CrossAxisAlignment.end,
            //                 children: [
            //                   Expanded(
            //                     child: Text(
            //                       'Calender',
            //                       style: TextStyle(
            //                         fontFamily: 'Roboto',
            //                         color: kColorPrimary,
            //                         fontSize: 20,
            //                         fontWeight: FontWeight.normal,
            //                         decoration: TextDecoration.none,
            //                       ),
            //                     ),
            //                   ),
            //                   GestureDetector(
            //                     onTap: () {
            //                       Get.back();
            //                     },
            //                     child: Icon(
            //                       Icons.close,
            //                     ),
            //                   ),
            //                   SizedBox(width: 20),
            //                 ],
            //               ),
            //               SizedBox(height: 20),
            //               Flexible(
            //                 child: SfCalendar(
            //                   view: CalendarView.month,
            //                   initialSelectedDate: DateTime.now(),
            //                   initialDisplayDate: DateTime.now(),
            //                   dataSource: MeetingDataSource(_getDataSource()),
            //                   // by default the month appointment display mode set as Indicator, we can
            //                   // change the display mode as appointment using the appointment display
            //                   // mode property
            //                   monthViewSettings: const MonthViewSettings(
            //                       appointmentDisplayMode:
            //                           MonthAppointmentDisplayMode.appointment),
            //                 ),
            //               ),
            //             ],
            //           ),
            //         );
            //       },
            //     );
            //   },
            //   icon: Icon(
            //     Icons.calendar_today_outlined,
            //   ),
            // ),
          ],
        ),
        body: DefaultTabController(
          length: 2,
          child: Column(
            children: <Widget>[
              TabBar(
                indicatorColor: kColorPrimary,
                labelStyle: _kTabTextStyle,
                unselectedLabelStyle: _kUnselectedTabTextStyle,
                labelColor: kColorPrimary,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(
                    text: Translate.of(context).translate('upcoming'),
                  ),
                  Tab(
                    text: Translate.of(context).translate('past'),
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    UpcomingAppointmentsPageDoctor(),
                    PastAppointmentsPageDoctor(),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

///For calender
// class MeetingDataSource extends CalendarDataSource {
//   /// Creates a meeting data source, which used to set the appointment
//   /// collection to the calendar
//   MeetingDataSource(List<Meeting> source) {
//     appointments = source;
//   }
//
//   @override
//   DateTime getStartTime(int index) {
//     return _getMeetingData(index).from;
//   }
//
//   @override
//   DateTime getEndTime(int index) {
//     return _getMeetingData(index).to;
//   }
//
//   @override
//   String getSubject(int index) {
//     return _getMeetingData(index).patientName;
//   }
//
//   @override
//   Color getColor(int index) {
//     return _getMeetingData(index).background;
//   }
//
//   @override
//   bool isAllDay(int index) {
//     return _getMeetingData(index).isAllDay;
//   }
//
//   Meeting _getMeetingData(int index) {
//     final dynamic meeting = appointments[index];
//     Meeting meetingData;
//     if (meeting is Meeting) {
//       meetingData = meeting;
//     }
//
//     return meetingData;
//   }
// }
//
// class Meeting {
//   /// Creates a meeting class with required details.
//   Meeting(this.patientName, this.from, this.to, this.background, this.isAllDay);
//
//   /// Event name which is equivalent to subject property of [Appointment].
//   String patientName;
//
//   /// From which is equivalent to start time property of [Appointment].
//   DateTime from;
//
//   /// To which is equivalent to end time property of [Appointment].
//   DateTime to;
//
//   /// Background which is equivalent to color property of [Appointment].
//   Color background;
//
//   /// IsAllDay which is equivalent to isAllDay property of [Appointment].
//   bool isAllDay;
// }
