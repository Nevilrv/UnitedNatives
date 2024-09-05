import 'package:united_natives/viewModel/user_controller.dart';
import 'package:united_natives/utils/pref_manager.dart';
import 'package:united_natives/newModel/apiModel/responseModel/class_detail_doctor_data_response_model.dart';
import 'package:united_natives/newModel/apis/api_response.dart';
import 'package:united_natives/utils/utils.dart';
import 'package:united_natives/viewModel/edit_scheduled_class.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DrCourseDetailScreen extends StatefulWidget {
  final String? classId;

  const DrCourseDetailScreen({super.key, this.classId});
  @override
  State<DrCourseDetailScreen> createState() => _DrCourseDetailScreenState();
}

class _DrCourseDetailScreenState extends State<DrCourseDetailScreen>
    with SingleTickerProviderStateMixin {
  TabController? controller;
  EditScheduledClassController editScheduledClassController =
      Get.put(EditScheduledClassController());
  var data = Get.arguments;
  final UserController userController = Get.find();
  final bool _isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);
  @override
  void initState() {
    editScheduledClassController.classDetailDoctor(
        id: userController.user.value.id, classId: widget.classId);
    super.initState();
    controller = TabController(length: 1, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
              child: GetBuilder<EditScheduledClassController>(
                builder: (controller) {
                  if (controller.classDetailDoctorApiResponse.status ==
                      Status.LOADING) {
                    return Center(
                      child: Utils.circular(),
                    );
                    // return Center(child: CircularProgressIndicator());
                  }
                  if (controller.classDetailDoctorApiResponse.status ==
                      Status.ERROR) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Center(child: Text("Server error")),
                    );
                  }
                  ClassDetailDoctorResponseModel responseModel =
                      controller.classDetailDoctorApiResponse.data;
                  return ListView(
                    children: [
                      headerView(
                        image: responseModel.data?.classFeaturedImage ?? "",
                        title: responseModel.data?.title ?? "",
                        date: responseModel.data?.classDate ?? "",
                        attendance: responseModel.data?.classAttendees ?? "",
                        endTime: responseModel.data?.classEndTime ?? "",
                        startTime: responseModel.data?.classStartTime ?? "",
                      ),
                      // Get.width * 0.05
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Get.height * 0.02,
                            vertical: Get.height * 0.012),
                        child: Text(
                          'Description',
                          style: TextStyle(
                              color: _isDark ? Colors.white : Colors.black,
                              fontSize: Get.height * 0.027,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                        child:
                            tab1(description: responseModel.data!.description!),
                      ),
                    ],
                  );
                },
              ))),
    );
  }

  Column tab1({required String description}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          description,
          style: TextStyle(
              fontSize: Get.height * 0.022,
              color: _isDark ? Colors.white.withOpacity(0.8) : Colors.grey),
        ),
      ],
    );
  }

  Widget headerView(
      {String? image,
      String? title,
      String? attendance,
      String? date,
      String? startTime,
      String? endTime}) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Stack(
                children: [
                  Container(
                    // width: Get.width,
                    height: 300,
                    margin: const EdgeInsets.only(bottom: 30),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(image == null || image == ''
                                ? 'https://www.safefood.net/getmedia/8b0483a1-ea59-4a74-857d-675a9cfecc80/medical-conditions.jpg?w=2048&h=1152&ext=.jpg&width=1360&resizemode=force'
                                : image),
                            fit: BoxFit.fitWidth),
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  Positioned(
                    bottom: 0,
                    left: Get.width / 1.6,
                    right: 10,
                    child: buildContainer(
                        title: "Live",
                        colorName: Colors.white,
                        colorText: Colors.black),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Get.height * 0.02, vertical: Get.height * 0.012),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title?.toUpperCase() ?? "",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: _isDark ? Colors.white : Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Attendance $attendance',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: _isDark
                            ? Colors.white.withOpacity(0.8)
                            : Colors.grey,
                        fontSize: 17,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            Container(
              width: Get.width * 2,
              height: 2,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              color: Colors.black12,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Get.height * 0.02, vertical: Get.height * 0.012),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Date',
                          style: TextStyle(
                              color: _isDark
                                  ? Colors.white.withOpacity(0.8)
                                  : Colors.grey,
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          date ?? '',
                          style: TextStyle(
                              color: _isDark ? Colors.white : Colors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: Get.height * 0.060,
                    width: 1,
                    color: Colors.grey,
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: Get.width * 0.040),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Time',
                              style: TextStyle(
                                  color: _isDark
                                      ? Colors.white.withOpacity(0.8)
                                      : Colors.grey,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          Text(
                            '${startTime ?? ""} to ${endTime ?? ""}',
                            style: TextStyle(
                                color: _isDark ? Colors.white : Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: Get.width * 2,
              height: 2,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              color: Colors.black12,
            ),
            // index.isEven
            //     ?

            // : buildContainerButton(title: "Withdraw",colorText: Colors.white,colorName: Colors.red),
          ],
        ),
        Positioned(
          top: Get.height * 0.02,
          left: Get.width * 0.04,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: CircleAvatar(
              backgroundColor: Colors.black.withOpacity(0.5),
              radius: Get.height * 0.025,
              child: const Center(
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Container buildContainer({
    required String title,
    required Color colorName,
    required Color colorText,
  }) {
    return Container(
      height: 40,
      // width: 50,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),

      decoration: BoxDecoration(
          color: colorName,
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              spreadRadius: 1,
              offset: Offset(0.5, 0.5),
            )
          ],
          borderRadius: BorderRadius.circular(8)),
      child: Text(
        "$title",
        style: TextStyle(
            color: colorText == null ? Colors.black : colorText, fontSize: 20),
      ),
    );
  }

  Container buildContainerButton({
    required String title,
    required Color colorName,
    required Color colorText,
  }) {
    return Container(
      height: 50,
      // width: 50,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      margin: const EdgeInsets.only(bottom: 25, right: 25, left: 25, top: 10),

      decoration: BoxDecoration(
          color: colorName,
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              spreadRadius: 1,
              offset: Offset(0.5, 0.5),
            )
          ],
          borderRadius: BorderRadius.circular(8)),
      child: Text(
        "$title",
        style: TextStyle(color: colorText, fontSize: 20),
      ),
    );
  }
}
