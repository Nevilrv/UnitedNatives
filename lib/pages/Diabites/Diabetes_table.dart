import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:united_natives/components/ads_bottom_bar.dart';
import 'package:united_natives/controller/ads_controller.dart';
import 'package:united_natives/controller/self_monitoring_controller.dart';
import 'package:united_natives/controller/user_controller.dart';
import 'package:united_natives/controller/user_update_contoller.dart';
import 'package:united_natives/data/pref_manager.dart';
import 'package:united_natives/pages/Diabites/custom_package/editable_custom_package.dart';
import 'package:united_natives/utils/constants.dart';
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

class Diabetes extends StatefulWidget {
  const Diabetes({super.key});

  @override
  State<Diabetes> createState() => _DiabetesState();
}

class _DiabetesState extends State<Diabetes> {
  String dropdownvalue = 'Blood Sugar 1 Hour';

  // List of items in our dropdown menu
  var items = [
    'Blood Sugar 1 Hour',
    'Blood Sugar 2 Hour',
  ];
  final UserController _userController = Get.find<UserController>();

  ChangeState changeState = Get.put(ChangeState());
  final SelfMonitoringController _controller =
      Get.put(SelfMonitoringController());
  int totalCount = 0;
  List list = [];
  List<Datum> listDatum = [];
  List editList = [];
  RxBool isLoading = false.obs;
  List cols = [
    {
      "title": 'Date',
      'index': 1,
      'widthFactor': 0.7,
      'key': 'date',
      'editable': false
    },
    {
      "title": 'M',
      'index': 2,
      'widthFactor': 0.7,
      'key': 'm',
      'editable': false
    },
    {
      "title": 'Blood Sugar Fasting',
      'index': 3,
      'widthFactor': 0.7,
      'key': 'sugar fasting',
      'editable': false
    },
    {
      "title": 'Blood Sugar',
      'index': 4,
      'widthFactor': 0.7,
      'key': 'one hour',
      'editable': false
    },
    // {
    //   "title": 'Blood Sugar 2 Hour',
    //   'index': 5,
    //   'widthFactor': 0.65,
    //   'key': 'two hour',
    //   'editable': false
    // },
    {
      "title": 'Food(s) Eaten Before Testing',
      'index': 6,
      'widthFactor': 0.7,
      'key': 'status',
      'editable': false
    },
  ];

  AdsController adsController = Get.find();

