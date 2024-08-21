import 'package:united_natives/controller/doctor_homescreen_controller.dart';
import 'package:united_natives/controller/user_controller.dart';
import 'package:united_natives/medicle_center/lib/utils/translate.dart';
import 'package:united_natives/model/api_state_enum.dart';
import 'package:united_natives/model/get_all_patient_response_model.dart';
import 'package:united_natives/pages/myPatientMessageList/my_patient_list.dart';
import 'package:united_natives/utils/constants.dart';
import 'package:united_natives/utils/time.dart';
import 'package:united_natives/utils/utils.dart';
import 'package:united_natives/viewModel/add_new_chat_message_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;

class MyPatientMessageList extends StatefulWidget {
  const MyPatientMessageList({super.key});

  @override
  State<MyPatientMessageList> createState() => _MyPatientMessageListState();
}

class _MyPatientMessageListState extends State<MyPatientMessageList> {
  final DoctorHomeScreenController patientHomeScreenController =
      Get.find<DoctorHomeScreenController>()..getAllPatients();
  AddNewChatMessageController addNewChatMessageController = Get.find();
  final UserController _userController = Get.find();

  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // _patientHomeScreenController.getAllPatients();
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) async {
        await addNewChatMessageController.getSortedChatListDoctor(
            doctorId: _userController.user.value.id);
        TimerChange().docTimerChange();
      },
      child: Scaffold(
          appBar: AppBar(
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_sharp),
              onPressed: () async {
                Navigator.pop(context);
                TimerChange().docTimerChange();
                // await addNewChatMess
                // ageController.getSortedChatListDoctor(
                //     doctorId: _userController.user.value.id);
              },
            ),
            title: Text(
              Translate.of(context)!.translate('My Client List'),
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
                    hintStyle: TextStyle(color: Colors.grey[400], fontSize: 22),
                  ),
                  cursorWidth: 1,
                  maxLines: 1,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: GetBuilder<DoctorHomeScreenController>(
                  builder: (controller) {
                    if (controller.getAllPatient.apiState ==
                        APIState.COMPLETE) {
                      int? index1 = -1;

                      index1 = controller.getAllPatient.data?.indexWhere(
                          (item) =>
                              item.chatKey == "" &&
                              (item.firstName! + item.firstName!)
                                  .toLowerCase()
                                  .toString()
                                  .contains(searchController.text
                                      .toLowerCase()
                                      .toString()));

                      if (index1! < 0) {
                        return Center(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 25)
                                .copyWith(bottom: 25),
                            child: Text(
                              'You can only start a conversation with clients with whom you currently have or have had appointments.',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(fontSize: 20),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: controller.getAllPatient.data?.length ?? 0,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        itemBuilder: (context, index) {
                          Patient item = controller.getAllPatient.data![index];

                          if (item.chatKey == "" &&
                              (item.firstName! + item.firstName!)
                                  .toLowerCase()
                                  .toString()
                                  .contains(searchController.text
                                      .toLowerCase()
                                      .toString())) {
                            return Column(
                              children: [
                                MyPatientLists(patient: item),
                                const SizedBox(height: 15)
                              ],
                            );
                          } else {
                            return const SizedBox();
                          }
                        },
                      );
                    } else if (controller.getAllPatient.apiState ==
                        APIState.COMPLETE_WITH_NO_DATA) {
                      return Center(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 25)
                              .copyWith(bottom: 25),
                          child: Text(
                            'You can only start a conversation with clients with whom you currently have or have had appointments.',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    } else if (controller.getAllPatient.apiState ==
                        APIState.ERROR) {
                      return Container(
                        color: Colors.yellow,
                        child: const Text("Error"),
                      );
                    } else if (controller.getAllPatient.apiState ==
                        APIState.PROCESSING) {
                      return Center(
                        child: Utils.circular(),
                      );
                    } else {
                      return const Center(
                        child: Text(""),
                      );
                    }
                  },
                ),
              ),
            ],
          )),
    );
  }
}
