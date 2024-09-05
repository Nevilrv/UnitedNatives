import 'dart:developer';
import 'package:united_natives/components/custom_button.dart';
import 'package:united_natives/components/progress_indicator.dart';
import 'package:united_natives/components/text_form_field.dart';
import 'package:united_natives/viewModel/book_appointment_controller.dart';
import 'package:united_natives/viewModel/patient_homescreen_controller.dart';
import 'package:united_natives/viewModel/user_controller.dart';
import 'package:united_natives/utils/pref_manager.dart';
import 'package:united_natives/medicle_center/lib/configs/routes.dart';
import 'package:united_natives/medicle_center/lib/utils/translate.dart';
import 'package:united_natives/ResponseModel/doctor_by_specialities.dart';
import 'package:united_natives/ResponseModel/paymentPaypalModel.dart';
import 'package:united_natives/newModel/apiModel/responseModel/get_states_response_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/intake_form_list_res_model.dart'
    as unh;
import 'package:united_natives/newModel/apis/api_response.dart';
import 'package:united_natives/pages/booking/step4/intake_form_list.dart';
import 'package:united_natives/utils/constants.dart';
import 'package:united_natives/utils/utils.dart';
import 'package:united_natives/viewModel/get_city_view_model.dart';
import 'package:united_natives/viewModel/get_states_view_model.dart';
import 'package:united_natives/viewModel/intake_form_view_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide Trans;

class PatientDetailsPage extends StatefulWidget {
  final NavigationModel? navigationModel;

  const PatientDetailsPage({super.key, this.navigationModel});

  @override
  State<PatientDetailsPage> createState() => _PatientDetailsPageState();
}

