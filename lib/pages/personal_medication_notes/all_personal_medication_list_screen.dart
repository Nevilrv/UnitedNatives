import 'package:doctor_appointment_booking/controller/user_controller.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/utils/translate.dart';
import 'package:doctor_appointment_booking/newModel/apiModel/requestModel/delete_personal_medication_notes_request_model.dart';
import 'package:doctor_appointment_booking/newModel/apiModel/requestModel/get_all_personal_medication_notes_request_model.dart';
import 'package:doctor_appointment_booking/newModel/apiModel/responseModel/get_all_personal_medication_notes_response_model.dart';
import 'package:doctor_appointment_booking/newModel/apis/api_response.dart';
import 'package:doctor_appointment_booking/pages/personal_medication_notes/edit_personal_medication_notes.dart';
import 'package:doctor_appointment_booking/pages/personal_medication_notes/personal_medication_item.dart';
import 'package:doctor_appointment_booking/routes/routes.dart';
import 'package:doctor_appointment_booking/utils/constants.dart';
import 'package:doctor_appointment_booking/utils/utils.dart';
import 'package:doctor_appointment_booking/viewModel/personal_medication_notes_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PersonalMedicationListScreen extends StatefulWidget {
  const PersonalMedicationListScreen({super.key});

  @override
  State<PersonalMedicationListScreen> createState() =>
      _PersonalMedicationListScreenState();
}

class _PersonalMedicationListScreenState
    extends State<PersonalMedicationListScreen> {
  PersonalMedicationNotesViewModel personalMedicationNotesViewModel =
      Get.put(PersonalMedicationNotesViewModel());
  final UserController userController = Get.find();
  void getData() {
    GetAllPersonalMedicationNotesRequestModel requestModel =
        GetAllPersonalMedicationNotesRequestModel(
      patientId: int.parse(userController.user.value.id),
    );

    personalMedicationNotesViewModel.getAllPersonalMedicationNotes(
        model: requestModel);
  }

  void deleteNotes({String notesId}) {
    DeletePersonalMedicationNotesRequestModel requestModel =
        DeletePersonalMedicationNotesRequestModel(
      patientId: userController.user.value.id,
      notesId: notesId,
    );

    personalMedicationNotesViewModel.deletePersonalMedicationNotes(
        model: requestModel);
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          Translate.of(context).translate('personal_notes'),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.subtitle1.color,
            fontSize: 24,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kColorBlue,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () async {
          final result = await Navigator.of(context)
              .pushNamed(Routes.addPersonalMedicationNotes);
          if (result != null) {
            getData();
          }
        },
      ),
      body: GetBuilder<PersonalMedicationNotesViewModel>(
        builder: (controller) {
          if (controller.getAllPersonalMedicationNotesApiResponse.status ==
              Status.LOADING) {
            return Center(
              child: Utils.circular(),
            );
          }
          if (controller.getAllPersonalMedicationNotesApiResponse.status ==
              Status.ERROR) {
            return Center(
                child: Text(controller
                    .getAllPersonalMedicationNotesApiResponse.message));
          }

          GetAllPersonalMedicationNotesResponseModel response =
              controller.getAllPersonalMedicationNotesApiResponse.data;

          if (response.data.isEmpty) {
            return Center(
                child: Text(
              'No Data',
              style: TextStyle(fontSize: 21),
            ));
          }

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(
                    height: 15,
                  ),
                  itemCount: response.data.length,
                  padding: EdgeInsets.symmetric(
                    vertical: 35,
                    horizontal: 20,
                  ),
                  itemBuilder: (context, index) {
                    return PersonalMedicationItem(
                      item: response.data[index],
                      onDeletePress: () {
                        print('DELETE=====>DELETE');
                        _showAlert(context, () {
                          deleteNotes(notesId: response.data[index].id);
                          Navigator.of(context).pop();
                          getData();
                        });
                      },
                      onEditPress: () async {
                        final result =
                            await Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              EditPersonalMedicationNotesScreen(
                            notesData: response.data[index],
                          ),
                        ));

                        if (result != null) {
                          getData();
                        }

                        print('EDIT=====>EDIT');
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  _showAlert(BuildContext context, Function onPressed) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Personal Medication Notes'),
          content: Text("Are You Sure Want To Delete ?"),
          actions: <Widget>[
            FlatButton(child: Text("YES"), onPressed: onPressed),
            FlatButton(
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
