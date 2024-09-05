import 'package:united_natives/viewModel/user_controller.dart';
import 'package:united_natives/medicle_center/lib/utils/translate.dart';
import 'package:united_natives/requestModel/delete_personal_medication_notes_request_model.dart';
import 'package:united_natives/requestModel/get_all_personal_medication_notes_request_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/get_all_personal_medication_notes_response_model.dart';
import 'package:united_natives/newModel/apis/api_response.dart';
import 'package:united_natives/pages/personal_medication_notes/edit_personal_medication_notes.dart';
import 'package:united_natives/pages/personal_medication_notes/personal_medication_item.dart';
import 'package:united_natives/routes/routes.dart';
import 'package:united_natives/utils/constants.dart';
import 'package:united_natives/utils/utils.dart';
import 'package:united_natives/viewModel/personal_medication_notes_view_model.dart';
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
      patientId: int.parse(userController.user.value.id!),
    );

    personalMedicationNotesViewModel.getAllPersonalMedicationNotes(
        model: requestModel);
  }

  void deleteNotes({required String notesId}) {
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
          Translate.of(context)!.translate('personal_notes'),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.titleMedium?.color,
            fontSize: 24,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kColorBlue,
        child: const Icon(
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
                        .getAllPersonalMedicationNotesApiResponse.message ??
                    ""));
          }

          GetAllPersonalMedicationNotesResponseModel response =
              controller.getAllPersonalMedicationNotesApiResponse.data;

          if (response.data!.isEmpty) {
            return const Center(
                child: Text(
              'No Data',
              style: TextStyle(fontSize: 21),
            ));
          }

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 15,
                  ),
                  itemCount: response.data!.length,
                  padding: const EdgeInsets.symmetric(
                    vertical: 35,
                    horizontal: 20,
                  ),
                  itemBuilder: (context, index) {
                    return PersonalMedicationItem(
                      item: response.data?[index],
                      onDeletePress: () {
                        _showAlert(context, () {
                          deleteNotes(notesId: response.data![index].id!);
                          Navigator.of(context).pop();
                          getData();
                        });
                      },
                      onEditPress: () async {
                        final result =
                            await Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              EditPersonalMedicationNotesScreen(
                            notesData: response.data?[index],
                          ),
                        ));

                        if (result != null) {
                          getData();
                        }
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

  _showAlert(BuildContext context, Function() onPressed) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Delete Notes',
            style: TextStyle(fontSize: 24),
          ),
          content: const Text(
            "Are you sure want to delete the personal note ?",
            style: TextStyle(fontSize: 22),
          ),
          actions: <Widget>[
            MaterialButton(
                onPressed: onPressed,
                child: const Text(
                  "Yes",
                  style: TextStyle(fontSize: 20),
                )),
            MaterialButton(
              child: const Text(
                "No",
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
