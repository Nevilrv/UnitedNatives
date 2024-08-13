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
import 'package:rflutter_alert/rflutter_alert.dart';
import '../../model/health_response_model.dart';
import '../../utils/utils.dart';

void enablePlatformOverrideForDesktop() {
  if (!kIsWeb && (Platform.isMacOS || Platform.isWindows || Platform.isLinux)) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
}

class Food extends StatefulWidget {
  const Food({super.key});

  @override
  State<Food> createState() => _FoodState();
}

class _FoodState extends State<Food> {
  final UserController _userController = Get.find<UserController>();
  final SelfMonitoringController _controller =
      Get.put(SelfMonitoringController());
  int totalCount = 0;
  List list = [];
  RxBool isLoading = false.obs;
  List<Datum> listDatum = [];
  List editList = [];
  final bool _isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);
  List cols = [
    {
      "title": 'Food/Drink',
      'index': 1,
      'widthFactor': 0.30,
      'key': 'food',
      'editable': false
    },
    {
      "title": 'Calories',
      'index': 2,
      'widthFactor': 0.30,
      'key': 'calories',
      'editable': false
    },
    {
      "title": 'Fat',
      'index': 3,
      'widthFactor': 0.30,
      'key': 'fat',
      'editable': false
    },
    {
      "title": 'Carbs',
      'index': 4,
      'widthFactor': 0.30,
      'key': 'carbs',
      'editable': false
    },
    {
      "title": 'Protein',
      'index': 5,
      'widthFactor': 0.30,
      'key': 'protein',
      'editable': false
    },
    {
      "title": 'Water',
      'index': 6,
      'widthFactor': 0.30,
      'key': 'water',
      'editable': false
    },
    {
      "title": 'Sugar',
      'index': 7,
      'widthFactor': 0.30,
      'key': 'sugar',
      'editable': false
    },
  ];

  List rows = [];
  List<String> idList = [];

  static List<_FoodCaloricIntakeData> data = [];
  final _editableKey = GlobalKey<EditableState>();

  Future<void> getFoodData() async {
    rows.clear();
    idList.clear();
    data.clear();

    const String url = Constants.getRoutineHealthReport;

    var body = {
      "patient_id": "${_userController.user.value.id}",
      "report_type_id": "4",
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
            'food': list[0],
            'calories': list[1],
            'fat': list[2],
            'carbs': list[3],
            'protein': list[4],
            'water': list[5],
            'sugar': list[6]
          });

          data.add(
            _FoodCaloricIntakeData(
              name: list[0].toString(),
              calories: double.parse(list[1].toString()),
              fat: double.parse(list[2].toString()),
              carbs: double.parse(list[3].toString()),
              protein: double.parse(list[4].toString()),
              water: double.parse(list[5].toString()),
              sugar: double.parse(list[6].toString()),
            ),
          );

          debugPrint('--data--$data');
        });
        debugPrint('Rows $rows');
        getDataLength = rows.length;
        setState(() {});
      } else {
        _controller.isLoading.value = false;
        return;
      }
    } catch (e) {
      _controller.isLoading.value = false;
      debugPrint('Error $e');
    }
  }

  Future addFoodData(reportTableData) async {
    isLoading.value = true;

    const String url = Constants.addRoutineHealthReport;

    var body = {
      "patient_id": "${_userController.user.value.id}",
      "report_type_id": "4",
      "report_table_headers": [
        "Food/Drink",
        "Calories",
        "Fat",
        "Carbs",
        "Protein",
        "Water",
      ],
      "report_table_data": reportTableData
    };

    var response = await http.post(Uri.parse(url),
        body: jsonEncode(body), headers: Config.getHeaders());
    isLoading.value = false;

    debugPrint('RESPONSE => ${response.body}');

    if (response != null) {
      await getFoodData();
      Utils.showSnackBar(
        'Success',
        'Client Routine Health Reports Added Successfully!!',
      );
      return true;
    } else {
      return null;
    }
  }

  Future deleteFoodData(String id) async {
    isLoading.value = true;

    const String url = Constants.deleteRoutineHealthReport;

    var body = {
      "patient_id": "${_userController.user.value.id}",
      "report_id": id,
    };

    var response = await http.post(Uri.parse(url),
        body: jsonEncode(body), headers: Config.getHeaders());
    isLoading.value = false;

    debugPrint('RESPONSE => ${response.body}');

    if (response != null) {
      await getFoodData();

      Utils.showSnackBar(
        'Success',
        'Routine Health Report Deleted Successfully!!',
      );
      return true;
    } else {
      return null;
    }
  }

  Future updateFoodData({dynamic reportTableData, required String id}) async {
    isLoading.value = true;

    const String url = Constants.updateRoutineHealthReport;

    var body = {
      "patient_id": "${_userController.user.value.id}",
      "report_id": id,
      "report_table_headers": [
        "Food/Drink",
        "Calories",
        "Fat",
        "Carbs",
        "Protein",
        "Water",
      ],
      "report_table_data": reportTableData,
    };

    var response = await http.post(Uri.parse(url),
        body: jsonEncode(body), headers: Config.getHeaders());
    isLoading.value = false;

    debugPrint('RESPONSE => ${response.body}');

    if (response != null) {
      await getFoodData();
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

  TextEditingController foodController = TextEditingController();
  TextEditingController calController = TextEditingController();
  TextEditingController fatController = TextEditingController();
  TextEditingController carController = TextEditingController();
  TextEditingController proController = TextEditingController();
  TextEditingController waterController = TextEditingController();
  TextEditingController sugarController = TextEditingController();

  TextEditingController editFoodController = TextEditingController();
  TextEditingController editCalController = TextEditingController();
  TextEditingController editFatController = TextEditingController();
  TextEditingController editCarController = TextEditingController();
  TextEditingController editProController = TextEditingController();
  TextEditingController editWaterController = TextEditingController();
  TextEditingController editSugarController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    _controller.isLoading.value = true;
    getData();

    super.initState();
  }

  getData() async {
    await getFoodData();
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
              "Food/Caloric Intake",
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
                        'Food/Caloric Intake Data',
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
                                      popUpTitle: 'Food/Caloric Intake Data',
                                      borderColor: Colors.blueGrey,
                                      showCreateButton: true,
                                      showSaveIcon: true,
                                      saveIconColor:
                                          _isDark ? Colors.white : Colors.black,
                                      onAddButtonPressed: () async {
                                        String text =
                                            '${foodController.text},${calController.text},${fatController.text},${carController.text},${proController.text},${waterController.text},${sugarController.text}';
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
                                            'food': result[0],
                                            'calories': result[1],
                                            'fat': result[2],
                                            'carbs': result[3],
                                            'protein': result[4],
                                            'water': result[5],
                                            'sugar': result[6]
                                          });
                                          data.add(
                                            _FoodCaloricIntakeData(
                                              name: result[0].toString(),
                                              calories: double.parse(
                                                  result[1].toString()),
                                              fat: double.parse(
                                                  result[2].toString()),
                                              carbs: double.parse(
                                                  result[3].toString()),
                                              protein: double.parse(
                                                  result[4].toString()),
                                              water: double.parse(
                                                  result[5].toString()),
                                              sugar: double.parse(
                                                  result[6].toString()),
                                            ),
                                          );
                                          Navigator.pop(context);
                                          await addFoodData(result);
                                        } else {
                                          // Navigator.pop(context);
                                        }
                                      },
                                      onDeleteButtonPressed: (index) async {
                                        await deleteFoodData(idList[index]);
                                      },
                                      onEditButtonPressed: (index) {
                                        _editDialog(context, index, listDatum);
                                      },
                                      onTap: () {
                                        foodController.clear();
                                        calController.clear();
                                        fatController.clear();
                                        carController.clear();
                                        proController.clear();
                                        waterController.clear();
                                        sugarController.clear();
                                      },
                                      popUpChild: SizedBox(
                                        width: Get.width * 0.75,
                                        child: Column(
                                          children: [
                                            TextField(
                                              controller: foodController,
                                              decoration: const InputDecoration(
                                                  hintText: 'Food/Drink'),
                                            ),
                                            TextField(
                                              controller: calController,
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .allow(RegExp(r'[0-9.]')),
                                              ],
                                              decoration: const InputDecoration(
                                                  hintText: 'Calories'),
                                            ),
                                            TextField(
                                              controller: fatController,
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .allow(RegExp(r'[0-9.]')),
                                              ],
                                              decoration: const InputDecoration(
                                                  hintText: 'Fat'),
                                            ),
                                            TextField(
                                              controller: carController,
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .allow(RegExp(r'[0-9.]')),
                                              ],
                                              decoration: const InputDecoration(
                                                  hintText: 'Carbs'),
                                            ),
                                            TextField(
                                              controller: proController,
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .allow(RegExp(r'[0-9.]')),
                                              ],
                                              decoration: const InputDecoration(
                                                  hintText: 'Protein'),
                                            ),
                                            TextField(
                                              controller: waterController,
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .allow(RegExp(r'[0-9.]')),
                                              ],
                                              decoration: const InputDecoration(
                                                  hintText: 'Water'),
                                            ),
                                            TextField(
                                              controller: sugarController,
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .allow(RegExp(r'[0-9.]')),
                                              ],
                                              decoration: const InputDecoration(
                                                  hintText: 'Sugar'),
                                            ),
                                          ],
                                        ),
                                      ),
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
                                      //   SfCartesianChart(
                                      //     // primaryXAxis: CategoryAxis(),
                                      //     enableAxisAnimation: true,
                                      //
                                      //     /// NEW CODE COMMENT
                                      //     // primaryXAxis: const CategoryAxis(
                                      //     //   zoomPosition: 0.1,
                                      //     // ),
                                      //     primaryYAxis: const NumericAxis(
                                      //         edgeLabelPlacement:
                                      //             EdgeLabelPlacement.shift),
                                      //     // axes: [Charts()],
                                      //     series: chartData,
                                      //   ),
                                      if (data.isEmpty)
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: Get.height * 0.30),
                                          child: Center(
                                            child: Text(
                                              'No food/caloric intake data',
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
    editFoodController.text = editList[0];
    editCalController.text = editList[1];
    editFatController.text = editList[2];
    editCarController.text = editList[3];
    editProController.text = editList[4];
    editWaterController.text = editList[5];
    editSugarController.text = editList[6];
    Alert(
        context: context,
        title: 'Food/Caloric Intake Data',
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: SizedBox(
            width: Get.width * 0.75,
            child: Column(
              children: [
                TextField(
                  controller: editFoodController,
                  decoration: const InputDecoration(hintText: 'Food/Drink'),
                ),
                TextField(
                  controller: editCalController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                  decoration: const InputDecoration(hintText: 'Calories'),
                ),
                TextField(
                  controller: editFatController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                  decoration: const InputDecoration(hintText: 'Fat'),
                ),
                TextField(
                  controller: editCarController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                  decoration: const InputDecoration(hintText: 'Carbs'),
                ),
                TextField(
                  controller: editProController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                  decoration: const InputDecoration(hintText: 'Protein'),
                ),
                TextField(
                  controller: editWaterController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                  decoration: const InputDecoration(hintText: 'Water'),
                ),
                TextField(
                  controller: editSugarController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                  decoration: const InputDecoration(hintText: 'Sugar'),
                ),
              ],
            ),
          ),
        ),
        buttons: [
          DialogButton(
            onPressed: () async {
              String text =
                  '${editFoodController.text},${editCalController.text},${editFatController.text},${editCarController.text},${editProController.text},${editWaterController.text},${editSugarController.text}';
              List<String> result = text.split(',');
              debugPrint("result=??$result");
              Navigator.pop(context);
              await updateFoodData(id: idList[index], reportTableData: result);
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
  //   ///calories
  //   LineSeries<_FoodCaloricIntakeData, dynamic>(
  //     dataSource: data,
  //     xValueMapper: (_FoodCaloricIntakeData food, _) => food.name,
  //     yValueMapper: (_FoodCaloricIntakeData food, _) => food.calories,
  //     dataLabelSettings: const DataLabelSettings(
  //       isVisible: true,
  //     ),
  //   ),
  //
  //   ///fat
  //   LineSeries<_FoodCaloricIntakeData, dynamic>(
  //     dataSource: data,
  //     xValueMapper: (_FoodCaloricIntakeData food, _) => food.name,
  //     yValueMapper: (_FoodCaloricIntakeData food, _) => food.fat,
  //     dataLabelSettings: const DataLabelSettings(
  //       isVisible: true,
  //     ),
  //   ),
  //
  //   ///carbs
  //   LineSeries<_FoodCaloricIntakeData, dynamic>(
  //     dataSource: data,
  //     xValueMapper: (_FoodCaloricIntakeData food, _) => food.name,
  //     yValueMapper: (_FoodCaloricIntakeData food, _) => food.carbs,
  //     dataLabelSettings: const DataLabelSettings(
  //       isVisible: true,
  //     ),
  //   ),
  //
  //   ///protein
  //   LineSeries<_FoodCaloricIntakeData, dynamic>(
  //     dataSource: data,
  //     xValueMapper: (_FoodCaloricIntakeData food, _) => food.name,
  //     yValueMapper: (_FoodCaloricIntakeData food, _) => food.protein,
  //     dataLabelSettings: const DataLabelSettings(
  //       isVisible: true,
  //     ),
  //   ),
  //
  //   ///water
  //   LineSeries<_FoodCaloricIntakeData, dynamic>(
  //     dataSource: data,
  //     xValueMapper: (_FoodCaloricIntakeData food, _) => food.name,
  //     yValueMapper: (_FoodCaloricIntakeData food, _) => food.water,
  //     dataLabelSettings: const DataLabelSettings(
  //       isVisible: true,
  //     ),
  //   ),
  //
  //   ///sugar
  //   LineSeries<_FoodCaloricIntakeData, dynamic>(
  //     dataSource: data,
  //     xValueMapper: (_FoodCaloricIntakeData food, _) => food.name,
  //     yValueMapper: (_FoodCaloricIntakeData food, _) => food.sugar,
  //     dataLabelSettings: const DataLabelSettings(
  //       isVisible: true,
  //     ),
  //   )
  // ];
}

class _FoodCaloricIntakeData {
  _FoodCaloricIntakeData(
      {required this.name,
      required this.calories,
      required this.fat,
      required this.carbs,
      required this.protein,
      required this.water,
      required this.sugar});

  final String name;
  final double calories;
  final double fat;
  final double carbs;
  final double protein;
  final double water;
  final double sugar;
}
