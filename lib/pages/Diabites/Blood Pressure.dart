import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:date_format/date_format.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:united_natives/components/ads_bottom_bar.dart';
import 'package:united_natives/controller/ads_controller.dart';
import 'package:united_natives/controller/self_monitoring_controller.dart';
import 'package:united_natives/controller/user_controller.dart';
import 'package:united_natives/data/pref_manager.dart';
import 'package:united_natives/pages/Diabites/custom_package/editable_custom_package.dart';
import 'package:united_natives/utils/constants.dart';
import '../../model/health_response_model.dart';
import '../../utils/utils.dart';

void enablePlatformOverrideForDesktop() {
  if (!kIsWeb && (Platform.isMacOS || Platform.isWindows || Platform.isLinux)) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
}

class BloodPressure extends StatefulWidget {
  const BloodPressure({super.key});

  @override
  State<BloodPressure> createState() => _BloodPressureState();
}

class _BloodPressureState extends State<BloodPressure> {
  final UserController _userController = Get.find<UserController>();
  final SelfMonitoringController _controller =
      Get.put(SelfMonitoringController());
  int totalCount = 0;
  List list = [];
  RxBool isLoading = false.obs;
  final bool _isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);
  List<Datum> listDatum = [];
  List editList = [];
  List cols = [
    {
      "title": 'Date',
      'index': 1,
      'widthFactor': 0.55,
      'key': 'Date',
      'editable': false
    },
    {
      "title": 'Time',
      'index': 2,
      'widthFactor': 0.55,
      'key': 'Time',
      'editable': false
    },
    {
      "title": 'Systolic',
      'index': 3,
      'widthFactor': 0.55,
      'key': 'Sbp',
      'editable': false
    },
    {
      "title": 'Diastolic',
      'index': 4,
      'widthFactor': 0.55,
      'key': 'Dbp',
      'editable': false
    },
    {
      "title": 'Heart beat per minute',
      'index': 5,
      'widthFactor': 0.55,
      'key': 'Bpm',
      'editable': false
    },
    {
      "title": 'Notes',
      'index': 6,
      'widthFactor': 0.55,
      'key': 'Notes',
      'editable': false
    },
  ];

  List rows = [];
  List<String> idList = [];

  final _editableKey = GlobalKey<EditableState>();
  static List<_BloodPressureData> data = [];
  TimeOfDay selectedTime = TimeOfDay.now();
  String? _setTime;

  Future<HealthResponseModel?> getBloodPressureData() async {
    rows.clear();
    idList.clear();
    const String url = Constants.getRoutineHealthReport;

    var body = {
      "patient_id": "${_userController.user.value.id}",
      "report_type_id": "8",
    };

    var response = await http.post(Uri.parse(url),
        body: jsonEncode(body), headers: Config.getHeaders());

    try {
      if (response != null) {
        _controller.isLoading.value = false;
        HealthResponseModel model = healthResponseModelFromJson(response.body);
        listDatum = model.data!;
        model.data?.forEach((element) {
          idList.add(element.id!);
          list = (jsonDecode(element.tableData!) as List);
          rows.add({
            'Date': list[0],
            'Time': list[1],
            'Sbp': list[2],
            'Dbp': list[3],
            'Bpm': list[4],
            'Notes': list[5],
          });

          List dateFixedList = list[0].toString().split('-');
          data.add(
            _BloodPressureData(
              date: DateTime(int.parse(dateFixedList[2]),
                  int.parse(dateFixedList[1]), int.parse(dateFixedList[0])),
              sbpValue: double.parse(list[2]),
              dbpValue: double.parse(list[3]),
              bpmValue: double.parse(list[4]),
            ),
          );
        });

        data.sort((a, b) => a.date.compareTo(b.date));

        getDataLength = rows.length;
        setState(() {});
        return null;
      } else {
        _controller.isLoading.value = false;
        return null;
      }
    } catch (e) {
      _controller.isLoading.value = false;
      debugPrint('ERROR $e');
      return null;
    }
  }

  Future addBloodPressureData(reportTableData) async {
    isLoading.value = true;

    const String url = Constants.addRoutineHealthReport;

    var body = {
      "patient_id": "${_userController.user.value.id}",
      "report_type_id": "8",
      "report_table_headers": [
        "Date",
        "Time",
        "Sbp",
        "Dbp",
        "Bpm",
        "Notes",
      ],
      "report_table_data": reportTableData
    };

    var response = await http.post(Uri.parse(url),
        body: jsonEncode(body), headers: Config.getHeaders());
    isLoading.value = false;

    if (response != null) {
      await getBloodPressureData();
      Utils.showSnackBar(
        'Success',
        'Client Routine Health Reports Added Successfully!!',
      );
      return true;
    } else {
      return null;
    }
  }

  Future deleteBloodPressureData(String id) async {
    isLoading.value = true;

    const String url = Constants.deleteRoutineHealthReport;

    var body = {
      "patient_id": "${_userController.user.value.id}",
      "report_id": id,
    };

    var response = await http.post(Uri.parse(url),
        body: jsonEncode(body), headers: Config.getHeaders());
    isLoading.value = false;

    if (response != null) {
      await getBloodPressureData();

      Utils.showSnackBar(
        'Success',
        'Routine Health Report Deleted Successfully!!',
      );
      return true;
    } else {
      return null;
    }
  }

  Future updateBloodPressureData({dynamic reportTableData, String? id}) async {
    isLoading.value = true;

    const String url = Constants.updateRoutineHealthReport;

    var body = {
      "patient_id": "${_userController.user.value.id}",
      "report_id": id,
      "report_table_headers": [
        "DATE",
        "TIME",
        "SBP",
        "DBP",
        "BPM",
        "NOTES",
      ],
      "report_table_data": reportTableData,
    };

    var response = await http.post(Uri.parse(url),
        body: jsonEncode(body), headers: Config.getHeaders());
    isLoading.value = false;

    if (response != null) {
      await getBloodPressureData();
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
  TextEditingController timeController = TextEditingController();
  TextEditingController sbpController = TextEditingController();
  TextEditingController dbpController = TextEditingController();
  TextEditingController bpmController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  TextEditingController editDateController = TextEditingController();
  TextEditingController editTimeController = TextEditingController();
  TextEditingController editSbpController = TextEditingController();
  TextEditingController editDbpController = TextEditingController();
  TextEditingController editBpmController = TextEditingController();
  TextEditingController editNotesController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    _controller.isLoading.value = true;
    getData();
    super.initState();
  }

  getData() async {
    await getBloodPressureData();
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
            surfaceTintColor: Colors.transparent,
            title: Text(
              "Blood Pressure",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleMedium?.color,
                  fontSize: 24),
            ),
          ),
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Blood Pressure Logs',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: Obx(() {
                        return _controller.isLoading.value
                            ? Center(
                                child: Utils.circular(),
                              )
                            : SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Editable(
                                      key: _editableKey,
                                      columns: cols,
                                      rows: rows,
                                      popUpTitle: 'Blood Pressure Logs',
                                      showSaveIcon: true,
                                      borderWidth: 1,
                                      saveIconColor:
                                          _isDark ? Colors.white : Colors.black,
                                      onAddButtonPressed: () async {
                                        String text =
                                            '${dateController.text},${timeController.text},${sbpController.text},${dbpController.text},${bpmController.text},${notesController.text}';
                                        List<String> result = text.split(',');
                                        bool addData = true;
                                        for (int i = 0;
                                            i < result.length;
                                            i++) {
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
                                            'Time': result[1],
                                            'Sbp': result[2],
                                            'Dbp': result[3],
                                            'Bpm': result[4],
                                            'Notes': result[5],
                                          });

                                          List dateFixedList =
                                              result[0].toString().split('-');
                                          data.add(
                                            _BloodPressureData(
                                              date: DateTime(
                                                  int.parse(dateFixedList[2]),
                                                  int.parse(dateFixedList[1]),
                                                  int.parse(dateFixedList[0])),
                                              sbpValue: double.parse(result[2]),
                                              dbpValue: double.parse(result[3]),
                                              bpmValue: double.parse(result[4]),
                                            ),
                                          );
                                          data.sort((a, b) =>
                                              a.date.compareTo(b.date));
                                          Navigator.pop(context);
                                          await addBloodPressureData(result);
                                        } else {
                                          // Navigator.pop(context);
                                        }
                                      },
                                      onDeleteButtonPressed: (index) async {
                                        await deleteBloodPressureData(
                                            idList[index]);
                                      },
                                      onEditButtonPressed: (index) {
                                        _editDialog(context, index, listDatum);
                                      },
                                      onTap: () {
                                        dateController.clear();
                                        timeController.clear();
                                        sbpController.clear();
                                        sbpController.clear();
                                        dbpController.clear();
                                        bpmController.clear();
                                        notesController.clear();
                                      },
                                      popUpChild: SizedBox(
                                        width: Get.width * 0.75,
                                        child: Column(
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                dateController.text =
                                                    await Utils
                                                        .selectedDateFormat(
                                                            context);
                                              },
                                              child: TextField(
                                                enabled: false,
                                                readOnly: true,
                                                controller: dateController,
                                                decoration:
                                                    const InputDecoration(
                                                        hintText: 'Date'),
                                              ),
                                            ),
                                            TextField(
                                                readOnly: true,
                                                onTap: () async {
                                                  final TimeOfDay? picked =
                                                      await showTimePicker(
                                                    context: context,
                                                    initialTime: selectedTime,
                                                  );
                                                  if (picked != null) {
                                                    setState(() {
                                                      selectedTime = picked;

                                                      _setTime = formatDate(
                                                          DateTime(
                                                              2019,
                                                              08,
                                                              1,
                                                              selectedTime.hour,
                                                              selectedTime
                                                                  .minute),
                                                          [
                                                            hh,
                                                            ':',
                                                            nn,
                                                            ' ',
                                                            am
                                                          ]).toString();
                                                      timeController.text =
                                                          _setTime!;
                                                      debugPrint(
                                                          "timeController${timeController.text}");
                                                    });
                                                  }
                                                },
                                                controller: timeController,
                                                decoration:
                                                    const InputDecoration(
                                                        hintText: 'Time')),
                                            TextField(
                                              controller: sbpController,
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .allow(
                                                  RegExp(r'[0-9.]'),
                                                ),
                                              ],
                                              decoration: const InputDecoration(
                                                  hintText: 'Systolic'),
                                            ),
                                            TextField(
                                              controller: dbpController,
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .allow(
                                                  RegExp(r'[0-9.]'),
                                                ),
                                              ],
                                              decoration: const InputDecoration(
                                                  hintText: 'Diastolic'),
                                            ),
                                            TextField(
                                              controller: bpmController,
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .allow(RegExp(r'[0-9.]')),
                                              ],
                                              decoration: const InputDecoration(
                                                  hintText:
                                                      'Heart beat per minute'),
                                            ),
                                            TextField(
                                              controller: notesController,
                                              decoration: const InputDecoration(
                                                  hintText: 'Notes'),
                                            ),
                                          ],
                                        ),
                                      ),
                                      borderColor: Colors.blueGrey,
                                      showCreateButton: true,
                                      createButtonLabel: const Text(
                                        'New',
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    if (data.isNotEmpty)

                                      ///CHART

                                      // SfCartesianChart(
                                      //   // primaryXAxis: CategoryAxis(),
                                      //   enableAxisAnimation: true,
                                      //   primaryXAxis: DateTimeAxis(
                                      //       dateFormat: DateFormat("MMM y"),
                                      //       minimum: data.first.date,
                                      //       maximum: data.last.date,
                                      //       autoScrollingDeltaType:
                                      //           DateTimeIntervalType.auto
                                      //       // autoScrollingMode: AutoScrollingMode.end,
                                      //       ),
                                      //   primaryYAxis: const NumericAxis(
                                      //       edgeLabelPlacement:
                                      //           EdgeLabelPlacement.shift),
                                      //   // axes: [Charts()],
                                      //   series: chartData,
                                      // ),
                                      if (data.isEmpty)
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: Get.height * 0.32),
                                          child: Center(
                                            child: Text(
                                              'No blood pressure data!',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge
                                                  ?.copyWith(fontSize: 20),
                                            ),
                                          ),
                                        )
                                  ],
                                ),
                              );
                      }),
                    ),
                  ],
                ),
              ),
              Obx(
                () => isLoading.value ? Utils.loadingBar() : const SizedBox(),
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
    editTimeController.text = editList[1];
    editSbpController.text = editList[2];
    editDbpController.text = editList[3];
    editBpmController.text = editList[4];
    editNotesController.text = editList[5];
    Alert(
        context: context,
        title: 'Add Blood Pressure Logs',
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: SizedBox(
            width: Get.width * 0.75,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    editDateController.text =
                        await Utils.selectedDateFormat(context);
                  },
                  child: TextField(
                    enabled: false,
                    readOnly: true,
                    controller: editDateController,
                    decoration: const InputDecoration(hintText: 'Date'),
                  ),
                ),
                TextField(
                  readOnly: true,
                  onTap: () async {
                    int hour =
                        int.parse(editTimeController.text.split(':').first);

                    if (editTimeController.text.contains('PM')) {
                      hour += 12;
                    }

                    int minute = int.parse(editTimeController.text
                        .split(':')
                        .last
                        .split(' ')
                        .first);

                    final TimeOfDay? picked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay(hour: hour, minute: minute),
                    );
                    if (picked != null) {
                      setState(() {
                        selectedTime = picked;

                        _setTime = formatDate(
                            DateTime(
                              2019,
                              08,
                              1,
                              selectedTime.hour,
                              selectedTime.minute,
                            ),
                            [hh, ':', nn, ' ', am]).toString();
                        editTimeController.text = _setTime!;

                        debugPrint(editTimeController.text);
                      });
                    }
                  },
                  controller: editTimeController,
                  decoration: const InputDecoration(hintText: 'Time'),
                ),
                TextField(
                  controller: editSbpController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                  decoration: const InputDecoration(hintText: 'Sbp'),
                ),
                TextField(
                  controller: editDbpController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                  decoration: const InputDecoration(hintText: 'Dbp'),
                ),
                TextField(
                  controller: editBpmController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                  decoration: const InputDecoration(hintText: 'Bpm'),
                ),
                TextField(
                  controller: editNotesController,
                  decoration: const InputDecoration(hintText: 'Notes'),
                ),
              ],
            ),
          ),
        ),
        buttons: [
          DialogButton(
            onPressed: () async {
              String text =
                  '${editDateController.text},${editTimeController.text},${editSbpController.text},${editDbpController.text},${editBpmController.text},${editNotesController.text}';

              List<String> result = text.split(',');

              Navigator.pop(context);

              await updateBloodPressureData(
                  id: idList[index], reportTableData: result);
            },
            child: const Text(
              "Save",
              style: TextStyle(color: Colors.white, fontSize: 22),
            ),
          )
        ]).show();
  }

  ///CHART
  // List<CartesianSeries> chartData = [
  //   ///SBP
  //   LineSeries<_BloodPressureData, dynamic>(
  //     dataSource: data,
  //     xValueMapper: (_BloodPressureData bloodPressure, _) => bloodPressure.date,
  //     yValueMapper: (_BloodPressureData bloodPressure, _) =>
  //         bloodPressure.sbpValue,
  //     dataLabelSettings: const DataLabelSettings(isVisible: true),
  //   ),
  //
  //   ///DBP
  //   LineSeries<_BloodPressureData, dynamic>(
  //     dataSource: data,
  //     xValueMapper: (_BloodPressureData bloodPressure, _) => bloodPressure.date,
  //     yValueMapper: (_BloodPressureData bloodPressure, _) =>
  //         bloodPressure.dbpValue,
  //     dataLabelSettings: const DataLabelSettings(isVisible: true),
  //   ),
  //
  //   ///BPM
  //   LineSeries<_BloodPressureData, dynamic>(
  //     dataSource: data,
  //     xValueMapper: (_BloodPressureData bloodPressure, _) => bloodPressure.date,
  //     yValueMapper: (_BloodPressureData bloodPressure, _) =>
  //         bloodPressure.bpmValue,
  //     dataLabelSettings: const DataLabelSettings(isVisible: true),
  //   ),
  // ];
}

class _BloodPressureData {
  _BloodPressureData({
    required this.date,
    required this.sbpValue,
    required this.dbpValue,
    required this.bpmValue,
  });

  final DateTime date;
  final double sbpValue;
  final double dbpValue;
  final double bpmValue;
}
