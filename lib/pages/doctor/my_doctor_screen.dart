import 'package:united_natives/components/custom_button.dart';
import 'package:united_natives/viewModel/user_controller.dart';
import 'package:united_natives/utils/pref_manager.dart';
import 'package:united_natives/medicle_center/lib/utils/translate.dart';
import 'package:united_natives/requestModel/my_doctor_list_request_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/my_doctor_list_reposne_model.dart';
import 'package:united_natives/newModel/apis/api_response.dart';
import 'package:united_natives/routes/routes.dart';
import 'package:united_natives/utils/constants.dart';
import 'package:united_natives/utils/utils.dart';
import 'package:united_natives/viewModel/add_my_doctors_and_notes_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyDoctorScreen extends StatefulWidget {
  const MyDoctorScreen({super.key});

  @override
  State<MyDoctorScreen> createState() => _MyDoctorScreenState();
}

class _MyDoctorScreenState extends State<MyDoctorScreen> {
  final bool _isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);
  final UserController _userController = Get.find<UserController>();
  MyDoctorNotesViewModel addMyDoctorNotesViewModel =
      Get.put(MyDoctorNotesViewModel());

  Future<void> getData() async {
    MyDoctorListRequestModel requestModel = MyDoctorListRequestModel(
      patientId: int.parse(_userController.user.value.id!),
      doctorName: '',
    );
    await addMyDoctorNotesViewModel.getAllDoctorList(model: requestModel);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: kColorBlue,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () async {
          final result =
              await Navigator.of(context).pushNamed(Routes.addMyDoctor);
          if (result != null) {
            getData();
          }
        },
      ),
      body: GetBuilder<MyDoctorNotesViewModel>(builder: (controller) {
        if (controller.getMyDoctorListApiResponse.status == Status.LOADING) {
          // return Center(
          //   child: CircularProgressIndicator(),
          // );
          return Center(
            child: Utils.circular(),
          );
        } else if (controller.getMyDoctorListApiResponse.status ==
            Status.ERROR) {
          return const Center(
            child: Text("Error"),
          );
        } else if (controller.getMyDoctorListApiResponse.status ==
            Status.COMPLETE) {
          MyDoctorsListDataResponseModel response =
              controller.getMyDoctorListApiResponse.data;

          if (response.data!.isEmpty || response.data == null) {
            return Center(
              child: Text(
                "No Providers",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            separatorBuilder: (context, index) => const SizedBox(
              height: 15,
            ),
            itemCount: response.data!.length,
            shrinkWrap: true,
            padding: const EdgeInsets.all(20),
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: _isDark
                      ? Colors.grey.withOpacity(0.2)
                      : const Color(0xffEBF2F5),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "${response.data?[index].doctorName}",
                            style: TextStyle(
                                color:
                                    _isDark ? Colors.white : kColorPrimaryDark,
                                fontSize: 20,
                                fontWeight: FontWeight.w700),
                          ),
                          Text("${response.data?[index].doctorMobile}",
                              style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    CustomButton(
                      text: Translate.of(context)!.translate('details'),
                      textSize: 18,
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(
                          Routes.myDoctorProfile,
                          arguments: response.data?[index].doctorName,
                        )
                            .then((value) {
                          if (value == true) {
                            getData();
                          }
                        });
                      },
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 5),
                    ),
                  ],
                ),
              );
            },
          );
        } else {
          return const SizedBox();
        }
      }),
    );
  }
}
