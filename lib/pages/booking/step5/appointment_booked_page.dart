import 'package:doctor_appointment_booking/controller/book_appointment_controller.dart';
import 'package:doctor_appointment_booking/controller/patient_homescreen_controller.dart';
import 'package:doctor_appointment_booking/controller/user_controller.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/utils/translate.dart';
import 'package:doctor_appointment_booking/model/doctor_by_specialities.dart';
import 'package:doctor_appointment_booking/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import '../../../components/custom_button.dart';
import '../../../routes/routes.dart';
import '../../../utils/constants.dart';

class AppointmentBookedPage extends StatefulWidget {
  final NavigationModel navigationModel;

  AppointmentBookedPage({this.navigationModel});

  @override
  _AppointmentBookedPageState createState() => _AppointmentBookedPageState();
}

class _AppointmentBookedPageState extends State<AppointmentBookedPage> {
  BookAppointmentController _bookAppointmentController = Get.find();

  PatientHomeScreenController _patientHomeScreenController = Get.find();
  UserController _userController = Get.find();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorDarkBlue,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(top: 100),
          width: double.infinity,
          child: Column(
            children: <Widget>[
              Image.asset('assets/images/thumb_success.png'),
              SizedBox(height: 60),
              Text(
                Translate.of(context).translate('appointment_booked'),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                Translate.of(context)
                    .translate('your_appointment_is_confirmed'),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                ),
                textAlign: TextAlign.center,
              ),
              Expanded(
                child: SizedBox(
                  height: 20,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: isLoading
                    // ? Center(
                    //     child: CircularProgressIndicator(
                    //     strokeWidth: 1,
                    //   ))
                    ? Container(
                        height: 60,
                        child: Center(
                          child: Utils.circular(height: 60),
                        ),
                      )
                    : CustomButton(
                        textSize: 24,
                        onPressed: () async {
                          print(
                              "Patient==>Appoinmentid==> ${_patientHomeScreenController.appointmentBookedModelData.value.data.toString()}");
                          setState(() {
                            isLoading = true;
                          });
                          await _bookAppointmentController
                              .getSpecificAppointmentDetails(
                                  _userController.user.value.id,
                                  _patientHomeScreenController
                                      .appointmentBookedModelData.value.data
                                      .toString());
                          setState(() {
                            isLoading = false;
                          });
                          Get.toNamed(Routes.appointmentDetail,
                              arguments: widget.navigationModel);
                        },
                        text: Translate.of(context).translate('done'),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
