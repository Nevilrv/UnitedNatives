import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:united_natives/components/ads_bottom_bar.dart';
import 'package:united_natives/viewModel/ads_controller.dart';
import 'package:united_natives/viewModel/self_monitoring_controller.dart';
import 'package:united_natives/viewModel/user_controller.dart';
import 'package:united_natives/viewModel/user_update_contoller.dart';
import 'package:united_natives/utils/pref_manager.dart';
import 'package:united_natives/ResponseModel/health_response_model.dart';
import 'package:united_natives/pages/Diabites/custom_package/editable_custom_package.dart';
import 'package:united_natives/utils/constants.dart';
import 'package:united_natives/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';

void enablePlatformOverrideForDesktop() {
  if (!kIsWeb && (Platform.isMacOS || Platform.isWindows || Platform.isLinux)) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
}

class MedicationCheckList extends StatefulWidget {
  const MedicationCheckList({super.key});

  @override
  State<MedicationCheckList> createState() => _MedicationCheckListState();
}

class _MedicationCheckListState extends State<MedicationCheckList> {
  final UserController _userController = Get.find<UserController>();

  ChangeState changeState = Get.put(ChangeState());
  final SelfMonitoringController _controller =
      Get.put(SelfMonitoringController());
  int totalCount = 0;
  List list = [];
  List<Datum> listDatum = [];
  List editList = [];
  RxBool isLoading = false.obs;
  List<bool>? isChecked;

