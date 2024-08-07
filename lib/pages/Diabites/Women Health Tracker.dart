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

class WomenHealth extends StatefulWidget {
  @override
  _WomenHealthState createState() => _WomenHealthState();
}

class _WomenHealthState extends State<WomenHealth> {
  UserController _userController = Get.find<UserController>();

  SelfMonitoringController _controller = Get.put(SelfMonitoringController());

  AdsController adsController = Get.find();
  int totalCount = 0;
  RxBool isLoading = false.obs;
  List<String> idList = [];
  List<Datum> listDatum = [];
  List list = [];
  bool _isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);
  int getDataLength = 0;
  List editList = [];
  List cols = [
    {
      "title": 'Start Date',
      'index': 1,
      'widthFactor': 0.40,
      'key': 'date',
      'editable': false
    },
    {
      "title": 'Days',
      'index': 2,
      'widthFactor': 0.40,
      'key': 'day',
      'editable': false
    },
  ];

  List rows = [];

  final _editableKey = GlobalKey<EditableState>();
  TextEditingController dateController = TextEditingController();
  TextEditingController editdateController = TextEditingController();
  TextEditingController daysController = TextEditingController();
  TextEditingController editdaysController = TextEditingController();

  Future<HealthResponseModel> getWomenHealthData() async {
    rows.clear();
    idList.clear();
    final String url = Constants.getRoutineHealthReport;

    var body = {
      "patient_id": "${_userController.user.value.id}",
      "report_type_id": "3",
    };

    var response = await http.post(Uri.parse(url),
        body: jsonEncode(body), headers: Config.getHeaders());

    print('RESPONSE => ${response.body}');

    try {
      if (response != null) {
        _controller.isLoading.value = false;
        HealthResponseModel model = healthResponseModelFromJson(response.body);
        listDatum = model.data;
        model.data.forEach((element) {
          idList.add(element.id);
          list = (jsonDecode(element.tableData) as List);
          rows.add({'date': list[0], 'day': list[1]});
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

  Future addWomenHealthData(reportTableData) async {
    isLoading.value = true;

    final String url = Constants.addRoutineHealthReport;

    var body = {
      "patient_id": "${_userController.user.value.id}",
      "report_type_id": "3",
      "report_table_headers": ["Start Date", "Days"],
      "report_table_data": reportTableData
    };

    var response = await http.post(Uri.parse(url),
        body: jsonEncode(body), headers: Config.getHeaders());
    isLoading.value = false;

    print('RESPONSE => ${response.body}');

    if (response != null) {
      await getWomenHealthData();
      Utils.showSnackBar(
          'Success', 'Client Routine Health Reports Added Successfully!');
      return true;
    } else {
      return null;
    }
  }

  Future deleteWomenHealthData(String id) async {
    isLoading.value = true;

    final String url = Constants.deleteRoutineHealthReport;

    var body = {
      "patient_id": "${_userController.user.value.id}",
      "report_id": id
    };

    var response = await http.post(Uri.parse(url),
        body: jsonEncode(body), headers: Config.getHeaders());

    print('RESPONSE => ${response.body}');
    isLoading.value = false;

    if (response != null) {
      await getWomenHealthData();

      Utils.showSnackBar(
          'Success', 'Routine Health Report Deleted Successfully!');
      return true;
    } else {
      return null;
    }
  }

  Future updateWomenHealthData({dynamic reportTableData, String id}) async {
    isLoading.value = true;

    final String url = Constants.updateRoutineHealthReport;

    var body = {
      "patient_id": "${_userController.user.value.id}",
      "report_id": id,
      "report_table_headers": ["Start Date", "Days"],
      "report_table_data": reportTableData
    };

    var response = await http.post(Uri.parse(url),
        body: jsonEncode(body), headers: Config.getHeaders());

    print('RESPONSE => ${response.body}');
    isLoading.value = false;

    if (response != null) {
      await getWomenHealthData();
      Utils.showSnackBar(
          'Success', 'Routine Health Report Updated Successfully!!');
      return true;
    } else {
      return null;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _controller.isLoading.value = true;
    getData();
    super.initState();
  }

  getData() async {
    await getWomenHealthData();
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
            title: Text(
              "Women Health Tracker",
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
                        'Women Health Tracker',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 10),
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
                                  popUpTitle: 'Women Health Tracker',
                                  showSaveIcon: true,
                                  saveIconColor:
                                      _isDark ? Colors.white : Colors.black,
                                  borderColor: Colors.blueGrey,
                                  onAddButtonPressed: () async {
                                    String text =
                                        '${dateController.text},${daysController.text}';
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
                                        'date': result[0],
                                        'day': result[1],
                                      });
                                      Navigator.pop(context);
                                      await addWomenHealthData(result);
                                    } else {
                                      // Navigator.pop(context);
                                    }
                                  },
                                  onDeleteButtonPressed: (index) async {
                                    print('Index $index');
                                    await deleteWomenHealthData(idList[index]);
                                  },
                                  onEditButtonPressed: (index) {
                                    _editDialog(context, index, listDatum);
                                  },
                                  onTap: () {
                                    dateController.clear();
                                    daysController.clear();
                                  },
                                  popUpChild: Container(
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
                                            decoration: InputDecoration(
                                                hintText: 'Start Date'),
                                          ),
                                        ),
                                        TextField(
                                          controller: daysController,
                                          decoration: InputDecoration(
                                              hintText: 'Number of Days'),
                                        ),
                                      ],
                                    ),
                                  ),
                                  showCreateButton: true,
                                  onSubmitted: (value) {},
                                  createButtonLabel: Text(
                                    'New',
                                    style: TextStyle(color: Colors.black),
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
                          'No women health tracker data',
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
    print('===editList===>$editList');
    editdateController.text = editList[0];
    editdaysController.text = editList[1];

    Alert(
        context: context,
        title: 'Physical Activity Tracker',
        content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Container(
              width: Get.width * 0.75,
              child: StatefulBuilder(
                builder: (BuildContext context, setStates) {
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          editdateController.text =
                              await Utils.selectedDateFormat(context);
                        },
                        child: TextField(
                          enabled: false,
                          readOnly: true,
                          controller: editdateController,
                          decoration: InputDecoration(hintText: 'Date'),
                        ),
                      ),
                      TextField(
                        controller: editdaysController,
                        decoration: InputDecoration(hintText: 'M'),
                      ),
                    ],
                  );
                },
              ),
            )),
        buttons: [
          DialogButton(
            onPressed: () async {
              print('call');
              String text =
                  '${editdateController.text},${editdaysController.text}';
              List<String> result = text.split(',');
              print("result=??$result");
              Navigator.pop(context);
              await updateWomenHealthData(
                  id: idList[index], reportTableData: result);
            },
            child: Text(
              "Save",
              style: TextStyle(color: Colors.white, fontSize: 22),
            ),
          )
        ]).show();
  }
}
