import 'package:united_natives/components/my_doctor_message_list.dart';
import 'package:united_natives/viewModel/patient_homescreen_controller.dart';
import 'package:united_natives/medicle_center/lib/utils/translate.dart';
import 'package:united_natives/ResponseModel/api_state_enum.dart';
import 'package:united_natives/ResponseModel/get_all_doctor.dart';
import 'package:united_natives/utils/constants.dart';
import 'package:united_natives/utils/time.dart';
import 'package:united_natives/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;

class MyDoctorMessageList extends StatefulWidget {
  const MyDoctorMessageList({super.key});

  @override
  State<MyDoctorMessageList> createState() => _MyDoctorMessageListState();
}

class _MyDoctorMessageListState extends State<MyDoctorMessageList> {
  final PatientHomeScreenController _patientHomeScreenController =
      Get.find<PatientHomeScreenController>()..getAllDoctors();

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // _patientHomeScreenController.getAllDoctors();
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        TimerChange().patientTimerChange();
      },
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              surfaceTintColor: Colors.transparent,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_sharp),
                onPressed: () {
                  Navigator.pop(context);
                  TimerChange().patientTimerChange();
                },
              ),
              title: Text(
                Translate.of(context)!.translate('My Provider List'),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.titleMedium?.color,
                    fontSize: 24),
              ),
            ),
            body: Column(
              children: [
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: searchController,
                    onChanged: (value) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide:
                            const BorderSide(color: kColorBlue, width: 0.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide:
                            BorderSide(color: Colors.grey[300]!, width: 0.5),
                      ),
                      filled: true,
                      fillColor: Colors.grey[250],
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 15,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey[400],
                        size: 30,
                      ),
                      hintText: Translate.of(context)?.translate('search'),
                      hintStyle:
                          TextStyle(color: Colors.grey[400], fontSize: 22),
                    ),
                    cursorWidth: 1,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Obx(() {
                    if (_patientHomeScreenController
                            .getAllDoctor.value.apiState ==
                        APIState.COMPLETE) {
                      List<Doctor> data = [];
                      _patientHomeScreenController.getAllDoctor.value.data
                          ?.forEach((element) {
                        if (element.chatKey == "") {
                          data.add(element);
                        }
                      });

                      int indexFind = data.indexWhere((element) =>
                          ('${element.firstName}${element.lastName}')
                              .toLowerCase()
                              .contains(searchController.text
                                  .toLowerCase()
                                  .replaceAll(" ", "")));

                      return RefreshIndicator(
                        onRefresh: _patientHomeScreenController.getAllDoctors,
                        child: indexFind < 0
                            ? Center(
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 25)
                                          .copyWith(bottom: 35),
                                  child: Text(
                                    'You can only start a conversation with providers with whom you currently have or have had appointments. Start booking appointments and come back here.',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(fontSize: 20),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                itemCount: data.length,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                itemBuilder: (context, index) {
                                  return "${data[index].firstName}${data[index].lastName}"
                                          .toLowerCase()
                                          .toString()
                                          .contains(searchController.text
                                              .replaceAll(" ", "")
                                              .toLowerCase()
                                              .toString())
                                      ? Column(
                                          children: [
                                            MyDoctorMessageLists(
                                              doctor: data[index],
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            )
                                          ],
                                        )
                                      : Container();
                                },
                              ),
                      );
                    } else if (_patientHomeScreenController
                            .getAllDoctor.value.apiState ==
                        APIState.COMPLETE_WITH_NO_DATA) {
                      return Center(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 25)
                              .copyWith(bottom: 35),
                          child: Text(
                            'You can only start a conversation with providers with whom you currently have or have had appointments. Start booking appointments and come back here.',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    } else if (_patientHomeScreenController
                            .getAllDoctor.value.apiState ==
                        APIState.ERROR) {
                      return Text(
                        "Error",
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontSize: 20),
                        textAlign: TextAlign.center,
                      );
                    } else if (_patientHomeScreenController
                            .getAllDoctor.value.apiState ==
                        APIState.PROCESSING) {
                      return Center(
                        child: Utils.circular(),
                      );
                    } else {
                      return const Center(
                        child: Text(""),
                      );
                    }
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
