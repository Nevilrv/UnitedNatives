import 'dart:async';
import 'dart:io';

import 'package:date_format/date_format.dart';
import 'package:united_natives/components/ads_bottom_bar.dart';
import 'package:united_natives/viewModel/ads_controller.dart';
import 'package:united_natives/viewModel/user_controller.dart';
import 'package:united_natives/utils/pref_manager.dart';
import 'package:united_natives/requestModel/add_class_request_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/add_class_response_model.dart';
import 'package:united_natives/newModel/apis/api_response.dart';
import 'package:united_natives/utils/common_snackbar.dart';
import 'package:united_natives/utils/utils.dart';
import 'package:united_natives/utils/validation_utility.dart';
import 'package:united_natives/viewModel/scheduled_class_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'comman_textform_widget.dart';

class ScheduleForm extends StatefulWidget {
  final String? urlSelectedTime;

  const ScheduleForm({super.key, this.urlSelectedTime});
  @override
  State<ScheduleForm> createState() => _ScheduleFormState();
}

class _ScheduleFormState extends State<ScheduleForm> {
  DateTime selectedDate = DateTime.now();
  ScheduledClassController scheduledClassController = Get.find();
  String? mySelectDate, selectedStartTime, selectedEndTime;
  String? _setTime;
  final UserController userController = Get.find();
  String? _hour, _minute, _time;
  GlobalKey<FormState>? formKey;

