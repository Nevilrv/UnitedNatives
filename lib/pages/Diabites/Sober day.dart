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
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../model/health_response_model.dart';
import '../../utils/utils.dart';

void enablePlatformOverrideForDesktop() {
  if (!kIsWeb && (Platform.isMacOS || Platform.isWindows || Platform.isLinux)) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
}

class SoberDay extends StatefulWidget {
  @override
  _SoberDayState createState() => _SoberDayState();
}

class _SoberDayState extends State<SoberDay> {
  UserController _userController = Get.find<UserController>();
  SelfMonitoringController _controller = Get.put(SelfMonitoringController());
  int totalCount = 0;
  List list = [];
  RxBool isLoading = false.obs;
  bool _isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);
  List<Datum> listDatum = [];
  List editList = [];
  String days;
  String editDays;
  String count;
  List cols = [
    {
      "title": 'StartDate',
      'index': 1,
      'widthFactor': 0.4,
      'key': 'startDate',
      'editable': false
    },
    {
      "title": 'EndDate',
      'index': 2,
      'widthFactor': 0.4,
      'key': 'endDate',
      'editable': false
    },
    {
      "title": 'Total Time',
      'index': 3,
      'widthFactor': 0.4,
      'key': 'soberTime',
      'editable': false
    },
  ];

  List rows = [];
  List<String> idList = [];

  final _editableKey = GlobalKey<EditableState>();
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();

  Future<HealthResponseModel> getSoberDayData() async {
    rows.clear();
    idList.clear();
    final String url = Constants.getRoutineHealthReport;

    var body = {
      "patient_id": "${_userController.user.value.id}",
      "report_type_id": "2",
    };

    var response = await http.post(Uri.parse(url),
        body: jsonEncode(body), headers: Config.getHeaders());

    debugPrint('RESPONSE => ${response.body}');

    try {
      if (response != null) {
        _controller.isLoading.value = false;
        HealthResponseModel model = healthResponseModelFromJson(response.body);
        listDatum = model.data;
        model.data.forEach((element) {
          idList.add(element.id);
          List list = (jsonDecode(element.tableData) as List);
          rows.add({
            'startDate': list[0],
            'endDate': list[1],
            'soberTime': list[2],
          });
        });
        debugPrint('Rows $rows');
        getDataLength = rows.length;
        setState(() {});
        return null;
      } else {
        _controller.isLoading.value = false;
        return null;
      }
    } catch (e) {
      _controller.isLoading.value = false;
      debugPrint('Error $e');
      return null;
    }
  }

  Future addSoberDayData(reportTableData) async {
    isLoading.value = true;

    final String url = Constants.addRoutineHealthReport;

    var body = {
      "patient_id": "${_userController.user.value.id}",
      "report_type_id": "2",
      "report_table_headers": [
        "StartDate",
        "EndDate",
        "Total Time",
      ],
      "report_table_data": reportTableData
    };

    var response = await http.post(Uri.parse(url),
        body: jsonEncode(body), headers: Config.getHeaders());
    isLoading.value = false;

    if (response != null) {
      await getSoberDayData();
      Utils.showSnackBar(
        'Success',
        'Client Routine Health Reports Added Successfully!!',
      );
      return true;
    } else {
      return null;
    }
  }

  Future deleteSoberDayData(String id) async {
    isLoading.value = true;

    final String url = Constants.deleteRoutineHealthReport;

    var body = {
      "patient_id": "${_userController.user.value.id}",
      "report_id": id,
    };

    var response = await http.post(Uri.parse(url),
        body: jsonEncode(body), headers: Config.getHeaders());

    isLoading.value = false;

    if (response != null) {
      await getSoberDayData();

      Utils.showSnackBar(
        'Success',
        'Routine Health Report Deleted Successfully!!',
      );
      return true;
    } else {
      return null;
    }
  }

  Future updateSoberDayData({dynamic reportTableData, String id}) async {
    isLoading.value = true;

    final String url = Constants.updateRoutineHealthReport;

    var body = {
      "patient_id": "${_userController.user.value.id}",
      "report_id": id,
      "report_table_headers": [
        "StartDate",
        "EndDate",
        "Total Time",
      ],
      "report_table_data": reportTableData,
    };

    var response = await http.post(Uri.parse(url),
        body: jsonEncode(body), headers: Config.getHeaders());
    isLoading.value = false;

    if (response != null) {
      await getSoberDayData();
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

  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();

  TextEditingController editStartTimeController = TextEditingController();
  TextEditingController editEndTimeController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    _controller.isLoading.value = true;
    getData();
    super.initState();
  }

  getData() async {
    await getSoberDayData();
    setState(() {});
  }

  AdsController adsController = Get.find();
  @override
  Widget build(BuildContext context) {
    print('getDataLength---------->>>>>>>>$getDataLength');

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
              "Sobriety Tracker",
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
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Sobriety Tracker',
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
                        return _controller.isLoading.value
                            ? /*Center(
                                child: CircularProgressIndicator(),
                              )*/
                            Center(
                                child: Utils.circular(),
                              )
                            : Container(
                                child: Editable(
                                  key: _editableKey,
                                  columns: cols,
                                  rows: rows,
                                  popUpTitle: 'Sobriety Tracker',
                                  showSaveIcon: true,
                                  saveIconColor:
                                      _isDark ? Colors.white : Colors.black,
                                  onAddButtonPressed: () async {
                                    print('DAYS::::::$days');
                                    String text =
                                        '${startTimeController.text},${endTimeController.text},$days';
                                    List<String> result = text.split(',');
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
                                        'startDate': result[0],
                                        'endDate': result[1],
                                        'soberTime': result[2],
                                      });
                                      Navigator.pop(context);

                                      await addSoberDayData(result);
                                      setState(() {
                                        days = null;
                                        startTime = null;
                                        endTime = null;
                                      });
                                    } else {
                                      // Navigator.pop(context);
                                    }
                                  },
                                  onDeleteButtonPressed: (index) async {
                                    print('Index $index');
                                    await deleteSoberDayData(idList[index]);
                                  },
                                  onEditButtonPressed: (index) {
                                    _editDialog(context, index, listDatum);
                                  },
                                  onTap: () {
                                    startTimeController.clear();
                                    endTimeController.clear();
                                    days = null;
                                    editDays = null;
                                    startTime = null;
                                    endTime = null;
                                  },
                                  popUpChild: Container(
                                    width: Get.width * 0.75,
                                    child: StatefulBuilder(
                                      builder: (BuildContext context,
                                          StateSetter setStates) {
                                        return Column(
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                final DateTime picked =
                                                    await showDatePicker(
                                                        context: context,
                                                        initialDate:
                                                            startTime ??
                                                                DateTime.now(),
                                                        firstDate:
                                                            DateTime(2000, 8),
                                                        lastDate:
                                                            DateTime(2100));
                                                if (picked != null &&
                                                    picked != startTime)
                                                  setStates(() {
                                                    startTime = picked;
                                                    startTimeController.text =
                                                        DateFormat('dd-MM-yyyy')
                                                            .format(startTime);
                                                    print(
                                                        '===startTimeController.text...${startTimeController.text}');

                                                    if (editStartTimeController
                                                        .text.isNotEmpty) {
                                                      DateTime date1 =
                                                          startTime;
                                                      DateTime date2 = endTime;
                                                      List<int> diffYMD =
                                                          differenceInYearsMonthsDays(
                                                              date1, date2);
                                                      List<int> diffMD =
                                                          differenceInMonths(
                                                              date1, date2);
                                                      int diffD =
                                                          differenceInDays(
                                                              date1, date2);
                                                      print(
                                                          "The difference in years, months and days: ${diffYMD[0]} years, ${diffYMD[1]} months, and ${diffYMD[2]} days.");
                                                      print(
                                                          "The difference in months and days: ${diffMD[0]} months, and ${diffMD[1]} days.");
                                                      print(
                                                          "The difference in days: $diffD days.");
                                                      if (diffYMD[0] == 0 &&
                                                          diffYMD[1] == 0) {
                                                        print(
                                                            " days: ${diffYMD[2]} days.");
                                                        days =
                                                            '${diffYMD[2]} ${diffYMD[2] == 1 ? 'Day' : 'Days'}';
                                                      } else if (diffYMD[0] ==
                                                          0) {
                                                        print(
                                                            " years, months and days: ${diffYMD[1]} months, and ${diffYMD[2]} days.");
                                                        days =
                                                            '${diffYMD[1]} ${diffYMD[1] == 1 ? 'Month' : 'Months'} ${diffYMD[2]} ${diffYMD[2] == 1 ? 'Day' : 'Days'}';
                                                      } else {
                                                        print(
                                                            "The difference in years, months and days: ${diffYMD[0]} years, ${diffYMD[1]} months, and ${diffYMD[2]} days.");
                                                        days =
                                                            '${diffYMD[0]} ${diffYMD[0] == 1 ? 'Year' : 'Years'} ${diffYMD[1]} ${diffYMD[1] == 1 ? 'Month' : 'Months'} ${diffYMD[2]} ${diffYMD[2] == 1 ? 'Day' : 'Days'}';
                                                      }
                                                    } else {
                                                      return null;
                                                    }
                                                  });
                                              },
                                              child: TextField(
                                                controller: startTimeController,
                                                readOnly: true,
                                                enabled: false,
                                                decoration: InputDecoration(
                                                    hintText:
                                                        'Start Date for Sober'),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () async {
                                                final DateTime picked =
                                                    await showDatePicker(
                                                        context: context,
                                                        initialDate:
                                                            startTime ??
                                                                DateTime.now(),
                                                        firstDate: startTime,
                                                        lastDate:
                                                            DateTime(2100));
                                                if (picked != null &&
                                                    picked != endTime)
                                                  setStates(() {
                                                    endTime = picked;
                                                    endTimeController.text =
                                                        DateFormat('dd-MM-yyyy')
                                                            .format(endTime);
                                                    DateTime date1 = startTime;
                                                    DateTime date2 = endTime;
                                                    List<int> diffYMD =
                                                        differenceInYearsMonthsDays(
                                                            date1, date2);
                                                    List<int> diffMD =
                                                        differenceInMonths(
                                                            date1, date2);
                                                    int diffD =
                                                        differenceInDays(
                                                            date1, date2);
                                                    print(
                                                        "The difference in years, months and days: ${diffYMD[0]} years, ${diffYMD[1]} months, and ${diffYMD[2]} days.");
                                                    print(
                                                        "The difference in months and days: ${diffMD[0]} months, and ${diffMD[1]} days.");
                                                    print(
                                                        "The difference in days: $diffD days.");
                                                    if (diffYMD[0] == 0 &&
                                                        diffYMD[1] == 0) {
                                                      print(
                                                          " days: ${diffYMD[2]} days.");
                                                      days =
                                                          '${diffYMD[2]} ${diffYMD[2] == 1 ? 'Day' : 'Days'}';
                                                    } else if (diffYMD[0] ==
                                                        0) {
                                                      print(
                                                          " years, months and days: ${diffYMD[1]} months, and ${diffYMD[2]} days.");
                                                      days =
                                                          '${diffYMD[1]} ${diffYMD[1] == 1 ? 'Month' : 'Months'} ${diffYMD[2]} ${diffYMD[2] == 1 ? 'Day' : 'Days'}';
                                                    } else {
                                                      print(
                                                          "The difference in years, months and days: ${diffYMD[0]} years, ${diffYMD[1]} months, and ${diffYMD[2]} days.");
                                                      days =
                                                          '${diffYMD[0]} ${diffYMD[0] == 1 ? 'Year' : 'Years'} ${diffYMD[1]} ${diffYMD[1] == 1 ? 'Month' : 'Months'} ${diffYMD[2]} ${diffYMD[2] == 1 ? 'Day' : 'Days'}';
                                                    }
                                                  });
                                              },
                                              child: TextField(
                                                controller: endTimeController,
                                                readOnly: true,
                                                enabled: false,
                                                decoration: InputDecoration(
                                                    hintText:
                                                        'End Date for Sober'),
                                              ),
                                            ),
                                            days == '' || days == null
                                                ? SizedBox()
                                                : Text('$days')
                                          ],
                                        );
                                      },
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
                      }),
                    ),
                    if (getDataLength == 0 &&
                        _controller.isLoading.isFalse &&
                        isLoading.value == false)
                      Padding(
                        padding: EdgeInsets.only(bottom: Get.height * 0.44),
                        child: Text(
                          'No any sobriety tracker data',
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
    editStartTimeController.text = editList[0];
    editEndTimeController.text = editList[1];

    print('===>editStartTimeController:${editStartTimeController.text}');
    print('===>editEndTimeController:${editEndTimeController.text}');

    int editStartDateYear =
        int.parse(editStartTimeController.text.split('-')[2]);
    int editStartDateMonth =
        int.parse(editStartTimeController.text.split('-')[1]);
    int editStartDateDay =
        int.parse(editStartTimeController.text.split('-')[0]);

    int editEndDateYear = int.parse(editEndTimeController.text.split('-')[2]);
    int editEndDateMonth = int.parse(editEndTimeController.text.split('-')[1]);
    int editEndDateDay = int.parse(editEndTimeController.text.split('-')[0]);

    startTime =
        DateTime(editStartDateYear, editStartDateMonth, editStartDateDay);
    endTime = DateTime(editEndDateYear, editEndDateMonth, editEndDateDay);

    editDays = editList[2];

    print('===>startTime:$startTime');
    print('===>endTime:$endTime');

    Alert(
        context: context,
        title: 'Sobriety Tracker',
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Container(
            width: Get.width * 0.75,
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setStates) {
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final DateTime picked = await showDatePicker(
                            context: context,
                            initialDate: startTime ?? DateTime.now(),
                            firstDate: DateTime(2000, 8),
                            lastDate: DateTime(2100));
                        if (picked != null && picked != startTime)
                          setStates(() {
                            startTime = picked;
                            editStartTimeController.text =
                                DateFormat('dd-MM-yyyy').format(startTime);
                            if (editStartTimeController.text.isNotEmpty) {
                              DateTime date1 = startTime;
                              DateTime date2 = endTime;
                              List<int> diffYMD =
                                  differenceInYearsMonthsDays(date1, date2);
                              List<int> diffMD =
                                  differenceInMonths(date1, date2);
                              int diffD = differenceInDays(date1, date2);
                              print(
                                  "The difference in years, months and days: ${diffYMD[0]} years, ${diffYMD[1]} months, and ${diffYMD[2]} days.");
                              print(
                                  "The difference in months and days: ${diffMD[0]} months, and ${diffMD[1]} days.");
                              print("The difference in days: $diffD days.");
                              if (diffYMD[0] == 0 && diffYMD[1] == 0) {
                                print(" days: ${diffYMD[2]} days.");
                                days =
                                    '${diffYMD[2]} ${diffYMD[2] == 1 ? 'Day' : 'Days'}';
                              } else if (diffYMD[0] == 0) {
                                print(
                                    " years, months and days: ${diffYMD[1]} months, and ${diffYMD[2]} days.");
                                days =
                                    '${diffYMD[1]} ${diffYMD[1] == 1 ? 'Month' : 'Months'} ${diffYMD[2]} ${diffYMD[2] == 1 ? 'Day' : 'Days'}';
                              } else {
                                print(
                                    "The difference in years, months and days: ${diffYMD[0]} years, ${diffYMD[1]} months, and ${diffYMD[2]} days.");
                                days =
                                    '${diffYMD[0]} ${diffYMD[0] == 1 ? 'Year' : 'Years'} ${diffYMD[1]} ${diffYMD[1] == 1 ? 'Month' : 'Months'} ${diffYMD[2]} ${diffYMD[2] == 1 ? 'Day' : 'Days'}';
                              }

                              editDays = days;
                            } else {
                              return null;
                            }
                          });
                      },
                      child: TextField(
                        controller: editStartTimeController,
                        readOnly: true,
                        enabled: false,
                        decoration:
                            InputDecoration(hintText: 'Start Date for Sober'),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        final DateTime picked = await showDatePicker(
                            context: context,
                            initialDate: endTime ?? DateTime.now(),
                            firstDate: startTime,
                            lastDate: DateTime(2100));
                        if (picked != null && picked != endTime)
                          setStates(() {
                            endTime = picked;
                            editEndTimeController.text =
                                DateFormat('dd-MM-yyyy').format(endTime);
                            DateTime date1 = startTime;
                            DateTime date2 = endTime;
                            List<int> diffYMD =
                                differenceInYearsMonthsDays(date1, date2);
                            List<int> diffMD = differenceInMonths(date1, date2);
                            int diffD = differenceInDays(date1, date2);
                            print(
                                "The difference in years, months and days: ${diffYMD[0]} years, ${diffYMD[1]} months, and ${diffYMD[2]} days.");
                            print(
                                "The difference in months and days: ${diffMD[0]} months, and ${diffMD[1]} days.");
                            print("The difference in days: $diffD days.");
                            if (diffYMD[0] == 0 && diffYMD[1] == 0) {
                              print(" days: ${diffYMD[2]} days.");
                              days =
                                  '${diffYMD[2]} ${diffYMD[2] == 1 ? 'Day' : 'Days'}';
                            } else if (diffYMD[0] == 0) {
                              print(
                                  " years, months and days: ${diffYMD[1]} months, and ${diffYMD[2]} days.");
                              days =
                                  '${diffYMD[1]} ${diffYMD[1] == 1 ? 'Month' : 'Months'} ${diffYMD[2]} ${diffYMD[2] == 1 ? 'Day' : 'Days'}';
                            } else {
                              print(
                                  "The difference in years, months and days: ${diffYMD[0]} years, ${diffYMD[1]} months, and ${diffYMD[2]} days.");
                              days =
                                  '${diffYMD[0]} ${diffYMD[0] == 1 ? 'Year' : 'Years'} ${diffYMD[1]} ${diffYMD[1] == 1 ? 'Month' : 'Months'} ${diffYMD[2]} ${diffYMD[2] == 1 ? 'Day' : 'Days'}';
                            }
                            editDays = days;
                          });
                      },
                      child: TextField(
                        controller: editEndTimeController,
                        readOnly: true,
                        enabled: false,
                        decoration:
                            InputDecoration(hintText: 'End Date for Sober'),
                      ),
                    ),
                    editDays == '' || editDays == null
                        ? Text('$days')
                        : Text('$editDays')
                  ],
                );
              },
            ),
          ),
        ),
        buttons: [
          DialogButton(
            onPressed: () async {
              print('call');
              String text =
                  '${editStartTimeController.text},${editEndTimeController.text},${days ?? editDays}';
              List<String> result = text.split(',');
              print("result=??$result");
              Navigator.pop(context);
              await updateSoberDayData(
                  id: idList[index], reportTableData: result);
              days = null;
              startTime = null;
              endTime = null;
            },
            child: Text(
              "Save",
              style: TextStyle(color: Colors.white, fontSize: 22),
            ),
          )
        ]).show();
  }

  static bool leapYear(DateTime date) {
    if (date.year % 4 == 0) {
      if (date.year % 100 == 0) {
        return date.year % 400 == 0;
      }
      return true;
    }
    return false;
  }

  static List<int> differenceInYearsMonthsDays(DateTime dt1, DateTime dt2) {
    List<int> simpleYear = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    if (dt1.isAfter(dt2)) {
      DateTime temp = dt1;
      dt1 = dt2;
      dt2 = temp;
    }
    int totalMonthsDifference = ((dt2.year * 12) + (dt2.month - 1)) -
        ((dt1.year * 12) + (dt1.month - 1));
    int years = (totalMonthsDifference / 12).floor();
    int months = totalMonthsDifference % 12;
    int days;
    if (dt2.day >= dt1.day) {
      days = dt2.day - dt1.day;
    } else {
      int monthDays = dt2.month == 3
          ? (leapYear(dt2) ? 29 : 28)
          : (dt2.month - 2 == -1 ? simpleYear[11] : simpleYear[dt2.month - 2]);
      int day = dt1.day;
      if (day > monthDays) day = monthDays;
      days = monthDays - (day - dt2.day);
      months--;
    }
    if (months < 0) {
      months = 11;
      years--;
    }
    return [years, months, days];
  }

  static List<int> differenceInMonths(DateTime dt1, DateTime dt2) {
    List<int> inYears = differenceInYearsMonthsDays(dt1, dt2);
    int difMonths = (inYears[0] * 12) + inYears[1];
    return [difMonths, inYears[2]];
  }

  static int differenceInDays(DateTime dt1, DateTime dt2) {
    if (dt1.isAfter(dt2)) {
      DateTime temp = dt1;
      dt1 = dt2;
      dt2 = temp;
    }
    return dt2.difference(dt1).inDays;
  }
}
