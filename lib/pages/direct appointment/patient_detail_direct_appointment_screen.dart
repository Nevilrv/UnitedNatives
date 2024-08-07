import 'dart:developer';

import 'package:doctor_appointment_booking/utils/common_snackbar.dart';
import 'package:doctor_appointment_booking/components/custom_button.dart';
import 'package:doctor_appointment_booking/components/progress_indicator.dart';
import 'package:doctor_appointment_booking/components/text_form_field.dart';
import 'package:doctor_appointment_booking/controller/patient_homescreen_controller.dart';
import 'package:doctor_appointment_booking/controller/user_controller.dart';
import 'package:doctor_appointment_booking/data/pref_manager.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/utils/translate.dart';
import 'package:doctor_appointment_booking/model/paymentPaypalModel.dart';
import 'package:doctor_appointment_booking/newModel/apiModel/requestModel/add_direct_appointment_req_model.dart';
import 'package:doctor_appointment_booking/newModel/apiModel/responseModel/add_direct_appointment_response_model.dart';
import 'package:doctor_appointment_booking/newModel/apiModel/responseModel/get_direct_doctor_response_model.dart';
import 'package:doctor_appointment_booking/newModel/apis/api_response.dart';
import 'package:doctor_appointment_booking/utils/constants.dart';
import 'package:doctor_appointment_booking/utils/utils.dart';
import 'package:doctor_appointment_booking/viewModel/direct_doctor_view_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:intl/intl.dart';

class PatientDetailDirectAppointment extends StatefulWidget {
  final DirectDoctorModel navigationModel;
  final String selctedSlot;
  final String selectedDate;

  PatientDetailDirectAppointment(
      {Key key, this.navigationModel, this.selctedSlot, this.selectedDate})
      : super(key: key);

  @override
  _PatientDetailDirectAppointmentState createState() =>
      _PatientDetailDirectAppointmentState();
}

