import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:united_natives/controller/book_appointment_controller.dart';
import 'package:united_natives/controller/patient_homescreen_controller.dart';
import 'package:united_natives/controller/user_controller.dart';
import 'package:united_natives/medicle_center/lib/utils/translate.dart';
import 'package:united_natives/model/doctor_by_specialities.dart';
import 'package:united_natives/utils/utils.dart';
import '../../../components/custom_button.dart';
import '../../../routes/routes.dart';
import '../../../utils/constants.dart';

class AppointmentBookedPage extends StatefulWidget {
  final NavigationModel? navigationModel;

  const AppointmentBookedPage({super.key, this.navigationModel});

  @override
  _AppointmentBookedPageState createState() => _AppointmentBookedPageState();
}

class _AppointmentBookedPageState extends State<AppointmentBookedPage> {
  final BookAppointmentController _bookAppointmentController = Get.find();

  final PatientHomeScreenController _patientHomeScreenController = Get.find();
  final UserController _userController = Get.find();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorDarkBlue,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(top: 100),
          width: double.infinity,
          child: Column(
            children: <Widget>[
              Image.asset('assets/images/thumb_success.png'),
              const SizedBox(height: 60),
              Text(
                Translate.of(context)!.translate('appointment_booked'),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                Translate.of(context)!
                    .translate('your_appointment_is_confirmed'),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                ),
                textAlign: TextAlign.center,
              ),
              const Expanded(
                child: SizedBox(
                  height: 20,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
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
                          setState(() {
                            isLoading = true;
                          });
                          await _bookAppointmentController
                              .getSpecificAppointmentDetails(
                                  "${_userController.user.value.id}",
                                  _patientHomeScreenController
                                      .appointmentBookedModelData.value.data
                                      .toString());
                          setState(() {
                            isLoading = false;
                          });
                          Get.toNamed(Routes.appointmentDetail,
                              arguments: widget.navigationModel);
                        },
                        text: Translate.of(context)!.translate('done'),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
