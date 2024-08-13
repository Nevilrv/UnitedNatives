import 'dart:developer';
import 'package:united_natives/components/round_icon_button.dart';
import 'package:united_natives/controller/user_controller.dart';
import 'package:united_natives/data/pref_manager.dart';
import 'package:united_natives/medicle_center/lib/utils/translate.dart';
import 'package:united_natives/newModel/apiModel/requestModel/delete_doctor_response_model.dart';
import 'package:united_natives/newModel/apiModel/requestModel/delete_my_doctor_notes_request_model.dart';
import 'package:united_natives/newModel/apiModel/requestModel/my_doctor_list_request_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/my_doctor_list_reposne_model.dart';
import 'package:united_natives/newModel/apis/api_response.dart';
import 'package:united_natives/pages/doctor/edit_my_doctor_notes_page.dart';
import 'package:united_natives/routes/routes.dart';
import 'package:united_natives/utils/constants.dart';
import 'package:united_natives/utils/utils.dart';
import 'package:united_natives/viewModel/add_my_doctors_and_notes_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyDoctorNotesScreen extends StatefulWidget {
  final String? doctor;

  const MyDoctorNotesScreen({super.key, this.doctor});

  @override
  State<MyDoctorNotesScreen> createState() => _MyDoctorNotesScreenState();
}

class _MyDoctorNotesScreenState extends State<MyDoctorNotesScreen> {
  MyDoctorNotesViewModel addMyDoctorNotesViewModel =
      Get.put(MyDoctorNotesViewModel());

  final bool _isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);
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
  final UserController _userController = Get.find<UserController>();
  Future<void> getData(String name) async {
    MyDoctorListRequestModel requestModel = MyDoctorListRequestModel(
      patientId: int.parse(_userController.user.value.id!),
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

    return PopScope(
      onPopInvokedWithResult: (didPop, result) => Navigator.pop(context, true),
      canPop: true,
      child: Scaffold(
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          centerTitle: true,
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context, true);
              },
              child: const Icon(Icons.arrow_back_ios)),
          title: Text(
            Translate.of(context)!.translate('My Provider Notes'),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.titleMedium?.color,
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
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      Navigator.of(context)
                          .pushNamed(Routes.addMyDocNotes, arguments: data)
                          .then((value) {
                        if (value == true) {
                          getData('${widget.doctor}');
                        }
                      });
                    },
                  )
                : const SizedBox(),
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
                          Text(controller.getMyDoctorListApiResponse.message!));
                } else if (controller.getMyDoctorListApiResponse.status ==
                    Status.COMPLETE) {
                  MyDoctorsListDataResponseModel resData =
                      controller.getMyDoctorListApiResponse.data;

                  if (resData.data == null ||
                      resData.data!.isEmpty ||
                      resData.data == []) {
                    getData(widget.doctor!);
                  }

                  data = resData.data?.first;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        padding: const EdgeInsets.all(15),
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
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${data.doctorName}',
                                  style: const TextStyle(
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
                            const Spacer(),
                            PopupMenuButton(
                              icon: const Icon(
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
                                          List data = value as List;

                                          if (data.first == true) {
                                            getData('${data.last}');
                                          }
                                        });
                                      });
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
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
                                                _userController.user.value.id!),
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
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
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
                      resData.data!.first.notes!.isEmpty ||
                              resData.data!.first.notes == null
                          ? const SizedBox()
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
                      if (resData.data!.first.notes!.isEmpty ||
                          resData.data?.first.notes == null)
                        Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.32),
                          child: Center(
                            child: Text(
                              'No Notes',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(fontSize: 20),
                            ),
                          ),
                        )
                      else
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: ListView.separated(
                            separatorBuilder: (context, index) {
                              return const SizedBox(
                                height: 15,
                              );
                            },
                            itemCount: resData.data!.first.notes!.length,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                            ),
                            itemBuilder: (context, index) {
                              resData.data?.first.notes?.sort((a, b) =>
                                  b.createdAt!.compareTo(a.createdAt!));

                              Note item = resData.data!.first.notes![index];

                              return Card(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                          const Text(
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
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            item.createdAt == null
                                                ? ''
                                                : '${item.createdAt}',
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w500),
                                          ),
                                          const Spacer(),
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
                                                            notesID: item.id,
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
                                                        const EdgeInsets.all(15)
                                                            .copyWith(
                                                                bottom: 0,
                                                                right: 0),
                                                    child:
                                                        const Icon(Icons.edit),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    _showAlert(context,
                                                        () async {
                                                      DeleteNotesRequestModel
                                                          requestModel =
                                                          DeleteNotesRequestModel(
                                                        patientId: int.parse(
                                                            Prefs.getString(Prefs
                                                                    .SOCIALID) ??
                                                                ""),
                                                        id: int.parse(data.id),
                                                        noteId: item.id,
                                                      );
                                                      await addMyDoctorNotesViewModel
                                                          .deleteMyDoctorNotes(
                                                              model:
                                                                  requestModel)
                                                          .then((value) async {
                                                        Navigator.of(context)
                                                            .pop();
                                                        await getData(
                                                            '${widget.doctor}');
                                                      });
                                                    });
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(15)
                                                            .copyWith(
                                                                bottom: 0),
                                                    child: const Icon(
                                                        Icons.delete),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    const Divider(
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
                                          const SizedBox(
                                            width: 50,
                                            child: Text(
                                              'Note :  ',
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w400,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              '${item.note}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.copyWith(
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
                  return const Center(child: Text('Something went wrong'));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  _showAlert(BuildContext context, Function() onPressed) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Notes'),
          content: const Text("Are You Sure Want To Delete ?"),
          actions: <Widget>[
            TextButton(onPressed: onPressed, child: const Text("YES")),
            TextButton(
              child: const Text("NO"),
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

  _showAlert1(BuildContext context, Function() onPressed) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Provider'),
          content: const Text("Are You Sure Want To Delete ?"),
          actions: <Widget>[
            TextButton(onPressed: onPressed, child: const Text("YES")),
            TextButton(
              child: const Text("NO"),
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