class _PatientDetailsPageState extends State<PatientDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final bool _isdark = Prefs.getBool(Prefs.DARKTHEME, def: false);
  bool _patient = true;
  final searchController = TextEditingController();
  final bool _isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);

  IntakeFormViewModel unitedNativesFormViewModel =
      Get.put(IntakeFormViewModel());
  PaypalPaymentModel paypalPaymentModel = PaypalPaymentModel();
  final PatientHomeScreenController _patientHomeScreenController = Get.find();
  final UserController _userController = Get.find();
  GetStatesViewModel getStatesViewModel = Get.put(GetStatesViewModel());
  GetCitiesViewModel getCitiesViewModel = Get.put(GetCitiesViewModel());
  List<GetStatesResponseModel> stateList = [];
  final BookAppointmentController bookAppointmentController = Get.find();

  @override
  void initState() {
    getData();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getIntakeForms();
    });
    super.initState();
  }

  getData() async {
    await getStatesViewModel.getStatesViewModel();

    if (getStatesViewModel.getStatesApiResponse.status == Status.COMPLETE) {
      stateList = getStatesViewModel.getStatesApiResponse.data;

      for (var element in stateList) {
        if (element.id == _userController.user.value.state) {
          bookAppointmentController.setStateName(element);
          bookAppointmentController.clearStateCity();
          await getCitiesViewModel
              .getCitiesViewModel(
                  stateId: bookAppointmentController.selectedState?.id)
              .then((value) => bookAppointmentController.changeCityValue(
                  getCitiesViewModel.getCitiesApiResponse.data));

          if (getCitiesViewModel.getCitiesApiResponse.status ==
              Status.COMPLETE) {
            await bookAppointmentController
                .changeCityValue(getCitiesViewModel.getCitiesApiResponse.data);
            for (var element in bookAppointmentController.cityList) {
              if (element.id == _userController.user.value.city) {
                bookAppointmentController.setCityName(element);
              }
            }
          }
        }
      }
    }

    bookAppointmentController.nameController.text =
        "${_userController.user.value.firstName}";
    bookAppointmentController.phoneController.text =
        _userController.user.value.contactNumber ?? "";
    bookAppointmentController.emailController.text =
        _userController.user.value.email ?? "";
  }

  bool isAllSubmitted = false;
  unh.IntakeFormListResponseModel? resData;
  getIntakeForms() async {
    await unitedNativesFormViewModel.getIntakeForm(
        medicalCenterID: bookAppointmentController.chooseMedicalCenter,
        userId: _userController.user.value.id ?? "");

    if (unitedNativesFormViewModel.getIntakeFormApiResponse.status ==
        Status.COMPLETE) {
      resData = unitedNativesFormViewModel.getIntakeFormApiResponse.data;

      for (var i = 0; i < resData!.data!.forms!.length; i++) {
        if (resData?.data?.forms?[i].userStatus == "Filled") {
          isAllSubmitted = true;
        } else {
          isAllSubmitted = false;
          break;
        }
      }
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    FocusManager.instance.primaryFocus?.unfocus();
    bookAppointmentController.clearData();
    bookAppointmentController.clearStateCity();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.dispose();
  }

  FocusScopeNode? currentFocus;

  unFocus() {
    FocusManager.instance.primaryFocus?.unfocus();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  String? validateMobile(String? value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = RegExp(pattern);
    if (value!.isEmpty) {
      return 'Please Enter Mobile Number';
    } else if (value.length != 10) {
      return 'Mobile Number Should be Only 10 Digit';
    } else if (!regExp.hasMatch(value)) {
      return 'Please Enter Valid Mobile Number';
    }
    return null;
  }

  Widget _patientDetails(double h, double w) {
    return GetBuilder<GetStatesViewModel>(
      builder: (statesController) {
        if (statesController.getStatesApiResponse.status == Status.COMPLETE) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                _patient
                    ? '${Translate.of(context)?.translate('please_provide_following_information_about')} ${bookAppointmentController.nameController.text}'
                    : Translate.of(context)!.translate(
                        'please_provide_following_patient_details_dot'),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 35,
              ),

              ///FULL NAME
              Text(
                _patient
                    ? '${Translate.of(context)?.translate('full_name')}*'
                    : '${Translate.of(context)?.translate('patient_full_name')}*',
                style: kInputTextStyle,
              ),
              CustomTextFormField(
                // textInputAction: TextInputAction.next,
                validator: (text) {
                  if (text!.isEmpty) {
                    return 'Enter Your Name';
                  }
                  return null;
                },
                controller: bookAppointmentController.nameController,
                hintText:
                    _patient ? '' : '${_userController.user.value.firstName}',
              ),
              const SizedBox(
                height: 15,
              ),

              ///MOBILE NUMBER
              Text(
                '${Translate.of(context)!.translate('mobile')}*',
                style: kInputTextStyle,
              ),
              CustomTextFormField(
                keyboardType: TextInputType.phone,
                // textInputAction: TextInputAction.next,
                validator: validateMobile,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                controller: bookAppointmentController.phoneController,
                hintText: _userController.user.value.contactNumber ??
                    "Enter mobile number",
              ),
              _patient ? Container() : _patientsMobile(),
              const SizedBox(
                height: 15,
              ),

              // ///FAX NUMBER
              // Text(
              //   '${Translate.of(context).translate('fax')}',
              //   style: kInputTextStyle,
              // ),
              // CustomTextFormField(
              //   keyboardType: TextInputType.phone,
              //   // textInputAction: TextInputAction.next,
              //   controller: bookAppointmentController.faxController,
              //
              //   hintText:
              //       '${Translate.of(context).translate('enter_your_fax')}',
              // ),
              const SizedBox(
                height: 15,
              ),

              ///YOUR EMAIL
              Text(
                _patient
                    ? '${Translate.of(context)?.translate('your_email')}*'
                    : '${Translate.of(context)?.translate('patient_email')}*',
                style: kInputTextStyle,
              ),
              CustomTextFormField(
                keyboardType: TextInputType.emailAddress,
                // textInputAction: TextInputAction.next,
                validator: (value) => EmailValidator.validate(value!)
                    ? null
                    : "Please Enter a Valid Email.",
                controller: bookAppointmentController.emailController,
                hintText: _patient
                    ? Translate.of(context)!.translate('enter_your_email_id')
                    : Translate.of(context)!
                        .translate('enter_patient_email_id'),
              ),
              const SizedBox(
                height: 15,
              ),

              ///COMPANY NAME
              Text(
                '${Translate.of(context)?.translate('company_name')} (optional)',
                style: kInputTextStyle,
              ),
              CustomTextFormField(
                controller: bookAppointmentController.companyController,
                hintText:
                    Translate.of(context)!.translate('enter_your_company_name'),
              ),
              const SizedBox(
                height: 15,
              ),

              ///PROVIDER NAME
              Text(
                '${Translate.of(context)?.translate('provider_name')} (optional)',
                style: kInputTextStyle,
              ),
              CustomTextFormField(
                controller: bookAppointmentController.providerController,
                hintText: Translate.of(context)!
                    .translate('enter_your_provider_name'),
              ),
              const SizedBox(
                height: 15,
              ),

              GetBuilder<BookAppointmentController>(
                builder: (bController) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ///STATE NAME
                      Text(
                        '${Translate.of(context)?.translate('state')}*',
                        style: kInputTextStyle,
                      ).paddingOnly(bottom: 15),

                      dropDownView(
                        state: true,
                        colorCon: stateList.isEmpty,
                        textStyleCon: bController.selectedState == null,
                        text: bController.selectedState != null
                            ? '${bController.selectedState?.name}'
                            : 'Select State',
                        onTap: () async {
                          unFocus();
                          await Future.delayed(
                              const Duration(milliseconds: 300));

                          if (stateList.isNotEmpty) {
                            selectStateCity(
                              state: true,
                              h: h,
                              w: w,
                              stateList: stateList,
                              bController: bController,
                            );
                          }
                        },
                      ),

                      ///CITY NAME
                      Text('${Translate.of(context)?.translate('city')}*',
                              style: kInputTextStyle)
                          .paddingOnly(bottom: 15),

                      dropDownView(
                        state: false,
                        colorCon: bController.cityList.isEmpty,
                        textStyleCon: bController.selectedCity == null,
                        text: bController.selectedCity != null
                            ? '${bController.selectedCity?.name.toString().capitalizeFirst}'
                            : 'Select City',
                        onTap: () async {
                          unFocus();
                          await Future.delayed(
                              const Duration(milliseconds: 300));

                          if (bController.cityList.isNotEmpty) {
                            selectStateCity(
                              state: false,
                              h: h,
                              w: w,
                              stateList: stateList,
                              bController: bController,
                            );
                            // await selectCity(h, w, bController);
                          }
                        },
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 15),
            ],
          );
        } else if (statesController.getStatesApiResponse.status ==
            Status.LOADING) {
          return Center(
            child: Utils.circular(),
          );
        } else if (statesController.getStatesApiResponse.status ==
            Status.ERROR) {
          return Center(
              child: Text('${statesController.getStatesApiResponse.message}'));
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget dropDownView(
      {required void Function() onTap,
      required String text,
      required bool textStyleCon,
      required bool colorCon,
      required bool state}) {
    return GestureDetector(
      onTap: onTap,
      child: commonContainer(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    text,
                    overflow: TextOverflow.ellipsis,
                    style: textStyleCon
                        ? const TextStyle(
                            fontSize: 22,
                            color: Color(0xffbcbcbc),
                            fontFamily: 'NunitoSans')
                        : TextStyle(
                            fontSize: 22,
                            color:
                                Theme.of(context).textTheme.titleMedium?.color),
                  ),
                ),
                (state == true &&
                            getStatesViewModel.getStatesApiResponse.status ==
                                Status.LOADING) ||
                        (state == false &&
                            getCitiesViewModel.getCitiesApiResponse.status ==
                                Status.LOADING)
                    ? const SizedBox(
                        height: 10,
                        width: 10,
                        child: CircularProgressIndicator(
                          strokeWidth: 5,
                        ),
                      ).paddingOnly(right: 5)
                    : Icon(Icons.arrow_drop_down,
                        color: _isDark
                            ? colorCon
                                ? Colors.grey.shade800
                                : Colors.grey.shade100
                            : colorCon
                                ? Colors.grey
                                : Colors.grey.shade800)
              ],
            ),
            const SizedBox(height: 10),
            Container(
                height: 1, width: double.infinity, color: Colors.grey.shade500)
          ],
        ),
      ),
    );
  }

  selectStateCity(
      {required double h,
      required double w,
      required bool state,
      required List<GetStatesResponseModel> stateList,
      required BookAppointmentController bController}) async {
    showDialog(
      context: context,
      builder: (context) {
        return PopScope(
          canPop: false,
          child: StatefulBuilder(
            builder: (context, setState234) {
              return Dialog(
                backgroundColor: Colors.transparent,
                child: ConstrainedBox(
                  constraints:
                      BoxConstraints(maxHeight: h * 0.6, maxWidth: 550),
                  child: Container(
                    decoration: BoxDecoration(
                      color: _isDark ? Colors.grey.shade800 : Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    // height: h * 0.6,
                    // width: w * 0.85,
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: h * 0.015,
                          left: h * 0.015,
                          right: h * 0.005,
                          bottom: 0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: _isDark
                                        ? Colors.grey.shade800
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(color: Colors.grey),
                                  ),
                                  height: 48,
                                  child: Center(
                                    child: TextField(
                                      controller: searchController,
                                      onChanged: (value) {
                                        setState234(() {});
                                      },
                                      decoration: const InputDecoration(
                                        contentPadding:
                                            EdgeInsets.only(top: 10, left: 16),
                                        suffixIcon: Icon(Icons.search),
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        hintText: 'Search...',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  searchController.clear();
                                },
                                icon: const Icon(Icons.clear,
                                    color: Colors.black, size: 25),
                              )
                            ],
                          ),
                          SizedBox(height: h * 0.005),
                          Expanded(
                            child: Builder(
                              builder: (context) {
                                int index = state
                                    ? stateList.indexWhere((element) => element
                                        .name
                                        .toString()
                                        .toLowerCase()
                                        .contains(searchController.text
                                            .toString()
                                            .toLowerCase()))
                                    : bController.cityList.indexWhere(
                                        (element) => element.name
                                            .toString()
                                            .toLowerCase()
                                            .contains(searchController.text
                                                .toString()
                                                .toLowerCase()));
                                if (index < 0) {
                                  return Center(
                                    child: Text(
                                      state ? 'No States !' : 'No City !',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.color,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  );
                                }

                                return ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: state
                                      ? stateList.length
                                      : bController.cityList.length,
                                  itemBuilder: (context, index) {
                                    if (state
                                        ? stateList[index]
                                            .name
                                            .toString()
                                            .toLowerCase()
                                            .contains(searchController.text
                                                .toString()
                                                .toLowerCase())
                                        : bController.cityList[index].name
                                            .toString()
                                            .toLowerCase()
                                            .contains(searchController.text
                                                .toString()
                                                .toLowerCase())) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ListTile(
                                            contentPadding: EdgeInsets.zero,
                                            onTap: () async {
                                              if (state) {
                                                Navigator.pop(context);

                                                searchController.clear();
                                                bController.setStateName(
                                                    stateList[index]);
                                                bController.clearStateCity();
                                                await getCitiesViewModel
                                                    .getCitiesViewModel(
                                                        stateId: bController
                                                            .selectedState?.id)
                                                    .then((value) => bController
                                                        .changeCityValue(
                                                            getCitiesViewModel
                                                                .getCitiesApiResponse
                                                                .data));
                                              } else {
                                                Navigator.pop(context);
                                                searchController.clear();
                                                bController.setCityName(
                                                    bController
                                                        .cityList[index]);
                                              }
                                            },
                                            title: Text(
                                              state
                                                  ? stateList[index]
                                                      .name
                                                      .toString()
                                                  : "${bController.cityList[index].name.toString().capitalizeFirst}",
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium
                                                    ?.color,
                                              ),
                                            ),
                                          ),
                                          const Divider(height: 0)
                                        ],
                                      );
                                    } else {
                                      return const SizedBox();
                                    }
                                  },
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _patientsMobile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 15),
        const Text(
          'Patient\'s Mobile*',
          style: kInputTextStyle,
        ),
        CustomTextFormField(
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ], // textInputAction: TextInputAction.next,
            controller: bookAppointmentController.patientPhoneController,
            // textInputFormatter: [FilteringTextInputFormatter.digitsOnly],
            validator: validateMobile,
            hintText: '+1 520 44 54 661'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            surfaceTintColor: Colors.transparent,
            centerTitle: true,
            title: Text(Translate.of(context)!.translate('patient_details'),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.titleMedium?.color,
                    fontSize: 24),
                textAlign: TextAlign.center),
          ),
          body: SafeArea(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: Container(
                      color: _isdark ? Colors.transparent : Colors.grey[300],
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              color:
                                  _isdark ? Colors.transparent : Colors.white,
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                child: Row(
                                  children: <Widget>[
                                    widget.navigationModel
                                                ?.doctorSpecialities !=
                                            null
                                        ? Utils()
                                            .patientProfile(
                                                widget
                                                        .navigationModel
                                                        ?.doctorSpecialities
                                                        ?.profilePic ??
                                                    "",
                                                widget
                                                        .navigationModel
                                                        ?.doctorSpecialities
                                                        ?.socialProfilePic ??
                                                    "",
                                                20)
                                        : Utils().patientProfile(
                                            widget.navigationModel?.doctor
                                                    ?.doctorProfilePic ??
                                                "",
                                            widget.navigationModel?.doctor
                                                    ?.doctorSocialProfilePic ??
                                                "",
                                            20),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    if (widget.navigationModel
                                            ?.doctorSpecialities !=
                                        null)
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              widget
                                                  .navigationModel!
                                                  .doctorSpecialities!
                                                  .firstName!,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w700),
                                            ),
                                            const SizedBox(height: 3),
                                            Text(
                                              widget
                                                      .navigationModel
                                                      ?.doctorSpecialities
                                                      ?.speciality ??
                                                  "",
                                              style: TextStyle(
                                                  color: Colors.grey[350],
                                                  fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      )
                                    else if (widget.navigationModel?.doctor !=
                                        null)
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              widget.navigationModel!.doctor!
                                                  .doctorFirstName!,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w700),
                                            ),
                                            const SizedBox(height: 3),
                                            Text(
                                              widget.navigationModel!.doctor!
                                                  .doctorSpeciality!,
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
                                color:
                                    _isdark ? Colors.black : Colors.grey[300],
                                height: 0.5),
                            Container(
                              width: double.infinity,
                              color: _isdark
                                  ? Colors.white.withOpacity(0.12)
                                  : Colors.white,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    const SizedBox(height: 15),
                                    Text(
                                      Translate.of(context)!
                                          .translate('purpose_of_visit'),
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    CustomTextFormField(
                                      textInputAction: TextInputAction.done,
                                      validator: (text) {
                                        if (text!.isEmpty) {
                                          return 'Enter Purpose of Visit';
                                        }
                                        return null;
                                      },
                                      controller: bookAppointmentController
                                          .purposeOfVisitController,
                                      hintText: Translate.of(context)!
                                          .translate('Reason for visit'),
                                    ),
                                    const SizedBox(height: 15),
                                  ],
                                ),
                              ),
                            ),
                            Divider(
                                color:
                                    _isdark ? Colors.black : Colors.grey[300],
                                height: 0.5),
                            Container(
                              width: double.infinity,
                              color: _isdark
                                  ? Colors.white.withOpacity(0.12)
                                  : Colors.white,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    const SizedBox(height: 15),
                                    Text(
                                      Translate.of(context)!
                                          .translate('date_and_time'),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Text(
                                      '${DateFormat('EEEE, dd MMM yyyy').format(DateTime.parse(widget.navigationModel!.mySelectedDate!))}, ${widget.navigationModel!.time! > 12 ? widget.navigationModel!.time! - 12 : widget.navigationModel?.time}:${widget.navigationModel?.minute == 0 ? "00" : "0"} ${widget.navigationModel!.time! >= 12 ? 'PM' : 'AM'}',
                                      // '${widget.navigationModel.time}:00 ${widget.navigationModel.time >= 12 ? 'PM' : 'AM'}, ${widget.navigationModel.mySelectedDate}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: double.infinity,
                              color: _isdark
                                  ? Colors.white.withOpacity(0.12)
                                  : Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      Translate.of(context)!.translate(
                                          'this_appointment_for_dot'),
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Material(
                                      color: _isdark
                                          ? Colors.white.withOpacity(0.12)
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(4),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: _isdark
                                                  ? Colors.black
                                                  : Colors.grey,
                                              width: 1),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            RadioListTile(
                                              value: true,
                                              onChanged: (value) async {
                                                unFocus();
                                                await Future.delayed(
                                                    const Duration(
                                                        milliseconds: 300));

                                                setState(() {
                                                  _patient = true;
                                                  getData();
                                                });
                                              },
                                              groupValue: _patient,
                                              title: Text(
                                                Translate.of(context)!
                                                    .translate(_userController
                                                        .user.value.firstName!),
                                              ),
                                            ),
                                            Divider(
                                                color: _isdark
                                                    ? Colors.black
                                                    : Colors.grey,
                                                height: 1),
                                            RadioListTile(
                                              value: false,
                                              onChanged: (value) async {
                                                unFocus();

                                                await Future.delayed(
                                                    const Duration(
                                                        milliseconds: 300));

                                                setState(() {
                                                  bookAppointmentController
                                                      .someoneElse();
                                                  _patient = false;
                                                });
                                              },
                                              groupValue: _patient,
                                              title: Text(Translate.of(context)!
                                                  .translate('someone_else')),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    _patientDetails(h, w),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 15),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: Translate.of(context)
                                          ?.translate('booking_agreement'),
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    TextSpan(
                                      text: Translate.of(context)
                                          ?.translate('t_and_c'),
                                      style: const TextStyle(
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
                ),
                GetBuilder<BookAppointmentController>(
                  builder: (bController) {
                    return Container(
                      //color: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: CustomButton(
                        textSize: 24,
                        onPressed: () async {
                          unFocus();
                          try {
                            if (_formKey.currentState!.validate()) {
                              if (bController.selectedState == null) {
                                Get.snackbar(
                                  'Alert',
                                  'Please select the State and City',
                                  backgroundColor:
                                      _isdark ? Colors.grey : Colors.grey,
                                  colorText: Colors.white,
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                              } else if (bController.selectedCity == null) {
                                Get.snackbar(
                                  'Alert',
                                  'Please select the City',
                                  backgroundColor:
                                      _isdark ? Colors.grey : Colors.grey,
                                  colorText: Colors.white,
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                              } else {
                                if (bController.ihOrNatives == 1 &&
                                    (bController.medicalCenterForm != null) &&
                                    isAllSubmitted == false &&
                                    (resData != null &&
                                        resData!.data!.forms!.isNotEmpty)) {
                                  return Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => IntakeFormList(
                                        id: bController.chooseMedicalCenter,
                                        navigationModel: widget.navigationModel,
                                        patient: _patient,
                                        selectedCity: bController.selectedCity,
                                        selectedState:
                                            bController.selectedState,
                                      ),
                                    ),
                                  ).then(
                                    (value) =>
                                        bController.getPatientAppointment(
                                            widget.navigationModel!
                                                .doctorSpecialities!.userId!,
                                            context),
                                  );
                                } else {
                                  bController.updateLoader(true);

                                  DateTime localTime = DateTime.parse(
                                      "${widget.navigationModel?.utcDateTime}:00");
                                  DateTime utcTime = localTime.toUtc();

                                  final date =
                                      "${utcTime.day}-${utcTime.month}-${utcTime.year}";
                                  final time =
                                      "${utcTime.hour}:${utcTime.minute == 0 ? "00" : utcTime.minute}";

                                  paypalPaymentModel.patientId =
                                      _userController.user.value.id;
                                  paypalPaymentModel.doctorId = widget
                                          .navigationModel
                                          ?.doctorSpecialities
                                          ?.userId ??
                                      widget.navigationModel?.doctor?.id;
                                  paypalPaymentModel.purposeOfVisit =
                                      bController.purposeOfVisitController.text;
                                  paypalPaymentModel.appointmentDate = date;
                                  paypalPaymentModel.appointmentTime = time;
                                  paypalPaymentModel.appointmentFor =
                                      _patient ? 'self' : 'someone else';
                                  paypalPaymentModel.fullName = _patient
                                      ? _userController.user.value.firstName
                                      : bController.nameController.text;
                                  paypalPaymentModel.mobile = _patient
                                      ? 'NA'
                                      : bController.patientPhoneController.text;
                                  paypalPaymentModel.email =
                                      bController.emailController.text;
                                  paypalPaymentModel.patientMobile =
                                      bController.phoneController.text;
                                  paypalPaymentModel.doctorFees = widget
                                      .navigationModel
                                      ?.doctorSpecialities
                                      ?.perAppointmentCharge;
                                  paypalPaymentModel.firstName =
                                      _userController.user.value.firstName;
                                  paypalPaymentModel.lastName =
                                      _userController.user.value.lastName;

                                  paypalPaymentModel.city =
                                      bController.selectedCity?.id;
                                  paypalPaymentModel.state =
                                      bController.selectedState?.id;
                                  paypalPaymentModel.companyName =
                                      bController.companyController.text;
                                  paypalPaymentModel.providerName =
                                      bController.providerController.text;
                                  paypalPaymentModel.faxNumber =
                                      bController.faxController.text;

                                  log('paypalPaymentModel  ${paypalPaymentModel.appointmentTime}');

                                  await _patientHomeScreenController
                                      .addPatientAppointment(
                                    patientId:
                                        paypalPaymentModel.patientId ?? "",
                                    appointmentDate:
                                        paypalPaymentModel.appointmentDate ??
                                            "",
                                    appointmentTime:
                                        paypalPaymentModel.appointmentTime ??
                                            "",
                                    doctorId: paypalPaymentModel.doctorId ?? "",
                                    fullName: paypalPaymentModel.fullName ?? "",
                                    mobile: paypalPaymentModel.mobile ?? "",
                                    appointmentFor:
                                        paypalPaymentModel.appointmentFor ?? "",
                                    email: paypalPaymentModel.email ?? "",
                                    patientMobile:
                                        paypalPaymentModel.patientMobile ?? "",
                                    purposeOfVisit:
                                        paypalPaymentModel.purposeOfVisit ?? "",
                                    city: paypalPaymentModel.city,
                                    state: paypalPaymentModel.state,
                                    companyName:
                                        paypalPaymentModel.companyName ?? "",
                                    providerName:
                                        paypalPaymentModel.providerName,
                                    faxNumber:
                                        paypalPaymentModel.faxNumber ?? "",
                                  )
                                      .then(
                                    (value) {
                                      Utils.showSnackBar('Appointment',
                                          "Appointment Book Successfully!");

                                      bController.clearData();
                                      Get.offAllNamed(Routes.home);
                                      return bController.getPatientAppointment(
                                          widget.navigationModel!
                                              .doctorSpecialities!.userId!,
                                          context);
                                    },
                                  );
                                  bController.updateLoader(false);
                                }
                              }
                            }
                          } catch (e) {
                            bController.updateLoader(false);
                          }
                        },
                        text: bController.ihOrNatives == 1 &&
                                (bController.medicalCenterForm != null) &&
                                isAllSubmitted == false &&
                                (resData != null &&
                                    resData!.data!.forms!.isNotEmpty)
                            ? "Next"
                            : Translate.of(context)!.translate('confirm'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        GetBuilder<BookAppointmentController>(
          builder: (bController) {
            return Container(
                child: bController.isLoader
                    ? const ProgressIndicatorScreen()
                    : const SizedBox());
          },
        )
      ],
    );
  }

  showDialogBoxForCircularBuilder(BuildContext context) {
    return showDialog(
      barrierColor: Colors.black.withOpacity(0.3),
      context: Get.overlayContext!,
      builder: (context) {
        return Center(
          child: Utils.circular(),
        );
      },
    );
  }

  static Container commonContainer({required Widget child}) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4), color: Colors.transparent
          // border: Border.all(color: Colors.grey),
          ),
      child: child,
    );
  }
}
