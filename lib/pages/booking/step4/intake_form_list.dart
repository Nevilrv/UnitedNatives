import 'package:doctor_appointment_booking/components/ads_bottom_bar.dart';
import 'package:doctor_appointment_booking/components/custom_button.dart';
import 'package:doctor_appointment_booking/components/progress_indicator.dart';
import 'package:doctor_appointment_booking/controller/ads_controller.dart';
import 'package:doctor_appointment_booking/controller/book_appointment_controller.dart';
import 'package:doctor_appointment_booking/controller/user_controller.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/utils/translate.dart';
import 'package:doctor_appointment_booking/model/doctor_by_specialities.dart';
import 'package:doctor_appointment_booking/newModel/apiModel/responseModel/get_city_response_model.dart';
import 'package:doctor_appointment_booking/newModel/apiModel/responseModel/get_states_response_model.dart';
import 'package:doctor_appointment_booking/newModel/apiModel/responseModel/intake_form_list_res_model.dart';
import 'package:doctor_appointment_booking/newModel/apis/api_response.dart';
import 'package:doctor_appointment_booking/pages/booking/step4/intake_from.dart';
import 'package:doctor_appointment_booking/utils/utils.dart' as snack;
import 'package:doctor_appointment_booking/utils/utils.dart';
import 'package:doctor_appointment_booking/viewModel/intake_form_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class IntakeFormList extends StatefulWidget {
  final String id;
  final bool patient;
  final NavigationModel navigationModel;
  final GetStatesResponseModel selectedState;
  final GetCityResponseModel selectedCity;

  const IntakeFormList({
    Key key,
    this.id,
    this.navigationModel,
    this.patient,
    this.selectedState,
    this.selectedCity,
  }) : super(key: key);
  _IntakeFormListState createState() => _IntakeFormListState();
}

class _IntakeFormListState extends State<IntakeFormList> {
  IntakeFormViewModel unitedNativesFormViewModel =
      Get.put(IntakeFormViewModel());
  final BookAppointmentController bookAppointmentController = Get.find();
  UserController _userController = Get.find<UserController>();

  @override
  void initState() {
    FocusManager.instance.primaryFocus.unfocus();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    unitedNativesFormViewModel.id = widget.id;
    unitedNativesFormViewModel.patient = widget.patient;
    unitedNativesFormViewModel.navigationModel = widget.navigationModel;
    unitedNativesFormViewModel.selectedState = widget.selectedState;
    unitedNativesFormViewModel.selectedCity = widget.selectedCity;
    unitedNativesFormViewModel.getIntakeForm(
        medicalCenterID: unitedNativesFormViewModel.id,
        userId: _userController.user.value.id ?? "");
    super.initState();
  }

  AdsController adsController = Get.find();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdsController>(
      builder: (ads) {
        return GetBuilder<BookAppointmentController>(
          builder: (bController) {
            return Stack(
              children: [
                Scaffold(
                  resizeToAvoidBottomInset: false,
                  bottomNavigationBar: AdsBottomBar(
                    ads: ads,
                    context: context,
                  ),
                  appBar: AppBar(
                    title: Text(
                      'Intake Forms',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.subtitle1.color,
                        fontSize: 24,
                      ),
                    ),
                    centerTitle: true,
                  ),
                  body: GetBuilder<IntakeFormViewModel>(
                    builder: (controller) {
                      if (controller.getIntakeFormApiResponse.status ==
                          Status.LOADING) {
                        return Center(
                          child: /*CircularProgressIndicator(
                            strokeWidth: 1,
                          )*/
                              Center(
                            child: Utils.circular(),
                          ),
                        );
                      } else if (controller.getIntakeFormApiResponse.status ==
                          Status.ERROR) {
                        return Center(
                          child: Text('Something went wrong please try again!'),
                        );
                      } else if (controller.getIntakeFormApiResponse.status ==
                          Status.COMPLETE) {
                        IntakeFormListResponseModel resData =
                            controller.getIntakeFormApiResponse.data;

                        return resData.data.forms.isEmpty
                            ? Center(
                                child: Text(
                                  'No forms available',
                                  style: TextStyle(fontSize: 21),
                                ),
                              )
                            : Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                            horizontal: 15)
                                        .copyWith(top: 15),
                                    child: Text(
                                      'Fill all the forms for book the appointment',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .textTheme
                                              .subtitle1
                                              .color,
                                          fontSize: 25),
                                    ),
                                  ),
                                  Expanded(
                                    child: ListView.separated(
                                      itemCount: resData.data.forms.length,
                                      padding: EdgeInsets.all(15),
                                      separatorBuilder: (context, index) {
                                        return SizedBox(height: 15);
                                      },
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    IntakeFrom(
                                                  formId: resData
                                                      .data.forms[index].id
                                                      .toString(),
                                                  medicalCenterId:
                                                      controller.id,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey)),
                                            padding: EdgeInsets.all(20),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                    "${resData.data.forms[index].postTitle}"),
                                                controller.savedForm.any(
                                                        (element) =>
                                                            element["formId"]
                                                                .toString() ==
                                                            resData.data
                                                                .forms[index].id
                                                                .toString())
                                                    ? Icon(Icons.task_alt)
                                                    : Icon(Icons
                                                        .arrow_forward_ios_rounded),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(15),
                                    child: CustomButton(
                                      textSize: 24,
                                      onPressed: () async {
                                        if (resData.data.forms.length ==
                                            controller.savedForm.length) {
                                          await controller
                                              .confirmBooking(context);
                                        } else {
                                          snack.Utils.showSnackBar('Warning!',
                                              "Please fill all remaining intake form for confirm your appointment");
                                        }
                                      },
                                      text: Translate.of(context)
                                          .translate('confirm'),
                                    ),
                                  )
                                ],
                              );
                      } else {
                        return SizedBox();
                      }
                    },
                  ),
                ),
                bController.isLoader ? ProgressIndicatorScreen() : SizedBox()
              ],
            );
          },
        );
      },
    );
  }
}
