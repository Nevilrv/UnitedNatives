import 'dart:developer';
import 'package:united_natives/viewModel/doctor_homescreen_controller.dart';
import 'package:united_natives/viewModel/user_controller.dart';
import 'package:united_natives/utils/pref_manager.dart';
import 'package:united_natives/ResponseModel/doctor_availability_display_model.dart';
import 'package:united_natives/pages/Availability_page/checkbox_group.dart';
import 'package:united_natives/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateAvailability extends StatefulWidget {
  const UpdateAvailability({super.key});

  @override
  State<UpdateAvailability> createState() => _UpdateAvailabilityState();
}

class _UpdateAvailabilityState extends State<UpdateAvailability> {
  final DoctorHomeScreenController _doctorHomeScreenController =
      Get.find<DoctorHomeScreenController>();
  final UserController _userController = Get.find<UserController>();
  // DateTime dateTime;
  // Duration duration;
  DateTime currentDate = DateTime.now();
  int? index;
  List<String>? checked;
  List<String> selectedItemIndex = [];
  List<String> selectedItem = [];
  List<String> finalDataItem = [];
  List<String> disabledTimeSlot = [];
  final RxBool _isSelectedNotifier = true.obs;
  bool isLoading = false;
  bool selectAll = false;
  bool filterLoading = false;
  List<String> timeSlot = <String>[
    "8:00 - 9:00 AM",
    "9:00 - 10:00 AM",
    "10:00 - 11:00 AM",
    "11:00 - 12:00 PM",
    "12:00 - 1:00 PM",
    "1:00 - 2:00 PM",
    "2:00 - 3:00 PM",
    "3:00 - 4:00 PM",
    "4:00 - 5:00 PM",
    "5:00 - 6:00 PM",
    "6:00 - 7:00 PM",
    "7:00 - 8:00 PM",
    "8:00 - 9:00 PM",
  ];
  var isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      selectedItem.clear();
      finalDataItem.clear();
      getData();
      disabledSlots();
      // dateTime = DateTime.now();
      // duration = Duration(minutes: 10);
    });

    super.initState();
  }

  disabledSlots() {
    disabledTimeSlot = [];
    if (DateFormat("dd-MM-yyyy").format(currentDate) ==
        DateFormat("dd-MM-yyyy").format(DateTime.now())) {
      for (var element in timeSlot) {
        final hour =
            (int.parse("${element.split(" -").first} ${element.split(" -").first == "11:00" ? "AM" : element.split("- ").last.split(" ").last}"
                            .toString()
                            .split(":")
                            .first) <
                        12 &&
                    element.split("- ").last.split(" ").last == "PM" &&
                    element.split(" -").first != "11:00")
                ? int.parse(element.split(" -").first.split(":").first) + 12
                : int.parse(element.split(" -").first.split(":").first);

        final checkTime =
            "$hour:${element.split(" -").first.split(":").last} ${element.split(" -").first == "11:00" ? "AM" : element.split("- ").last.split(" ").last}";

        DateTime parsedGivenTime = DateFormat.Hm().parse(checkTime);

        DateTime combinedGivenTime = DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
            parsedGivenTime.hour,
            parsedGivenTime.minute);

        if (combinedGivenTime.isBefore(DateTime.now())) {
          disabledTimeSlot.add(element);
        }
      }
    }
  }

  getData() async {
    await filterData(currentDate);
  }

  Future<void> _selectDate(BuildContext context) async {
    selectAll = false;
    selectedItem.clear();
    finalDataItem.clear();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (pickedDate != null && pickedDate != currentDate) {
      filterData(pickedDate);
      setState(() {
        currentDate = pickedDate;
        log('currentDate==========>>>>>$currentDate');
      });
    }
  }

  Future<void> filterData(DateTime pickedDate) async {
    timeSlot = <String>[
      "8:00 - 9:00 AM",
      "9:00 - 10:00 AM",
      "10:00 - 11:00 AM",
      "11:00 - 12:00 PM",
      "12:00 - 1:00 PM",
      "1:00 - 2:00 PM",
      "2:00 - 3:00 PM",
      "3:00 - 4:00 PM",
      "4:00 - 5:00 PM",
      "5:00 - 6:00 PM",
      "6:00 - 7:00 PM",
      "7:00 - 8:00 PM",
      "8:00 - 9:00 PM",
    ];
    filterLoading = true;
    setState(() {});
    DateTime date11 = pickedDate.toUtc();
    log('date11==========>>>>>$date11');
    await _doctorHomeScreenController.getDoctorAvailabilityDisplay(
        _userController.user.value.id!,
        DateFormat("yyyy-MM-dd").format(pickedDate));
    PostedDateAvailabilityClass? iterable = _doctorHomeScreenController
        .doctorAvailabilityForDisplayOnlyModelData
        .value
        .data
        ?.postedDateAvailability;

    DateTime? date = iterable?.availDate;

    if (date == null) {
      filterLoading = false;
      setState(() {});
      return;
    }

    PostedDateAvailabilityClass? availability = iterable;

    availability?.availData?.forEach(
      (element) {
        String startTime =
            "${element.startTime!.toLocal().hour > 12 ? element.startTime!.toLocal().hour - 12 : element.startTime!.toLocal().hour}:${element.startTime!.toLocal().minute == 0 ? "00" : element.startTime!.toLocal().minute}";
        String endTime =
            "${element.endTime!.toLocal().hour > 12 ? element.endTime!.toLocal().hour - 12 : element.endTime!.toLocal().hour}:${element.endTime!.toLocal().minute == 0 ? "00" : element.endTime!.toLocal().minute} ${element.endTime!.toLocal().hour >= 12 ? "PM" : "AM"}";
        if (element.avail == "1") {
          if (startTime == "8:00" && endTime == "9:00 AM") {
            selectedItem.add("8:00 - 9:00 AM");
          }
          if (startTime == "9:00" && endTime == "10:00 AM") {
            selectedItem.add("9:00 - 10:00 AM");
          }
          if (startTime == "10:00" && endTime == "11:00 AM") {
            selectedItem.add("10:00 - 11:00 AM");
          }
          if (startTime == "11:00" && endTime == "12:00 PM") {
            selectedItem.add("11:00 - 12:00 PM");
          }
          if (startTime == "12:00" && endTime == "1:00 PM") {
            selectedItem.add("12:00 - 1:00 PM");
          }
          if (startTime == "1:00" && endTime == "2:00 PM") {
            selectedItem.add("1:00 - 2:00 PM");
          }
          if (startTime == "2:00" && endTime == "3:00 PM") {
            selectedItem.add("2:00 - 3:00 PM");
          }
          if (startTime == "3:00" && endTime == "4:00 PM") {
            selectedItem.add("3:00 - 4:00 PM");
          }
          if (startTime == "4:00" && endTime == "5:00 PM") {
            selectedItem.add("4:00 - 5:00 PM");
          }
          if (startTime == "5:00" && endTime == "6:00 PM") {
            selectedItem.add("5:00 - 6:00 PM");
          }
          if (startTime == "6:00" && endTime == "7:00 PM") {
            selectedItem.add("6:00 - 7:00 PM");
          }
          if (startTime == "7:00" && endTime == "8:00 PM") {
            selectedItem.add("7:00 - 8:00 PM");
          }
          if (startTime == "8:00" && endTime == "9:00 PM") {
            selectedItem.add("8:00 - 9:00 PM");
          }
        }
      },
    );

    finalDataItem = selectedItem;

    log('selectedItem.length - disabledTimeSlot.length==========>>>>>${selectedItem.length - disabledTimeSlot.length}');
    log('26 - disabledTimeSlot.length==========>>>>>${26 - disabledTimeSlot.length}');
    if ((selectedItem.length) == (13 - disabledTimeSlot.length) ||
        selectedItem.length == 13) {
      selectAll = true;
    }

    // if (DateFormat("yyyy/MM/dd").format(currentDate) ==
    //     DateFormat("yyyy/MM/dd").format(date)) {
    //   if (availability?.avail8 == "1") {
    //     print('avail8:${availability?.avail8}');
    //     selectedItem.add("8 - 9 AM");
    //     print('selectedItem:$selectedItem');
    //   }
    //   if (availability?.avail9 == "1") {
    //     print('avail9:${availability?.avail9}');
    //     selectedItem.add("9 - 10 AM");
    //     print('selectedItem:$selectedItem');
    //   }
    //   if (availability?.avail10 == "1") {
    //     selectedItem.add("10 - 11 AM");
    //     print('selectedItem:$selectedItem');
    //   }
    //   if (availability?.avail11 == "1") {
    //     selectedItem.add("11 - 12 AM");
    //     print('selectedItem:$selectedItem');
    //   }
    //   if (availability?.avail12 == "1") {
    //     selectedItem.add("12 - 1 PM");
    //     print('selectedItem:$selectedItem');
    //   }
    //   if (availability?.avail13 == "1") {
    //     selectedItem.add("1 - 2 PM");
    //     print('selectedItem:$selectedItem');
    //   }
    //   if (availability?.avail14 == "1") {
    //     selectedItem.add("2 - 3 PM");
    //     print('selectedItem:$selectedItem');
    //   }
    //   if (availability?.avail15 == "1") {
    //     selectedItem.add("3 - 4 PM");
    //     print('selectedItem:$selectedItem');
    //   }
    //   if (availability?.avail16 == "1") {
    //     selectedItem.add("4 - 5 PM");
    //     print('selectedItem:$selectedItem');
    //   }
    //   if (availability?.avail17 == "1") {
    //     selectedItem.add("5 - 6 PM");
    //     print('selectedItem:$selectedItem');
    //   }
    //   if (availability?.avail18 == "1") {
    //     selectedItem.add("6 - 7 PM");
    //     print('selectedItem:$selectedItem');
    //   }
    //   if (availability?.avail19 == "1") {
    //     selectedItem.add("7 - 8 PM");
    //     print('selectedItem:$selectedItem');
    //   }
    //   if (availability?.avail20 == "1") {
    //     selectedItem.add("8 - 9 PM");
    //     print('selectedItem:$selectedItem');
    //   }
    //   if (availability?.avail21 == "1") {
    //     selectedItem.add("9 - 10 PM");
    //     print('selectedItem:$selectedItem');
    //   }
    //   log('selectedItem.length---------->>>>>>>>${selectedItem.length}');
    //   if (selectedItem.length == 14) {
    //     selectAll = true;
    //   }
    // }
    filterLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    disabledSlots();
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: _body(),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(32.0),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
                color: Colors.blue,
              ),
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 1,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ) /*
                        Center(
                            child: Utils.circular(),
                          )*/
                  : ElevatedButton(
                      style: ButtonStyle(
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        elevation: WidgetStateProperty.all(0),
                        backgroundColor: WidgetStateProperty.all<Color>(
                          Colors.white,
                        ),
                        foregroundColor: WidgetStateProperty.all<Color>(
                          Colors.blue,
                        ),
                      ),
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });

                        List<Map<String, dynamic>> availData = [];

                        for (var element in timeSlot) {
                          String startTimeString =
                              "${element.split(" -").first} ${element.split(" -").first == "11:00" ? "AM" : element.split("- ").last.split(" ").last.replaceAll(" ", "")}";
                          var statTemp = startTimeString.split(":");
                          int startHour =
                              statTemp.last.split(" ").last == "AM" ||
                                      int.parse(statTemp.first) == 12 ||
                                      startTimeString == "11:00 AM"
                                  ? int.parse(statTemp.first)
                                  : int.parse(statTemp.first) + 12;
                          int startMinute =
                              int.parse(statTemp.last.split(" ").first);
                          DateTime startDateTime = DateTime(
                              currentDate.toLocal().year,
                              currentDate.toLocal().month,
                              currentDate.toLocal().day,
                              startHour,
                              startMinute);

                          DateTime startUtcDateTime = startDateTime.toUtc();
                          String endTimeString = element.split("- ").last;

                          var endTemp = endTimeString.split(":");

                          int endHour = endTemp.last.split(" ").last == "AM" ||
                                  int.parse(endTemp.first) == 12
                              ? int.parse(endTemp.first)
                              : int.parse(endTemp.first) + 12;
                          int endMinute =
                              int.parse(endTemp.last.split(" ").first);

                          DateTime endDateTime = DateTime(
                              currentDate.toLocal().year,
                              currentDate.toLocal().month,
                              currentDate.toLocal().day,
                              endHour,
                              endMinute);

                          ///

                          if (endHour < startHour ||
                              (endHour == startHour &&
                                  endMinute <= startMinute)) {
                            endDateTime =
                                endDateTime.add(const Duration(days: 1));
                          }

                          DateTime endUtcDateTime = endDateTime.toUtc();

                          String avail =
                              selectedItem.contains(element) ? "1" : "0";

                          availData.add({
                            "start_time": startUtcDateTime.toString().trim(),
                            "end_time": endUtcDateTime.toString().trim(),
                            "avail": avail,
                          });

                          if (endDateTime.day != startDateTime.day) {
                            currentDate =
                                currentDate.add(const Duration(days: 1));
                          }

                          ///
                          // DateTime endUtcDateTime = endDateTime.toUtc();
                          //
                          // String avail =
                          //     selectedItem.contains(element) ? "1" : "0";
                          //
                          // availData.add({
                          //   "start_time": startUtcDateTime.toString(),
                          //   "end_time": endUtcDateTime.toString(),
                          //   "avail": avail,
                          // });
                        }
                        await _doctorHomeScreenController.getDoctorAvailability(
                            _userController.user.value.id!,
                            currentDate,
                            availData);

                        setState(() {
                          isLoading = false;
                        });
                      },
                      child: const Text(
                        "UPDATE",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18.0),
                      ),
                    ),
            ),
          ],
        ),
        filterLoading
            ? Container(
                color: Colors.black12,
                child: /*Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 1,
                  ),
                )*/
                    Center(
                  child: Utils.circular(),
                ),
              )
            : const SizedBox()
      ],
    );
  }

  Widget _body() {
    return Container(
      padding: const EdgeInsets.only(left: 14.0, top: 14.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(
                  Colors.blue,
                ),
                foregroundColor: WidgetStateProperty.all<Color>(
                  Colors.white,
                ),
              ),
              onPressed: () async {
                _selectDate(context);
              },
              child: Text(DateFormat('EEEE, dd MMMM yyyy').format(currentDate)),
            ),
            const SizedBox(
              height: 10,
            ),
            Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 13),
                    child: Row(
                      children: [
                        Checkbox(
                          value: selectAll,
                          onChanged: disabledTimeSlot.length == 26
                              ? null
                              : (value) {
                                  selectAll = !selectAll;
                                  final temp = finalDataItem;
                                  if (selectAll == true) {
                                    selectedItem = timeSlot;
                                    // disabledTimeSlot.forEach((el1) {
                                    //   selectedItem.removeWhere(
                                    //       (element) => element == el1);
                                    // });

                                    for (var element in disabledTimeSlot) {
                                      selectedItem.remove(element);
                                    }

                                    for (var element in temp) {
                                      selectedItem.add(element);
                                    }

                                    _isSelectedNotifier.value = true;
                                  } else {
                                    selectedItem = [];
                                    for (var el1 in temp) {
                                      for (var el2 in disabledTimeSlot) {
                                        if (el1 == el2) {
                                          selectedItem.add(el2);
                                        }
                                      }
                                    }
                                  }
                                  timeSlot = <String>[
                                    "8:00 - 9:00 AM",
                                    "9:00 - 10:00 AM",
                                    "10:00 - 11:00 AM",
                                    "11:00 - 12:00 PM",
                                    "12:00 - 1:00 PM",
                                    "1:00 - 2:00 PM",
                                    "2:00 - 3:00 PM",
                                    "3:00 - 4:00 PM",
                                    "4:00 - 5:00 PM",
                                    "5:00 - 6:00 PM",
                                    "6:00 - 7:00 PM",
                                    "7:00 - 8:00 PM",
                                    "8:00 - 9:00 PM",
                                  ];
                                  // disabledSlots();
                                  setState(() {});
                                },
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "Select all",
                          style: TextStyle(
                              fontSize: 18,
                              color: disabledTimeSlot.length == 26
                                  ? Colors.grey.shade600
                                  : isDark
                                      ? Colors.white
                                      : Colors.black),
                        ),
                      ],
                    ),
                  ),
                  // ...List.generate(
                  //   timeSlot.length,
                  //   (index) => Padding(
                  //     padding: const EdgeInsets.only(left: 13),
                  //     child: Row(
                  //       children: [
                  //         Checkbox(
                  //           value: selectedItem.contains(timeSlot[index])
                  //               ? true
                  //               : false,
                  //           onChanged: (value) {
                  //             selectedItemIndex.add("$index");
                  //             _isSelectedNotifier.value = false;
                  //             setState(() {});
                  //           },
                  //         ),
                  //         SizedBox(width: 10),
                  //         Text(
                  //           "${timeSlot[index]}",
                  //           style: TextStyle(fontSize: 18),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  CheckboxGroup(
                    disabled: disabledTimeSlot,
                    checked: _isSelectedNotifier.value ? selectedItem : null,
                    labelStyle: const TextStyle(fontSize: 18),
                    labels: timeSlot,
                    onChange: (bool isChecked, String label, int index) {
                      selectedItemIndex.add("$index");
                      _isSelectedNotifier.value = false;
                    },
                    onSelected: (checked) {
                      selectedItem = checked;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
