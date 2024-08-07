import 'package:doctor_appointment_booking/components/ads_bottom_bar.dart';
import 'package:doctor_appointment_booking/components/progress_indicator.dart';
import 'package:doctor_appointment_booking/controller/ads_controller.dart';
import 'package:doctor_appointment_booking/controller/book_appointment_controller.dart';
import 'package:doctor_appointment_booking/data/pref_manager.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/utils/translate.dart';
import 'package:doctor_appointment_booking/newModel/apiModel/responseModel/get_direct_doctor_response_model.dart';
import 'package:doctor_appointment_booking/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;

class TimeSlotPageDirectPage extends StatefulWidget {
  final Data doctorDetails;

  TimeSlotPageDirectPage({this.doctorDetails});

  @override
  State<TimeSlotPageDirectPage> createState() => _TimeSlotPageDirectPageState();
}

class _TimeSlotPageDirectPageState extends State<TimeSlotPageDirectPage> {
  final BookAppointmentController _bookAppointmentController =
      Get.put(BookAppointmentController());

  AdsController adsController = Get.find();
  Widget _slot() {
    return SizedBox();

    // return Obx(
    //   () {
    //     int i = -1;
    //     if (_bookAppointmentController.items.isNotEmpty) {
    //       _bookAppointmentController.items.forEach((element) {
    //         if (!(element <=
    //                 int.parse(
    //                     "${DateTime.now().toString().substring(11, 13)}") &&
    //             00 <
    //                 int.parse(
    //                     "${DateTime.now().toString().substring(14, 16)}") &&
    //             _bookAppointmentController.mySelectedDate.value ==
    //                 DateTime.now().toString().split(" ")[0])) {
    //           i = 0;
    //         }
    //       });
    //     }
    //     return _bookAppointmentController.items.isEmpty ||
    //             _bookAppointmentController.weekAvailabilityList
    //                     .where((p0) =>
    //                         p0.date ==
    //                         _bookAppointmentController.mySelectedDate.value
    //                             .toString())
    //                     .first
    //                     .actualSlotCount ==
    //                 0 ||
    //             i == -1
    //         ? Center(
    //             child: Text('No Time Slots Available!'),
    //           )
    //         : Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: <Widget>[
    //               Wrap(
    //                 children: List.generate(
    //                   _bookAppointmentController.items.length,
    //                   (index) {
    //                     int _temp = _bookAppointmentController.items[index];
    //                     return TimeSlotItem(
    //                       isClosed: _temp <=
    //                               int.parse(
    //                                   "${DateTime.now().toString().substring(11, 13)}") &&
    //                           00 <
    //                               int.parse(
    //                                   "${DateTime.now().toString().substring(14, 16)}") &&
    //                           _bookAppointmentController.mySelectedDate.value ==
    //                               DateTime.now().toString().split(" ")[0],
    //                       time: "${_temp > 12 ? _temp - 12 : _temp} : 00",
    //                       time1: "${_temp >= 12 ? 'PM' : 'AM'}",
    //                       onTap: () {
    //                         DateTime now = DateTime.now();
    //                         String todayDate = now.toString().split(" ")[0];
    //                         num todayHours = int.parse(
    //                             "${now.toString().substring(11, 13)}");
    //                         num todayMinutes = int.parse(
    //                             "${now.toString().substring(14, 16)}");
    //                         num _tempMinutes = 00;
    //                         if (_temp <= todayHours &&
    //                             _tempMinutes < todayMinutes &&
    //                             _bookAppointmentController
    //                                     .mySelectedDate.value ==
    //                                 todayDate) {
    //                           Utils.showSnackBar(title: "Booking is closed");
    //                         } else {
    //                           DirectDoctorModel navigationModel =
    //                               DirectDoctorModel(
    //                             doctorSpecialities: widget.doctorDetails,
    //                             mySelectedDate: _bookAppointmentController
    //                                 .mySelectedDate.value,
    //                             time: _temp,
    //                           );
    //                           Get.to(PatientDetailDirectAppointment(
    //                             navigationModel: navigationModel,
    //                             selctedSlot: "$_temp:00",
    //                             selectedDate:
    //                                 DateFormat('dd-MM-yyyy').format(now),
    //                           ));
    //                           print("_temp");
    //                           /*Get.toNamed(Routes.bookingStep4,
    //                           arguments: navigationModel);*/
    //                         }
    //                       },
    //                     );
    //                   },
    //                 ),
    //               ),
    //               // StaggeredGridView.countBuilder(
    //               //   padding: EdgeInsets.symmetric(horizontal: 10),
    //               //   crossAxisCount: 4,
    //               //   physics: NeverScrollableScrollPhysics(),
    //               //   shrinkWrap: true,
    //               //   itemCount: _bookAppointmentController.items.length,
    //               //   staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
    //               //   mainAxisSpacing: 10,
    //               //   crossAxisSpacing: 10,
    //               //   itemBuilder: (context, index) {
    //               //     int _temp = _bookAppointmentController.items[index];
    //               //     return TimeSlotItem(
    //               //       isClosed: _temp <=
    //               //               int.parse(
    //               //                   "${DateTime.now().toString().substring(11, 13)}") &&
    //               //           00 <
    //               //               int.parse(
    //               //                   "${DateTime.now().toString().substring(14, 16)}") &&
    //               //           _bookAppointmentController.mySelectedDate.value ==
    //               //               DateTime.now().toString().split(" ")[0],
    //               //       time: "${_temp > 12 ? _temp - 12 : _temp} : 00",
    //               //       time1: "${_temp >= 12 ? 'PM' : 'AM'}",
    //               //       onTap: () {
    //               //         DateTime now = DateTime.now();
    //               //         String todayDate = now.toString().split(" ")[0];
    //               //         num todayHours =
    //               //             int.parse("${now.toString().substring(11, 13)}");
    //               //         num todayMinutes =
    //               //             int.parse("${now.toString().substring(14, 16)}");
    //               //         num _tempMinutes = 00;
    //               //         if (_temp <= todayHours &&
    //               //             _tempMinutes < todayMinutes &&
    //               //             _bookAppointmentController.mySelectedDate.value ==
    //               //                 todayDate) {
    //               //           Utils.showSnackBar(title: "Booking is closed");
    //               //         } else {
    //               //           DirectDoctorModel navigationModel = DirectDoctorModel(
    //               //               doctorSpecialities: widget.doctorDetails,
    //               //               mySelectedDate: _bookAppointmentController
    //               //                   .mySelectedDate.value,
    //               //               time: _temp);
    //               //           Get.to(
    //               //             PatientDetailDirectAppointment(
    //               //               navigationModel: navigationModel,
    //               //               selctedSlot: "$_temp:00",
    //               //               selectedDate:
    //               //                   DateFormat('dd-MM-yyyy').format(now),
    //               //             ),
    //               //           );
    //               //           /*Get.toNamed(Routes.bookingStep4,
    //               //               arguments: navigationModel);*/
    //               //         }
    //               //       },
    //               //     );
    //               //   },
    //               // ),
    //             ],
    //           );
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    _bookAppointmentController.getPatientAppointment(
        widget.doctorDetails.userId, context);
    // _bookAppointmentController.getPatientAppointment(
    //     doctorDetails.userId, context);
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
                        // CircleAvatar(
                        //     radius: 20,
                        //     backgroundColor: Colors.transparent,
                        //     backgroundImage:
                        //         NetworkImage(doctorDetails?.profilePic??"")),

                        Utils().patientProfile(
                            widget.doctorDetails?.profilePic ?? "",
                            widget.doctorDetails?.socialProfilePic ?? "",
                            20),
                        SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                widget.doctorDetails?.firstName ?? "",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2
                                    .copyWith(fontWeight: FontWeight.w700),
                              ),
                              SizedBox(height: 3),
                              Text(
                                widget.doctorDetails?.speciality ?? "",
                                style: TextStyle(
                                    color: Colors.grey[350], fontSize: 14),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 90,
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    color: Prefs.getBool(Prefs.DARKTHEME, def: false)
                        ? Colors.white.withOpacity(0.12)
                        : Colors.grey[300],
                    // child: Obx(
                    //   () => ListView.separated(
                    //     separatorBuilder: (context, index) =>
                    //         SizedBox(width: 10),
                    //     padding: EdgeInsets.symmetric(horizontal: 10),
                    //     scrollDirection: Axis.horizontal,
                    //     shrinkWrap: true,
                    //     itemCount: _bookAppointmentController
                    //             .weekAvailabilityList.length ??
                    //         0,
                    //     itemBuilder: (context, index) {
                    //       WeekAvailability _weekAvailability =
                    //           _bookAppointmentController
                    //               .weekAvailabilityList[index];
                    //       return DateFormat('dd-MM-yyyy').format(DateTime.now()
                    //                   .subtract(Duration(days: 1))) !=
                    //               DateFormat('dd-MM-yyyy').format(
                    //                   DateTime.parse(_weekAvailability.date))
                    //           ? DaySlotItem(
                    //               date: '${_weekAvailability?.date}' ?? '',
                    //               slot: _weekAvailability.availableSlotCount,
                    //               onTap: () {
                    //                 _bookAppointmentController.mySelectedDate
                    //                     .value = _weekAvailability.date;
                    //                 _bookAppointmentController
                    //                     .selectedIndex.value = index;
                    //                 _bookAppointmentController.filterData();
                    //               },
                    //               index: index)
                    //           : SizedBox(width: 0);
                    //     },
                    //   ),
                    // ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child:
                          _bookAppointmentController.selectedIndex.value == -1
                              ? Text(
                                  'Select DateTime to Show Available Slot',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )
                              : Obx(
                                  () => Text(
                                    '${DateFormat('EEEE, dd MMM yyyy').format(DateTime.parse(_bookAppointmentController.mySelectedDate.value))}',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                    ),
                  ),
                  Obx(
                    () => _bookAppointmentController.selectedIndex.value == -1
                        ? LinearProgressIndicator()
                        : Divider(color: Colors.grey, height: 1),
                  ),
                  SizedBox(height: 10),
                  Obx(
                    () => _bookAppointmentController.selectedIndex.value == -1
                        ? Container()
                        : Center(
                            child: _slot(),
                          ),
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
