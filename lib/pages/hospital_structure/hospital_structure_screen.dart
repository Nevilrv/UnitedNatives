import 'dart:developer';
import 'dart:io';
import 'package:date_format/date_format.dart';
import 'package:united_natives/utils/common_snackbar.dart';
import 'package:united_natives/data/pref_manager.dart';
import 'package:united_natives/newModel/apiModel/requestModel/add_maintenance_req_model.dart';
import 'package:united_natives/newModel/apiModel/requestModel/add_room_data_req_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/message_status_response_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/room_detail_response_model.dart';
import 'package:united_natives/newModel/apis/api_response.dart';
import 'package:united_natives/utils/utils.dart';
import 'package:united_natives/viewModel/room_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' as g;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class HospitalStructureScreen extends StatefulWidget {
  const HospitalStructureScreen({super.key});

  @override
  State<HospitalStructureScreen> createState() =>
      _HospitalStructureScreenState();
}

class _HospitalStructureScreenState extends State<HospitalStructureScreen>
    with TickerProviderStateMixin {
  RoomController roomController = Get.put(RoomController());
  TextEditingController nameController = TextEditingController();
  TextEditingController reasonController = TextEditingController();
  TextEditingController staffInChargeNameController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String? mySelectDate, selectedStartTime;
  File? imageW;
  String? _hour, _minute, _time;
  String? _setTime;
  String? roomId;
  int? status;
  String? time;

  String? exstingImage;
  File? imageURL;
  TimeOfDay selectedTime = const TimeOfDay(hour: 00, minute: 00);
  final ImagePicker _picker = ImagePicker();
  TabController? _tabController;
  final bool _isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);
  @override
  void initState() {
    getData();
    _tabController = TabController(length: 2, vsync: this);
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  Future getData() async {
    await roomController.getRoomDetail();
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > Get.width / 2) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: Material(
              child: GetBuilder<RoomController>(
                builder: (controller) {
                  if (controller.getRoomDetailApiResponse.status ==
                      Status.LOADING) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Center(
                        child: Utils.circular(),
                      ),
                    );
                  }
                  /* if (controller.getRoomDetailApiResponse.status ==
                    Status.ERROR) {
                  return Center(child: Text("Server error"));
                }*/
                  RoomDetailResponseModel responseModel =
                      controller.getRoomDetailApiResponse.data;
                  return SafeArea(
                    child: Stack(
                      children: [
                        SizedBox(
                          height: Get.height,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              Column(
                                children: [
                                  SizedBox(
                                    height: Get.height * 0.03,
                                  ),
                                  Center(
                                    child: Row(
                                      children: [
                                        Container(
                                          height: Get.height * 0.03,
                                          width: Get.width * 0.03,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.red,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        const Text("Under Maintenance"),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Container(
                                          height: Get.height * 0.03,
                                          width: Get.width * 0.03,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                            border:
                                                Border.all(color: Colors.black),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        const Text("Available"),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Container(
                                          height: Get.height * 0.03,
                                          width: Get.width * 0.03,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        const Text("Occupied"),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: Get.height * 0.03,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: Get.width,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Spacer(),
                                            Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    commonContainer(
                                                      no: '214',
                                                    ),
                                                    commonContainer(
                                                      no: '213',
                                                    ),
                                                    commonContainer(
                                                      no: '212',
                                                    ),
                                                    commonContainer(
                                                      no: '211',
                                                    ),
                                                    commonContainer(
                                                      no: '210',
                                                    ),
                                                    commonContainer(
                                                      no: '209',
                                                    ),
                                                    commonContainer(
                                                      no: '208',
                                                    ),
                                                    commonContainer(
                                                      no: '207',
                                                    ),
                                                    commonContainer(
                                                      no: '206',
                                                    )
                                                  ],
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            commonContainer(
                                                              no: '114',
                                                            ),
                                                            commonContainer(
                                                              no: '113',
                                                            ),
                                                          ],
                                                        ),
                                                        commonContainer4()
                                                      ],
                                                    ),
                                                    commonContainer(
                                                      no: '112',
                                                    ),
                                                    commonContainer(
                                                      no: '111',
                                                    ),
                                                    commonContainer(
                                                      no: '110',
                                                    ),
                                                    commonContainer(
                                                      no: '109',
                                                    ),
                                                    Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            commonContainer(
                                                              no: '108',
                                                            ),
                                                            commonContainer(
                                                              no: '107',
                                                            ),
                                                          ],
                                                        ),
                                                        commonContainer4()
                                                      ],
                                                    ),
                                                    commonContainer(
                                                      no: '106',
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              width: Get.width * 0.02,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    commonContainer(
                                                      no: '205',
                                                    ),
                                                    commonContainer(
                                                      no: '204',
                                                    ),
                                                    commonContainer(
                                                      no: '203',
                                                    ),
                                                    commonContainer(
                                                      no: '202',
                                                    ),
                                                    commonContainer(
                                                      no: '201',
                                                    )
                                                  ],
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    commonContainer(
                                                      no: '105',
                                                    ),
                                                    Column(
                                                      children: [
                                                        commonContainer(
                                                          no: '104',
                                                        ),
                                                        commonContainer4()
                                                      ],
                                                    ),
                                                    commonContainer(
                                                      no: '103',
                                                    ),
                                                    commonContainer(
                                                      no: '102',
                                                    ),
                                                    commonContainer(
                                                        no: '101',
                                                        status: responseModel
                                                            .data?[0].status)
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              width: Get.width * 0.02,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: Get.height * 0.02,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: Get.width * 0.02,
                                          ),
                                          commonContainer2(no: '125'),
                                          commonContainer(no: '124'),
                                          SizedBox(
                                            width: Get.width * 0.02,
                                          ),
                                          commonContainer(no: '122'),
                                          commonContainer(no: '121'),
                                          SizedBox(
                                            width: Get.width * 0.02,
                                          ),
                                          commonContainer(no: '119'),
                                          commonContainer(no: '118'),
                                          SizedBox(
                                            width: Get.width * 0.02,
                                          ),
                                          commonContainer(no: '116'),
                                          commonContainer(no: '115'),
                                        ],
                                      ),
                                      SizedBox(
                                        height: Get.height * 0.02,
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: Get.width * 0.02,
                                          ),
                                          Column(
                                            children: [
                                              commonContainer(no: '126'),
                                              commonContainer(no: '127'),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: Get.height * 0.02,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          SizedBox(
                                            width: Get.width * 0.02,
                                          ),
                                          commonContainer2(no: '128'),
                                          commonContainer(no: '129'),
                                          SizedBox(
                                            width: Get.width * 0.02,
                                          ),
                                          commonContainer(no: '131'),
                                          commonContainer(no: '132'),
                                          SizedBox(
                                            width: Get.width * 0.02,
                                          ),
                                          commonContainer(no: '134'),
                                          commonContainer(no: '135'),
                                          SizedBox(
                                            width: Get.width * 0.02,
                                          ),
                                          commonContainer(no: '137'),
                                          commonContainer(no: '138'),
                                          SizedBox(
                                            width: Get.width * 0.02,
                                          ),
                                          commonContainer(no: '140'),
                                          commonContainer(no: '141'),
                                          SizedBox(
                                            width: Get.width * 0.02,
                                          ),
                                          commonContainer(no: '143'),
                                          commonContainer(no: '144'),
                                          SizedBox(
                                            width: Get.width * 0.02,
                                          ),
                                          commonContainer(no: '146'),
                                          commonContainer(no: '147'),
                                          SizedBox(
                                            width: Get.width * 0.02,
                                          ),
                                          commonContainerBlank(),
                                          commonContainer(no: '148'),
                                          commonContainer(no: '149'),
                                          commonContainerBlank(),
                                          commonContainer(no: '150'),
                                          commonContainer(no: '151'),
                                          Stack(
                                            clipBehavior: Clip.none,
                                            children: [
                                              commonContainerBlank(),
                                              Positioned(
                                                top: Get.height * 0.04,
                                                right: 0,
                                                left: 0,
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      height: Get.height * 0.05,
                                                      width: Get.width * 0.002,
                                                      color: _isDark
                                                          ? Colors.grey
                                                          : Colors.black,
                                                    ),
                                                    Text(
                                                      'Guest\nLaundry',
                                                      style: TextStyle(
                                                        color: _isDark
                                                            ? Colors.white
                                                            : Colors.black,
                                                        fontSize:
                                                            Get.height * 0.025,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                          commonContainer3(no: 'Office'),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 10,
                          left: 10,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.blue,
                              child: Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: Center(
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                    size: Get.height * 0.05,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Future<File> _fileFromImageUrl({required String image}) async {
    final response = await http.get(Uri.parse(image));
    final documentDirectory = await getApplicationDocumentsDirectory();
    final file = File(p.join(
        documentDirectory.path, '${DateTime.now().millisecondsSinceEpoch}'));
    file.writeAsBytesSync(response.bodyBytes);
    // print("FILE    >>>>${file.path}");
    setState(() {
      imageURL = file;
    });
    // Uint8List uint8List = await compressFile(File(file.path));
    return file;
  }

  Widget commonContainer({required String no, status}) {
    ///101
    return GetBuilder<RoomController>(
      builder: (controller) {
        if (controller.getRoomDetailApiResponse.status == Status.LOADING) {}
        List<String> availableList = [];
        List<String> occupiedList = [];
        List<String> maintenanceList = [];

        RoomDetailResponseModel responseModel =
            controller.getRoomDetailApiResponse.data;
        responseModel.data?.forEach((element) {
          if (element.status == 1) {
            maintenanceList.add(element.name!);
          } else if (element.status == 2) {
            // availableIdList.add(element.id);
            availableList.add(element.name!);
          } else if (element.status == 3) {
            occupiedList.add(element.name!);
          }
        });
        return GestureDetector(
          onTap: () {
            responseModel.data?.forEach((element) {
              if (element.name == no) {
                roomId = element.id;
                status = element.status;
                nameController.text = element.patientName!;
                staffInChargeNameController.text = element.staffInChargeName!;
                mySelectDate = element.patientAdmissiondate;
                reasonController.text = element.patientReason!;
                time = element.patientAdmissiontime;
                selectedStartTime = time;
                exstingImage = element.patientProfilepicture;
                element.patientProfilepicture == null ||
                        element.patientProfilepicture == ''
                    ? const SizedBox()
                    : _fileFromImageUrl(image: element.patientProfilepicture!);
              }
            });
            maintenanceList.contains(no)
                ? commonDialogRemoveMaintenance(controller, roomId!)
                : availableList.contains(no)
                    ? commonDialog(controller, roomId!)
                    : commonDialogGetDetail(controller, roomId!);
            roomId = null;

            // no == null || no == '' ? SizedBox() : commonDialog(controller);
            // no == null || no == '' ? SizedBox() : commonDialog(controller);
          },
          child: Container(
            height: Get.height * 0.08,
            width: Get.height * 0.08,
            decoration: BoxDecoration(
              color: maintenanceList.contains(no)
                  ? Colors.red
                  : availableList.contains(no)
                      ? Colors.white
                      : Colors.blue,
              border: Border.all(color: Colors.black, width: 1.3),
            ),
            child: Center(
              child: Text(
                no,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: Get.width * 0.019,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget commonContainerBlank() {
    return Container(
      height: Get.height * 0.08,
      width: Get.height * 0.08,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 1.3),
      ),
    );
  }

  Widget commonContainer2({required String no}) {
    return GetBuilder<RoomController>(
      builder: (controller) {
        if (controller.getRoomDetailApiResponse.status == Status.LOADING) {}
        List<String> availableList = [];
        List<String> occupiedList = [];
        List<String> maintenanceList = [];

        RoomDetailResponseModel responseModel =
            controller.getRoomDetailApiResponse.data;
        responseModel.data?.forEach((element) {
          if (element.status == 1) {
            maintenanceList.add(element.name!);
          } else if (element.status == 2) {
            availableList.add(element.name!);
          } else if (element.status == 3) {
            occupiedList.add(element.name!);
          }
        });
        return GestureDetector(
          onTap: () {
            responseModel.data?.forEach((element) {
              if (element.name == no) {
                roomId = element.id;
                status = element.status;
                nameController.text = element.patientName!;
                staffInChargeNameController.text = element.staffInChargeName!;
                mySelectDate = element.patientAdmissiondate;
                time = element.patientAdmissiontime;
                selectedStartTime = time;
                reasonController.text = element.patientReason!;
                exstingImage = element.patientProfilepicture;
                element.patientProfilepicture == null ||
                        element.patientProfilepicture == ''
                    ? const SizedBox()
                    : _fileFromImageUrl(image: element.patientProfilepicture!);
              }
            });

            maintenanceList.contains(no)
                ? commonDialogRemoveMaintenance(controller, no)
                : availableList.contains(no)
                    ? commonDialog(controller, roomId!)
                    : commonDialogGetDetail(controller, roomId!);
            roomId = null;
            // no == null || no == '' ? SizedBox() : commonDialog(controller);
          },
          child: Container(
            height: Get.height * 0.11,
            width: Get.height * 0.08,
            decoration: BoxDecoration(
              color: maintenanceList.contains(no)
                  ? Colors.red
                  : availableList.contains(no)
                      ? Colors.white
                      : Colors.blue,
              border: Border.all(color: Colors.black, width: 1.3),
            ),
            child: Center(
              child: Text(
                no,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: Get.width * 0.019,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Container commonContainer3({required String no}) {
    return Container(
      height: Get.height * 0.11,
      width: Get.height * 0.11,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 1.3),
      ),
      child: Center(
        child: Text(
          no,
          style: TextStyle(
            fontSize: Get.height * 0.028,
            color: _isDark ? Colors.black : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget commonContainer4({String? no}) {
    return Column(
      children: List.generate(6, (index) {
        return Container(
          height: Get.height * 0.02,
          width: Get.height * 0.05,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.black,
              width: 1.3,
            ),
          ),
        );
      }),
    );
  }

  Future commonDialog(RoomController controller, String no) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter onChange) {
                return Container(
                  height: Get.height * 0.8,
                  width: Get.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.blue),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: Get.width,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: Get.height * 0.02,
                                right: Get.width * 0.02),
                            child: GestureDetector(
                                child: Icon(
                                  Icons.cancel_rounded,
                                  color: Colors.blue,
                                  size: Get.width * 0.03,
                                ),
                                onTap: () {
                                  imageW = null;
                                  nameController.clear();
                                  staffInChargeNameController.clear();
                                  mySelectDate = null;
                                  selectedStartTime = null;
                                  reasonController.clear();
                                  Navigator.pop(context);
                                }),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: Get.height * 0.07,
                        child: TabBar(
                          controller: _tabController,
                          labelColor:
                              _isDark ? Colors.white : Colors.blue.shade900,
                          labelStyle: TextStyle(
                            fontSize: Get.height * 0.08,
                          ),
                          tabs: const <Widget>[
                            Tab(
                              text: 'Add Client',
                            ),
                            Tab(
                              text: 'Maintenance',
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: <Widget>[
                            Stack(
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          Get.dialog(
                                            Center(
                                              child: Container(
                                                height: Get.height * 0.4,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    border: Border.all(
                                                        color:
                                                            Colors.blueAccent,
                                                        width: 3)),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 20,
                                                      vertical: 20),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      MaterialButton(
                                                          color:
                                                              Colors.blueAccent,
                                                          onPressed: () async {
                                                            final pickedFile =
                                                                await _picker.pickImage(
                                                                    source: ImageSource
                                                                        .camera);

                                                            onChange(() {
                                                              if (pickedFile !=
                                                                  null) {
                                                                imageW = File(
                                                                    pickedFile
                                                                        .path);
                                                              } else {}
                                                            });
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: const Text(
                                                            "Camera",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          )),
                                                      MaterialButton(
                                                          color:
                                                              Colors.blueAccent,
                                                          onPressed: () async {
                                                            final pickedFile =
                                                                await _picker.pickImage(
                                                                    source: ImageSource
                                                                        .gallery);

                                                            onChange(() {
                                                              if (pickedFile !=
                                                                  null) {
                                                                imageW = File(
                                                                    pickedFile
                                                                        .path);
                                                              } else {}
                                                            });

                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: const Text(
                                                            "Gallery",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ))
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            barrierDismissible: true,
                                          );
                                        },
                                        child: Container(
                                          height: Get.height,
                                          width: Get.width * 0.25,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.withOpacity(0.3),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            border: Border.all(
                                              color: Colors.black,
                                            ),
                                          ),
                                          child: imageW == null
                                              ? const Center(
                                                  child: CircleAvatar(
                                                    radius: 30,
                                                    backgroundColor:
                                                        Colors.black,
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: Icon(
                                                        Icons.add,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  child: Image.file(
                                                    imageW!,
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Client Name :',
                                                style: TextStyle(
                                                  fontSize: Get.width * 0.04,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              SizedBox(
                                                height: Get.height * 0.03,
                                              ),
                                              TextField(
                                                controller: nameController,
                                                decoration: InputDecoration(
                                                  hintText: 'Enter Client name',
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          vertical: 0,
                                                          horizontal: 10),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    borderSide:
                                                        const BorderSide(
                                                            color:
                                                                Colors.black),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    borderSide:
                                                        const BorderSide(
                                                            color:
                                                                Colors.black),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: Get.height * 0.03,
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    'Admission date : ',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          Get.width * 0.04,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: InkWell(
                                                      onTap: () async {
                                                        final DateTime picked =
                                                            await showDatePicker(
                                                          context: context,
                                                          initialDate:
                                                              DateTime.now(),
                                                          firstDate:
                                                              DateTime.now(),
                                                          lastDate:
                                                              DateTime(2500),
                                                        ).then((value) {
                                                          if (value != null &&
                                                              value !=
                                                                  selectedDate) {
                                                            onChange(() {
                                                              selectedDate =
                                                                  value;
                                                              mySelectDate =
                                                                  "${value.toLocal()}"
                                                                      .split(
                                                                          ' ')[0];
                                                            });
                                                          }

                                                          return selectedDate;
                                                        });

                                                        log('picked==========>>>>>$picked');
                                                      },
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                                color: _isDark
                                                                    ? Colors
                                                                        .transparent
                                                                    : Colors
                                                                        .white,
                                                                border:
                                                                    Border.all(
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10)),
                                                        child: mySelectDate !=
                                                                    null &&
                                                                mySelectDate !=
                                                                    ""
                                                            ? Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        8.0),
                                                                child: Center(
                                                                  child: Text(
                                                                    "${selectedDate.toLocal()}"
                                                                        .split(
                                                                            ' ')[0],
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          Get.width *
                                                                              0.04,
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            : Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        8.0),
                                                                child: Center(
                                                                  child: Text(
                                                                    "Choose date",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          Get.width *
                                                                              0.05,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height: Get.height * 0.02,
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    'Admission Time : ',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          Get.width * 0.05,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: InkWell(
                                                      onTap: () async {
                                                        final TimeOfDay?
                                                            picked =
                                                            await showTimePicker(
                                                          context: context,
                                                          initialTime:
                                                              selectedTime,
                                                        );
                                                        if (picked != null) {
                                                          onChange(() {
                                                            selectedTime =
                                                                picked;
                                                            _hour = selectedTime
                                                                .hour
                                                                .toString();
                                                            _minute =
                                                                selectedTime
                                                                    .minute
                                                                    .toString();
                                                            _time =
                                                                '$_hour : $_minute';
                                                            _setTime = _time;
                                                            _setTime = formatDate(
                                                                DateTime(
                                                                    2019,
                                                                    08,
                                                                    1,
                                                                    selectedTime
                                                                        .hour,
                                                                    selectedTime
                                                                        .minute),
                                                                [
                                                                  hh,
                                                                  ':',
                                                                  nn,
                                                                  ":",
                                                                  ss
                                                                ]).toString();
                                                            selectedStartTime =
                                                                _setTime;
                                                          });
                                                        }
                                                      },
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: _isDark
                                                              ? Colors
                                                                  .transparent
                                                              : Colors.white,
                                                          border: Border.all(
                                                            color: Colors.black,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        child:
                                                            selectedStartTime !=
                                                                    null
                                                                ? Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        "$selectedStartTime",
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              Get.width * 0.05,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                                : Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        "Choose time",
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              Get.width * 0.05,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height: Get.height * 0.02,
                                              ),
                                              Text(
                                                'Client Reason :',
                                                style: TextStyle(
                                                  fontSize: Get.width * 0.05,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              SizedBox(
                                                height: Get.height * 0.03,
                                              ),
                                              TextField(
                                                controller: reasonController,
                                                decoration: InputDecoration(
                                                  hintText:
                                                      'Enter Client reason',
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          vertical: 0,
                                                          horizontal: 10),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    borderSide:
                                                        const BorderSide(
                                                            color:
                                                                Colors.black),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    borderSide:
                                                        const BorderSide(
                                                            color:
                                                                Colors.black),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: Get.height * 0.02,
                                              ),
                                              Text(
                                                'Staff Incharge Name:',
                                                style: TextStyle(
                                                  fontSize: Get.width * 0.05,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              SizedBox(
                                                height: Get.height * 0.03,
                                              ),
                                              TextField(
                                                controller:
                                                    staffInChargeNameController,
                                                decoration: InputDecoration(
                                                  hintText:
                                                      'Enter staff incharge name',
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          vertical: 0,
                                                          horizontal: 10),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    borderSide:
                                                        const BorderSide(
                                                            color:
                                                                Colors.black),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    borderSide:
                                                        const BorderSide(
                                                            color:
                                                                Colors.black),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: Get.height * 0.03,
                                              ),
                                              Center(
                                                child: ElevatedButton(
                                                  onPressed: () async {
                                                    if (nameController
                                                        .text.isEmpty) {
                                                      CommonSnackBar.snackBar(
                                                          message:
                                                              "Please enter Client name");
                                                      return;
                                                    }
                                                    if (imageW == null ||
                                                        imageW?.path == '') {
                                                      CommonSnackBar.snackBar(
                                                          message:
                                                              "Please select image");
                                                      return;
                                                    }
                                                    if (mySelectDate == null ||
                                                        mySelectDate == '') {
                                                      CommonSnackBar.snackBar(
                                                          message:
                                                              "Please select date");
                                                      return;
                                                    }
                                                    if (selectedStartTime ==
                                                            null ||
                                                        selectedStartTime ==
                                                            '') {
                                                      CommonSnackBar.snackBar(
                                                          message:
                                                              "Please select time");
                                                      return;
                                                    }
                                                    if (reasonController
                                                        .text.isEmpty) {
                                                      CommonSnackBar.snackBar(
                                                          message:
                                                              "Please enter Client reason");
                                                      return;
                                                    }

                                                    AddRoomDetailsReqModel
                                                        model =
                                                        AddRoomDetailsReqModel();
                                                    model.staffInChargeName =
                                                        staffInChargeNameController
                                                            .text;
                                                    model.name =
                                                        nameController.text;
                                                    model.reason =
                                                        reasonController.text;
                                                    model.date = mySelectDate;
                                                    model.time =
                                                        selectedStartTime;
                                                    model.image = imageW?.path;
                                                    await roomController
                                                        .addRoomDetail(
                                                            model: model,
                                                            id: no);
                                                    if (roomController
                                                            .addRoomDetailApiResponse
                                                            .status ==
                                                        Status.COMPLETE) {
                                                      MessageStatusResponseModel
                                                          response =
                                                          roomController
                                                              .addRoomDetailApiResponse
                                                              .data;
                                                      if (response.status ==
                                                          'Success') {
                                                        CommonSnackBar.snackBar(
                                                            message: response
                                                                .message!);
                                                        Future.delayed(
                                                            const Duration(
                                                                seconds: 2),
                                                            () {
                                                          getData();
                                                          Navigator.pop(
                                                              context);
                                                          imageW = null;
                                                          staffInChargeNameController
                                                              .clear();
                                                          nameController
                                                              .clear();
                                                          mySelectDate = null;
                                                          selectedStartTime =
                                                              null;
                                                          reasonController
                                                              .clear();
                                                        });
                                                      } else {
                                                        CommonSnackBar.snackBar(
                                                            message: response
                                                                .message!);
                                                      }
                                                    } else {
                                                      CommonSnackBar.snackBar(
                                                          message:
                                                              "Server error");
                                                    }

                                                    roomId = null;
                                                    // model.name=?
                                                  },
                                                  child: const Text("Submit"),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                GetBuilder<RoomController>(
                                  builder: (controller) {
                                    if (controller
                                            .addRoomDetailApiResponse.status ==
                                        Status.LOADING) {
                                      return Center(
                                        child: Utils.circular(),
                                      );
                                    }
                                    return const SizedBox();
                                  },
                                )
                              ],
                            ),
                            GetBuilder<RoomController>(
                              builder: (controller) {
                                if (controller
                                        .addMaintenanceApiResponse.status ==
                                    Status.LOADING) {
                                  return Center(
                                    child: Utils.circular(),
                                  );
                                }
                                return Center(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      AddMaintenanceModel model =
                                          AddMaintenanceModel();
                                      model.state = 'true';
                                      await roomController.addMaintenanceRoom(
                                          model: model, id: no);
                                      if (roomController
                                              .addMaintenanceApiResponse
                                              .status ==
                                          Status.COMPLETE) {
                                        MessageStatusResponseModel response =
                                            roomController
                                                .addMaintenanceApiResponse.data;
                                        if (response.status == 'Success') {
                                          CommonSnackBar.snackBar(
                                              message: response.message!);
                                          Future.delayed(
                                              const Duration(seconds: 2), () {
                                            getData();
                                            Navigator.pop(context);
                                          });
                                        } else {
                                          CommonSnackBar.snackBar(
                                              message: response.message!);
                                        }
                                      } else {
                                        CommonSnackBar.snackBar(
                                            message: "Server error");
                                      }
                                    },
                                    child: const Text('Add Maintenance'),
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future commonDialogGetDetail(RoomController controller, String no) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter onChange) {
                return Container(
                  height: Get.height * 0.8,
                  width: Get.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.blue),
                  ),
                  child: Stack(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                Get.dialog(
                                    Center(
                                      child: Container(
                                        height: Get.height * 0.4,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                            color: Colors.blueAccent,
                                            width: 3,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 20),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              MaterialButton(
                                                  color: Colors.blueAccent,
                                                  onPressed: () async {
                                                    final pickedFile =
                                                        await _picker.pickImage(
                                                            source: ImageSource
                                                                .camera);

                                                    onChange(() {
                                                      if (pickedFile != null) {
                                                        imageW = File(
                                                            pickedFile.path);
                                                      } else {}
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text(
                                                    "Camera",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  )),
                                              MaterialButton(
                                                color: Colors.blueAccent,
                                                onPressed: () async {
                                                  final pickedFile =
                                                      await _picker.pickImage(
                                                          source: ImageSource
                                                              .gallery);

                                                  onChange(() {
                                                    if (pickedFile != null) {
                                                      imageW =
                                                          File(pickedFile.path);
                                                    } else {}
                                                  });

                                                  Navigator.pop(context);
                                                },
                                                child: const Text(
                                                  "Gallery",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    barrierDismissible: true);
                              },
                              child: Container(
                                height: Get.height,
                                width: Get.width * 0.25,
                                decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: Colors.black,
                                    )),
                                child: imageW == null
                                    ? exstingImage == null || exstingImage == ''
                                        ? const Center(
                                            child: CircleAvatar(
                                              radius: 30,
                                              backgroundColor: Colors.black,
                                              child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Icon(
                                                  Icons.add,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          )
                                        : ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            child: Image.network(
                                              exstingImage!,
                                              fit: BoxFit.fill,
                                            ),
                                          )
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image.file(
                                          imageW!,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          'Room Detail',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Spacer(),
                                        IconButton(
                                            icon: Icon(
                                              Icons.cancel_rounded,
                                              color: Colors.blue,
                                              size: Get.width * 0.03,
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                              imageW = null;
                                              staffInChargeNameController
                                                  .clear();
                                              nameController.clear();
                                              mySelectDate = null;
                                              selectedStartTime = null;
                                              reasonController.clear();
                                            }),
                                      ],
                                    ),
                                    Text(
                                      'Client Name :',
                                      style: TextStyle(
                                          fontSize: Get.width * 0.05,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    SizedBox(
                                      height: Get.height * 0.03,
                                    ),
                                    TextField(
                                      controller: nameController,
                                      decoration: InputDecoration(
                                        hintText: 'Enter Client name',
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 0, horizontal: 10),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              color: Colors.black),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: Get.height * 0.03,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Admission date : ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: Get.width * 0.05,
                                          ),
                                        ),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () async {
                                              final DateTime picked =
                                                  await showDatePicker(
                                                          context: context,
                                                          initialDate:
                                                              DateTime.now(),
                                                          firstDate:
                                                              DateTime.now(),
                                                          lastDate:
                                                              DateTime(2500))
                                                      .then((value) {
                                                if (value != null &&
                                                    value != selectedDate) {
                                                  onChange(() {
                                                    selectedDate = value;
                                                    mySelectDate =
                                                        "${value.toLocal()}"
                                                            .split(' ')[0];
                                                  });
                                                }

                                                return selectedDate;
                                              });
                                              log('picked==========>>>>>$picked');
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: _isDark
                                                      ? Colors.transparent
                                                      : Colors.white,
                                                  border: Border.all(
                                                    color: Colors.black,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: mySelectDate != null &&
                                                      mySelectDate != ""
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Center(
                                                        child: Text(
                                                          "${selectedDate.toLocal()}"
                                                              .split(' ')[0],
                                                          style: TextStyle(
                                                            fontSize:
                                                                Get.width *
                                                                    0.05,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Center(
                                                        child: Text(
                                                          "Choose date",
                                                          style: TextStyle(
                                                            fontSize:
                                                                Get.width *
                                                                    0.05,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: Get.height * 0.02,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Admission Time : ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: Get.width * 0.05,
                                          ),
                                        ),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () async {
                                              final TimeOfDay? picked =
                                                  await showTimePicker(
                                                context: context,
                                                initialTime: selectedTime,
                                              );
                                              if (picked != null) {
                                                onChange(() {
                                                  selectedTime = picked;
                                                  _hour = selectedTime.hour
                                                      .toString();
                                                  _minute = selectedTime.minute
                                                      .toString();
                                                  _time = '$_hour : $_minute';
                                                  _setTime = _time;
                                                  _setTime = formatDate(
                                                      DateTime(
                                                          2019,
                                                          08,
                                                          1,
                                                          selectedTime.hour,
                                                          selectedTime.minute),
                                                      [
                                                        hh,
                                                        ':',
                                                        nn,
                                                        ":",
                                                        ss
                                                      ]).toString();
                                                  selectedStartTime = _setTime;
                                                });
                                              }
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: _isDark
                                                    ? Colors.transparent
                                                    : Colors.white,
                                                border: Border.all(
                                                  color: Colors.black,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: selectedStartTime != null
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Center(
                                                        child: Text(
                                                          "$selectedStartTime",
                                                          style: TextStyle(
                                                            fontSize:
                                                                Get.width *
                                                                    0.05,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Center(
                                                        child: Text(
                                                          "Choose time",
                                                          style: TextStyle(
                                                            fontSize:
                                                                Get.width *
                                                                    0.05,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: Get.height * 0.02,
                                    ),
                                    Text(
                                      'Client Reason :',
                                      style: TextStyle(
                                        fontSize: Get.width * 0.05,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(
                                      height: Get.height * 0.03,
                                    ),
                                    TextField(
                                      controller: reasonController,
                                      decoration: InputDecoration(
                                        hintText: 'Enter Client reason',
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 0, horizontal: 10),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              color: Colors.black),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: Get.height * 0.02,
                                    ),
                                    Text(
                                      'Staff In Charge :',
                                      style: TextStyle(
                                        fontSize: Get.width * 0.05,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(
                                      height: Get.height * 0.03,
                                    ),
                                    TextField(
                                      controller: staffInChargeNameController,
                                      decoration: InputDecoration(
                                        hintText: 'Enter staff in charge',
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 0, horizontal: 10),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                                color: Colors.black)),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: Get.height * 0.03,
                                    ),
                                    Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.blue),
                                            onPressed: () async {
                                              if (nameController.text.isEmpty) {
                                                CommonSnackBar.snackBar(
                                                    message:
                                                        "Please enter Client name");
                                                return;
                                              }

                                              if (mySelectDate == null ||
                                                  mySelectDate == '') {
                                                CommonSnackBar.snackBar(
                                                    message:
                                                        "Please select date");
                                                return;
                                              }
                                              if (selectedStartTime == null ||
                                                  selectedStartTime == '') {
                                                CommonSnackBar.snackBar(
                                                    message:
                                                        "Please select time");
                                                return;
                                              }
                                              if (reasonController
                                                  .text.isEmpty) {
                                                CommonSnackBar.snackBar(
                                                    message:
                                                        "Please enter Client reason");
                                                return;
                                              }

                                              UpdateRoomDetailsReqModel model =
                                                  UpdateRoomDetailsReqModel();
                                              model.action = 'update';
                                              model.staffInChargeName =
                                                  staffInChargeNameController
                                                      .text;
                                              model.name = nameController.text;
                                              model.reason =
                                                  reasonController.text;
                                              model.date = mySelectDate;
                                              model.time = selectedStartTime;
                                              model.image = imageW == null ||
                                                      imageW?.path == ''
                                                  ? ''
                                                  : imageW?.path;

                                              UpdateRoomWithoutImgReqModel
                                                  reqModel =
                                                  UpdateRoomWithoutImgReqModel();
                                              reqModel.action = 'update';
                                              reqModel.staffInChargeName =
                                                  staffInChargeNameController
                                                      .text;
                                              reqModel.name =
                                                  nameController.text;
                                              reqModel.reason =
                                                  reasonController.text;
                                              reqModel.date = mySelectDate;
                                              reqModel.time = selectedStartTime;
                                              imageW == null ||
                                                      imageW?.path == ''
                                                  ? await roomController
                                                      .updateRoomDetailWithoutImg(
                                                          id: no,
                                                          model: reqModel)
                                                  : await roomController
                                                      .updateRoomDetail(
                                                          model: model, id: no);
                                              if (roomController
                                                      .updateRoomDetailApiResponse
                                                      .status ==
                                                  Status.COMPLETE) {
                                                MessageStatusResponseModel
                                                    response = roomController
                                                        .updateRoomDetailApiResponse
                                                        .data;
                                                if (response.status ==
                                                    'Success') {
                                                  CommonSnackBar.snackBar(
                                                      message:
                                                          response.message!);
                                                  Future.delayed(
                                                      const Duration(
                                                          seconds: 2), () {
                                                    getData();
                                                    Navigator.pop(context);
                                                    imageW = null;
                                                    staffInChargeNameController
                                                        .clear();
                                                    nameController.clear();
                                                    mySelectDate = null;
                                                    selectedStartTime = null;
                                                    reasonController.clear();
                                                  });
                                                } else {
                                                  CommonSnackBar.snackBar(
                                                      message:
                                                          response.message!);
                                                }
                                              } else {
                                                CommonSnackBar.snackBar(
                                                    message: "Server error");
                                              }
                                            },
                                            child: const Text("Update"),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red),
                                            onPressed: () async {
                                              await roomController
                                                  .deletRoomDetail(id: no);
                                              if (roomController
                                                      .deleteRoomApiResponse
                                                      .status ==
                                                  Status.COMPLETE) {
                                                MessageStatusResponseModel
                                                    response = roomController
                                                        .deleteRoomApiResponse
                                                        .data;
                                                if (response.status ==
                                                    'Success') {
                                                  CommonSnackBar.snackBar(
                                                      message:
                                                          response.message!);
                                                  Future.delayed(
                                                      const Duration(
                                                          seconds: 2), () {
                                                    getData();
                                                    Navigator.pop(context);
                                                    imageW = null;
                                                    staffInChargeNameController
                                                        .clear();
                                                    nameController.clear();
                                                    mySelectDate = null;
                                                    selectedStartTime = null;
                                                    reasonController.clear();
                                                  });
                                                } else {
                                                  CommonSnackBar.snackBar(
                                                      message:
                                                          response.message!);
                                                }
                                              } else {
                                                CommonSnackBar.snackBar(
                                                    message: "Server error");
                                              }
                                            },
                                            child: const Text("Discharge"),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      GetBuilder<RoomController>(
                        builder: (controller) {
                          if (controller.deleteRoomApiResponse.status ==
                                  Status.LOADING ||
                              controller.updateRoomDetailApiResponse.status ==
                                  Status.LOADING) {
                            // return Center(child: CircularProgressIndicator());
                            return Center(
                              child: Utils.circular(),
                            );
                          }
                          return const SizedBox();
                        },
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future commonDialogRemoveMaintenance(
      RoomController controller, String no) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Center(
          child: Container(
            height: Get.width * 0.25,
            width: Get.height * 0.7,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.blueAccent, width: 3)),
            child: Material(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Icon(
                              Icons.cancel_rounded,
                              color: Colors.blue,
                              size: Get.height * 0.06,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: Get.height * 0.03,
                      ),
                      Text(
                        "Remove Maintenance",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: Get.height * 0.08,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: Get.height * 0.03,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          MaterialButton(
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  color: Colors.blueAccent, width: 2),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            color: Colors.white,
                            onPressed: () async {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "No",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          MaterialButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            color: Colors.blueAccent,
                            onPressed: () async {
                              AddMaintenanceModel model = AddMaintenanceModel();
                              model.state = 'false';
                              await roomController.addMaintenanceRoom(
                                  model: model, id: no);
                              if (roomController
                                      .addMaintenanceApiResponse.status ==
                                  Status.COMPLETE) {
                                MessageStatusResponseModel response =
                                    roomController
                                        .addMaintenanceApiResponse.data;
                                if (response.status == 'Success') {
                                  CommonSnackBar.snackBar(
                                      message: response.message!);
                                  Future.delayed(const Duration(seconds: 2),
                                      () {
                                    getData();
                                    Navigator.pop(context);
                                  });
                                } else {
                                  CommonSnackBar.snackBar(
                                      message: response.message!);
                                }
                              } else {
                                CommonSnackBar.snackBar(
                                    message: "Server error");
                              }
                            },
                            child: const Text(
                              "Yes",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  GetBuilder<RoomController>(
                    builder: (controller) {
                      if (controller.addMaintenanceApiResponse.status ==
                          Status.LOADING) {
                        return Center(
                          child: Utils.circular(),
                        );
                        // return Center(child: CircularProgressIndicator());
                      }
                      return const SizedBox();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
