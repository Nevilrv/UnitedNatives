import 'package:doctor_appointment_booking/components/ads_bottom_bar.dart';
import 'package:doctor_appointment_booking/components/day_slot_item.dart';
import 'package:doctor_appointment_booking/components/progress_indicator.dart';
import 'package:doctor_appointment_booking/components/time_slot_item.dart';
import 'package:doctor_appointment_booking/controller/ads_controller.dart';
import 'package:doctor_appointment_booking/controller/book_appointment_controller.dart';
import 'package:doctor_appointment_booking/data/pref_manager.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/utils/translate.dart';
import 'package:doctor_appointment_booking/model/doctor_by_specialities.dart';
import 'package:doctor_appointment_booking/model/patient_appointment_model.dart';
import 'package:doctor_appointment_booking/routes/routes.dart';
import 'package:doctor_appointment_booking/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;

class TimeSlotPage extends StatefulWidget {
  final DoctorSpecialities doctorDetails;

  TimeSlotPage({this.doctorDetails});

  @override
  State<TimeSlotPage> createState() => _TimeSlotPageState();
}

class _TimeSlotPageState extends State<TimeSlotPage> {
  final BookAppointmentController _bookAppointmentController = Get.find();

  AdsController adsController = Get.find();
  Widget _slot() {
    return Obx(
      () {
        // int i = -1;

        // if (_bookAppointmentController.items.isNotEmpty) {
        //   _bookAppointmentController.items.forEach((element) {
        //     if (!(int.parse(
        //                 element["start_time"].toString().split(":").first) <=
        //             int.parse(
        //                 "${DateTime.now().toString().substring(11, 13)}") &&
        //         00 <
        //             int.parse(
        //                 "${DateTime.now().toString().substring(14, 16)}") &&
        //         _bookAppointmentController.mySelectedDate.value ==
        //             DateTime.now().toString().split(" ")[0])) {
        //       i = 0;
        //     }
        //   });
        // }

        return _bookAppointmentController.items.isEmpty ||
                _bookAppointmentController.weekAvailabilityList
                        .where((p0) =>
                            DateFormat("yyyy-MM-dd").format(p0.date) ==
                            DateFormat("yyyy-MM-dd").format(DateTime.parse(
                                _bookAppointmentController
                                    .mySelectedDate.value)))
                        .first
                        .actualSlotCount ==
                    0 /*||
                i == -1*/

            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text(
                    'No Time Slots Available!',
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(fontSize: 20),
                  ),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Wrap(
                    children: List.generate(
                        _bookAppointmentController.items.length, (index) {
                      int _temp = int.parse(_bookAppointmentController
                          .items[index]["start_time"]
                          .toString()
                          .split(":")
                          .first);
                      int _tempMinute = int.parse(_bookAppointmentController
                          .items[index]["start_time"]
                          .toString()
                          .split(":")
                          .last);

                      return TimeSlotItem(
                        isClosed: _temp <=
                                int.parse(
                                    "${DateTime.now().toString().substring(11, 13)}") &&
                            _tempMinute <
                                int.parse(
                                    "${DateTime.now().toString().substring(14, 16)}") &&
                            _bookAppointmentController.mySelectedDate.value ==
                                DateTime.now().toString().split(" ")[0],
                        time:
                            "${_temp == 0 ? "12" : _temp > 12 ? _temp - 12 : _temp} : ${_tempMinute == 0 ? "00" : _tempMinute}",
                        time1: "${_temp >= 12 ? 'PM' : 'AM'}",
                        onTap: () {
                          // DateTime now = DateTime.now();
                          // String todayDate = now.toString().split(" ")[0];
                          // num todayHours =
                          //     int.parse("${now.toString().substring(11, 13)}");
                          // num todayMinutes =
                          //     int.parse("${now.toString().substring(14, 16)}");
                          // num _tempMinutes = 00;
                          // print('SLOT>>>>>>> $_temp ${now.hour}');

                          // if (_temp <= todayHours &&
                          //     _tempMinutes < todayMinutes &&
                          //     _bookAppointmentController.mySelectedDate.value ==
                          //         todayDate) {
                          //   Utils.showSnackBar(
                          //       title: "Booking Closed",
                          //       message:
                          //           "Bookings are closed for elapsed time");
                          // } else {
                          NavigationModel navigationModel = NavigationModel(
                            utcDateTime:
                                "${DateFormat("yyyy-MM-dd").format(DateTime.parse(_bookAppointmentController.mySelectedDate.value))} ${_temp.toString().length == 1 ? "0$_temp" : _temp}:${_tempMinute == 0 ? "00" : _tempMinute}",
                            doctorSpecialities: widget.doctorDetails,
                            mySelectedDate:
                                _bookAppointmentController.mySelectedDate.value,
                            minute: _tempMinute,
                            time: _temp,
                          );
                          Get.toNamed(Routes.bookingStep4,
                              arguments: navigationModel);
                          // }
                        },
                      );
                    }),
                  ),

                  // StaggeredGridView.countBuilder(
                  //   padding: EdgeInsets.symmetric(horizontal: 10),
                  //   crossAxisCount: 4,
                  //   physics: NeverScrollableScrollPhysics(),
                  //   shrinkWrap: true,
                  //   itemCount: _bookAppointmentController.items.length,
                  //   staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
                  //   mainAxisSpacing: 10,
                  //   crossAxisSpacing: 10,
                  //   itemBuilder: (context, index) {
                  //     int _temp = _bookAppointmentController.items[index];
                  //
                  //     return TimeSlotItem(
                  //       isClosed: _temp <=
                  //               int.parse(
                  //                   "${DateTime.now().toString().substring(11, 13)}") &&
                  //           00 <
                  //               int.parse(
                  //                   "${DateTime.now().toString().substring(14, 16)}") &&
                  //           _bookAppointmentController.mySelectedDate.value ==
                  //               DateTime.now().toString().split(" ")[0],
                  //       time: "${_temp > 12 ? _temp - 12 : _temp} : 00",
                  //       time1: "${_temp >= 12 ? 'PM' : 'AM'}",
                  //       onTap: () {
                  //         DateTime now = DateTime.now();
                  //         String todayDate = now.toString().split(" ")[0];
                  //         num todayHours =
                  //             int.parse("${now.toString().substring(11, 13)}");
                  //         num todayMinutes =
                  //             int.parse("${now.toString().substring(14, 16)}");
                  //         num _tempMinutes = 00;
                  //         print('SLOT>>>>>>> $_temp ${now.hour}');
                  //
                  //         if (_temp <= todayHours &&
                  //             _tempMinutes < todayMinutes &&
                  //             _bookAppointmentController.mySelectedDate.value ==
                  //                 todayDate) {
                  //           Utils.showSnackBar(
                  //               title: "Booking Closed",
                  //               message: "Bookings are closed for elapsed time");
                  //         } else {
                  //           NavigationModel navigationModel = NavigationModel(
                  //             doctorSpecialities: widget.doctorDetails,
                  //             mySelectedDate:
                  //                 _bookAppointmentController.mySelectedDate.value,
                  //             time: _temp,
                  //           );
                  //           Get.toNamed(
                  //             Routes.bookingStep4,
                  //             arguments: navigationModel,
                  //           );
                  //         }
                  //       },
                  //     );
                  //   },
                  // ),
                ],
              );
      },
    );
  }

  @override
  void initState() {
    DateTime now = DateTime.now();
    _bookAppointmentController.mySelectedDate.value =
        "${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _bookAppointmentController.getPatientAppointment(
          widget.doctorDetails.userId, context);
    });

    super.initState();
  }

  // getAppointmentData() async {
  //   await _doctorHomeScreenController
  //       .getDoctorAppointmentsDOCID(widget.doctorDetails?.id.toString());
  //   print('--------1--------->>>>>>>>');
  //   if (_doctorHomeScreenController.doctorAppointmentsModelData.apiState ==
  //       APIState.COMPLETE) {
  //     print('--------2--------->>>>>>>>');
  //     int i = 0;
  //     _doctorHomeScreenController.doctorAppointmentsModelData?.upcoming
  //         ?.forEach((element) {
  //       if (element.appointmentDate ==
  //           _bookAppointmentController.mySelectedDate.value) {
  //         print('----------------->>>>>>>>${i++}');
  //       }
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GetBuilder<AdsController>(builder: (ads) {
          return Scaffold(
            bottomNavigationBar: AdsBottomBar(
              ads: ads,
              context: context,
            ),
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                Translate.of(context).translate('time_slot'),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.subtitle1.color,
                    fontSize: 24),
                textAlign: TextAlign.center,
              ),
            ),
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: <Widget>[
                        Utils().patientProfile(
                            widget.doctorDetails?.profilePic ?? "",
                            widget.doctorDetails?.socialProfilePic ?? "",
                            25),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                widget.doctorDetails?.firstName ?? "",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2
                                    .copyWith(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                widget.doctorDetails?.speciality ?? "",
                                style: TextStyle(
                                  color: Colors.grey[450],
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 85,
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    color: Prefs.getBool(Prefs.DARKTHEME, def: false)
                        ? Colors.white.withOpacity(0.12)
                        : Colors.grey[300],
                    child: Obx(
                      () => ListView.separated(
                        separatorBuilder: (context, index) =>
                            SizedBox(width: 10),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: _bookAppointmentController
                                    .weekAvailabilityList.length >
                                7
                            ? 7
                            : _bookAppointmentController
                                    .weekAvailabilityList.length ??
                                0,
                        itemBuilder: (context, index) {
                          WeekAvailability _weekAvailability =
                              _bookAppointmentController
                                  .weekAvailabilityList[index + 1];

                          return DateFormat('dd-MM-yyyy').format(DateTime.now()
                                      .subtract(Duration(days: 1))) !=
                                  DateFormat('dd-MM-yyyy').format(
                                      DateTime.parse(_weekAvailability.date
                                          .toLocal()
                                          .toString()))
                              ? DaySlotItem(
                                  date: '${_weekAvailability?.date}' ?? '',
                                  slot: _weekAvailability.actualSlotCount,
                                  onTap: () {
                                    _bookAppointmentController
                                            .mySelectedDate.value =
                                        _weekAvailability.date
                                            .toLocal()
                                            .toString();

                                    _bookAppointmentController
                                        .selectedIndex.value = index;
                                    _bookAppointmentController.filterData();
                                  },
                                  index: index,
                                )
                              : SizedBox(width: 0);
                        },
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: _bookAppointmentController
                              .mySelectedDate.value.isEmpty
                          ? Text(
                              'Select DateTime to Show Available Slot',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : Obx(
                              () => Text(
                                '${DateFormat('EEEE, dd MMM yyyy').format(DateTime.parse(_bookAppointmentController.mySelectedDate.value))}',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                    ),
                  ),
                  Obx(
                    () => _bookAppointmentController.selectedIndex.value == -1
                        ? LinearProgressIndicator()
                        : Divider(
                            color: Colors.grey,
                            height: 1,
                            // indent: 15,
                            // endIndent: 15,
                          ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Obx(
                    () => _bookAppointmentController.selectedIndex.value == -1
                        ? Container()
                        : Center(child: _slot()),
                  ),
                ],
              ),
            ),
          );
        }),
        Obx(
          () => Container(
            child: _bookAppointmentController.isLoading.value
                ? ProgressIndicatorScreen()
                : Container(),
          ),
        ),
      ],
    );
  }
}
