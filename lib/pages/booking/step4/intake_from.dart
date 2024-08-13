import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:united_natives/components/custom_button.dart';
import 'package:united_natives/components/text_form_field.dart';
import 'package:united_natives/controller/ads_controller.dart';
import 'package:united_natives/controller/book_appointment_controller.dart';
import 'package:united_natives/controller/patient_homescreen_controller.dart';
import 'package:united_natives/data/pref_manager.dart';
import 'package:united_natives/medicle_center/lib/utils/utils.dart';
import 'package:united_natives/model/paymentPaypalModel.dart';
import 'package:united_natives/newModel/apis/api_response.dart';
import 'package:united_natives/utils/constants.dart';
import 'package:united_natives/utils/utils.dart' as snack;
import 'package:united_natives/utils/utils.dart';
import 'package:united_natives/viewModel/intake_form_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class IntakeFrom extends StatefulWidget {
  final String? medicalCenterId;
  final String? formId;

  const IntakeFrom({super.key, this.medicalCenterId, this.formId});
  @override
  State<IntakeFrom> createState() => _IntakeFrom();
}

class _IntakeFrom extends State<IntakeFrom> {
  IntakeFormViewModel unitedNativesFormViewModel = Get.find();
  PaypalPaymentModel paypalPaymentModel = PaypalPaymentModel();
  final PatientHomeScreenController patientHomeScreenController =
      Get.find<PatientHomeScreenController>();
  final BookAppointmentController bookAppointmentController = Get.find();
  final bool _isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      getForm();
    });
    super.initState();
  }

  FocusScopeNode? currentFocus;

  unFocus() {
    // currentFocus = FocusScope.of(context);
    // if (!currentFocus.hasPrimaryFocus) {
    //   currentFocus.unfocus();
    // }
    FocusManager.instance.primaryFocus?.unfocus();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  getForm() async {
    await unitedNativesFormViewModel.getForm(
        medicalCenterID: widget.medicalCenterId!, fromId: widget.formId!);
  }

  @override
  void dispose() {
    FocusManager.instance.primaryFocus?.unfocus();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  AdsController adsController = Get.find();
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Intake From',
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
          return Column(
            children: [
              Expanded(
                child: Builder(
                  builder: (context) {
                    if (controller.getFormApiResponse.status ==
                        Status.LOADING) {
                      return Center(
                          child: /* CircularProgressIndicator(
                          strokeWidth: 1,
                        ),*/
                              Utils.circular());
                    } else if (controller.getFormApiResponse.status ==
                        Status.ERROR) {
                      return const Center(
                        child: Text('Server error!'),
                      );
                    } else if (controller.getFormApiResponse.status ==
                        Status.COMPLETE) {
                      return Scrollbar(
                        controller: _scrollController,
                        thickness: w * 0.012,
                        radius: const Radius.circular(10),
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: Form(
                            key: _formKey,
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount:
                                  controller.resData?.data?.formParams?.length,
                              padding: EdgeInsets.all(h * 0.012),
                              itemBuilder: (context, index) {
                                bool? ctlrIsEmpty = controller
                                    .resData
                                    ?.data!
                                    .formParams?[index]
                                    .controller
                                    ?.text
                                    .isEmpty;
                                return Container(
                                  padding: EdgeInsets.all(h * 0.005),
                                  margin: EdgeInsets.only(bottom: h * 0.01),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      controller.resData?.data!
                                                  .formParams?[index].type ==
                                              "image"
                                          ? controller.resData!.data!
                                                  .formParams![index].label!
                                                  .contains("https://")
                                              ? const SizedBox()
                                              : const SizedBox()
                                          : Text(
                                              Translate.of(context)!.translate(
                                                  '${controller.resData?.data!.formParams![index].label}${controller.resData!.data!.formParams![index].isRequired == "true" && controller.resData?.data!.formParams?[index].type != "text-area" ? "*" : ""}'),
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                      if (controller.resData?.data!
                                              .formParams?[index].type ==
                                          "text") ...[
                                        SizedBox(height: h * 0.01),
                                        CustomOuterLineTextFormField(
                                          // textInputAction: TextInputAction.next,
                                          validator: validator(
                                              controller: controller,
                                              index: index),
                                          controller: controller.resData?.data
                                              ?.formParams?[index].controller,
                                          hintText: "Enter here..",
                                        ),
                                      ],
                                      if (controller.resData?.data
                                              ?.formParams?[index].type ==
                                          "phone") ...[
                                        SizedBox(height: h * 0.01),
                                        CustomOuterLineTextFormField(
                                          // textInputAction: TextInputAction.next,
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                            LengthLimitingTextInputFormatter(
                                                10),
                                          ],
                                          validator: validator(
                                              controller: controller,
                                              index: index),
                                          controller: controller.resData?.data
                                              ?.formParams?[index].controller,
                                          hintText: "Enter here..",
                                        ),
                                      ],
                                      /*if (controller.resData.data
                                              .formParams[index].type ==
                                          "text-area") ...[
                                        SizedBox(height: h * 0.01),
                                        CustomOuterLineTextFormField(
                                          minLines: 3,
                                          maxLines: 10,
                                          textInputAction: TextInputAction.next,
                                          validator: validator(
                                              controller: controller,
                                              index: index),
                                          controller: controller.resData.data
                                              .formParams[index].controller,
                                          hintText: "Enter here..",
                                        ),
                                      ],*/
                                      if (controller.resData?.data
                                              ?.formParams?[index].type ==
                                          "date") ...[
                                        SizedBox(height: h * 0.01),
                                        CustomOuterLineTextFormField(
                                          readOnly: true,
                                          // textInputAction: TextInputAction.next,
                                          validator: validator(
                                              controller: controller,
                                              index: index),
                                          controller: controller.resData?.data
                                              ?.formParams?[index].controller,
                                          suffixIcon: IconButton(
                                            onPressed: () async {
                                              unFocus();
                                              await Future.delayed(
                                                  const Duration(
                                                      milliseconds: 200));

                                              controller.datePicker(
                                                  index: index,
                                                  context: context);
                                            },
                                            icon: Icon(
                                              Icons.calendar_today_outlined,
                                              color: _isDark
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                          hintText: "Select Date",
                                        ),
                                      ],
                                      if (controller.resData!.data
                                              ?.formParams?[index].type ==
                                          "signature") ...[
                                        SizedBox(height: h * 0.01),
                                        CustomOuterLineTextFormField(
                                          readOnly: true,
                                          onTap: () async {
                                            unFocus();
                                            await Future.delayed(const Duration(
                                                milliseconds: 200));
                                          },
                                          // textInputAction: TextInputAction.next,
                                          validator: validator(
                                              controller: controller,
                                              index: index),
                                          controller: controller.resData?.data
                                              ?.formParams?[index].controller,
                                          suffixIcon: SizedBox(
                                            width: w * 0.4,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                if (!ctlrIsEmpty!) ...[
                                                  showSignatureAndImage(
                                                      index: index,
                                                      controller: controller,
                                                      context: context,
                                                      h: h,
                                                      w: w),
                                                  cancleSignature(
                                                      controller: controller,
                                                      index: index,
                                                      w: w),
                                                  SizedBox(width: w * 0.014),
                                                ],
                                                Padding(
                                                  padding:
                                                      EdgeInsets.all(w * 0.01),
                                                  child: SizedBox(
                                                    width: w * 0.16,
                                                    child: RawMaterialButton(
                                                      fillColor: ctlrIsEmpty
                                                          ? kColorBlue
                                                          : kColorBlue
                                                              .withOpacity(0.5),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4)),
                                                      onPressed: ctlrIsEmpty
                                                          ? () async {
                                                              unFocus();
                                                              await Future.delayed(
                                                                  const Duration(
                                                                      milliseconds:
                                                                          200));
                                                              signatureDialog(
                                                                  controller:
                                                                      controller,
                                                                  context:
                                                                      context,
                                                                  w: w,
                                                                  h: h,
                                                                  index: index);
                                                            }
                                                          : null,
                                                      child: Text(
                                                        Translate.of(context)!
                                                            .translate('Esign'),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .labelLarge
                                                            ?.copyWith(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 18),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ).paddingSymmetric(
                                                          vertical: h * 0.009),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          hintText: "Signature",
                                        ),
                                      ],
                                      /*if (controller.resData.data
                                              .formParams[index].type ==
                                          "image") ...[
                                        SizedBox(height: h * 0.01),
                                        CustomOuterLineTextFormField(
                                          readOnly: true,
                                          textInputAction: TextInputAction.next,
                                          validator: validator(
                                              controller: controller,
                                              index: index),
                                          controller: controller.resData.data
                                              .formParams[index].controller,
                                          suffixIcon: Container(
                                            width: ctlrIsEmpty
                                                ? w * 0.22
                                                : w * 0.4,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                if (!ctlrIsEmpty) ...[
                                                  showSignatureAndImage(
                                                      index: index,
                                                      controller: controller,
                                                      context: context,
                                                      h: h,
                                                      w: w),
                                                  cancleSignature(
                                                      controller: controller,
                                                      index: index,
                                                      w: w),
                                                  SizedBox(width: w * 0.014),
                                                ],
                                                Padding(
                                                  padding:
                                                      EdgeInsets.all(w * 0.01),
                                                  child: SizedBox(
                                                    width: w * 0.16,
                                                    child: RawMaterialButton(
                                                      fillColor: ctlrIsEmpty
                                                          ? kColorBlue
                                                          : kColorBlue
                                                              .withOpacity(0.5),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4)),
                                                      onPressed: ctlrIsEmpty
                                                          ? () {
                                                              bottomSheetForPhoto(
                                                                context:
                                                                    context,
                                                                controller:
                                                                    controller,
                                                                index: index,
                                                              );
                                                            }
                                                          : null,
                                                      child: Text(
                                                        Translate.of(context)
                                                            .translate(
                                                                'Choose'),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .button
                                                            .copyWith(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 18),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ).paddingSymmetric(
                                                          vertical: h * 0.009),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          hintText: "Select or capture image",
                                        ),
                                      ],*/
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ),
              !controller.isValue
                  ? const SizedBox()
                  : GetBuilder<BookAppointmentController>(
                      builder: (bController) {
                        return Container(
                          padding: EdgeInsets.all(h * 0.016),
                          child: controller.submitUnitedNativesFormApiResponse
                                          .status ==
                                      Status.LOADING ||
                                  bController.isLoader
                              ? /*Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1,
                                  ),
                                ) */
                              SizedBox(
                                  height: 60,
                                  child: Center(
                                    child: Utils.circular(height: 60),
                                  ),
                                )
                              : CustomButton(
                                  textSize: 24,
                                  onPressed: () async {
                                    await Future.delayed(
                                        const Duration(milliseconds: 200));

                                    unFocus();

                                    if (_formKey.currentState!.validate()) {
                                      await controller.saveData(widget.formId!);
                                    } else {
                                      snack.Utils.showSnackBar('Required',
                                          "Please fill the details to continue.");
                                    }
                                  },
                                  text: Translate.of(context)!
                                      .translate('I Agree'),
                                ),
                        );
                      },
                    ),
            ],
          );
        },
      ),
    );
  }

  /// CHOOSE IMAGE

  Future<dynamic> bottomSheetForPhoto(
      {BuildContext? context, IntakeFormViewModel? controller, int? index}) {
    return showModalBottomSheet(
      context: context!,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(
                  Icons.camera,
                  size: 25,
                ),
                title: Text(
                  Translate.of(context)!.translate('take_a_photo'),
                  style: TextStyle(
                    color: Theme.of(context).textTheme.titleMedium?.color,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                onTap: () {
                  controller?.getImage(
                      imageSource: ImageSource.camera, index: index);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo_library,
                  size: 25,
                ),
                title: Text(
                  Translate.of(context)!.translate('choose_a_photo'),
                  style: TextStyle(
                    color: Theme.of(context).textTheme.titleMedium?.color,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                onTap: () {
                  controller?.getImage(
                      index: index, imageSource: ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// SIGNATURE PAD

  signatureDialog(
      {required IntakeFormViewModel controller,
      required BuildContext context,
      required double w,
      required double h,
      required int index}) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => SimpleDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        backgroundColor: _isDark ? Colors.grey.shade800 : Colors.white,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.03),
            child: Container(
              height: h * 0.37,
              width: w,
              decoration: BoxDecoration(
                  color: _isDark ? Colors.grey.shade400 : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(5)),
              child: Signature(
                color: Colors.black,
                key: controller.sign,
                onSign: () {
                  final sign1 = controller.sign.currentState;
                  log('$sign1');
                },
                backgroundPainter: _WatermarkPaint("2.0", "2.0"),
                strokeWidth: 5.0,
              ),
            ),
          ),
          SizedBox(height: h * 0.02),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.041),
            child: Row(
              children: [
                Expanded(
                  child: Material(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: kColorBlue,
                    child: InkWell(
                        onTap: () async {
                          Navigator.pop(context);
                        },
                        child: Text(
                          Translate.of(context)!.translate('Cancel'),
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(color: Colors.white),
                          textAlign: TextAlign.center,
                        ).paddingSymmetric(vertical: h * 0.016)),
                  ),
                ),
                SizedBox(
                  width: w * 0.041,
                ),
                Expanded(
                  child: Material(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: kColorBlue,
                    child: InkWell(
                      onTap: () async {
                        await controller.signMethod(
                            index: index, context: context);
                      },
                      child: Text(
                        Translate.of(context)!.translate('Save'),
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge
                            ?.copyWith(color: Colors.white),
                        textAlign: TextAlign.center,
                      ).paddingSymmetric(vertical: h * 0.016),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  /// CANCLE SIGN

  Widget cancleSignature({
    required int index,
    required double w,
    required IntakeFormViewModel controller,
  }) {
    return SizedBox(
      width: w * 0.081,
      child: IconButton(
        onPressed: () async {
          unFocus();
          await Future.delayed(const Duration(milliseconds: 200));
          controller.cancelSign(
            index: index,
          );
        },
        icon: Icon(Icons.cancel_outlined,
            color: _isDark ? Colors.white : Colors.black),
      ),
    );
  }

  /// SHOW SIGN

  Widget showSignatureAndImage({
    required int index,
    required BuildContext context,
    required double h,
    required double w,
    required IntakeFormViewModel controller,
  }) {
    return SizedBox(
      width: w * 0.081,
      child: IconButton(
        onPressed: () async {
          unFocus();
          await Future.delayed(const Duration(milliseconds: 200));
          showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                backgroundColor: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        _isDark ? Colors.grey.shade400 : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: h * 0.4,
                  width: w * 0.8,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(h * 0.016),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(Icons.close, size: 30),
                          ),
                        ),
                      ),
                      Container(
                        height: h * 0.3,
                        width: w * 0.7,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: FileImage(
                                File(controller
                                    .resData!.data!.formParams![index].path!),
                              ),
                              fit: BoxFit.contain),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        icon: Icon(
          Icons.remove_red_eye_outlined,
          color: _isDark ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  /// VALIDATION

  String? Function(dynamic text)? validator(
      {int? index, IntakeFormViewModel? controller}) {
    return controller?.resData?.data!.formParams?[index!].isRequired == "true"
        ? (text) {
            if (text.isEmpty) {
              return 'This field is required!';
            }
            return null;
          }
        : null;
  }
}

class _WatermarkPaint extends CustomPainter {
  final String price;
  final String watermark;

  _WatermarkPaint(this.price, this.watermark);

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 10.8,
        Paint()..color = Colors.transparent);
  }

  @override
  bool shouldRepaint(_WatermarkPaint oldDelegate) {
    return oldDelegate != this;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _WatermarkPaint &&
          runtimeType == other.runtimeType &&
          price == other.price &&
          watermark == other.watermark;

  @override
  int get hashCode => price.hashCode ^ watermark.hashCode;
}
