import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:doctor_appointment_booking/components/ads_bottom_bar.dart';
import 'package:doctor_appointment_booking/controller/ads_controller.dart';
import 'package:doctor_appointment_booking/controller/self_monitoring_controller.dart';
import 'package:doctor_appointment_booking/controller/user_controller.dart';
import 'package:doctor_appointment_booking/data/pref_manager.dart';
import 'package:doctor_appointment_booking/pages/Diabites/custom_package/editable_custom_package.dart';
import 'package:doctor_appointment_booking/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../model/health_response_model.dart';
import '../../utils/utils.dart';

void enablePlatformOverrideForDesktop() {
  if (!kIsWeb && (Platform.isMacOS || Platform.isWindows || Platform.isLinux)) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
}

class Sleep extends StatefulWidget {
  @override
  _SleepState createState() => _SleepState();
}

class _SleepState extends State<Sleep> {
  UserController _userController = Get.find<UserController>();
  SelfMonitoringController _controller = Get.put(SelfMonitoringController());
  int totalCount = 0;
  String startTime;
  String endTime;
  List list = [];
  RxBool isLoading = false.obs;
  List<Datum> listDatum = [];
  List editList = [];
  bool _isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);
  List cols = [
    {
      "title": 'Date',
      'index': 1,
      'widthFactor': 0.3,
      'key': 'Date',
      'editable': false
    },
    {
      "title": 'Start Time',
      'index': 2,
      'widthFactor': 0.3,
      'key': 'StartTime',
      'editable': false
    },
    {
      "title": 'End Time',
      'index': 3,
      'widthFactor': 0.3,
      'key': 'EndTime',
      'editable': false
    },
    {
      "title": 'Naps',
      'index': 4,
      'widthFactor': 0.3,
      'key': 'Naps',
      'editable': false
    },
    {
      "title": 'Night',
      'index': 5,
      'widthFactor': 0.3,
      'key': 'Night',
      'editable': false
    },
    {
      "title": 'Total',
      'index': 6,
      'widthFactor': 0.3,
      'key': 'Total',
      'editable': false
    },
  ];

  List rows = [];
  List<String> idList = [];

  final _editableKey = GlobalKey<EditableState>();
  Future<void> _startTime(BuildContext context, bool isEdit) async {
    TimeOfDay pickedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );

    if (pickedTime != null) {
      debugPrint(pickedTime.format(context)); //output 10:51 PM
      /*DateTime parsedTime =
          DateFormat.jm().parse(pickedTime.format(context));
      print(parsedTime); */ //output 1970-01-01 22:53:00.000
      DayPeriod day = pickedTime.period;
      String day1 = day.toString();
      List data = day1.split('.');
      String v = data.last;
      String v1 = v.toUpperCase();
      setState(() {
        isEdit == true
            ? editStartTimeController.text =
                '${pickedTime.hour > 12 ? pickedTime.hour - 12 : pickedTime.hour}:${pickedTime.minute} $v1'
            : startTimeController.text =
                '${pickedTime.hour > 12 ? pickedTime.hour - 12 : pickedTime.hour}:${pickedTime.minute} $v1'; //set the value of text field.
      });
    } else {
      debugPrint("Time is not selected");
    }
  }

  Future<void> _endTime(BuildContext context, bool isEdit) async {
    TimeOfDay pickedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );

    if (pickedTime != null) {
      debugPrint(pickedTime.format(context)); //output 10:51 PM
      //output 1970-01-01 22:53:00.000
      DayPeriod day = pickedTime.period;
      String day1 = day.toString();
      List data = day1.split('.');
      String v = data.last;
      String v1 = v.toUpperCase();

      setState(() {
        isEdit == true
            ? editEndTimeController.text =
                '${pickedTime.hour > 12 ? pickedTime.hour - 12 : pickedTime.hour}:${pickedTime.minute} $v1'
            : endTimeController.text =
                '${pickedTime.hour > 12 ? pickedTime.hour - 12 : pickedTime.hour}:${pickedTime.minute} $v1'; //set the value of text field.
      });
    } else {
      debugPrint("Time is not selected");
    }
  }

  Future<HealthResponseModel> getSleepData() async {
    rows.clear();
    idList.clear();
    final String url = Constants.getRoutineHealthReport;

    var body = {
      "patient_id": "${_userController.user.value.id}",
      "report_type_id": "5",
    };

    var response = await http.post(Uri.parse(url),
        body: jsonEncode(body), headers: Config.getHeaders());

    try {
      if (response != null) {
        _controller.isLoading.value = false;
        HealthResponseModel model = healthResponseModelFromJson(response.body);
        model.data.forEach((element) {
          listDatum = model.data;
          idList.add(element.id);
          List list = (jsonDecode(element.tableData) as List);
          print("ROWS------");
          print(list[0]);
          rows.add({
            'Date': list[0],
            'StartTime': list[1],
            'EndTime': list[2],
            'Naps': list[3],
            'Night': list[4],
            'Total': list[5],
          });
        });
        print('Rows $rows');
        getDataLength = rows.length;
        setState(() {});
        return null;
      } else {
        _controller.isLoading.value = false;
        return null;
      }
    } catch (e) {
      _controller.isLoading.value = false;
      print('Error $e');
      return null;
    }
  }

  Future addSleepData(reportTableData) async {
    isLoading.value = true;

    final String url = Constants.addRoutineHealthReport;

    var body = {
      "patient_id": "${_userController.user.value.id}",
      "report_type_id": "5",
      "report_table_headers": [
        "DATE",
        "NAPS",
        "NIGHT",
        "TOTAL",
      ],
      "report_table_data": reportTableData
    };

    var response = await http.post(Uri.parse(url),
        body: jsonEncode(body), headers: Config.getHeaders());
    isLoading.value = false;

    print('RESPONSE => ${response.body}');

    if (response != null) {
      await getSleepData();
      Utils.showSnackBar(
        'Success',
        'Client Routine Health Reports Added Successfully!!',
      );
      return true;
    } else {
      return null;
    }
  }

  Future deleteSleepData(String id) async {
    isLoading.value = true;

    final String url = Constants.deleteRoutineHealthReport;

    var body = {
      "patient_id": "${_userController.user.value.id}",
      "report_id": id,
    };

    var response = await http.post(Uri.parse(url),
        body: jsonEncode(body), headers: Config.getHeaders());
    isLoading.value = false;

    print('RESPONSE => ${response.body}');

    if (response != null) {
      await getSleepData();

      Utils.showSnackBar(
        'Success',
        'Routine Health Report Deleted Successfully!!',
      );
      return true;
    } else {
      return null;
    }
  }

  Future updateSleepData({dynamic reportTableData, String id}) async {
    isLoading.value = true;

    final String url = Constants.updateRoutineHealthReport;

    var body = {
      "patient_id": "${_userController.user.value.id}",
      "report_id": id,
      "report_table_headers": [
        "DATE",
        "NAPS",
        "NIGHT",
        "TOTAL",
      ],
      "report_table_data": reportTableData,
    };

    var response = await http.post(Uri.parse(url),
        body: jsonEncode(body), headers: Config.getHeaders());
    isLoading.value = false;

    print('RESPONSE => ${response.body}');

    if (response != null) {
      await getSleepData();
      Utils.showSnackBar(
        'Success',
        'Routine Health Report Updated Successfully!!',
      );
      return true;
    } else {
      return null;
    }
  }

  int getDataLength = 0;

  TextEditingController dateController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  TextEditingController napsController = TextEditingController();
  TextEditingController nightController = TextEditingController();
  TextEditingController totalController = TextEditingController();

  TextEditingController editDateController = TextEditingController();
  TextEditingController editStartTimeController = TextEditingController();
  TextEditingController editEndTimeController = TextEditingController();
  TextEditingController editNapsController = TextEditingController();
  TextEditingController editNightController = TextEditingController();
  TextEditingController editTotalController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    _controller.isLoading.value = true;
    getData();
    super.initState();
  }

  getData() async {
    await getSleepData();
    setState(() {});
  }

  AdsController adsController = Get.find();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: GetBuilder<AdsController>(builder: (ads) {
        return Scaffold(
          bottomNavigationBar: AdsBottomBar(
            ads: ads,
            context: context,
          ),
          appBar: AppBar(
            title: Text(
              "Sleep",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.subtitle1.color,
                  fontSize: 24),
            ),
          ),
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Sleep Tracker',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: Obx(() {
                        if (_controller.isLoading.value) {
                          return /*Center(
                            child: CircularProgressIndicator(),
                          )*/
                              Center(
                            child: Utils.circular(),
                          );
                        } else {
                          return Container(
                            child: Editable(
                              key: _editableKey,
                              columns: cols,
                              rows: rows,
                              popUpTitle: 'Sleep Tracker',
                              showSaveIcon: true,
                              saveIconColor:
                                  _isDark ? Colors.white : Colors.black,
                              onAddButtonPressed: () async {
                                print("dateController");
                                print(dateController.text);
                                String text =
                                    '${dateController.text},${startTimeController.text},${endTimeController.text},${napsController.text},${nightController.text},${totalController.text}';
                                List<String> result = text.split(',');
                                print("result=??$result");

                                bool addData = true;
                                for (int i = 0; i < result.length; i++) {
                                  if (result[i] == "") {
                                    Utils.showSnackBar(
                                      'Enter details',
                                      'Please enter all required details!!',
                                    );
                                    addData = false;
                                    break;
                                  }
                                }
                                if (addData) {
                                  rows.add({
                                    'Date': result[0],
                                    'StartTime': result[1],
                                    'EndTime': result[2],
                                    'Naps': result[3],
                                    'Night': result[4],
                                    'Total': result[5],
                                  });
                                  Navigator.pop(context);
                                  await addSleepData(result);
                                } else {
                                  // Navigator.pop(context);
                                }
                              },
                              onDeleteButtonPressed: (index) async {
                                print('Index $index');
                                await deleteSleepData(idList[index]);
                              },
                              onEditButtonPressed: (index) {
                                _editDialog(context, index, listDatum);
                              },
                              onTap: () {
                                dateController.clear();
                                startTimeController.clear();
                                endTimeController.clear();
                                napsController.clear();
                                nightController.clear();
                                totalController.clear();
                              },
                              popUpChild: Container(
                                width: Get.width * 0.75,
                                child: Column(
                                  children: [
                                    TextField(
                                      controller: dateController,
                                      onTap: () async {
                                        dateController.text =
                                            await Utils.selectedDateFormat(
                                                context);
                                      },
                                      readOnly: true,
                                      decoration:
                                          InputDecoration(hintText: 'Date'),
                                    ),
                                    TextField(
                                      onTap: () async {
                                        _startTime(context, false);
                                      },
                                      readOnly: true,
                                      controller: startTimeController,
                                      decoration: InputDecoration(
                                          hintText: 'Start Time'),
                                    ),
                                    TextField(
                                      onTap: () {
                                        _endTime(context, false);
                                      },
                                      readOnly: true,
                                      controller: endTimeController,
                                      decoration:
                                          InputDecoration(hintText: 'End Time'),
                                    ),
                                    TextField(
                                      controller: napsController,
                                      decoration:
                                          InputDecoration(hintText: 'Naps'),
                                    ),
                                    TextField(
                                      controller: nightController,
                                      decoration:
                                          InputDecoration(hintText: 'Night'),
                                    ),
                                    TextField(
                                      controller: totalController,
                                      decoration:
                                          InputDecoration(hintText: 'Total'),
                                    ),
                                  ],
                                ),
                              ),
                              borderColor: Colors.blueGrey,
                              showCreateButton: true,
                              onSubmitted: (value) {},
                              createButtonLabel: Text(
                                'New',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          );
                        }
                      }),
                    ),
                    if (getDataLength == 0 &&
                        _controller.isLoading.isFalse &&
                        isLoading.value == false)
                      Padding(
                        padding: EdgeInsets.only(bottom: Get.height * 0.44),
                        child: Text(
                          'No sleep tracker data',
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(fontSize: 20),
                        ),
                      )
                  ],
                ),
              ),
              Obx(
                () => isLoading.value ? Utils.loadingBar() : SizedBox(),
              )
            ],
          ),
        );
      }),
    );
  }

  _editDialog(context, index, listDatum) async {
    editList = (jsonDecode(listDatum[index].tableData) as List);
    editDateController.text = editList[0];

    editStartTimeController.text = editList[1];
    editEndTimeController.text = editList[2];
    editNapsController.text = editList[3];

    editNightController.text = editList[4];
    editTotalController.text = editList[5];
    Alert(
        context: context,
        title: 'Sleep Tracker',
        content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setStates) {
                return Container(
                  width: Get.width * 0.75,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          String date = await Utils.selectedDateFormat(context);
                          setStates(() {
                            editDateController.text = date;
                            print('CONTROLLER  ${editDateController.text}');
                          });
                        },
                        child: TextField(
                          enabled: false,
                          readOnly: true,
                          controller: editDateController,
                          decoration: InputDecoration(hintText: 'Date'),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setStates(() {
                            _startTime(context, true);
                          });
                        },
                        child: TextField(
                          enabled: false,
                          readOnly: true,
                          controller: editStartTimeController,
                          decoration: InputDecoration(hintText: 'Start Time'),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _endTime(context, true);
                        },
                        child: TextField(
                          enabled: false,
                          readOnly: true,
                          controller: editEndTimeController,
                          decoration: InputDecoration(hintText: 'End Time'),
                        ),
                      ),
                      TextField(
                        controller: editNapsController,
                        decoration: InputDecoration(hintText: 'Naps'),
                      ),
                      TextField(
                        controller: editNightController,
                        decoration: InputDecoration(hintText: 'Night'),
                      ),
                      TextField(
                        controller: editTotalController,
                        decoration: InputDecoration(hintText: 'Total'),
                      ),
                    ],
                  ),
                );
              },
            )),
        buttons: [
          DialogButton(
            onPressed: () async {
              print('call');
              String text =
                  '${editDateController.text},${editStartTimeController.text},${editEndTimeController.text},${editNapsController.text},${editNightController.text},${editTotalController.text}';
              List<String> result = text.split(',');
              print("result=??$result");
              Navigator.pop(context);
              await updateSleepData(id: idList[index], reportTableData: result);
            },
            child: Text(
              "Save",
              style: TextStyle(color: Colors.white, fontSize: 22),
            ),
          )
        ]).show();
  }
}