  AdsController adsController = Get.find();
  final bool _isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);
  List cols = [
    {
      "title": 'Date',
      'index': 1,
      'widthFactor': 0.5,
      'key': 'date',
      'editable': false
    },
    {
      "title": 'Medication',
      'index': 2,
      'widthFactor': 0.5,
      'key': 'medication',
      'editable': false
    },
    {
      "title": 'Dose Prescribed',
      'index': 3,
      'widthFactor': 0.5,
      'key': 'doseprescribed',
      'editable': false
    },
    {
      "title": 'Prescribed Schedule',
      'index': 4,
      'widthFactor': 0.5,
      'key': 'prescribedschedule',
      'editable': false
    },
    {
      "title": 'AM',
      'index': 5,
      'widthFactor': 0.5,
      'key': 'am',
      'editable': false
    },
    {
      "title": 'Noon',
      'index': 6,
      'widthFactor': 0.5,
      'key': 'noon',
      'editable': false
    },
    {
      "title": 'After-Noon',
      'index': 7,
      'widthFactor': 0.5,
      'key': 'afternoon',
      'editable': false
    },
    {
      "title": 'BedTime',
      'index': 8,
      'widthFactor': 0.5,
      'key': 'bedtime',
      'editable': false
    },
  ];

  List rows = [];
  List<String> idList = [];
  String? medicationData;
  final _editableKey = GlobalKey<EditableState>();
  final List<String> _texts = [
    "AM",
    "Noon",
    "After-Noon",
    "BedTime",
  ];
  Future<HealthResponseModel?> getMedicationData() async {
    rows.clear();
    idList.clear();
    const String url = Constants.getRoutineHealthReport;

    var body = {
      "patient_id": "${_userController.user.value.id}",
      "report_type_id": "10",
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
            'medication': list[1],
            'doseprescribed': list[2],
            'prescribedschedule': list[3],
            'am': list[4] == "true" ? '✔' : '-',
            'noon': list[5] == "true" ? '✔' : '-',
            'afternoon': list[6] == "true" ? '✔' : '-',
            'bedtime': list[7] == "true" ? '✔' : '-',
          });
        });
        getDataLength = rows.length;
        setState(() {});
        return null;
      } else {
        _controller.isLoading.value = false;
        return null;
      }
    } catch (e) {
      _controller.isLoading.value = false;
      return null;
    }
  }

  Future addMedicationData(reportTableData) async {
    isLoading.value = true;

    const String url = Constants.addRoutineHealthReport;

    var body = {
      "patient_id": "${_userController.user.value.id}",
      "report_type_id": "10",
      "report_table_headers": [
        "Date",
        "Medication",
        "Dose Prescribed",
        "Prescribed Schedule",
        "AM",
        "Noon",
        "After-Noon",
        "BedTime"
      ],
      "report_table_data": reportTableData
    };

    var response = await http.post(Uri.parse(url),
        body: jsonEncode(body), headers: Config.getHeaders());
    isLoading.value = false;

    if (response != null) {
      await getMedicationData();
      Utils.showSnackBar(
        'Success',
        'Client Routine Health Reports Added Successfully!!',
      );
      return true;
    } else {
      return null;
    }
  }

  Future deleteMedicationData(String id) async {
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
      await getMedicationData();

      Utils.showSnackBar(
        'Success',
        'Routine Health Report Deleted Successfully!!',
      );
      return true;
    } else {
      return null;
    }
  }

  Future updateMedicationData(
      {dynamic reportTableData, required String id}) async {
    isLoading.value = true;

    const String url = Constants.updateRoutineHealthReport;

    var body = {
      "patient_id": "${_userController.user.value.id}",
      "report_id": id,
      "report_table_headers": [
        "Date",
        "Medication",
        "Dose Prescribed",
        "Prescribed Schedule",
        "AM",
        "Noon",
        "After-Noon",
        "BedTime"
      ],
      "report_table_data": reportTableData,
    };

    var response = await http.post(Uri.parse(url),
        body: jsonEncode(body), headers: Config.getHeaders());

    isLoading.value = false;

    if (response != null) {
      await getMedicationData();
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
  TextEditingController medicationController = TextEditingController();
  TextEditingController dosePrescribedController = TextEditingController();
  TextEditingController prescribedScheduleController = TextEditingController();

  TextEditingController editDateController = TextEditingController();
  TextEditingController editmedicationController = TextEditingController();
  TextEditingController editdosePrescribedController = TextEditingController();
  TextEditingController editprescribedScheduleController =
      TextEditingController();

  @override
  void initState() {
    _controller.isLoading.value = true;
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        isChecked = List<bool>.filled(_texts.length, false);
        getData();
      },
    );
    super.initState();
  }

  getData() async {
    await getMedicationData();
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
            surfaceTintColor: Colors.transparent,
            title: Text(
              "Medication Checklist Tracker",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleMedium?.color,
                  fontSize: 22),
            ),
          ),
          body: Stack(
            fit: StackFit.expand,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    // const Align(
                    //   alignment: Alignment.center,
                    //   child: Text(
                    //     'Medication CheckList Tracker',
                    //     textAlign: TextAlign.center,
                    //     style: TextStyle(
                    //       fontSize: 30,
                    //       fontWeight: FontWeight.bold,
                    //     ),
                    //   ),
                    // ),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    Expanded(
                      child: Obx(() {
                        return _controller.isLoading.value
                            ? Center(
                                child: Utils.circular(),
                              )
                            : Editable(
                                key: _editableKey,
                                columns: cols,
                                rows: rows,
                                popUpTitle: 'Medication CheckList Tracker',
                                showSaveIcon: true,
                                saveIconColor:
                                    _isDark ? Colors.white : Colors.black,
                                borderColor: Colors.blueGrey,
                                onAddButtonPressed: () async {
                                  String? medication = medicationData;

                                  String text =
                                      '${dateController.text},${medicationController.text},${dosePrescribedController.text},${prescribedScheduleController.text},$medication';
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
                                      'medication': result[1],
                                      'doseprescribed': result[2],
                                      'prescribedschedule': result[3],
                                      'am': result[4],
                                      'noon': result[5],
                                      'afternoon': result[5],
                                      'bedtime': result[5],
                                    });
                                    Navigator.pop(context);
                                    await addMedicationData(result);
                                    isChecked =
                                        List<bool>.filled(_texts.length, false);
                                  } else {
                                    // Navigator.pop(context);
                                  }
                                },
                                onDeleteButtonPressed: (index) async {
                                  await deleteMedicationData(idList[index]);
                                },
                                onEditButtonPressed: (index) {
                                  _editDialog(context, index, listDatum);
                                },
                                onTap: () {
                                  dateController.clear();
                                  medicationController.clear();
                                  dosePrescribedController.clear();
                                  prescribedScheduleController.clear();
                                },
                                popUpChild: SizedBox(
                                  width: Get.width * 0.75,
                                  child: StatefulBuilder(
                                    builder: (BuildContext context,
                                        StateSetter setStates) {
                                      return Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              dateController.text = await Utils
                                                  .selectedDateFormat(context);
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
                                            controller: medicationController,
                                            decoration: const InputDecoration(
                                                hintText: 'Medication'),
                                          ),
                                          TextField(
                                            controller:
                                                dosePrescribedController,
                                            decoration: const InputDecoration(
                                                hintText: 'Dose Prescribed'),
                                          ),
                                          TextField(
                                            controller:
                                                prescribedScheduleController,
                                            decoration: const InputDecoration(
                                                hintText:
                                                    'Prescribed Scheduled'),
                                          ),
                                          SizedBox(
                                            height: Get.height * 0.25,
                                            width: Get.width * 0.6,
                                            child: ListView.builder(
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                padding: EdgeInsets.zero,
                                                itemCount: _texts.length,
                                                itemBuilder: (context, index) {
                                                  return CheckboxListTile(
                                                    checkColor: Colors.indigo,
                                                    // value: _saved.contains(context), // changed
                                                    value: isChecked?[index],
                                                    title: Text(_texts[index]),
                                                    onChanged: (val) {
                                                      setStates(() {
                                                        isChecked?[index] =
                                                            val!;
                                                      });
                                                      final input =
                                                          isChecked.toString();
                                                      final removedBrackets =
                                                          input.substring(1,
                                                              input.length - 1);
                                                      final parts =
                                                          removedBrackets
                                                              .split(', ');
                                                      var joined = parts
                                                          .map((part) => part)
                                                          .join(',');
                                                      medicationData = joined;
                                                    },
                                                  );
                                                }),
                                          ),
                                        ],
                                      );
                                    },
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
                              );
                      }),
                    ),
                    if (getDataLength == 0 &&
                        _controller.isLoading.isFalse &&
                        isLoading.value == false)
                      Padding(
                        padding: EdgeInsets.only(bottom: Get.height * 0.44),
                        child: Text(
                          'No any medication checklist',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontSize: 20),
                        ),
                      )
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
    editmedicationController.text = editList[1];
    editdosePrescribedController.text = editList[2];
    editprescribedScheduleController.text = editList[3];
    List<bool> tempList = [];
    for (int i = 4; i < editList.length; i++) {
      if (editList[i].toString() == "false") {
        tempList.add(false);
      } else {
        tempList.add(true);
      }
    }
    isChecked = tempList;
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
                          controller: editDateController,
                          enabled: false,
                          readOnly: true,
                          decoration: const InputDecoration(hintText: 'Date'),
                        ),
                      ),
                      TextField(
                        controller: editmedicationController,
                        decoration:
                            const InputDecoration(hintText: 'Medication'),
                      ),
                      TextField(
                        controller: editdosePrescribedController,
                        decoration:
                            const InputDecoration(hintText: 'Dose Prescribed'),
                      ),
                      TextField(
                        controller: editprescribedScheduleController,
                        decoration: const InputDecoration(
                            hintText: 'Prescribed Scheduled'),
                      ),
                      SizedBox(
                        height: Get.height * 0.25,
                        width: Get.width * 0.6,
                        child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemCount: _texts.length,
                            itemBuilder: (context, index) {
                              return CheckboxListTile(
                                checkColor: Colors.indigo,
                                // value: _saved.contains(context), // changed
                                value: isChecked?[index],
                                title: Text(_texts[index]),
                                onChanged: (val) {
                                  setStates(() {
                                    isChecked?[index] = val!;
                                  });
                                  final input = isChecked.toString();
                                  final removedBrackets =
                                      input.substring(1, input.length - 1);
                                  final parts = removedBrackets.split(', ');
                                  var joined =
                                      parts.map((part) => part).join(',');
                                  medicationData = joined;
                                },
                              );
                            }),
                      ),
                    ],
                  ),
                );
              },
            )),
        buttons: [
          DialogButton(
            onPressed: () async {
              String? text1 = medicationData;
              String text =
                  '${editDateController.text},${editmedicationController.text},${editdosePrescribedController.text},${editprescribedScheduleController.text},$text1';
              List<String> result = text.split(',');
              Navigator.pop(context);
              await updateMedicationData(
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