class _PatientDetailDirectAppointmentState
    extends State<PatientDetailDirectAppointment> {
  final _formKey = GlobalKey<FormState>();
  bool _isdark = Prefs.getBool(Prefs.DARKTHEME, def: false);
  bool _patient = true;
  var _nameController = TextEditingController();
  var _phoneController = TextEditingController();
  var _patientPhoneController = TextEditingController();
  var _emailController = TextEditingController();
  var _notesController = TextEditingController();
  var _purposeOfVisitController =
      TextEditingController(text: 'Direct Appointment');
  bool isLoading = false;
  String appointmentFor;

  PaypalPaymentModel paypalPaymentModel = PaypalPaymentModel();
  DirectDoctorController directDoctorController = Get.find();
  PatientHomeScreenController patientHomeScreenController = Get.find();

  // DoctorHomeScreenController _doctorHomeScreenController =
  //     Get.put(DoctorHomeScreenController());
  // BookAppointmentController _bookAppointmentController =
  //     Get.put(BookAppointmentController());
  UserController _userController = Get.find();

  @override
  void initState() {
    super.initState();
    _nameController.text = "${_userController.user.value.firstName}";
    _phoneController.text = '${_userController.user.value.contactNumber}';
    appointmentFor = _userController.user.value.firstName;
  }

  String validateMobile(String value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return 'Please Enter Mobile Number';
    } else if (value.length != 10) {
      return 'Mobile Number Should be Only 10 Digit';
    } else if (!regExp.hasMatch(value)) {
      return 'Please Enter Valid Mobile Number';
    }
    return null;
  }

  Widget _patientDetails() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            _patient
                ? '${Translate.of(context).translate('please_provide_following_information_about')} ${_nameController.text}'
                : Translate.of(context)
                    .translate('please_provide_following_patient_details_dot'),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 35,
          ),
          Text(
            _patient
                ? '${Translate.of(context).translate('full_name')}*'
                : '${Translate.of(context).translate('patient_full_name')}*',
            style: kInputTextStyle,
          ),
          CustomTextFormField(
            textInputAction: TextInputAction.next,
            validator: (text) {
              if (text.isEmpty) {
                return 'Enter Your Name';
              }
              return null;
            },
            controller: _nameController,
            hintText: _patient ? '' : '${_userController.user.value.firstName}',
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            '${Translate.of(context).translate('mobile')}*',
            style: kInputTextStyle,
          ),
          CustomTextFormField(
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            validator: validateMobile,
            controller: _phoneController,
            hintText: '${_userController.user.value.contactNumber}',
            enabled: false,
          ),
          _patient ? Container() : _patientsMobile(),
          SizedBox(
            height: 15,
          ),
          Text(
            _patient
                ? '${Translate.of(context).translate('your_email')}*'
                : '${Translate.of(context).translate('patient_email')}*',
            style: kInputTextStyle,
          ),
          CustomTextFormField(
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: (value) => EmailValidator.validate(value)
                ? null
                : "Please Enter a Valid Email.",
            controller: _emailController,
            hintText: _patient
                ? Translate.of(context).translate('enter_your_email_id')
                : Translate.of(context).translate('enter_patient_email_id'),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            'Notes',
            style: kInputTextStyle,
          ),
          CustomTextFormField(
            textInputAction: TextInputAction.next,
            validator: (text) {
              if (text.isEmpty) {
                return 'Enter notes';
              }
              return null;
            },
            controller: _notesController,
            hintText: 'Enter Your notes',
          ),
        ],
      ),
    );
  }

  Widget _patientsMobile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 15,
        ),
        Text(
          'Patient\'s Mobile*',
          style: kInputTextStyle,
        ),
        CustomTextFormField(
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          controller: _patientPhoneController,
          // textInputFormatter: [FilteringTextInputFormatter.digitsOnly],
          validator: validateMobile,
          hintText: '+1 520 44 54 661',
        ),
        // CustomTextFormField(
        //   textInputAction: TextInputAction.next,
        //   validator: (text) {
        //     if (text.isEmpty) {
        //       return 'Enter Mobile Numnber';
        //     }
        //     return null;
        //   },
        //   controller: _patientPhoneController,
        //   hintText: 'Enter Patient\'s Mobile Number',
        // ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          Translate.of(context).translate('patient_details'),
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.subtitle1.color,
              fontSize: 24),
        ),
      ),
      body: SafeArea(
          child: Stack(
        children: [
          Column(
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
                                  backgroundImage: NetworkImage(widget
                                          .navigationModel
                                          .doctorSpecialities
                                          .profilePic) ??
                                      AssetImage(
                                        'assets/images/Doctor_lee.png',
                                      ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        widget.navigationModel
                                            .doctorSpecialities.firstName,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2
                                            .copyWith(
                                                fontWeight: FontWeight.w700),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        widget.navigationModel
                                            .doctorSpecialities.speciality,
                                        style: TextStyle(
                                          color: Colors.grey[350],
                                          fontSize: 14,
                                        ),
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
                          height: 0.5,
                        ),
                        Container(
                          width: double.infinity,
                          color: _isdark
                              ? Colors.white.withOpacity(0.12)
                              : Colors.white,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  Translate.of(context).translate(
                                      'how_are_youpurpose_of_visit_today'),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                CustomTextFormField(
                                  textInputAction: TextInputAction.next,
                                  enabled: false,
                                  validator: (text) {
                                    if (text.isEmpty) {
                                      return 'Enter Purpose of Visit';
                                    }
                                    return null;
                                  },
                                  controller: _purposeOfVisitController,
                                  hintText: Translate.of(context)
                                      .translate('What happened to you'),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(
                          color: _isdark ? Colors.black : Colors.grey[300],
                          height: 0.5,
                        ),
                        Container(
                          width: double.infinity,
                          color: _isdark
                              ? Colors.white.withOpacity(0.12)
                              : Colors.white,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  Translate.of(context)
                                      .translate('date_and_time'),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  '${DateFormat('EEEE, dd MMM yyyy').format(DateTime.parse(widget.navigationModel.mySelectedDate))}, ${widget.navigationModel.time}:00 ${widget.navigationModel.time >= 12 ? 'PM' : 'AM'}',
                                  // '${widget.navigationModel.time}:00 ${widget.navigationModel.time >= 12 ? 'PM' : 'AM'}, ${widget.navigationModel.mySelectedDate}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: double.infinity,
                          color: _isdark
                              ? Colors.white.withOpacity(0.12)
                              : Colors.white,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 15,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  Translate.of(context)
                                      .translate('this_appointment_for_dot'),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
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
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        RadioListTile(
                                          value: true,
                                          onChanged: (value) {
                                            setState(() {
                                              _nameController.text =
                                                  '${_userController.user.value.firstName}';
                                              _patient = true;
                                              appointmentFor = _userController
                                                  .user.value.firstName;
                                            });
                                          },
                                          groupValue: _patient,
                                          title: Text(
                                            Translate.of(context).translate(
                                                _userController
                                                    .user.value.firstName),
                                          ),
                                        ),
                                        Divider(
                                          color: _isdark
                                              ? Colors.black
                                              : Colors.grey,
                                          height: 1,
                                        ),
                                        RadioListTile(
                                          value: false,
                                          onChanged: (value) {
                                            setState(() {
                                              _nameController.clear();
                                              _patient = false;
                                              appointmentFor = "Someone else";
                                            });
                                          },
                                          groupValue: _patient,
                                          title: Text(
                                            Translate.of(context)
                                                .translate('someone_else'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                _patientDetails(),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 15),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      '${Translate.of(context).translate('booking_agreement')} ',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                TextSpan(
                                  text: Translate.of(context)
                                      .translate('t_and_c'),
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    decoration: TextDecoration.underline,
                                  ),
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
                //color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: isLoading
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
                              "hello787 ==> ${_userController.user.value.perAppointmentCharge}");
                          print(
                              widget.navigationModel.doctorSpecialities.userId);
                          if (_formKey.currentState.validate()) {
                            AddDirectAppointmentReqModel model =
                                AddDirectAppointmentReqModel();
                            model.doctorId = widget
                                .navigationModel.doctorSpecialities.userId;
                            model.purposeOfVisit =
                                _purposeOfVisitController.text;
                            model.appointmentDate = widget.selectedDate;
                            model.appointmentTime = widget.selctedSlot;
                            model.appointmentFor = appointmentFor;
                            model.fullName = _nameController.text;
                            model.mobile = widget.navigationModel
                                    .doctorSpecialities.contactNumber ??
                                0000000000;
                            model.email = _emailController.text;
                            model.patientMobile = _phoneController.text;
                            model.appointmentNotes = _notesController.text;
                            await directDoctorController
                                .addDirectAppointmentClass(model);

                            if (directDoctorController
                                    .addDirectAppointmentApiResponse.status ==
                                Status.COMPLETE) {
                              AddDirectAppointmentResponseModel model =
                                  directDoctorController
                                      .addDirectAppointmentApiResponse.data;
                              log('message >> ${model.message}');
                              if (model.status == "Success") {
                                CommonSnackBar.snackBar(message: model.message);
                                Future.delayed(Duration(seconds: 2), () {
                                  Navigator.pop(context);
                                });
                              } else {
                                CommonSnackBar.snackBar(
                                    message: "Server error");
                              }
                            } else {
                              CommonSnackBar.snackBar(message: "Server error");
                            }
                          }
                        },
                        text: Translate.of(context).translate('confirm'),
                      ),
              ),
            ],
          ),
          GetBuilder<DirectDoctorController>(
            builder: (controller) {
              if (controller.addDirectAppointmentApiResponse.status ==
                  Status.LOADING) {
                return ProgressIndicatorScreen();
              }
              return SizedBox();
            },
          )
        ],
      )),
    );
  }
}
