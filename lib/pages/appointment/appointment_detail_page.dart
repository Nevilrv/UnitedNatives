import 'package:doctor_appointment_booking/components/custom_button.dart';
import 'package:doctor_appointment_booking/controller/book_appointment_controller.dart';
import 'package:doctor_appointment_booking/data/pref_manager.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/utils/translate.dart';
import 'package:doctor_appointment_booking/model/doctor_by_specialities.dart';
import 'package:doctor_appointment_booking/routes/routes.dart';
import 'package:doctor_appointment_booking/utils/utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'my_appointments_page.dart';

class AppointmentDetailPage extends StatefulWidget {
  final NavigationModel navigationModel;

  AppointmentDetailPage({this.navigationModel});

  @override
  _AppointmentDetailPageState createState() => _AppointmentDetailPageState();
}

BookAppointmentController _bookAppointmentController =
    Get.find<BookAppointmentController>();

class _AppointmentDetailPageState extends State<AppointmentDetailPage> {
  final bool _isdark = Prefs.getBool(Prefs.DARKTHEME, def: false);

  Widget dateAndTime() {
    return Container(
      width: double.infinity,
      color: _isdark ? Colors.white.withOpacity(0.12) : Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 15),
            Text(
              Translate.of(context).translate('date_and_time'),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 10),
            Text(
              // '${DateFormat('EEEE, dd MMM yyyy').format(DateTime.parse(
              //   _bookAppointmentController?.specificAppointmentDetailsData?.value
              //       ?.specificAppointmentDetailsData?.appointmentDate??'',
              // ))}, ${_bookAppointmentController?.specificAppointmentDetailsData?.value?.specificAppointmentDetailsData?.appointmentTime??''}',
              "${Utils.formattedDate(
                '${_bookAppointmentController.specificAppointmentDetailsData.value.specificAppointmentDetailsData.appointmentDate}, ${_bookAppointmentController.specificAppointmentDetailsData.value.specificAppointmentDetailsData.appointmentTime}',
              )}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            // Text(
            //   '${'in'.tr()} 13 ${'hours'.tr()}',
            //   style: TextStyle(
            //     fontSize: 14,
            //     fontWeight: FontWeight.w400,
            //   ),
            // ),
            SizedBox(height: 5),
          ],
        ),
      ),
    );
  }

  // Widget practiceDetail() {
  //   return Container(
  //     width: double.infinity,
  //     color: _isdark ? Colors.white.withOpacity(0.12) : Colors.white,
  //     child: Padding(
  //       padding: EdgeInsets.symmetric(horizontal: 15),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: <Widget>[
  //           SizedBox(
  //             height: 15,
  //           ),
  //           Text(
  //             'practice_detail'.tr(),
  //             style: TextStyle(
  //               fontSize: 14,
  //               fontWeight: FontWeight.w400
  //             ),
  //           ),
  //           SizedBox(
  //             height: 10,
  //           ),
  //           Text(
  //             'YourHealth Medical Centre',
  //             style: TextStyle(
  //               fontSize: 16,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //           Text(
  //             '3719  Jehovah Drive, Roanoke, Virginia - 24011',
  //             style: TextStyle(
  //               fontSize: 14,
  //               fontWeight: FontWeight.w400
  //             ),
  //           ),
  //           SizedBox(
  //             height: 10,
  //           ),
  //           InkWell(
  //             onTap: () {},
  //             child: Text(
  //               'get_direction'.tr().toUpperCase(),
  //               style: TextStyle(
  //                 color: kColorBlue,
  //                 fontSize: 14,
  //                 fontWeight: FontWeight.bold
  //               ),
  //             ),
  //           ),
  //           SizedBox(
  //             height: 5,
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget procedure() {
    return Container(
      width: double.infinity,
      color: _isdark ? Colors.white.withOpacity(0.12) : Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 15),
            Text(
              Translate.of(context).translate('procedure'),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 10),
            Text(
              _bookAppointmentController?.specificAppointmentDetailsData?.value
                      ?.specificAppointmentDetailsData?.purposeOfVisit ??
                  '',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
          ],
        ),
      ),
    );
  }

  Widget bookingDetails() {
    return Container(
      width: double.infinity,
      color: _isdark ? Colors.white.withOpacity(0.12) : Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: <Widget>[
          SizedBox(height: 15),
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      Translate.of(context).translate('booked_for'),
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: 10),
                    Text(
                      _bookAppointmentController
                              ?.specificAppointmentDetailsData
                              ?.value
                              ?.specificAppointmentDetailsData
                              ?.appointmentFor ??
                          '',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Container(
                height: 80,
                child: VerticalDivider(
                    color: _isdark ? Colors.black : Colors.grey[300],
                    width: 0.5),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        Translate.of(context).translate('appointment_id'),
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400),
                      ),
                      SizedBox(height: 10),
                      Text(
                        _bookAppointmentController
                                ?.specificAppointmentDetailsData
                                ?.value
                                ?.specificAppointmentDetailsData
                                ?.id ??
                            '',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          Translate.of(context).translate('appointment_details'),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                color: _isdark ? Colors.transparent : Colors.grey[300],
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        color: _isdark ? Colors.transparent : Colors.white,
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: Row(
                            children: <Widget>[
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.transparent,
                                backgroundImage: AssetImage(
                                  'assets/images/doctor_profile.jpg',
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      _bookAppointmentController
                                              ?.specificAppointmentDetailsData
                                              ?.value
                                              ?.specificAppointmentDetailsData
                                              ?.doctorFirstName ??
                                          '',
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2
                                          .copyWith(
                                              fontWeight: FontWeight.w700),
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      _bookAppointmentController
                                              ?.specificAppointmentDetailsData
                                              ?.value
                                              ?.specificAppointmentDetailsData
                                              ?.doctorSpeciality ??
                                          '',
                                      style: TextStyle(
                                          color: Colors.grey[350],
                                          fontSize: 14),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Divider(
                          color: _isdark ? Colors.black : Colors.grey[300],
                          height: 0.5),
                      dateAndTime(),
                      Divider(
                          color: _isdark ? Colors.black : Colors.grey[300],
                          height: 0.5),
                      // practiceDetail(),
                      // Divider(
                      //   color: _isdark ? Colors.black : Colors.grey[300],
                      //   height: 0.5,
                      // ),
                      procedure(),
                      Divider(
                        color: _isdark ? Colors.black : Colors.grey[300],
                        height: 0.5,
                      ),
                      bookingDetails(),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text:
                                    '${Translate.of(context).translate('manage_you_appointments_better')} ',
                                style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400),
                              ),
                              TextSpan(
                                text: Translate.of(context)
                                    .translate('my_appointments'),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            MyAppointmentsPage(),
                                      ),
                                    );
                                  },
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    decoration: TextDecoration.underline),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: CustomButton(
                textSize: 24,
                onPressed: () {
                  // Navigator.of(context).pushNamed(Routes.home);
                  Get.offAllNamed(Routes.home);
                },
                text: Translate.of(context).translate('done'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
