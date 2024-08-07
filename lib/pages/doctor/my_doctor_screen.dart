import 'package:doctor_appointment_booking/components/custom_button.dart';
import 'package:doctor_appointment_booking/controller/user_controller.dart';
import 'package:doctor_appointment_booking/data/pref_manager.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/utils/translate.dart';
import 'package:doctor_appointment_booking/newModel/apiModel/requestModel/my_doctor_list_request_model.dart';
import 'package:doctor_appointment_booking/newModel/apiModel/responseModel/my_doctor_list_reposne_model.dart';
import 'package:doctor_appointment_booking/newModel/apis/api_response.dart';
import 'package:doctor_appointment_booking/routes/routes.dart';
import 'package:doctor_appointment_booking/utils/constants.dart';
import 'package:doctor_appointment_booking/utils/utils.dart';
import 'package:doctor_appointment_booking/viewModel/add_my_doctors_and_notes_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyDoctorScreen extends StatefulWidget {
  const MyDoctorScreen({Key key}) : super(key: key);

  @override
  State<MyDoctorScreen> createState() => _MyDoctorScreenState();
}

class _MyDoctorScreenState extends State<MyDoctorScreen> {
  bool _isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);
  UserController _userController = Get.find<UserController>();
  MyDoctorNotesViewModel addMyDoctorNotesViewModel =
      Get.put(MyDoctorNotesViewModel());

  Future<void> getData() async {
    MyDoctorListRequestModel requestModel = MyDoctorListRequestModel(
      patientId: int.parse(_userController.user.value.id),
      doctorName: '',
    );
    print('requestModel==========>>>>>$requestModel');
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
        child: Icon(
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
          return Center(
            child: Text("Error"),
          );
        } else if (controller.getMyDoctorListApiResponse.status ==
            Status.COMPLETE) {
          MyDoctorsListDataResponseModel response =
              controller.getMyDoctorListApiResponse.data;

          if (response.data.isEmpty || response.data == null) {
            return Center(
              child: Text(
                "No Providers",
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView.separated(
            physics: AlwaysScrollableScrollPhysics(),
            separatorBuilder: (context, index) => SizedBox(
              height: 15,
            ),
            itemCount: response.data.length,
            shrinkWrap: true,
            padding: EdgeInsets.all(20),
            itemBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: _isDark
                      ? Colors.grey.withOpacity(0.2)
                      : Color(0xffEBF2F5),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "${response.data[index].doctorName}",
                            style: TextStyle(
                                color:
                                    _isDark ? Colors.white : kColorPrimaryDark,
                                fontSize: 20,
                                fontWeight: FontWeight.w700),
                          ),
                          Text("${response.data[index].doctorMobile}",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    CustomButton(
                      text: Translate.of(context).translate('details'),
                      textSize: 18,
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(
                          Routes.myDoctorProfile,
                          arguments: response.data[index].doctorName,
                        )
                            .then((value) {
                          if (value == true) {
                            getData();
                          }
                        });
                      },
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    ),
                  ],
                ),
              );
            },
          );
        } else {
          return SizedBox();
        }
      }),
    );
  }
}
