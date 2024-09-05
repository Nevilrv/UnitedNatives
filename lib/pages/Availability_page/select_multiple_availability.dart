import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:united_natives/viewModel/doctor_homescreen_controller.dart';
import 'package:united_natives/viewModel/user_controller.dart';
import 'package:united_natives/pages/Availability_page/checkbox_group.dart';

class SelectMultipleAvailability extends StatefulWidget {
  const SelectMultipleAvailability({super.key});

  @override
  State<SelectMultipleAvailability> createState() =>
      _SelectMultipleAvailabilityState();
}

class _SelectMultipleAvailabilityState
    extends State<SelectMultipleAvailability> {
  final DoctorHomeScreenController _doctorHomeScreenController =
      Get.find<DoctorHomeScreenController>();
  final UserController _userController = Get.find<UserController>();
  bool isLoading = false;
  final RxBool _isSelectedNotifier = true.obs;
  DateTime? currentDate;
  List<String> selectedItemIndex = [];
  List<String> selectedItem = [];
  DateTime? startDate;
  DateTime? endDate;
  bool selectAll = false;
  // Future<void> filterData(DateTime pickedDate) async {
  //   await _doctorHomeScreenController.getDoctorAvailabilityDisplay(
  //       _userController.user.value.id, pickedDate.toString().split(' ')[0]);
  //   print('items.length:$selectedItem');
  //   print(
  //       'items.123:${_doctorHomeScreenController?.doctorAvailabilityForDisplayOnlyModelData?.value?.data?.postedDateAvailability}');
  //   PostedDateAvailabilityClass iterable = _doctorHomeScreenController
  //       ?.doctorAvailabilityForDisplayOnlyModelData
  //       ?.value
  //       ?.data
  //       ?.postedDateAvailability;
  //   DateTime date = iterable?.availDate;
  //   print('date:$date');
  //   print('currentDate:$currentDate');
  //   PostedDateAvailabilityClass availability = iterable;
  //   if (currentDate == date) {
  //     if (availability?.avail8 == "1") {
  //       print('avail8:${availability?.avail8}');
  //       selectedItem.add("8 - 9 AM");
  //       print('selectedItem:$selectedItem');
  //     }
  //     if (availability?.avail9 == "1") {
  //       print('avail9:${availability?.avail9}');
  //       selectedItem.add("9 - 10 AM");
  //       print('selectedItem:$selectedItem');
  //     }
  //     if (availability?.avail10 == "1") {
  //       selectedItem.add("10 - 11 AM");
  //       print('selectedItem:$selectedItem');
  //     }
  //     if (availability?.avail11 == "1") {
  //       selectedItem.add("11 - 12 AM");
  //       print('selectedItem:$selectedItem');
  //     }
  //     if (availability?.avail12 == "1") {
  //       selectedItem.add("12 - 1 PM");
  //       print('selectedItem:$selectedItem');
  //     }
  //     if (availability?.avail13 == "1") {
  //       selectedItem.add("1 - 2 PM");
  //       print('selectedItem:$selectedItem');
  //     }
  //     if (availability?.avail14 == "1") {
  //       selectedItem.add("2 - 3 PM");
  //       print('selectedItem:$selectedItem');
  //     }
  //     if (availability?.avail15 == "1") {
  //       selectedItem.add("3 - 4 PM");
  //       print('selectedItem:$selectedItem');
  //     }
  //     if (availability?.avail16 == "1") {
  //       selectedItem.add("4 - 5 PM");
  //       print('selectedItem:$selectedItem');
  //     }
  //     if (availability?.avail17 == "1") {
  //       selectedItem.add("5 - 6 PM");
  //       print('selectedItem:$selectedItem');
  //     }
  //     if (availability?.avail18 == "1") {
  //       selectedItem.add("6 - 7 PM");
  //       print('selectedItem:$selectedItem');
  //     }
  //     if (availability?.avail19 == "1") {
  //       selectedItem.add("7 - 8 PM");
  //       print('selectedItem:$selectedItem');
  //     }
  //     if (availability?.avail20 == "1") {
  //       selectedItem.add("8 - 9 PM");
  //       print('selectedItem:$selectedItem');
  //     }
  //     if (availability?.avail21 == "1") {
  //       selectedItem.add("9 - 10 PM");
  //       print('selectedItem:$selectedItem');
  //     }
  //     if (selectedItem.length == 14) {
  //       selectAll = true;
  //     }
  //   }
  //
  //   setState(() {});
  // }

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

  @override
  void initState() {
    selectedItem.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(18),
                color: Colors.black.withOpacity(0.1),
                child: SfDateRangePicker(
                  minDate: DateTime.now(),
                  view: DateRangePickerView.month,
                  monthViewSettings:
                      const DateRangePickerMonthViewSettings(firstDayOfWeek: 7),
                  selectionMode: DateRangePickerSelectionMode.range,
                  showActionButtons: true,
                  onSubmit: (val) {
                    if (val != null) {
                      setState(() {});
                      PickerDateRange data = val as PickerDateRange;
                      startDate = data.startDate;
                      endDate = data.endDate;
                      setState(() {});
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Select at least on date for update your availability!'),
                        ),
                      );
                    }
                  },
                  cancelText: "",
                  confirmText: "SELECT",
                  onSelectionChanged: (dateRangePickerSelectionChangedArgs) {
                    startDate = null;
                    endDate = null;
                    selectAll = false;
                    selectedItem.clear();
                    setState(() {});
                  },
                ),
              ),
              startDate == null && endDate == null
                  ? const Text(
                      'Select Dates to Update Your Availability',
                    )
                  : Obx(
                      () => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 13),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: selectAll,
                                  onChanged: (value) {
                                    selectAll = !selectAll;
                                    if (selectAll == true) {
                                      selectedItem = timeSlot;
                                      _isSelectedNotifier.value = true;
                                    } else {
                                      selectedItem = [];
                                    }

                                    setState(() {});
                                  },
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  "Select all",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                          CheckboxGroup(
                              checked: _isSelectedNotifier.value
                                  ? selectedItem
                                  : null,
                              labelStyle: const TextStyle(fontSize: 18),
                              labels: timeSlot,
                              onChange:
                                  (bool isChecked, String label, int index) {
                                selectedItemIndex.add("$index");
                                _isSelectedNotifier.value = false;
                                log("isChecked: $isChecked   label: $label  index: $index");
                              },
                              onSelected: (checked) {
                                selectedItem = checked;
                              }),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.15,
                          )
                        ],
                      ),
                    ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          child: startDate == null && endDate == null
              ? Container()
              : Container(
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
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      // Center(
                      //     child: Utils.circular(),
                      //   )
                      : ElevatedButton(
                          style: ButtonStyle(
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
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

                            /*DateTime time = DateTime.now();
                            timeSlot.forEach((element) {
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
                                  time.toLocal().year,
                                  time.toLocal().month,
                                  time.toLocal().day,
                                  startHour,
                                  startMinute);

                              DateTime startUtcDateTime = startDateTime.toUtc();
                              String endTimeString =
                                  "${element.split("- ").last}";

                              var endTemp = endTimeString.split(":");

                              int endHour =
                                  endTemp.last.split(" ").last == "AM" ||
                                          int.parse(endTemp.first) == 12
                                      ? int.parse(endTemp.first)
                                      : int.parse(endTemp.first) + 12;
                              int endMinute =
                                  int.parse(endTemp.last.split(" ").first);

                              DateTime endDateTime = DateTime(
                                  time.toLocal().year,
                                  time.toLocal().month,
                                  time.toLocal().day,
                                  endHour,
                                  endMinute);

                              ///

                              if (endHour < startHour ||
                                  (endHour == startHour &&
                                      endMinute <= startMinute)) {
                                endDateTime =
                                    endDateTime.add(Duration(days: 1));
                              }

                              DateTime endUtcDateTime = endDateTime.toUtc();

                              String avail =
                                  selectedItem.contains(element) ? "1" : "0";

                              availData.add({
                                "start_time":
                                    startUtcDateTime.toString().trim(),
                                "end_time": endUtcDateTime.toString().trim(),
                                "avail": avail,
                              });

                              if (endDateTime.day != startDateTime.day) {
                                time = time.add(Duration(days: 1));
                              }
                            });*/

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
                                  startDate!.toLocal().year,
                                  startDate!.toLocal().month,
                                  startDate!.toLocal().day,
                                  startHour,
                                  startMinute);

                              DateTime startUtcDateTime = startDateTime.toUtc();
                              String endTimeString = element.split("- ").last;

                              var endTemp = endTimeString.split(":");

                              int endHour =
                                  endTemp.last.split(" ").last == "AM" ||
                                          int.parse(endTemp.first) == 12
                                      ? int.parse(endTemp.first)
                                      : int.parse(endTemp.first) + 12;
                              int endMinute =
                                  int.parse(endTemp.last.split(" ").first);

                              DateTime endDateTime = DateTime(
                                  startDate!.toLocal().year,
                                  startDate!.toLocal().month,
                                  startDate!.toLocal().day,
                                  endHour,
                                  endMinute);

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
                                "start_time":
                                    startUtcDateTime.toString().trim(),
                                "end_time": endUtcDateTime.toString().trim(),
                                "avail": avail,
                              });

                              if (endDateTime.day != startDateTime.day) {
                                startDate =
                                    startDate?.add(const Duration(days: 1));
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

                            log("===DATA===>>>>${jsonEncode(availData)}");

                            if (endDate != null) {
                              await _doctorHomeScreenController
                                  .multipleDoctorAvailability(
                                _userController.user.value.id!,
                                startDate,
                                endDate,
                                availData,
                              );
                            } else {
                              await _doctorHomeScreenController
                                  .getDoctorAvailability(
                                      _userController.user.value.id!,
                                      startDate,
                                      availData);
                            }

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
        )
      ],
    );
  }
}
