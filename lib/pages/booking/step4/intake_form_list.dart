import 'package:united_natives/components/ads_bottom_bar.dart';
import 'package:united_natives/components/custom_button.dart';
import 'package:united_natives/components/progress_indicator.dart';
import 'package:united_natives/controller/ads_controller.dart';
import 'package:united_natives/controller/book_appointment_controller.dart';
import 'package:united_natives/controller/user_controller.dart';
import 'package:united_natives/medicle_center/lib/utils/translate.dart';
import 'package:united_natives/model/doctor_by_specialities.dart';
import 'package:united_natives/newModel/apiModel/responseModel/get_city_response_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/get_states_response_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/intake_form_list_res_model.dart';
import 'package:united_natives/newModel/apis/api_response.dart';
import 'package:united_natives/pages/booking/step4/intake_from.dart';
import 'package:united_natives/utils/utils.dart' as snack;
import 'package:united_natives/utils/utils.dart';
import 'package:united_natives/viewModel/intake_form_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class IntakeFormList extends StatefulWidget {
  final String? id;
  final bool? patient;
  final NavigationModel? navigationModel;
  final GetStatesResponseModel? selectedState;
  final GetCityResponseModel? selectedCity;

  const IntakeFormList({
    super.key,
    this.id,
    this.navigationModel,
    this.patient,
    this.selectedState,
    this.selectedCity,
  });
  @override
  State<IntakeFormList> createState() => _IntakeFormListState();
}

class _IntakeFormListState extends State<IntakeFormList> {
  IntakeFormViewModel unitedNativesFormViewModel =
      Get.put(IntakeFormViewModel());
  final BookAppointmentController bookAppointmentController = Get.find();
  final UserController _userController = Get.find<UserController>();

  @override
  void initState() {
    FocusManager.instance.primaryFocus?.unfocus();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    unitedNativesFormViewModel.id = widget.id;
    unitedNativesFormViewModel.patient = widget.patient;
    unitedNativesFormViewModel.navigationModel = widget.navigationModel;
    unitedNativesFormViewModel.selectedState = widget.selectedState;
    unitedNativesFormViewModel.selectedCity = widget.selectedCity;
    unitedNativesFormViewModel.getIntakeForm(
        medicalCenterID: unitedNativesFormViewModel.id!,
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
                        color: Theme.of(context).textTheme.titleMedium?.color,
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
                        return const Center(
                          child: Text('Something went wrong please try again!'),
                        );
                      } else if (controller.getIntakeFormApiResponse.status ==
                          Status.COMPLETE) {
                        IntakeFormListResponseModel resData =
                            controller.getIntakeFormApiResponse.data;

                        return resData.data!.forms!.isEmpty
                            ? const Center(
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
                                              .titleMedium
                                              ?.color,
                                          fontSize: 25),
                                    ),
                                  ),
                                  Expanded(
                                    child: ListView.separated(
                                      itemCount: resData.data!.forms!.length,
                                      padding: const EdgeInsets.all(15),
                                      separatorBuilder: (context, index) {
                                        return const SizedBox(height: 15);
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
                                                      .data!.forms![index].id
                                                      .toString(),
                                                  medicalCenterId:
                                                      controller.id!,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey)),
                                            padding: const EdgeInsets.all(20),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                    "${resData.data!.forms?[index].postTitle}"),
                                                controller.savedForm.any(
                                                        (element) =>
                                                            element["formId"]
                                                                .toString() ==
                                                            resData
                                                                .data!
                                                                .forms?[index]
                                                                .id
                                                                .toString())
                                                    ? const Icon(Icons.task_alt)
                                                    : const Icon(Icons
                                                        .arrow_forward_ios_rounded),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: CustomButton(
                                      textSize: 24,
                                      onPressed: () async {
                                        if (resData.data?.forms?.length ==
                                            controller.savedForm.length) {
                                          await controller
                                              .confirmBooking(context);
                                        } else {
                                          snack.Utils.showSnackBar('Warning!',
                                              "Please fill all remaining intake form for confirm your appointment");
                                        }
                                      },
                                      text: Translate.of(context)!
                                          .translate('confirm'),
                                    ),
                                  )
                                ],
                              );
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                ),
                bController.isLoader
                    ? const ProgressIndicatorScreen()
                    : const SizedBox()
              ],
            );
          },
        );
      },
    );
  }
}
