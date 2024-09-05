import 'package:united_natives/components/text_form_field.dart';
import 'package:united_natives/viewModel/user_controller.dart';
import 'package:united_natives/medicle_center/lib/utils/translate.dart';
import 'package:united_natives/requestModel/add_personal_medication_notes_req_model.dart';
import 'package:united_natives/newModel/apis/api_response.dart';
import 'package:united_natives/utils/common_snackbar.dart';
import 'package:united_natives/utils/utils.dart';
import 'package:united_natives/viewModel/personal_medication_notes_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddPersonalMedicationNotesScreen extends StatefulWidget {
  const AddPersonalMedicationNotesScreen({super.key});

  @override
  State<AddPersonalMedicationNotesScreen> createState() =>
      _AddPersonalMedicationNotesScreenState();
}

class _AddPersonalMedicationNotesScreenState
    extends State<AddPersonalMedicationNotesScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  TextEditingController dateTimeController = TextEditingController();
  PersonalMedicationNotesViewModel personalMedicationNotesViewModel =
      Get.put(PersonalMedicationNotesViewModel());
  DateTime? finalDate;
  final UserController _userController = Get.find<UserController>();
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
                fontSize: 24),
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  AddPersonalMedicationNotesRequestModel requestModel =
                      AddPersonalMedicationNotesRequestModel(
                    title: titleController.text,
                    notes: notesController.text,
                    dateTime: finalDate.toString(),
                    patientId: int.parse(_userController.user.value.id!),
                  );

                  await personalMedicationNotesViewModel
                      .addPersonalMedicationNotes(model: requestModel);

                  if (personalMedicationNotesViewModel
                          .addNewPersonalMedicationNotesApiResponse.status ==
                      Status.COMPLETE) {
                    if (!context.mounted) return;

                    Navigator.pop(context, [true]);
                    CommonSnackBar.snackBar(
                        message: personalMedicationNotesViewModel
                            .addNewPersonalMedicationNotesApiResponse
                            .data
                            .message);
                  } else if (personalMedicationNotesViewModel
                          .addNewPersonalMedicationNotesApiResponse.status ==
                      Status.LOADING) {
                  } else {
                    CommonSnackBar.snackBar(
                        message: personalMedicationNotesViewModel
                                .addNewPersonalMedicationNotesApiResponse
                                .message ??
                            "");
                  }
                }
              },
              icon: const Icon(Icons.done),
            )
          ],
        ),
        body: GetBuilder<PersonalMedicationNotesViewModel>(
          builder: (controller) {
            if (controller.addNewPersonalMedicationNotesApiResponse.status ==
                Status.LOADING) {
              return Center(
                child: Utils.circular(),
              );
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ///TITLE
                      titleWidget(),

                      ///Notes
                      notesWidget(),

                      ///Date/Time
                      dateTimeWidget(),
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }

  Widget titleWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Title",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        CustomTextFormField(
          textInputAction: TextInputAction.next,
          validator: (text) {
            if (text!.isEmpty) {
              return '*enter title';
            }
            return null;
          },
          controller: titleController,
          hintText: 'Enter title here',
          hintTextStyle: const TextStyle(
            fontSize: 18,
            color: Color(0xffbcbcbc),
            fontFamily: 'NunitoSans',
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget notesWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Notes",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        CustomTextFormField(
          textInputAction: TextInputAction.next,
          validator: (text) {
            if (text!.isEmpty) {
              return '*enter notes';
            }
            return null;
          },
          controller: notesController,
          hintText: 'Enter notes here',
          hintTextStyle: const TextStyle(
            fontSize: 18,
            color: Color(0xffbcbcbc),
            fontFamily: 'NunitoSans',
          ),
          keyboardType: TextInputType.multiline,
          maxLines: null,
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget dateTimeWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Date-Time",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        CustomTextFormField(
          textInputAction: TextInputAction.next,
          validator: (text) {
            if (text!.isEmpty) {
              return '*select date-time';
            }
            return null;
          },
          onTap: () async {
            DateTime? selectedDate = await showDatePicker(
              context: context,
              initialDate: finalDate ?? DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime(2100),
            );

            if (selectedDate != null) {
              if (!mounted) return;
              TimeOfDay? selectedTime = await showTimePicker(
                context: context,
                initialTime: finalDate != null
                    ? TimeOfDay(
                        hour: finalDate!.hour, minute: finalDate!.minute)
                    : TimeOfDay.now(),
              );

              if (selectedTime != null) {
                finalDate = DateTime(selectedDate.year, selectedDate.month,
                    selectedDate.day, selectedTime.hour, selectedTime.minute);
                dateTimeController.text =
                    DateFormat('EEEE, dd MMM yyyy, hh:mm aa')
                        .format(finalDate!);
                setState(() {});
              }
            }
          },
          controller: dateTimeController,
          hintText: 'Select date-time here',
          readOnly: true,
          hintTextStyle: const TextStyle(
            fontSize: 18,
            color: Color(0xffbcbcbc),
            fontFamily: 'NunitoSans',
          ),
          keyboardType: TextInputType.multiline,
          maxLines: null,
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
