import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:dio/dio.dart' as dio;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:united_natives/controller/book_appointment_controller.dart';
import 'package:united_natives/controller/patient_homescreen_controller.dart';
import 'package:united_natives/controller/user_controller.dart';
import 'package:united_natives/medicle_center/lib/configs/routes.dart';
import 'package:united_natives/model/booked_appointment_data.dart';
import 'package:united_natives/model/doctor_by_specialities.dart';
import 'package:united_natives/model/patient_appointment_model.dart';
import 'package:united_natives/model/paymentPaypalModel.dart';
import 'package:united_natives/newModel/apiModel/responseModel/get_city_response_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/get_states_response_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/intake_form_list_res_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/intake_form_res_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/submit_form_res_model.dart';
import 'package:united_natives/newModel/apis/api_response.dart';
import 'package:united_natives/newModel/repo/united_natives_form_repo.dart';
import 'package:united_natives/utils/utils.dart';

class IntakeFormViewModel extends GetxController {
  ApiResponse getIntakeFormApiResponse = ApiResponse.initial('Initial');
  ApiResponse getFormApiResponse = ApiResponse.initial('Initial');
  ApiResponse submitUnitedNativesFormApiResponse =
      ApiResponse.initial('Initial');

  final UserController userController = Get.find();
  final BookAppointmentController bController = Get.find();
  PaypalPaymentModel paypalPaymentModel = PaypalPaymentModel();
  PatientHomeScreenController patientHomeScreenController = Get.find();

  String? id;
  bool? patient;
  NavigationModel? navigationModel;
  GetStatesResponseModel? selectedState;
  GetCityResponseModel? selectedCity;
  final sign = GlobalKey<SignatureState>();
  IntakeFormResponseModel? resData;
  ImagePicker imagePicker = ImagePicker();
  bool isValue = false;
  List<Map<String, dynamic>> savedForm = [];

  Future getImage({ImageSource? imageSource, int? index}) async {
    Get.back();
    final pickedImage =
        await imagePicker.pickImage(source: imageSource ?? ImageSource.gallery);

    if (pickedImage != null) {
      resData?.data?.formParams?[index!].path = pickedImage.path;
      resData?.data?.formParams?[index!].controller?.text = 'Image Captured';
    }
    update();
  }

  cancelSign({int? index}) {
    resData?.data?.formParams?[index!].path = "";
    resData?.data?.formParams?[index!].path = "";
    resData?.data?.formParams?[index!].controller?.clear();
    update();
  }

  Future<void> signMethod({int? index, required BuildContext context}) async {
    final sign1 = sign.currentState;
    final image = await sign1?.getData();
    var data = await image?.toByteData(format: ui.ImageByteFormat.png);
    sign1?.clear();
    final encoded = base64.encode(data!.buffer.asUint8List());
    log('encoded==========>>>>>$encoded');
    String tempPath = (await getTemporaryDirectory()).path;
    File file =
        File('$tempPath/signature${DateTime.now().millisecondsSinceEpoch}.png');
    await file.writeAsBytes(data.buffer.asUint8List());
    resData?.data?.formParams?[index!].path = file.path;
    resData?.data?.formParams?[index!].controller?.text = 'Signature Captured';
    if (!context.mounted) return;
    Navigator.pop(context);
    update();
  }