  TimeOfDay selectedTime = const TimeOfDay(hour: 00, minute: 00);

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2500))
        .then((value) {
      if (value != null && value != selectedDate) {
        setState(() {
          selectedDate = value;
        });
      }
      mySelectDate = "${value?.toLocal()}".split(' ')[0];

      return selectedDate;
    });
    debugPrint('picked==========>>>>>$picked');
  }

  Future<Null> _selectTime(BuildContext context, String time) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = '$_hour : $_minute';
        _setTime = _time;
        _setTime = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
        if (time == 'start') {
          selectedStartTime = _setTime;
        } else {
          selectedEndTime = _setTime;
        }
      });
    }
  }

  TextEditingController? titleEditingController, descriptionController;
  File? imageW;

  @override
  void initState() {
    formKey = GlobalKey<FormState>();
    titleEditingController = TextEditingController();
    descriptionController = TextEditingController();
    super.initState();
  }

  final ImagePicker _picker = ImagePicker();
  final bool _isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);

  AdsController adsController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdsController>(builder: (ads) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: AdsBottomBar(
          ads: ads,
          context: context,
        ),
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          title: Text(
            "Add schedule class ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.titleMedium?.color,
              fontSize: 24,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Form(
              key: formKey,
              child: ListView(
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  CommonTextField(
                    textEditingController: titleEditingController,
                    labelText: "Title",
                    onChange: (value) {
                      ///request model.full name=value
                    },
                    isChange: false,
                    maxLine: 1,
                    isValidate: true,
                    textInputType: TextInputType.name,
                    validationMessage: "required",
                    inputLength: 30,
                    hintText: "Enter title",
                    regularExpression: ValidationUtility.address,
                  ),
                  CommonTextField(
                    textEditingController: descriptionController,
                    labelText: "Description",
                    onChange: (value) {
                      ///request model.full name=value
                    },
                    isChange: false,
                    maxLine: 1,
                    isValidate: true,
                    textInputType: TextInputType.name,
                    validationMessage: "required",
                    inputLength: 30,
                    hintText: 'Enter description...',
                    regularExpression: ValidationUtility.address,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Text(
                      'Select picture',
                      // style: FontTextStyle.nunito600Black3dS14Style,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: _isDark ? Colors.white : Colors.black,
                        fontSize: Get.height * 0.022,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      pickImage();
                    },
                    child: Container(
                      width: Get.width,
                      height: Get.height * 0.20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: _isDark
                            ? Colors.grey.withOpacity(0.2)
                            : const Color(0XffF3F3F3),
                        border: Border.all(color: Colors.black38, width: 1),
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: imageW != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.file(
                                imageW!,
                                fit: BoxFit.fill,
                              ),
                            )
                          : Center(
                              child: Text(
                                "Select image...",
                                style: TextStyle(
                                  fontSize: Get.height * 0.022,
                                ),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Text(
                          'Choose date',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: _isDark ? Colors.white : Colors.black,
                            fontSize: Get.height * 0.022,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          _selectDate(context);
                        },
                        child: Container(
                          width: Get.width * 1.5,
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: _isDark
                                ? Colors.grey.withOpacity(0.2)
                                : const Color(0XffF3F3F3),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(width: 2, color: Colors.black26),
                          ),

                          // margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(
                                Icons.calendar_today_outlined,
                                size: 25,
                                color: Colors.grey,
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                flex: 2,
                                child:
                                    mySelectDate != null && mySelectDate != ""
                                        ? Text(
                                            "${selectedDate.toLocal()}"
                                                .split(' ')[0],
                                            style: TextStyle(
                                              fontSize: Get.height * 0.022,
                                            ),
                                          )
                                        : Text(
                                            "Choose date",
                                            style: TextStyle(
                                              fontSize: Get.height * 0.022,
                                            ),
                                          ),
                              ),
                              // Icon(Icons.arrow_forward_ios_rounded)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  'Choose start time',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color:
                                        _isDark ? Colors.white : Colors.black,
                                    fontSize: Get.height * 0.022,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  _selectTime(context, "start");
                                },
                                child: Container(
                                  width: Get.width * 1.5,
                                  padding: const EdgeInsets.all(8),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: _isDark
                                        ? Colors.grey.withOpacity(0.2)
                                        : const Color(0XffF3F3F3),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        width: 2, color: Colors.black26),
                                  ),

                                  // margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Icon(
                                        Icons.access_time,
                                        size: 25,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: selectedStartTime != null
                                            ? Text(
                                                "$selectedStartTime",
                                                style: TextStyle(
                                                  fontSize: Get.height * 0.022,
                                                ),
                                              )
                                            : Text(
                                                "Choose start time",
                                                style: TextStyle(
                                                  fontSize: Get.height * 0.022,
                                                ),
                                              ),
                                      ),
                                      // Icon(Icons.arrow_forward_ios_rounded)
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  'Choose end time',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color:
                                        _isDark ? Colors.white : Colors.black,
                                    fontSize: Get.height * 0.022,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  _selectTime(context, 'end');
                                },
                                child: Container(
                                  width: Get.width * 1.5,
                                  padding: const EdgeInsets.all(8),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: _isDark
                                        ? Colors.grey.withOpacity(0.2)
                                        : const Color(0XffF3F3F3),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      width: 2,
                                      color: Colors.black26,
                                    ),
                                  ),

                                  // margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Icon(
                                        Icons.access_time,
                                        size: 25,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: selectedEndTime != null
                                            ? Text(
                                                "$selectedEndTime",
                                                style: TextStyle(
                                                  fontSize: Get.height * 0.022,
                                                ),
                                              )
                                            : Text(
                                                "Choose end time",
                                                style: TextStyle(
                                                  fontSize: Get.height * 0.022,
                                                ),
                                              ),
                                      ),
                                      // Icon(Icons.arrow_forward_ios_rounded)
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GetBuilder<ScheduledClassController>(
                    builder: (controller) {
                      if (controller.addclassApiResponse.status ==
                          Status.LOADING) {
                        // return Center(
                        //   child: CircularProgressIndicator(),
                        // );
                        return Center(
                          child: Utils.circular(),
                        );
                      }
                      return Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: Get.width / 4),
                        child: InkWell(
                          onTap: () async {
                            if (formKey?.currentState != null) {
                              if (formKey!.currentState!.validate()) {
                                if (mySelectDate == null ||
                                    mySelectDate.isBlank!) {
                                  Utils.showSnackBar(
                                      'Validation', 'Select date');
                                } else if (selectedStartTime == null ||
                                    selectedStartTime.isBlank!) {
                                  Utils.showSnackBar(
                                      'Validation', 'Select start time');
                                } else if (selectedEndTime == null ||
                                    selectedEndTime.isBlank!) {
                                  Utils.showSnackBar(
                                      'Validation', 'Select end time');
                                } else if (imageW == null ||
                                    imageW!.path == '') {
                                  Utils.showSnackBar(
                                      'Validation', 'Please choose a image');
                                } else {
                                  FocusScope.of(context).unfocus();
                                  AddClassReqModel model = AddClassReqModel();
                                  model.doctorId = userController.user.value.id;
                                  model.title = titleEditingController?.text;
                                  model.description =
                                      descriptionController?.text;
                                  model.featuredImage = imageW?.path;
                                  model.date = mySelectDate;
                                  model.startTime = selectedStartTime;
                                  model.endTime = selectedEndTime;
                                  model.streaming = '0';
                                  await scheduledClassController
                                      .addClass(model);
                                  if (scheduledClassController
                                          .addclassApiResponse.status ==
                                      Status.COMPLETE) {
                                    AddClassResponseModel responseModel =
                                        scheduledClassController
                                            .addclassApiResponse.data;
                                    if (responseModel.status == "Success") {
                                      CommonSnackBar.snackBar(
                                          message: responseModel.message!);
                                      Future.delayed(const Duration(seconds: 2),
                                          () {
                                        scheduledClassController.getClassDoctor(
                                            id: userController.user.value.id!,
                                            date: "");
                                        Navigator.pop(context);
                                      });
                                    } else {
                                      CommonSnackBar.snackBar(
                                          message: "Server error");
                                    }
                                  } else {
                                    CommonSnackBar.snackBar(
                                        message: "Server error");
                                  }
                                }
                              } else {}
                            }
                          },
                          child: Container(
                            height: 50,
                            // width: 50,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 12),

                            decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                  spreadRadius: 1,
                                  offset: Offset(0.5, 0.5),
                                ),
                              ],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              "Submit",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  void pickImage() {
    Get.dialog(
      Center(
        child: Container(
          height: Get.height * 0.2,
          width: Get.width * 0.5,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.blueAccent, width: 3),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MaterialButton(
                color: Colors.blueAccent,
                onPressed: () async {
                  getImage(imgSource: ImageSource.camera);
                  Navigator.pop(context);
                },
                child: const Text(
                  "Camera",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              MaterialButton(
                color: Colors.blueAccent,
                onPressed: () async {
                  getImage(imgSource: ImageSource.gallery);
                  Navigator.pop(context);
                },
                child: const Text(
                  "Gallery",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  Future getImage({required ImageSource imgSource}) async {
    final pickedFile = await _picker.pickImage(source: imgSource);

    setState(() {
      if (pickedFile != null) {
        imageW = File(pickedFile.path);
      } else {}
    });
  }
}
