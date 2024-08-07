import 'dart:developer';
import 'package:doctor_appointment_booking/components/round_icon_button.dart';
import 'package:doctor_appointment_booking/controller/user_controller.dart';
import 'package:doctor_appointment_booking/data/pref_manager.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/utils/translate.dart';
import 'package:doctor_appointment_booking/newModel/apiModel/requestModel/delete_doctor_response_model.dart';
import 'package:doctor_appointment_booking/newModel/apiModel/requestModel/delete_my_doctor_notes_request_model.dart';
import 'package:doctor_appointment_booking/newModel/apiModel/requestModel/my_doctor_list_request_model.dart';
import 'package:doctor_appointment_booking/newModel/apiModel/responseModel/my_doctor_list_reposne_model.dart';
import 'package:doctor_appointment_booking/newModel/apis/api_response.dart';
import 'package:doctor_appointment_booking/pages/doctor/edit_my_doctor_notes_page.dart';
import 'package:doctor_appointment_booking/routes/routes.dart';
import 'package:doctor_appointment_booking/utils/constants.dart';
import 'package:doctor_appointment_booking/utils/utils.dart';
import 'package:doctor_appointment_booking/viewModel/add_my_doctors_and_notes_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:get/get.dart';

class MyDoctorNotesScreen extends StatefulWidget {
  final String? doctor;

  const MyDoctorNotesScreen({Key? key, this.doctor}) : super(key: key);

  @override
  State<MyDoctorNotesScreen> createState() => _MyDoctorNotesScreenState();
}

class _MyDoctorNotesScreenState extends State<MyDoctorNotesScreen> {
  MyDoctorNotesViewModel addMyDoctorNotesViewModel =
      Get.put(MyDoctorNotesViewModel());