  datePicker({
    required BuildContext context,
    required int index,
  }) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2010),
      lastDate: DateTime(2200),
    );

    if (pickedDate != null) {
      resData?.data?.formParams?[index].controller?.text =
          DateFormat('MM/dd/yyyy').format(pickedDate);
      update();
    }
  }

  /// Get Intake Form

  Future<void> getIntakeForm(
      {required String medicalCenterID, required String userId}) async {
    getIntakeFormApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      IntakeFormListResponseModel response = await UnitedNativesFormRepo()
          .getIntakeFormRepo(medicalCenterId: medicalCenterID, userId: userId);

      getIntakeFormApiResponse = ApiResponse.complete(response);
    } catch (e) {
      getIntakeFormApiResponse = ApiResponse.error('error');
    }
    update();
  }

  /// Get Form

  Future<void> getForm(
      {required String medicalCenterID, required String fromId}) async {
    isValue = false;
    getFormApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      if (savedForm.any((element) => element["formId"] == fromId)) {
        for (var i = 0; i < savedForm.length; i++) {
          if (savedForm[i]["formId"] == fromId) {
            resData = savedForm[i]["formData"];
            isValue = resData!.data!.formParams!.isNotEmpty;
            getFormApiResponse = ApiResponse.complete(resData);
            break;
          }
        }
      } else {
        IntakeFormResponseModel response = await UnitedNativesFormRepo()
            .intakeFormRepo(medicalCenterId: medicalCenterID, formId: fromId);
        getFormApiResponse = ApiResponse.complete(response);
        resData = getFormApiResponse.data;
        isValue = response.data!.formParams!.isNotEmpty;
      }
    } catch (e) {
      getFormApiResponse = ApiResponse.error('error');
    }
    update();
  }

  /// Get United Natives Form

  saveData(String formId) async {
    Map<String, dynamic> body = {
      "medical_center_id": id,
      "user_fname": userController.user.value.firstName ?? "",
      "user_lname": userController.user.value.lastName ?? "",
      "user_id": userController.user.value.id,
      "form_id": formId,
    };

    for (var i = 0; i < resData!.data!.formParams!.length; i++) {
      if (resData?.data?.formParams?[i].type != "image" &&
          resData?.data?.formParams?[i].type != "text-area") {
        if (resData?.data?.formParams?[i].type == "signature") {
          body.addAll({
            "${resData?.data?.formParams?[i].key}":
                resData!.data!.formParams![i].path!.isNotEmpty
                    ? await dio.MultipartFile.fromFile(
                        resData?.data?.formParams?[i].path ?? '',
                        filename: '${resData?.data?.formParams?[i].key}.png')
                    : null
          });
        } else {
          body.addAll({
            "${resData?.data?.formParams?[i].key}":
                resData?.data?.formParams?[i].controller?.text.toString()
          });
        }
      }
    }

    savedForm.removeWhere((element) => element["formId"] == formId);

    savedForm.add({
      "formId": formId,
      "formBody": body,
      "formData": resData,
      "isDone": true
    });

    Utils.showSnackBar('Form Saved', "Form Saved Successfully!");
    Get.back();
    update();
  }

  Future<void> submitUnitedNativesForm(
      {required Map<String, dynamic> body}) async {
    submitUnitedNativesFormApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      SubmitUnitedNativesFormResponseModel response =
          await UnitedNativesFormRepo().unitedNativesSubmitFormRepo(body: body);

      submitUnitedNativesFormApiResponse = ApiResponse.complete(response);
    } catch (e) {
      submitUnitedNativesFormApiResponse = ApiResponse.error('error');
    }
    update();
  }

  confirmBooking(BuildContext context) async {
    DateTime localTime = DateTime.parse("${navigationModel!.utcDateTime}:00");
    DateTime utcTime = localTime.toUtc();

    final date = "${utcTime.day}-${utcTime.month}-${utcTime.year}";
    final time =
        "${utcTime.hour}:${utcTime.minute == 0 ? "00" : utcTime.minute}";

    bController.updateLoader(true);
    paypalPaymentModel.patientId = userController.user.value.id;
    paypalPaymentModel.doctorId = navigationModel?.doctorSpecialities?.userId ??
        navigationModel!.doctor?.id;
    paypalPaymentModel.purposeOfVisit =
        bController.purposeOfVisitController.text;
    // paypalPaymentModel.appointmentDate = DateFormat('dd-MM-yyyy')
    //     .format(DateTime.parse(navigationModel.mySelectedDate));
    // paypalPaymentModel.appointmentTime = '${navigationModel.time}:00';
    paypalPaymentModel.appointmentDate = date;
    paypalPaymentModel.appointmentTime = time;
    paypalPaymentModel.appointmentFor =
        patient ?? true ? 'self' : 'someone else';
    paypalPaymentModel.fullName = patient ?? true
        ? userController.user.value.firstName
        : bController.nameController.text;
    paypalPaymentModel.mobile =
        patient ?? true ? 'NA' : bController.patientPhoneController.text;
    paypalPaymentModel.email = bController.emailController.text;
    paypalPaymentModel.patientMobile = bController.phoneController.text;
    paypalPaymentModel.doctorFees =
        navigationModel?.doctorSpecialities?.perAppointmentCharge;
    paypalPaymentModel.firstName = userController.user.value.firstName;
    paypalPaymentModel.lastName = userController.user.value.lastName;
    paypalPaymentModel.city = bController.selectedCity?.id;
    paypalPaymentModel.state = bController.selectedState?.id;
    paypalPaymentModel.companyName = bController.companyController.text;
    paypalPaymentModel.providerName = bController.providerController.text;
    paypalPaymentModel.faxNumber = bController.faxController.text;

    log('paypalPaymentModel==========>>>>====>>>>${paypalPaymentModel.appointmentTime}');

    await patientHomeScreenController
        .addPatientAppointment(
      patientId: paypalPaymentModel.patientId ?? "",
      appointmentDate: paypalPaymentModel.appointmentDate ?? "",
      appointmentTime: paypalPaymentModel.appointmentTime ?? "",
      doctorId: paypalPaymentModel.doctorId ?? "",
      fullName: paypalPaymentModel.fullName ?? "",
      mobile: paypalPaymentModel.mobile ?? "",
      appointmentFor: paypalPaymentModel.appointmentFor ?? "",
      email: paypalPaymentModel.email ?? "",
      patientMobile: paypalPaymentModel.patientMobile ?? "",
      purposeOfVisit: paypalPaymentModel.purposeOfVisit ?? "",
      city: paypalPaymentModel.city,
      state: paypalPaymentModel.state,
      companyName: paypalPaymentModel.companyName,
      providerName: paypalPaymentModel.providerName,
      faxNumber: paypalPaymentModel.faxNumber,
    )
        .then(
      (value) async {
        Utils.showSnackBar('Appointment', "Appointment Book Successfully!");
        bController.clearData();
        String appointmentId = patientHomeScreenController
            .appointmentBookedModelData.value.data
            .toString();
        for (var i = 0; i < savedForm.length; i++) {
          Map<String, dynamic> body = savedForm[i]["formBody"];
          body.addAll({"appointment_id": appointmentId});
          submitUnitedNativesForm(body: body);
          if (i + 1 == savedForm.length) {
            savedForm = [];
          }
        }
        Get.offAllNamed(Routes.home);
        if (!context.mounted) return null;
        await bController.getPatientAppointment(
            "${navigationModel?.doctorSpecialities?.userId}", context);
      },
    );
    bController.updateLoader(false);
  }
}