  final bool _isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);
  List rows = [];
  List<String> idList = [];

  final _editableKey = GlobalKey<EditableState>();

  Future<HealthResponseModel?> getDiabetesData() async {
    rows.clear();
    idList.clear();
    const String url = Constants.getRoutineHealthReport;
    var body = {
      "patient_id": "${_userController.user.value.id}",
      "report_type_id": "7",
    };

    var response = await http.post(Uri.parse(url),
        body: jsonEncode(body), headers: Config.getHeaders());

    debugPrint('RESPONSE => ${response.body}');

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
            'm': list[1],
            'sugar fasting': list[2],
            'one hour': list[3],
            'two hour': list[4],
            'status': list[4],
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

  Future addDiabetesData(reportTableData) async {
    isLoading.value = true;

    const String url = Constants.addRoutineHealthReport;

    var body = {
      "patient_id": "${_userController.user.value.id}",
      "report_type_id": "7",
      "report_table_headers": [
        "Date",
        "M",
        "Blood Sugar Fasting",
        "Blood Sugar 1 Hour",
        "Blood Sugar 2 Hour",
        "Food(s) Eaten Before Testing",
      ],
      "report_table_data": reportTableData
    };

    var response = await http.post(Uri.parse(url),
        body: jsonEncode(body), headers: Config.getHeaders());
    isLoading.value = false;

    debugPrint('RESPONSE => ${response.body}');

    if (response != null) {
      await getDiabetesData();
      Utils.showSnackBar(
        'Success',
        'Client Routine Health Reports Added Successfully!!',
      );
      return true;
    } else {
      return null;
    }
  }

  Future deleteDiabetesData(String id) async {
    isLoading.value = true;

    const String url = Constants.deleteRoutineHealthReport;

    var body = {
      "patient_id": "${_userController.user.value.id}",
      "report_id": id,
    };

    var response = await http.post(Uri.parse(url),
        body: jsonEncode(body), headers: Config.getHeaders());

    debugPrint('RESPONSE => ${response.body}');
    isLoading.value = false;

    if (response != null) {
      await getDiabetesData();

      Utils.showSnackBar(
        'Success',
        'Routine Health Report Deleted Successfully!!',
      );
      return true;
    } else {
      return null;
    }
  }

  Future updateDiabetesData(
      {dynamic reportTableData, required String id}) async {
    isLoading.value = true;

    const String url = Constants.updateRoutineHealthReport;

    var body = {
      "patient_id": "${_userController.user.value.id}",
      "report_id": id,
      "report_table_headers": [
        "Date",
        "M",
        "Blood Sugar Fasting",
        "Blood Sugar 1 Hour",
        "Blood Sugar 2 Hour",
        "Food(s) Eaten Before Testing",
      ],
      "report_table_data": reportTableData,
    };

    var response = await http.post(Uri.parse(url),
        body: jsonEncode(body), headers: Config.getHeaders());

    debugPrint('RESPONSE => ${response.body}');
    isLoading.value = false;

    if (response != null) {
      await getDiabetesData();
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
  TextEditingController mController = TextEditingController();
  TextEditingController bsController = TextEditingController();
  TextEditingController bs1Controller = TextEditingController();
  TextEditingController bs2Controller = TextEditingController();
  TextEditingController foodController = TextEditingController();

  TextEditingController editDateController = TextEditingController();
  TextEditingController editMController = TextEditingController();
  TextEditingController editBsController = TextEditingController();
  TextEditingController editBs1Controller = TextEditingController();
  TextEditingController editBs2Controller = TextEditingController();
  TextEditingController editFoodController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    _controller.isLoading.value = true;
    getData();

    super.initState();
  }

  getData() async {
    await getDiabetesData();
    setState(() {});
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
              "Blood Sugar Tracker",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.titleMedium?.color,
                fontSize: 24,
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
                        'Blood Sugar Tracker',
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
                            : Editable(
                                key: _editableKey,
                                columns: cols,
                                rows: rows,
                                popUpTitle: 'Blood Sugar Tracker',
                                showSaveIcon: true,
                                saveIconColor:
                                    _isDark ? Colors.white : Colors.black,
                                borderColor: Colors.blueGrey,
                                onAddButtonPressed: () async {
                                  debugPrint(dropdownvalue);
                                  String text =
                                      '${dateController.text},${mController.text},${bsController.text},$dropdownvalue,${foodController.text}';
                                  List<String> result = text.split(',');
                                  debugPrint("result=??$result");
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
                                      'm': result[1],
                                      'sugar fasting': result[2],
                                      'one hour': result[3],
                                      'two hour': result[4],
                                      'status': result[4],
                                    });
                                    Navigator.pop(context);
                                    await addDiabetesData(result);
                                  } else {
                                    // Navigator.pop(context);
                                  }
                                },
                                onDeleteButtonPressed: (index) async {
                                  await deleteDiabetesData(idList[index]);
                                },
                                onEditButtonPressed: (index) {
                                  _editDialog(context, index, listDatum);
                                },
                                onTap: () {
                                  dateController.clear();
                                  foodController.clear();
                                  bs2Controller.clear();
                                  bs1Controller.clear();
                                  bsController.clear();
                                  mController.clear();
                                },
                                popUpChild: SizedBox(
                                  width: Get.width * 0.75,
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          dateController.text =
                                              await Utils.selectedDateFormat(
                                                  context);
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
                                        controller: mController,
                                        decoration: const InputDecoration(
                                            hintText: 'M'),
                                      ),
                                      TextField(
                                        controller: bsController,
                                        decoration: const InputDecoration(
                                            hintText: 'Blood Sugar Fasting'),
                                      ),
                                      GetBuilder<ChangeState>(
                                        builder: (controller) {
                                          return SizedBox(
                                            width: double.infinity,
                                            child: DropdownButton(
                                              // Initial Value
                                              value: controller.change,
                                              style: TextStyle(
                                                color: Colors.black
                                                    .withOpacity(0.6),
                                                fontSize: 18,
                                              ),
                                              isExpanded: true,
                                              // Down Arrow Icon
                                              icon: const Icon(
                                                  Icons.keyboard_arrow_down),
                                              // Array list of items
                                              items: items.map((String items) {
                                                return DropdownMenuItem(
                                                  value: items,
                                                  child: Text(
                                                    items,
                                                    style: TextStyle(
                                                        color: _isDark
                                                            ? Colors.white
                                                                .withOpacity(
                                                                    0.8)
                                                            : Colors.black),
                                                  ),
                                                );
                                              }).toList(),
                                              // After selecting the desired option,it will
                                              // change button value to selected value
                                              onChanged: (String? newValue) {
                                                controller
                                                    .changeString(newValue!);
                                                dropdownvalue =
                                                    controller.change;
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                      // TextField(
                                      //   controller: bs1Controller,
                                      //   decoration: InputDecoration(
                                      //       hintText: 'Blood Sugar 1 Hour'),
                                      // ),
                                      // TextField(
                                      //   controller: bs2Controller,
                                      //   decoration: InputDecoration(
                                      //       hintText: 'Blood Sugar 2 Hour'),
                                      // ),
                                      TextField(
                                        controller: foodController,
                                        decoration: const InputDecoration(
                                            hintText:
                                                'Food(s) Eaten Before Testing'),
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
                              );
                      }),
                    ),
                    if (getDataLength == 0 &&
                        _controller.isLoading.isFalse &&
                        isLoading.value == false)
                      Padding(
                        padding: EdgeInsets.only(bottom: Get.height * 0.43),
                        child: Text(
                          'No blood sugar details',
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
    debugPrint('FOODD ${editList[4]}');
    editDateController.text = editList[0];
    editMController.text = editList[1];
    editBsController.text = editList[2];
    dropdownvalue = editList[3];
    // editBs1Controller.text = editList[3];
    // editBs2Controller.text = editList[4];
    editFoodController.text = editList[4];

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
                      controller: editMController,
                      decoration: const InputDecoration(hintText: 'M'),
                    ),
                    TextField(
                      controller: editBsController,
                      decoration: const InputDecoration(
                          hintText: 'Blood Sugar Fasting'),
                    ),
                    GetBuilder<ChangeState>(
                      builder: (controller) {
                        controller.change = dropdownvalue;

                        return SizedBox(
                          width: double.infinity,
                          child: DropdownButton(
                            // Initial Value
                            value: controller.change,
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.6),
                              fontSize: 18,
                            ),
                            isExpanded: true,
                            // Down Arrow Icon
                            icon: const Icon(Icons.keyboard_arrow_down),
                            // Array list of items
                            items: items.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items),
                              );
                            }).toList(),
                            // After selecting the desired option,it will
                            // change button value to selected value
                            onChanged: (String? newValue) {
                              setStates(() {
                                controller.changeString(newValue!);
                                dropdownvalue = controller.change;
                              });
                            },
                          ),
                        );
                      },
                    ),

                    // TextField(
                    //   controller: editBs1Controller,
                    //   decoration: InputDecoration(hintText: 'Blood Sugar 1 Hour'),
                    // ),
                    // TextField(
                    //   controller: editBs2Controller,
                    //   decoration: InputDecoration(hintText: 'Blood Sugar 2 Hour'),
                    // ),
                    TextField(
                      controller: editFoodController,
                      decoration: const InputDecoration(
                          hintText: 'Food(s) Eaten Before Testing'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        buttons: [
          DialogButton(
            onPressed: () async {
              String text =
                  '${editDateController.text},${editMController.text},${editBsController.text},$dropdownvalue,${editFoodController.text}';
              List<String> result = text.split(',');

              Navigator.pop(context);
              await updateDiabetesData(
                  id: idList[index], reportTableData: result);
            },
            child: const Text(
              "Save",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
              ),
            ),
          )
        ]).show();
  }
}