  bool _isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);
  final notesController = TextEditingController();
  //
  // deleteNotes({int notesId, int id}) async {
  //   DeleteNotesRequestModel requestModel = DeleteNotesRequestModel(
  //     patientId: int.parse(Prefs.getString(Prefs.SOCIALID)),
  //     id: id,
  //     noteId: notesId,
  //   );
  //   await addMyDoctorNotesViewModel.deleteMyDoctorNotes(model: requestModel);
  // }
  //
  // deleteDoctor() async {
  //   DeleteDoctorRequestModel requestModel = DeleteDoctorRequestModel(
  //     patientId: int.parse(Prefs.getString(Prefs.SOCIALID)),
  //     id: int.parse(widget.doctor.id),
  //   );
  //   await addMyDoctorNotesViewModel.deleteMyDoctor(model: requestModel);
  // }
  UserController _userController = Get.find<UserController>();
  Future<void> getData(String name) async {
    MyDoctorListRequestModel requestModel = MyDoctorListRequestModel(
      patientId: int.parse(_userController.user.value.id),
      doctorName: name,
    );
    await addMyDoctorNotesViewModel.getAllDoctorList(model: requestModel);
  }

  var data;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getData('${widget.doctor}');
    });
  }

  @override
  Widget build(BuildContext context) {
    log('doctor---------->>>>>>>>${widget.doctor}');

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context, true);
              },
              child: Icon(Icons.arrow_back_ios)),
          title: Text(
            Translate.of(context).translate('My Provider Notes'),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.subtitle1.color,
              fontSize: 24,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        floatingActionButton:
            addMyDoctorNotesViewModel.getMyDoctorListApiResponse.status !=
                    Status.LOADING
                ? FloatingActionButton(
                    backgroundColor: kColorBlue,
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      Navigator.of(context)
                          .pushNamed(Routes.addMyDocNotes, arguments: data)
                          .then((value) {
                        print('value---------->>>>>>>>$value');
                        if (value == true) {
                          getData('${widget.doctor}');
                        }
                      });
                    },
                  )
                : SizedBox(),
        body: Column(
          children: [
            GetBuilder<MyDoctorNotesViewModel>(
              builder: (controller) {
                if (controller.getMyDoctorListApiResponse.status ==
                    Status.LOADING) {
                  return Expanded(
                      // child: Center(child: CircularProgressIndicator()));
                      child: Center(
                    child: Utils.circular(),
                  ));
                } else if (controller.getMyDoctorListApiResponse.status ==
                    Status.ERROR) {
                  return Center(
                      child:
                          Text(controller.getMyDoctorListApiResponse.message));
                } else if (controller.getMyDoctorListApiResponse.status ==
                    Status.COMPLETE) {
                  MyDoctorsListDataResponseModel resData =
                      controller.getMyDoctorListApiResponse.data;

                  if (resData.data == null ||
                      resData.data.isEmpty ||
                      resData.data == []) {
                    print('this part');
                    getData(widget.doctor);
                  }

                  data = resData.data.first;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: kColorBlue,
                        ),
                        child: Row(
                          children: <Widget>[
                            RoundIconButton(
                              onPressed: () {},
                              icon: Icons.person_pin,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${data.doctorName}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  'Contact No : ${data.doctorMobile}',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            PopupMenuButton(
                              icon: Icon(
                                Icons.more_vert,
                                size: 25,
                                color: Colors.white,
                              ),
                              itemBuilder: (context) {
                                return [
                                  PopupMenuItem(
                                    onTap: () async {
                                      await Future.delayed(
                                              const Duration(microseconds: 100))
                                          .then((value) {
                                        Navigator.of(context)
                                            .pushNamed(Routes.editMyDoctor,
                                                arguments: data)
                                            .then((value) {
                                          List data = value;

                                          if (data.first == true) {
                                            getData('${data.last}');
                                          }
                                        });
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15, horizontal: 5),
                                      child: Row(
                                        children: [
                                          Icon(Icons.edit),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text('Edit'),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // PopupMenuDivider(),
                                  PopupMenuItem(
                                    onTap: () async {
                                      await Future.delayed(
                                              const Duration(microseconds: 100))
                                          .then((value) {
                                        _showAlert1(context, () async {
                                          DeleteDoctorRequestModel
                                              requestModel =
                                              DeleteDoctorRequestModel(
                                            patientId: int.parse(
                                                _userController.user.value.id),
                                            id: int.parse(data.id),
                                          );
                                          await addMyDoctorNotesViewModel
                                              .deleteMyDoctor(
                                                  model: requestModel);

                                          Navigator.pop(context);
                                          Navigator.pop(context, true);
                                        });
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15, horizontal: 5),
                                      child: Row(
                                        children: [
                                          Icon(Icons.delete),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text('Delete'),
                                        ],
                                      ),
                                    ),
                                  ),
                                ];
                              },
                            )
                          ],
                        ),
                      ),
                      resData.data.first.notes.isEmpty ||
                              resData.data.first.notes == null
                          ? SizedBox()
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20)
                                      .copyWith(bottom: 10),
                              child: Text(
                                'Notes :',
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    color: _isDark
                                        ? Colors.white.withOpacity(0.8)
                                        : Colors.black.withOpacity(0.8)),
                              ),
                            ),
                      resData.data.first.notes.isEmpty ||
                              resData.data.first.notes == null
                          ? Padding(
                              padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height *
                                      0.32),
                              child: Center(
                                child: Text(
                                  'No Notes',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .copyWith(fontSize: 20),
                                ),
                              ),
                            )
                          : Container(
                              height: MediaQuery.of(context).size.height * 0.7,
                              child: ListView.separated(
                                separatorBuilder: (context, index) {
                                  return SizedBox(
                                    height: 15,
                                  );
                                },
                                itemCount: resData.data.first.notes.length,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 18,
                                ),
                                itemBuilder: (context, index) {
                                  resData.data.first.notes.sort((a, b) =>
                                      b.createdAt.compareTo(a.createdAt));

                                  Note item = resData.data.first.notes[index];

                                  return Card(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                                  horizontal: 10)
                                              .copyWith(top: 5),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                'Date : ',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                item.createdAt == null
                                                    ? ''
                                                    : '${item.createdAt}',
                                                textAlign: TextAlign.center,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle1
                                                    .copyWith(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w500),
                                              ),
                                              Spacer(),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 15),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () async {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  UpdateDocNotesScreen(
                                                                doctor: data,
                                                                notesID:
                                                                    item.id,
                                                              ),
                                                            )).then((value) {
                                                          if (value == true) {
                                                            getData(
                                                                '${widget.doctor}');
                                                          }
                                                        });
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .all(15)
                                                                .copyWith(
                                                                    bottom: 0,
                                                                    right: 0),
                                                        child: Icon(Icons.edit),
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        print(
                                                            'DELETE=====>DELETE');
                                                        _showAlert(context,
                                                            () async {
                                                          DeleteNotesRequestModel
                                                              requestModel =
                                                              DeleteNotesRequestModel(
                                                            patientId: int.parse(
                                                                Prefs.getString(
                                                                    Prefs
                                                                        .SOCIALID)),
                                                            id: int.parse(
                                                                data.id),
                                                            noteId: item.id,
                                                          );
                                                          await addMyDoctorNotesViewModel
                                                              .deleteMyDoctorNotes(
                                                                  model:
                                                                      requestModel)
                                                              .then(
                                                                  (value) async {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            await getData(
                                                                '${widget.doctor}');
                                                          });
                                                        });
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .all(15)
                                                                .copyWith(
                                                                    bottom: 0),
                                                        child:
                                                            Icon(Icons.delete),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Divider(
                                          height: 1,
                                          thickness: 1,
                                          indent: 10,
                                          endIndent: 10,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 50,
                                                child: Text(
                                                  'Note :  ',
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  '${item.note}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle1
                                                      .copyWith(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                    ],
                  );
                } else {
                  return Center(child: Text('Something went wrong'));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  _showAlert(BuildContext context, Function onPressed) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Notes'),
          content: Text("Are You Sure Want To Delete ?"),
          actions: <Widget>[
            TextButton(child: Text("YES"), onPressed: onPressed),
            TextButton(
              child: Text("NO"),
              onPressed: () {
                //Put your code here which you want to execute on No button click.
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _showAlert1(BuildContext context, Function onPressed) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Provider'),
          content: Text("Are You Sure Want To Delete ?"),
          actions: <Widget>[
            TextButton(child: Text("YES"), onPressed: onPressed),
            TextButton(
              child: Text("NO"),
              onPressed: () {
                //Put your code here which you want to execute on No button click.
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
