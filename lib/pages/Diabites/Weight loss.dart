import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:united_natives/components/ads_bottom_bar.dart';
import 'package:united_natives/controller/ads_controller.dart';
import 'package:united_natives/controller/self_monitoring_controller.dart';
import 'package:united_natives/controller/user_controller.dart';
import 'package:united_natives/data/pref_manager.dart';
import 'package:united_natives/pages/Diabites/custom_package/editable_custom_package.dart';
import 'package:united_natives/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
import '../../model/health_response_model.dart';
import '../../utils/utils.dart';

void enablePlatformOverrideForDesktop() {
  if (!kIsWeb && (Platform.isMacOS || Platform.isWindows || Platform.isLinux)) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
}

class Weightloss extends StatefulWidget {
  const Weightloss({super.key});

  @override
  State<Weightloss> createState() => _WeightlossState();
}

class _WeightlossState extends State<Weightloss> {
  final UserController _userController = Get.find<UserController>();
  final SelfMonitoringController _controller =
      Get.put(SelfMonitoringController());
  int totalCount = 0;
  List list = [];
  RxBool isLoading = false.obs;
  List<Datum> listDatum = [];
  final bool _isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);
  List editList = [];

  AdsController adsController = Get.find();
  List cols = [
    {
      "title": 'Date',
      'index': 1,
      'widthFactor': 0.45,
      'key': 'Date',
      'editable': false
    },
    {
      "title": 'Weight',
      'index': 2,
      'widthFactor': 0.45,
      'key': 'Weight',
      'editable': false
    },
    {
      "title": 'Chest',
      'index': 3,
      'widthFactor': 0.45,
      'key': 'Chest',
      'editable': false
    },
    {
      "title": 'Waist',
      'index': 4,
      'widthFactor': 0.45,
      'key': 'Waist',
      'editable': false
    },
    {
      "title": 'Hips',
      'index': 5,
      'widthFactor': 0.45,
      'key': 'Hips',
      'editable': false
    },
    {
      "title": 'Comments/Notes',
      'index': 6,
      'widthFactor': 0.45,
      'key': 'Comments/Notes',
      'editable': false
    },
  ];

  List rows = [];
  List<String> idList = [];

  final _editableKey = GlobalKey<EditableState>();
  List<_WeightLossData> data = [];

  Future<HealthResponseModel?> getWeightLossData() async {
    rows.clear();
    data.clear();
    idList.clear();
    final String url = Constants.getRoutineHealthReport;

    var body = {
      "patient_id": "${_userController.user.value.id}",
      "report_type_id": "1",
    };

    var response = await http.post(Uri.parse(url),
        body: jsonEncode(body), headers: Config.getHeaders());

    try {
      if (response != null) {
        _controller.isLoading.value = false;
        HealthResponseModel model = healthResponseModelFromJson(response.body);

        model.data?.forEach((element) {
          listDatum = model.data!;
          idList.add(element.id!);
          list = (jsonDecode(element.tableData!) as List);
          rows.add({
            'Date': list[0],
            'Weight': list[1],
            'Chest': list[2],
            'Waist': list[3],
            'Hips': list[4],
            'Comments/Notes': list[5],
          });

          List dateFixedList = list[0].toString().split('-');
          data.add(
            _WeightLossData(
              date: DateTime(int.parse(dateFixedList[2]),
                  int.parse(dateFixedList[1]), int.parse(dateFixedList[0])),
              weight: double.parse(list[1]),
            ),
          );
          // }
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
      debugPrint('Error $e');
      return null;
    }
  }

  Future addWeightLossData(reportTableData) async {
    isLoading.value = true;

    final String url = Constants.addRoutineHealthReport;

    var body = {
      "patient_id": "${_userController.user.value.id}",
      "report_type_id": "1",
      "report_table_headers": [
        "Date",
        "Weight",
        "Chest",
        "Waist",
        "Hips",
        "Comments/Notes",
      ],
      "report_table_data": reportTableData
    };

    var response = await http.post(Uri.parse(url),
        body: jsonEncode(body), headers: Config.getHeaders());
    isLoading.value = false;

    if (response != null) {
      await getWeightLossData();
      Utils.showSnackBar(
        'Success',
        'Client Routine Health Reports Added Successfully!!',
      );
      return true;
    } else {
      return null;
    }
  }

  Future deleteWeightLossData(String id) async {
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
      await getWeightLossData();

      Utils.showSnackBar(
        'Success',
        'Routine Health Report Deleted Successfully!!',
      );
      return true;
    } else {
      return null;
    }
  }

  Future updateWeightLossData(
      {dynamic reportTableData, required String id}) async {
    isLoading.value = true;

    final String url = Constants.updateRoutineHealthReport;

    var body = {
      "patient_id": "${_userController.user.value.id}",
      "report_id": id,
      "report_table_headers": [
        "Date",
        "Weight",
        "Chest",
        "Waist",
        "Hips",
        "Comments/Notes",
      ],
      "report_table_data": reportTableData,
    };

    var response = await http.post(Uri.parse(url),
        body: jsonEncode(body), headers: Config.getHeaders());
    isLoading.value = false;

    if (response != null) {
      await getWeightLossData();
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
  TextEditingController weightController = TextEditingController();
  TextEditingController chestController = TextEditingController();
  TextEditingController waistController = TextEditingController();
  TextEditingController hipsController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  TextEditingController editDateController = TextEditingController();
  TextEditingController editWeightController = TextEditingController();
  TextEditingController editChestController = TextEditingController();
  TextEditingController editWaistController = TextEditingController();
  TextEditingController editHipsController = TextEditingController();
  TextEditingController editNotesController = TextEditingController();

  @override
  void initState() {
    _controller.isLoading.value = true;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getData();
    });
    super.initState();
  }

  getData() async {
    await getWeightLossData();
  }

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
              "Weight Loss",
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
                        'Weight Loss Data',
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
                                      popUpTitle: 'Weight Loss Data',
                                      borderColor: Colors.blueGrey,
                                      showSaveIcon: true,
                                      saveIconColor:
                                          _isDark ? Colors.white : Colors.black,
                                      onAddButtonPressed: () async {
                                        String text =
                                            '${dateController.text},${weightController.text},${chestController.text},${waistController.text},${hipsController.text},${notesController.text}';
                                        List<String> result = text.split(',');
                                        bool addData = true;
                                        for (int i = 0;
                                            i < result.length;
                                            i++) {
                                          if (result[i] == "") {
                                            Utils.showSnackBar('Enter details',
                                                'Please enter all required details!!');
                                            addData = false;
                                            break;
                                          }
                                        }
                                        if (addData) {
                                          rows.add({
                                            'Date': result[0],
                                            'Weight': result[1],
                                            'Chest': result[2],
                                            'Waist': result[3],
                                            'Hips': result[4],
                                            'Comments/Notes': result[5],
                                          });

                                          List dateFixedList =
                                              result[0].toString().split('-');

                                          data.add(_WeightLossData(
                                              date: DateTime(
                                                  int.parse(dateFixedList[2]),
                                                  int.parse(dateFixedList[1]),
                                                  int.parse(dateFixedList[0])),
                                              weight: double.parse(result[1])));
                                          data.sort((a, b) =>
                                              a.date.compareTo(b.date));
                                          Navigator.pop(context);
                                          await addWeightLossData(result);
                                        } else {
                                          // Navigator.pop(context);
                                        }
                                      },
                                      onDeleteButtonPressed: (index) async {
                                        await deleteWeightLossData(
                                            idList[index]);
                                      },
                                      onEditButtonPressed: (index) {
                                        _editDialog(context, index, listDatum);
                                      },
                                      onTap: () {
                                        dateController.clear();
                                        weightController.clear();
                                        chestController.clear();
                                        waistController.clear();
                                        hipsController.clear();
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
                                              controller: weightController,
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .allow(RegExp(r'[0-9.]')),
                                              ],
                                              decoration: const InputDecoration(
                                                  hintText: 'Weight'),
                                            ),
                                            TextField(
                                              controller: chestController,
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .allow(RegExp(r'[0-9.]')),
                                              ],
                                              decoration: const InputDecoration(
                                                  hintText: 'Chest'),
                                            ),
                                            TextField(
                                              controller: waistController,
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .allow(RegExp(r'[0-9.]')),
                                              ],
                                              decoration: const InputDecoration(
                                                  hintText: 'Waist'),
                                            ),
                                            TextField(
                                              controller: hipsController,
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .allow(RegExp(r'[0-9.]')),
                                              ],
                                              decoration: const InputDecoration(
                                                  hintText: 'Hips'),
                                            ),
                                            TextField(
                                              controller: notesController,
                                              decoration: const InputDecoration(
                                                  hintText: 'Notes'),
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
                                    /*if (data.isNotEmpty)
                                      SfCartesianChart(
                                        // primaryXAxis: CategoryAxis(),
                                        enableAxisAnimation: true,
                                        primaryXAxis: DateTimeAxis(
                                          dateFormat: DateFormat("MMM y"),
                                          minimum: data.first.date,
                                          maximum: data.last.date,

                                          autoScrollingDeltaType:
                                              DateTimeIntervalType.auto,
                                          // autoScrollingMode: AutoScrollingMode.end,
                                        ),
                                        primaryYAxis: const NumericAxis(
                                            edgeLabelPlacement:
                                                EdgeLabelPlacement.shift),
                                        // axes: [Charts()],
                                        series: <ChartSeries<_WeightLossData,
                                            dynamic>>[
                                          LineSeries<_WeightLossData, dynamic>(
                                            dataSource: data,
                                            xValueMapper:
                                                (_WeightLossData weight, _) =>
                                                    weight.date,
                                            yValueMapper:
                                                (_WeightLossData weight, _) =>
                                                    weight.weight,
                                            dataLabelSettings:
                                                const DataLabelSettings(
                                              isVisible: true,
                                            ),
                                          )
                                        ] as List<CartesianSeries>,
                                      ),*/
                                    if (data.isEmpty)
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: Get.height * 0.30),
                                        child: Center(
                                          child: Text(
                                            'No weight loss data',
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
    editWeightController.text = editList[1];
    editChestController.text = editList[2];
    editWaistController.text = editList[3];
    editHipsController.text = editList[4];
    editNotesController.text = editList[5];
    Alert(
        context: context,
        title: 'Weight Loss Data',
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: SizedBox(
            width: Get.width * 0.75,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    int day = int.parse(editDateController.text.split('-')[0]);
                    int month =
                        int.parse(editDateController.text.split('-')[1]);
                    int year = int.parse(editDateController.text.split('-')[2]);

                    DateTime date = DateTime(year, month, day);

                    editDateController.text = await Utils.selectedDateFormat(
                        context,
                        selectedDate: date);
                  },
                  child: TextField(
                    enabled: false,
                    readOnly: true,
                    controller: editDateController,
                    decoration: const InputDecoration(hintText: 'Date'),
                  ),
                ),
                TextField(
                  controller: editWeightController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                  decoration: const InputDecoration(hintText: 'Weight'),
                ),
                TextField(
                  controller: editChestController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                  decoration: const InputDecoration(hintText: 'Chest'),
                ),
                TextField(
                  controller: editWaistController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                  decoration: const InputDecoration(hintText: 'Waist'),
                ),
                TextField(
                  controller: editHipsController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                  decoration: const InputDecoration(hintText: 'Hips'),
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
                  '${editDateController.text},${editWeightController.text},${editChestController.text},${editWaistController.text},${editHipsController.text},${editNotesController.text}';
              List<String> result = text.split(',');

              Navigator.pop(context);
              await updateWeightLossData(
                  id: idList[index], reportTableData: result);
            },
            child: const Text(
              "Save",
              style: TextStyle(color: Colors.white, fontSize: 22),
            ),
          )
        ]).show();
  }
}

class _WeightLossData {
  _WeightLossData({required this.date, required this.weight});

  final DateTime date;
  final double weight;
}
