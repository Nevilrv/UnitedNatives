import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:date_format/date_format.dart';
import 'package:united_natives/components/ads_bottom_bar.dart';
import 'package:united_natives/controller/ads_controller.dart';
import 'package:united_natives/controller/self_monitoring_controller.dart';
import 'package:united_natives/controller/user_controller.dart';
import 'package:united_natives/controller/user_update_contoller.dart';
import 'package:united_natives/data/pref_manager.dart';
import 'package:united_natives/model/health_response_model.dart';
import 'package:united_natives/pages/Diabites/custom_package/editable_custom_package.dart';
import 'package:united_natives/utils/constants.dart';
import 'package:united_natives/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:syncfusion_flutter_charts/charts.dart' as chart;

void enablePlatformOverrideForDesktop() {
  if (!kIsWeb && (Platform.isMacOS || Platform.isWindows || Platform.isLinux)) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
}

class PhysicalActivity extends StatefulWidget {
  const PhysicalActivity({super.key});

  @override
  State<PhysicalActivity> createState() => _PhysicalActivityState();
}

class _PhysicalActivityState extends State<PhysicalActivity> {
  final SelfMonitoringController _controller =
      Get.put(SelfMonitoringController());
  final UserController _userController = Get.find<UserController>();
  ChangeState changeState = Get.put(ChangeState());
  final bool _isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);
  List cols = [
    {
      "title": 'Date',
      'index': 1,
      'widthFactor': 0.55,
      'key': 'date',
      'editable': false
    },
    {
      "title": 'Day of Week',
      'index': 2,
      'widthFactor': 0.55,
      'key': 'dayofwek',
      'editable': false
    },
    {
      "title": 'Time of Day',
      'index': 3,
      'widthFactor': 0.55,
      'key': 'timeofday',
      'editable': false
    },
    {
      "title": 'Description of Activity',
      'index': 4,
      'widthFactor': 0.55,
      'key': 'description',
      'editable': false
    },
    {
      "title": 'Duration',
      'index': 5,
      'widthFactor': 0.55,
      'key': 'duration',
      'editable': false
    },
  ];
  List rows = [];
  List<String> idList = [];
  String? _setTime;

  int totalCount = 0;
  List list = [];
  List<Datum> listDatum = [];
  List editList = [];
  RxBool isLoading = false.obs;

  static List<_PhysicalActivityData> data = [];

  final _editableKey = GlobalKey<EditableState>();

  Future<void> getPhysicalActivitiesData() async {
    rows.clear();
    idList.clear();
    data.clear();
    const String url = Constants.getRoutineHealthReport;

    var body = {
      "patient_id": "${_userController.user.value.id}",
      "report_type_id": "9",
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
            'date': list[0],
            'dayofwek': list[1],
            'timeofday': list[2],
            'description': list[3],
            'duration': list[4],
          });

          List dateFixedList = list[0].toString().split('-');
          data.add(
            _PhysicalActivityData(
              date: DateTime(int.parse(dateFixedList[2]),
                  int.parse(dateFixedList[1]), int.parse(dateFixedList[0])),
              duration: double.parse(list[4]),
            ),
          );
        });
        data.sort((a, b) => a.date.compareTo(b.date));
        getDataLength = rows.length;
        setState(() {});
      } else {
        _controller.isLoading.value = false;
        return;
      }
    } catch (e) {
      _controller.isLoading.value = false;
    }
  }

  Future addPhysicalActivityData(reportTableData) async {
    isLoading.value = true;

    const String url = Constants.addRoutineHealthReport;

    var body = {
      "patient_id": "${_userController.user.value.id}",
      "report_type_id": "9",
      "report_table_headers": [
        "Date",
        "Day of Week",
        "Time of Day ",
        "Description of Activity",
        "Duration",
      ],
      "report_table_data": reportTableData
    };

    var response = await http.post(Uri.parse(url),
        body: jsonEncode(body), headers: Config.getHeaders());
    isLoading.value = false;

    if (response != null) {
      await getPhysicalActivitiesData();
      Utils.showSnackBar(
        'Success',
        'Client Routine Health Reports Added Successfully!!',
      );
      return true;
    } else {
      return null;
    }
  }

  Future deletePhysicalActivityData(String id) async {
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
      await getPhysicalActivitiesData();

      Utils.showSnackBar(
        'Success',
        'Routine Health Report Deleted Successfully!!',
      );
      return true;
    } else {
      return null;
    }
  }

  Future updatePhysicalActivityData(
      {dynamic reportTableData, required String id}) async {
    isLoading.value = true;

    const String url = Constants.updateRoutineHealthReport;

    var body = {
      "patient_id": "${_userController.user.value.id}",
      "report_id": id,
      "report_table_headers": [
        "Date",
        "Day of Week",
        "Time of Day ",
        "Description of Activity",
        "Duration",
      ],
      "report_table_data": reportTableData,
    };

    var response = await http.post(Uri.parse(url),
        body: jsonEncode(body), headers: Config.getHeaders());

    isLoading.value = false;

    if (response != null) {
      await getPhysicalActivitiesData();
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
  TimeOfDay selectedTime = TimeOfDay.now();
  TextEditingController dateController = TextEditingController();
  TextEditingController dayOfWeekController = TextEditingController();
  TextEditingController timeOfDayController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController durationController = TextEditingController();

  TextEditingController editDateController = TextEditingController();
  TextEditingController editDayOfWeekController = TextEditingController();
  TextEditingController editTimeOfDayController = TextEditingController();
  TextEditingController editDescriptionController = TextEditingController();
  TextEditingController editDurationController = TextEditingController();
  String? descriptionOfActivityValue;
  List<String> descriptionOFActivityList = ['lifting', 'running', 'crossfit'];
  List<String> trackerActivityList = ['walk', 'run', 'cycling'];

  @override
  void initState() {
    _controller.isLoading.value = true;
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        getData();
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    if (changeState.timer != null) changeState.endTimer();
    changeState.date = null;
  }

  getData() async {
    await getPhysicalActivitiesData();
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
              "Physical Activity",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleMedium?.color,
                  fontSize: 24),
            ),
            leading: IconButton(
              onPressed: () {
                if (changeState.timer != null) changeState.endTimer();
                changeState.date = null;
                Get.back();
              },
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
              ),
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
                        'Physical Activity Tracker',
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
                        if (_controller.isLoading.value) {
                          return /*Center(
                            child: CircularProgressIndicator(),
                          )*/
                              Center(
                            child: Utils.circular(),
                          );
                        } else {
                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                GetBuilder<ChangeState>(
                                  builder: (controller) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        if (controller.start <= 0)
                                          GestureDetector(
                                            onTap: () async {
                                              String selectedValue = '';

                                              await showMenu(
                                                context: context,
                                                position: RelativeRect.fromLTRB(
                                                    80,
                                                    150,
                                                    Get.width - 80,
                                                    Get.height - 150),
                                                items: List.generate(
                                                  trackerActivityList.length,
                                                  (index) => PopupMenuItem<
                                                          String>(
                                                      onTap: () {
                                                        selectedValue =
                                                            trackerActivityList[
                                                                    index]
                                                                .capitalizeFirst!;
                                                        setState(() {});
                                                      },
                                                      value:
                                                          trackerActivityList[
                                                              index],
                                                      child: Text(
                                                          '${trackerActivityList[index].capitalizeFirst}')),
                                                ),
                                              );
                                              dateController.text =
                                                  DateFormat('dd-MM-yyyy')
                                                      .format(DateTime.now());
                                              dayOfWeekController.text =
                                                  DateFormat.EEEE()
                                                      .format(DateTime.now());
                                              timeOfDayController.text =
                                                  formatDate(DateTime.now(), [
                                                hh,
                                                ':',
                                                nn,
                                                ' ',
                                                am
                                              ]).toString();

                                              descriptionOfActivityValue =
                                                  selectedValue;

                                              controller.startTimer(
                                                  value: selectedValue);
                                            },
                                            child: Container(
                                              height: 40,
                                              width: 80,
                                              decoration: BoxDecoration(
                                                color: kColorPrimary,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: const Center(
                                                child: Text(
                                                  'Start',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        if (controller.date != null)
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  const SizedBox(
                                                    width: 100,
                                                    child: Text(
                                                      'Time :',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Text(
                                                    '${controller.date?.hour}:${controller.date?.minute}:${controller.date?.second}',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  const SizedBox(
                                                    width: 100,
                                                    child: Text(
                                                      'Distance :',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Text(
                                                    '${controller.totalDistance.toStringAsFixed(2)} km',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  const SizedBox(
                                                    width: 100,
                                                    child: Text(
                                                      'Activity :',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Text(
                                                    '$descriptionOfActivityValue',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        if (controller.start > 0)
                                          GestureDetector(
                                            onTap: () async {
                                              controller.endTimer();

                                              if (DateTime.now()
                                                      .difference(controller
                                                          .startTimerDate!)
                                                      .inMinutes <=
                                                  0) {
                                                durationController.text =
                                                    '0.${DateTime.now().difference(controller.startTimerDate!).inSeconds}';
                                              } else {
                                                durationController.text =
                                                    DateTime.now()
                                                        .difference(controller
                                                            .startTimerDate!)
                                                        .inMinutes
                                                        .toString();
                                              }

                                              String text =
                                                  '${dateController.text},${dayOfWeekController.text},${timeOfDayController.text},$descriptionOfActivityValue,${durationController.text}';
                                              List<String> result =
                                                  text.split(',');
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
                                                  'date': result[0],
                                                  'dayofwek': result[1],
                                                  'timeofday': result[2],
                                                  'description': result[3],
                                                  'duration': result[4],
                                                });

                                                List dateFixedList = result[0]
                                                    .toString()
                                                    .split('-');
                                                data.add(
                                                  _PhysicalActivityData(
                                                    date: DateTime(
                                                        int.parse(
                                                            dateFixedList[2]),
                                                        int.parse(
                                                            dateFixedList[1]),
                                                        int.parse(
                                                            dateFixedList[0])),
                                                    duration:
                                                        double.parse(result[4]),
                                                  ),
                                                );
                                                data.sort((a, b) =>
                                                    a.date.compareTo(b.date));

                                                await addPhysicalActivityData(
                                                    result);
                                              } else {}
                                            },
                                            child: Container(
                                              height: 40,
                                              width: 80,
                                              decoration: BoxDecoration(
                                                color: kColorPrimary,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: const Center(
                                                child: Text(
                                                  'End',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    );
                                  },
                                ),
                                Editable(
                                  key: _editableKey,
                                  columns: cols,
                                  rows: rows,
                                  popUpTitle: 'Physical Activity Tracker',
                                  showSaveIcon: true,
                                  tdAlignment: TextAlign.start,
                                  saveIconColor:
                                      _isDark ? Colors.white : Colors.black,
                                  borderColor: Colors.blueGrey,
                                  onAddButtonPressed: () async {
                                    String text =
                                        '${dateController.text},${dayOfWeekController.text},${timeOfDayController.text},$descriptionOfActivityValue,${durationController.text}';
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
                                        'date': result[0],
                                        'dayofwek': result[1],
                                        'timeofday': result[2],
                                        'description': result[3],
                                        'duration': result[4],
                                      });

                                      List dateFixedList =
                                          result[0].toString().split('-');
                                      data.add(
                                        _PhysicalActivityData(
                                          date: DateTime(
                                              int.parse(dateFixedList[2]),
                                              int.parse(dateFixedList[1]),
                                              int.parse(dateFixedList[0])),
                                          duration: double.parse(result[4]),
                                        ),
                                      );
                                      data.sort(
                                          (a, b) => a.date.compareTo(b.date));
                                      Navigator.pop(context);
                                      await addPhysicalActivityData(result);
                                    } else {
                                      // Navigator.pop(context);
                                    }
                                  },
                                  onDeleteButtonPressed: (index) async {
                                    await deletePhysicalActivityData(
                                        idList[index]);
                                  },
                                  onEditButtonPressed: (index) {
                                    _editDialog(context, index, listDatum);
                                  },
                                  onTap: () {
                                    dateController.clear();
                                    dayOfWeekController.clear();
                                    timeOfDayController.clear();
                                    descriptionController.clear();
                                    durationController.clear();
                                    descriptionOfActivityValue = null;
                                  },
                                  popUpChild: SizedBox(
                                    width: Get.width * 0.75,
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            final time = await showDatePicker(
                                                context: context,
                                                firstDate: DateTime(1900),
                                                initialDate: DateTime.now(),
                                                lastDate: DateTime(2100));

                                            if (time != null) {
                                              dateController.text =
                                                  DateFormat('dd-MM-yyyy')
                                                      .format(time);
                                              dayOfWeekController.text =
                                                  DateFormat.EEEE()
                                                      .format(time);
                                            }
                                          },
                                          child: TextField(
                                            controller: dateController,
                                            enabled: false,
                                            readOnly: true,
                                            decoration: const InputDecoration(
                                                hintText: 'Date'),
                                          ),
                                        ),
                                        TextField(
                                          controller: dayOfWeekController,
                                          enabled: false,
                                          readOnly: true,
                                          decoration: const InputDecoration(
                                              hintText: 'Day of week'),
                                        ),
                                        GestureDetector(
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
                                                          selectedTime.minute,
                                                        ),
                                                        [hh, ':', nn, ' ', am])
                                                    .toString();
                                                timeOfDayController.text =
                                                    _setTime!;
                                              });
                                            }
                                          },
                                          child: TextField(
                                            enabled: false,
                                            readOnly: true,
                                            controller: timeOfDayController,
                                            decoration: const InputDecoration(
                                                hintText: 'Time of Day'),
                                          ),
                                        ),
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: StatefulBuilder(
                                            builder: (context, setState1) {
                                              return DropdownButton<String>(
                                                value:
                                                    descriptionOfActivityValue,
                                                isExpanded: true,
                                                onChanged: (String? newValue) {
                                                  setState1(() {
                                                    descriptionOfActivityValue =
                                                        newValue;
                                                  });
                                                },
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium,
                                                hint: const Text(
                                                    'Description of Activity'),
                                                items: descriptionOFActivityList
                                                    .map<
                                                            DropdownMenuItem<
                                                                String>>(
                                                        (String value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: Text(
                                                      value,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleMedium,
                                                    ),
                                                  );
                                                }).toList(),
                                              );
                                            },
                                          ),
                                        ),
                                        // TextField(
                                        //   controller: descriptionController,
                                        //   decoration: InputDecoration(
                                        //       hintText: 'Description of Activity'),
                                        // ),
                                        TextField(
                                          controller: durationController,
                                          decoration: const InputDecoration(
                                              hintText: 'Duration'),
                                        ),
                                      ],
                                    ),
                                  ),
                                  showCreateButton: true,
                                  onSubmitted: (value) {},
                                  createButtonLabel: const Text(
                                    'New',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                if (data.isNotEmpty)

                                  ///CHART
                                  chart.SfCartesianChart(
                                    // primaryXAxis: CategoryAxis(),
                                    enableAxisAnimation: true,
                                    primaryXAxis: chart.DateTimeAxis(
                                      dateFormat: DateFormat("MMM y"),
                                      minimum: data.first.date,
                                      maximum: data.last.date,

                                      autoScrollingDeltaType:
                                          chart.DateTimeIntervalType.auto,
                                      // autoScrollingMode: AutoScrollingMode.end,
                                    ),
                                    primaryYAxis: const chart.NumericAxis(
                                        edgeLabelPlacement:
                                            chart.EdgeLabelPlacement.shift),
                                    // axes: [Charts()],
                                    series: chartData,
                                  ),
                                if (data.isEmpty)
                                  Padding(
                                    padding:
                                        EdgeInsets.only(top: Get.height * 0.30),
                                    child: Center(
                                      child: Text(
                                        'No any physical activity',
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
                        }
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
    editDayOfWeekController.text = editList[1];
    editTimeOfDayController.text = editList[2];
    editDescriptionController.text = editList[3];
    if (descriptionOFActivityList.contains(editList[3])) {
      descriptionOfActivityValue = editList[3];
    } else {
      descriptionOfActivityValue = null;
    }

    editDurationController.text = editList[4];

    Alert(
        context: context,
        title: 'Physical Activity Tracker',
        content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: StatefulBuilder(
              builder: (BuildContext context, setStates) {
                return SizedBox(
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
                        controller: editDayOfWeekController,
                        decoration:
                            const InputDecoration(hintText: 'Day of Week'),
                      ),
                      TextField(
                        readOnly: true,
                        onTap: () async {
                          int hour = int.parse(
                              editTimeOfDayController.text.split(':').first);

                          if (editTimeOfDayController.text.contains('PM')) {
                            hour += 12;
                          }

                          int minute = int.parse(editTimeOfDayController.text
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
                              editTimeOfDayController.text = _setTime!;
                            });
                          }
                        },
                        controller: editTimeOfDayController,
                        decoration:
                            const InputDecoration(hintText: 'Time of Day'),
                      ),
                      // TextField(
                      //   controller: editDescriptionController,
                      //   decoration:
                      //       InputDecoration(hintText: 'Description of Activity'),
                      // ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: StatefulBuilder(
                          builder: (context, setState1) {
                            return DropdownButton<String>(
                              value: descriptionOfActivityValue,
                              isExpanded: true,
                              onChanged: (String? newValue) {
                                setState1(() {
                                  descriptionOfActivityValue = newValue;
                                });
                              },
                              style: Theme.of(context).textTheme.titleMedium,
                              hint: const Text('Description of Activity'),
                              items: descriptionOFActivityList
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ),
                      TextField(
                        controller: editDurationController,
                        decoration: const InputDecoration(hintText: 'Duration'),
                      ),
                    ],
                  ),
                );
              },
            )),
        buttons: [
          DialogButton(
            onPressed: () async {
              String text =
                  '${editDateController.text},${editDayOfWeekController.text},${editTimeOfDayController.text},$descriptionOfActivityValue,${editDurationController.text}';
              List<String> result = text.split(',');
              Navigator.pop(context);
              await updatePhysicalActivityData(
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
  List<chart.CartesianSeries> chartData = [
    chart.LineSeries<_PhysicalActivityData, dynamic>(
      dataSource: data,
      xValueMapper: (_PhysicalActivityData weight, _) => weight.date,
      yValueMapper: (_PhysicalActivityData weight, _) => weight.duration,
      dataLabelSettings: const chart.DataLabelSettings(
        isVisible: true,
      ),
    )
  ];
}

class _PhysicalActivityData {
  _PhysicalActivityData({required this.date, required this.duration});

  final DateTime date;
  final double duration;
}
