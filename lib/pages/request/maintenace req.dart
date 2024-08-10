import 'dart:async';
import 'package:date_format/date_format.dart';
import 'package:united_natives/components/ads_bottom_bar.dart';
import 'package:united_natives/controller/ads_controller.dart';
import 'package:united_natives/data/pref_manager.dart';
import 'package:united_natives/newModel/apiModel/requestModel/patient_add_request_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/message_status_response_model.dart';
import 'package:united_natives/newModel/apis/api_response.dart';
import 'package:united_natives/utils/common_snackbar.dart';
import 'package:united_natives/utils/utils.dart';
import 'package:united_natives/viewModel/patient_request_viewModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MaintenanceRequestScreen extends StatefulWidget {
  final String? categoryId;

  const MaintenanceRequestScreen({super.key, this.categoryId});
  @override
  State<MaintenanceRequestScreen> createState() =>
      _MaintenanceRequestScreenState();
}

class _MaintenanceRequestScreenState extends State<MaintenanceRequestScreen> {
  double? width;
  double? height;

  String? _setTime, setDate;

  String? _hour, _minute, _time;

  String? dateTime;
  final bool _isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);

  DateTime selectedDate = DateTime.now();
  RequestController requestController = Get.find();
  TimeOfDay selectedTime = const TimeOfDay(hour: 00, minute: 00);
  String? mySelectDate, selectedStartTime;
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  TextEditingController noteController = TextEditingController();
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
          mySelectDate = "${value.toLocal()}".split(' ')[0];
        });
      }

      return selectedDate;
    });
    debugPrint('picked==========>>>>>$picked');
  }

  Future<Null> _selectTime(BuildContext context) async {
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
            [hh, ':', nn, ":", ss]).toString();
        selectedStartTime = _setTime;
      });
    }
  }

  @override
  void initState() {
    _dateController.text = DateFormat('dd/MM/yyyy').format(selectedDate);

    _timeController.text = formatDate(
        DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute),
        [hh, ':', nn, " ", am]).toString();
    super.initState();
  }

  AdsController adsController = Get.find();
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    dateTime = DateFormat.yMd().format(DateTime.now());
    return GetBuilder<AdsController>(builder: (ads) {
      return Scaffold(
          bottomNavigationBar: AdsBottomBar(
            ads: ads,
            context: context,
          ),
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Request',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleMedium?.color,
                  fontSize: 24),
              textAlign: TextAlign.center,
            ),
          ),
          body: SafeArea(
              child: Center(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.7),
                        offset: const Offset(0, 0),
                        blurRadius: 10)
                  ],
                  borderRadius: BorderRadius.circular(20)),
              width: Get.width,
              child: Padding(
                padding: EdgeInsets.all(Get.height * 0.013),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey, width: 2),
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: EdgeInsets.all(Get.height * 0.012),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: Get.height * 0.01,
                          ),
                          chooseText(),
                          SizedBox(
                            height: Get.height * 0.01,
                          ),
                          date(context),
                          SizedBox(
                            height: Get.height * 0.01,
                          ),
                          time(context),
                          SizedBox(
                            height: Get.height * 0.01,
                          ),
                          note(),
                          SizedBox(
                            height: Get.height * 0.03,
                          ),
                          submit()
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )));
    });
  }

  Material submit() {
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
            color: Colors.blue, borderRadius: BorderRadius.circular(10)),
        child: InkWell(
          onTap: () {
            if (mySelectDate == null || mySelectDate == '') {
              CommonSnackBar.snackBar(message: "Please select date");
              return;
            }
            if (selectedStartTime == null || selectedStartTime == '') {
              CommonSnackBar.snackBar(message: "Please select time");
              return;
            }
            if (noteController.text.isEmpty || noteController.text == '') {
              CommonSnackBar.snackBar(message: "please enter note");
              return;
            } else {
              dialog();
            }
          },
          child: SizedBox(
            width: Get.width * 0.25,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: Text(
                'Submit',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: Get.width * 0.049,
                    fontWeight: FontWeight.bold),
              )),
            ),
          ),
        ),
      ),
    );
  }

  Future dialog() {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  ' Request successfully submitted!!!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Image.asset(
                'assets/images/success.png',
                height: Get.height * 0.07,
                width: Get.width * 0.5,
              ),
              SizedBox(
                height: Get.height * 0.01,
              ),
              GestureDetector(
                onTap: () async {
                  AddRequestModel model = AddRequestModel();
                  model.date = mySelectDate;
                  model.time = selectedStartTime;
                  model.notes = noteController.text;
                  model.categoryId = widget.categoryId;

                  await requestController.addRequest(model: model);
                  if (requestController.addRequestApiResponse.status ==
                      Status.COMPLETE) {
                    MessageStatusResponseModel model =
                        requestController.addRequestApiResponse.data;
                    if (model.status == 'Success') {
                      CommonSnackBar.snackBar(message: model.message!);
                      Future.delayed(const Duration(seconds: 2), () {
                        FocusScope.of(context).unfocus();
                        Navigator.pop(context);
                      });
                    } else {
                      CommonSnackBar.snackBar(message: "Server error");
                    }
                  } else {
                    CommonSnackBar.snackBar(message: "Server error");
                  }
                },
                child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: GetBuilder<RequestController>(
                      builder: (controller) {
                        if (controller.addRequestApiResponse.status ==
                            Status.LOADING) {
                          // return Center(child: CircularProgressIndicator());
                          return Center(
                            child: Utils.circular(),
                          );
                        }
                        return Container(
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10)),
                          child: const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Center(
                                child: Text(
                              'Submit',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),
                            )),
                          ),
                        );
                      },
                    )),
              ),
            ],
          ),
        );
      },
    );
  }

  TextField note() {
    return TextField(
      controller: noteController,
      maxLines: 4,
      style: TextStyle(color: _isDark ? Colors.black : Colors.black),
      decoration: InputDecoration(
          hintText: 'Enter Note',
          hintStyle: TextStyle(
            color: _isDark ? Colors.black : Colors.black,
            fontSize: Get.height * 0.027,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: _isDark ? Colors.black : Colors.grey),
            borderRadius: BorderRadius.circular(15),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: _isDark ? Colors.black : Colors.grey),
            borderRadius: BorderRadius.circular(15),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: _isDark ? Colors.black : Colors.grey),
            borderRadius: BorderRadius.circular(15),
          )),
    );
  }

  Row time(BuildContext context) {
    return Row(
      children: [
        Text(
          'Time : ',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: Get.height * 0.028,
              color: _isDark ? Colors.black : Colors.black),
        ),
        Expanded(
          child: InkWell(
            onTap: () {
              _selectTime(context);
            },
            child: Container(
              height: Get.height * 0.06,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey, width: 1)),
              child: selectedStartTime != null
                  ? Center(
                      child: Text(
                        "$selectedStartTime",
                        style: TextStyle(
                            fontSize: Get.height * 0.03,
                            color: _isDark ? Colors.black : Colors.black),
                      ),
                    )
                  : Center(
                      child: Text(
                        "Choose time",
                        style: TextStyle(
                            fontSize: Get.height * 0.03,
                            color: _isDark ? Colors.black : Colors.black),
                      ),
                    ),
            ),
          ),
        )
      ],
    );
  }

  Row date(BuildContext context) {
    return Row(
      children: [
        Text(
          'Date : ',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: Get.height * 0.028,
              color: _isDark ? Colors.black : Colors.black),
        ),
        Expanded(
          child: InkWell(
            onTap: () {
              _selectDate(context);
            },
            child: Container(
              height: Get.height * 0.06,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey, width: 1)),
              child: mySelectDate != null && mySelectDate != ""
                  ? Center(
                      child: Text("${selectedDate.toLocal()}".split(' ')[0],
                          style: TextStyle(
                              fontSize: Get.height * 0.03,
                              color: _isDark ? Colors.black : Colors.black)),
                    )
                  : Center(
                      child: Text(
                      "Choose date",
                      style: TextStyle(
                          fontSize: Get.height * 0.03,
                          color: _isDark ? Colors.black : Colors.black),
                    )),
            ),
          ),
        )
      ],
    );
  }

  Text chooseText() {
    return Text(
      'Please choose date and time',
      style: TextStyle(
          fontSize: Get.height * 0.027,
          color: _isDark ? Colors.black : Colors.black),
    );
  }
}
