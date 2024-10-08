import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:united_natives/components/ads_bottom_bar.dart';
import 'package:united_natives/viewModel/ads_controller.dart';
import 'package:united_natives/viewModel/self_monitoring_controller.dart';
import 'package:united_natives/viewModel/user_controller.dart';
import 'package:united_natives/viewModel/user_update_contoller.dart';
import 'package:united_natives/utils/pref_manager.dart';
import 'package:united_natives/pages/Diabites/custom_package/editable_custom_package.dart';
import 'package:united_natives/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../ResponseModel/health_response_model.dart';
import '../../utils/utils.dart';

void enablePlatformOverrideForDesktop() {
  if (!kIsWeb && (Platform.isMacOS || Platform.isWindows || Platform.isLinux)) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
}

class Mood extends StatefulWidget {
  const Mood({super.key});

  @override
  State<Mood> createState() => _MoodState();
}

// final Set _saved = Set();

class _MoodState extends State<Mood> {
  final UserController _userController = Get.find<UserController>();
  ChangeState changeState = Get.put(ChangeState());
  final SelfMonitoringController _controller =
      Get.put(SelfMonitoringController());
  int totalCount = 0;
  List list = [];
  RxBool isLoading = false.obs;
  List<Datum> listDatum = [];
  List<dynamic> editList = [];
  final bool _isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);

  AdsController adsController = Get.find();
  String? moodData;
  List cols = [
    {
      "title": 'Date',
      'index': 1,
      'widthFactor': 0.3,
      'key': 'date',
      'editable': false
    },
    {
      "title": 'Time',
      'index': 2,
      'widthFactor': 0.3,
      'key': 'time',
      'editable': false
    },
    {
      "title": 'Panic',
      'index': 3,
      'widthFactor': 0.3,
      'key': 'panic',
      'editable': false
    },
    {
      "title": 'Triggered',
      'index': 4,
      'widthFactor': 0.3,
      'key': 'triggered',
      'editable': false
    },
    {
      "title": 'Anger',
      'index': 5,
      'widthFactor': 0.3,
      'key': 'anger',
      'editable': false
    },
    {
      "title": 'Tired',
      'index': 6,
      'widthFactor': 0.3,
      'key': 'tired',
      'editable': false
    },
    {
      "title": 'Strong',
      'index': 7,
      'widthFactor': 0.3,
      'key': 'strong',
      'editable': false
    },
    {
      "title": 'Helped',
      'index': 8,
      'widthFactor': 0.3,
      'key': 'helped',
      'editable': false
    },
    {
      "title": 'Sad',
      'index': 9,
      'widthFactor': 0.3,
      'key': 'sad',
      'editable': false
    },
    {
      "title": 'Happy',
      'index': 10,
      'widthFactor': 0.3,
      'key': 'happy',
      'editable': false
    },
    {
      "title": 'Hurt',
      'index': 11,
      'widthFactor': 0.3,
      'key': 'hurt',
      'editable': false
    },
    {
      "title": 'Confident',
      'index': 12,
      'widthFactor': 0.3,
      'key': 'confident',
      'editable': false
    },
    {
      "title": 'Motivated',
      'index': 13,
      'widthFactor': 0.3,
      'key': 'motivated',
      'editable': false
    },
    {
      "title": 'Depressed',
      'index': 14,
      'widthFactor': 0.3,
      'key': 'depressed',
      'editable': false
    },
  ];

  List rows = [];
  List<String> idList = [];

  final _editableKey = GlobalKey<EditableState>();

  Future<HealthResponseModel?> getMoodData() async {
    rows.clear();
    idList.clear();
    const String url = Constants.getRoutineHealthReport;

    var body = {
      "patient_id": "${_userController.user.value.id}",
      "report_type_id": "6",
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
          List list = (jsonDecode(element.tableData!) as List);
          rows.add({
            'date': list[0].toString().trim(),
            'time': list[1].toString().trim(),
            'panic': list[2].toString().trim() == "true" ? '✔' : '-',
            'triggered': list[3].toString().trim() == "true" ? '✔' : '-',
            'anger': list[4].toString().trim() == "true" ? '✔' : '-',
            'tired': list[5].toString().trim() == "true" ? '✔' : '-',
            'strong': list[6].toString().trim() == "true" ? '✔' : '-',
            'helped': list[7].toString().trim() == "true" ? '✔' : '-',
            'sad': list[8].toString().trim() == "true" ? '✔' : '-',
            'happy': list[9].toString().trim() == "true" ? '✔' : '-',
            'hurt': list[10].toString().trim() == "true" ? '✔' : '-',
            'confident': list[11].toString().trim() == "true" ? '✔' : '-',
            'motivated': list[12].toString().trim() == "true" ? '✔' : '-',
            'depressed': list[13].toString().trim() == "true" ? '✔' : '-',
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

  Future addMoodData(reportTableData) async {
    isLoading.value = true;

    const String url = Constants.addRoutineHealthReport;

    var body = {
      "patient_id": "${_userController.user.value.id}",
      "report_type_id": "6",
      "report_table_headers": [
        "Date",
        "Time",
        "Panic",
        "Triggered",
        "Anger",
        "Tired",
        "Strong",
        "Helped",
        "Sad",
        "Happy",
        "Hurt",
        "Confident",
        "Motivated",
        "Depressed"
      ],
      "report_table_data": reportTableData
    };

    var response = await http.post(Uri.parse(url),
        body: jsonEncode(body), headers: Config.getHeaders());

    debugPrint('RESPONSE => ${response.body}');
    isLoading.value = false;

    if (response != null) {
      await getMoodData();
      Utils.showSnackBar(
        'Success',
        'Client Routine Health Reports Added Successfully!!',
      );
      return true;
    } else {
      return null;
    }
  }

  Future deleteMoodData(String id) async {
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
      await getMoodData();

      Utils.showSnackBar(
        'Success',
        'Routine Health Report Deleted Successfully!!',
      );
      return true;
    } else {
      return null;
    }
  }

  Future updateMoodData({dynamic reportTableData, required String id}) async {
    isLoading.value = true;

    const String url = Constants.updateRoutineHealthReport;

    var body = {
      "patient_id": "${_userController.user.value.id}",
      "report_id": id,
      "report_table_headers": [
        "Date",
        "Time",
        "Panic",
        "Triggered",
        "Anger",
        "Tired",
        "Strong",
        "Helped",
        "Sad",
        "Happy",
        "Hurt",
        "Confident",
        "Motivated",
        "Depressed"
      ],
      "report_table_data": reportTableData,
    };

    var response = await http.post(Uri.parse(url),
        body: jsonEncode(body), headers: Config.getHeaders());
    isLoading.value = false;

    debugPrint('RESPONSE => ${response.body}');

    if (response != null) {
      await getMoodData();
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

  TextEditingController happyController = TextEditingController();
  TextEditingController sadController = TextEditingController();
  TextEditingController tiredController = TextEditingController();
  TextEditingController otherController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  TextEditingController editHappyController = TextEditingController();
  TextEditingController editSadController = TextEditingController();
  TextEditingController editTiredController = TextEditingController();
  TextEditingController editOtherController = TextEditingController();

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
    await getMoodData();
  }

  List<bool>? isChecked;

  final List<String> _texts = [
    "Panic",
    "Triggered",
    "Anger",
    "Tired",
    "Strong",
    "Helped",
    "Sad",
    "Happy",
    "Hurt",
    "Confident",
    "Motivated",
    "Depressed"
  ];

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
              "Mood Tracker",
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
                    //     'Mood Tracker',
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
                            // ? Center(
                            //     child: CircularProgressIndicator(),
                            //   )
                            ? Center(
                                child: Utils.circular(),
                              )
                            : SingleChildScrollView(
                                child: Editable(
                                  key: _editableKey,
                                  columns: cols,
                                  rows: rows,
                                  popUpTitle: 'Mood Tracker',
                                  saveIconColor:
                                      _isDark ? Colors.white : Colors.black,
                                  showSaveIcon: true,
                                  onAddButtonPressed: () async {
                                    String? text = moodData;
                                    List<String>? result = text?.split(',');
                                    if (result == null) {
                                      return Utils.showSnackBar(
                                        'Enter details',
                                        'Please enter all required details!!',
                                      );
                                    }
                                    if (dateController.text.isEmpty) {
                                      return Utils.showSnackBar(
                                        'Enter Date',
                                        'Please enter date!!',
                                      );
                                    }
                                    if (timeController.text.isEmpty) {
                                      return Utils.showSnackBar(
                                        'Enter Time',
                                        'Please enter time!!',
                                      );
                                    }

                                    result.insert(0, dateController.text);
                                    result.insert(1, timeController.text);

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
                                        'time': result[1],
                                        'panic': result[2],
                                        'triggered': result[3],
                                        'anger': result[4],
                                        'tired': result[5],
                                        'strong': result[6],
                                        'helped': result[7],
                                        'sad': result[8],
                                        'happy': result[9],
                                        'hurt': result[10],
                                        'confident': result[11],
                                        'motivated': result[12],
                                        'depressed': result[13],
                                      });
                                      Navigator.pop(context);

                                      await addMoodData(result);
                                      isChecked = List<bool>.filled(
                                          _texts.length, false);

                                      timeController.clear();
                                      dateController.clear();
                                    } else {
                                      // Navigator.pop(context);
                                    }
                                  },
                                  onDeleteButtonPressed: (index) async {
                                    await deleteMoodData(idList[index]);
                                  },
                                  onEditButtonPressed: (index) {
                                    _editDialog(context, index, listDatum);
                                  },
                                  onTap: () {},
                                  popUpChild: StatefulBuilder(
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
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge
                                                  ?.copyWith(fontSize: 18),
                                              controller: dateController,
                                              enabled: false,
                                              readOnly: true,
                                              decoration: const InputDecoration(
                                                hintText: 'Date',
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              timeController.text = await Utils
                                                  .selectedTimeFormat(context);
                                            },
                                            child: TextField(
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge
                                                  ?.copyWith(fontSize: 18),
                                              controller: timeController,
                                              enabled: false,
                                              readOnly: true,
                                              decoration: const InputDecoration(
                                                  hintText: 'Time'),
                                            ),
                                          ),
                                          Scrollbar(
                                            child: SizedBox(
                                              height: Get.height * 0.4,
                                              width: Get.width * 0.75,
                                              child: ListView.builder(
                                                  padding: EdgeInsets.zero,
                                                  itemCount: _texts.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return CheckboxListTile(
                                                      checkColor: Colors.indigo,
                                                      // value: _saved.contains(context), // changed
                                                      value: isChecked?[index],
                                                      title:
                                                          Text(_texts[index]),
                                                      onChanged: (val) {
                                                        setStates(() {
                                                          isChecked?[index] =
                                                              val!;
                                                        });

                                                        final input = isChecked
                                                            .toString();
                                                        final removedBrackets =
                                                            input.substring(
                                                                1,
                                                                input.length -
                                                                    1);
                                                        final parts =
                                                            removedBrackets
                                                                .split(', ');
                                                        var joined = parts
                                                            .map((part) => part)
                                                            .join(',');
                                                        moodData = joined;

                                                        debugPrint(
                                                            'SPLITSES  $joined');
                                                      },
                                                    );
                                                  }),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                  borderColor: Colors.blueGrey,
                                  showCreateButton: true,
                                  onSubmitted: (value) {},
                                  createButtonLabel: const Text(
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
                          'No mood tracker data',
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
    debugPrint('EDITLIST ${jsonDecode(listDatum[index].tableData)}');
    List<bool> tempList = [];
    for (int i = 0; i < editList.length; i++) {
      if (editList[i].toString() == "false") {
        tempList.add(false);
      } else {
        tempList.add(true);
      }
    }

    isChecked = tempList;
    // isChecked.addAll(tempList);
    debugPrint('EDITLIST $tempList');

    // editSadController.text = editList[1];
    // editTiredController.text = editList[2];
    // editOtherController.text = editList[3];
    Alert(
        context: context,
        title: 'Mood Tracker',
        closeFunction: () {
          Navigator.pop(context);
          isChecked = List<bool>.filled(_texts.length, false);
        },
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setStates) {
              return SizedBox(
                height: Get.height * 0.55,
                width: Get.width * 0.75,
                child: ListView.builder(
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
                          debugPrint('VAl$isChecked');
                          final input = isChecked.toString();
                          final removedBrackets =
                              input.substring(1, input.length - 1);
                          final parts = removedBrackets.split(', ');
                          var joined = parts.map((part) => part).join(',');
                          moodData = joined;

                          debugPrint('SPLITSES  $joined');
                        },
                      );
                    }),
              );
            },
          ),
        ),
        buttons: [
          DialogButton(
            onPressed: () async {
              String? text = moodData;
              List<String>? result = text?.split(',');
              debugPrint("result=??$result");
              Navigator.pop(context);
              await updateMoodData(id: idList[index], reportTableData: result);
              isChecked = List<bool>.filled(_texts.length, false);
            },
            child: const Text(
              "Save",
              style: TextStyle(color: Colors.white, fontSize: 22),
            ),
          )
        ]).show();
  }
}
