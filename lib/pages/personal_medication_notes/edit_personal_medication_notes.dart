import 'package:doctor_appointment_booking/components/text_form_field.dart';
import 'package:doctor_appointment_booking/controller/user_controller.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/utils/translate.dart';
import 'package:doctor_appointment_booking/newModel/apiModel/requestModel/update_personal_medication_notes_request_model.dart';
import 'package:doctor_appointment_booking/newModel/apiModel/responseModel/get_all_personal_medication_notes_response_model.dart';
import 'package:doctor_appointment_booking/newModel/apis/api_response.dart';
import 'package:doctor_appointment_booking/utils/common_snackbar.dart';
import 'package:doctor_appointment_booking/utils/utils.dart';
import 'package:doctor_appointment_booking/viewModel/personal_medication_notes_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EditPersonalMedicationNotesScreen extends StatefulWidget {
  final PersonalMedicationNotesItemData notesData;

  const EditPersonalMedicationNotesScreen({Key key, this.notesData})
      : super(key: key);

  @override
  State<EditPersonalMedicationNotesScreen> createState() =>
      _EditPersonalMedicationNotesScreenState();
}

class _EditPersonalMedicationNotesScreenState
    extends State<EditPersonalMedicationNotesScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final UserController userController = Get.find();
  TextEditingController titleController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  TextEditingController dateTimeController = TextEditingController();
  PersonalMedicationNotesViewModel personalMedicationNotesViewModel =
      Get.put(PersonalMedicationNotesViewModel());
  DateTime finalDate;

  @override
  void initState() {
    super.initState();

    titleController.text = widget.notesData.title;
    notesController.text = widget.notesData.notes;
    finalDate = widget.notesData.datetime;
    dateTimeController.text = finalDate == null
        ? ''
        : '${DateFormat('EEEE, dd MMM yyyy, hh:mm aa').format(finalDate)}';
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
                fontSize: 24),
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  UpdatePersonalMedicationNotesRequestModel requestModel =
                      UpdatePersonalMedicationNotesRequestModel(
                    title: titleController.text,
                    notes: notesController.text,
                    dateTime: finalDate.toString(),
                    patientId: userController.user.value.id,
                    notesId: widget.notesData.id,
                  );

                  await personalMedicationNotesViewModel
                      .updatePersonalMedicationNotes(model: requestModel);

                  if (personalMedicationNotesViewModel
                          .updatePersonalMedicationNotesApiResponse.status ==
                      Status.COMPLETE) {
                    Navigator.pop(context, [true]);
                    CommonSnackBar.snackBar(
                        message: personalMedicationNotesViewModel
                            .updatePersonalMedicationNotesApiResponse
                            .data
                            .message);
                  } else if (personalMedicationNotesViewModel
                          .updatePersonalMedicationNotesApiResponse.status ==
                      Status.LOADING) {
                  } else if (personalMedicationNotesViewModel
                          .updatePersonalMedicationNotesApiResponse.status ==
                      Status.ERROR) {
                    CommonSnackBar.snackBar(
                        message: personalMedicationNotesViewModel
                            .updatePersonalMedicationNotesApiResponse.message);
                  }
                }
              },
              icon: Icon(
                Icons.done,
              ),
            )
          ],
        ),
        body: GetBuilder<PersonalMedicationNotesViewModel>(
          builder: (controller) {
            if (controller.updatePersonalMedicationNotesApiResponse.status ==
                Status.LOADING) {
              return Center(
                child: Utils.circular(),
              );
              // return Center(child: CircularProgressIndicator());
            }

            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),
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
          style: Theme.of(context).textTheme.subtitle1,
        ),
        CustomTextFormField(
          textInputAction: TextInputAction.next,
          validator: (text) {
            if (text.isEmpty) {
              return '*enter title';
            }
            return null;
          },
          controller: titleController,
          hintText: 'Enter title here',
          hintTextStyle: TextStyle(
            fontSize: 18,
            color: Color(0xffbcbcbc),
            fontFamily: 'NunitoSans',
          ),
        ),
        SizedBox(height: 15),
      ],
    );
  }

  Widget notesWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Notes",
          style: Theme.of(context).textTheme.subtitle1,
        ),
        CustomTextFormField(
          textInputAction: TextInputAction.next,
          validator: (text) {
            if (text.isEmpty) {
              return '*enter notes';
            }
            return null;
          },
          controller: notesController,
          hintText: 'Enter notes here',
          hintTextStyle: TextStyle(
            fontSize: 18,
            color: Color(0xffbcbcbc),
            fontFamily: 'NunitoSans',
          ),
          keyboardType: TextInputType.multiline,
          maxLines: null,
        ),
        SizedBox(height: 15),
      ],
    );
  }

  Widget dateTimeWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Date-Time",
          style: Theme.of(context).textTheme.subtitle1,
        ),
        CustomTextFormField(
          textInputAction: TextInputAction.next,
          validator: (text) {
            if (text.isEmpty) {
              return '*select date-time';
            }
            return null;
          },
          onTap: () async {
            DateTime selectedDate = await showDatePicker(
              context: context,
              initialDate: finalDate ?? DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime(2100),
            );
            print('==selectedDate==>$selectedDate');

            if (selectedDate != null) {
              TimeOfDay selectedTime = await showTimePicker(
                context: context,
                initialTime: finalDate != null
                    ? TimeOfDay(hour: finalDate.hour, minute: finalDate.minute)
                    : TimeOfDay.now(),
              );
              print('==selectedTime==>$selectedTime');

              if (selectedTime != null) {
                finalDate = DateTime(selectedDate.year, selectedDate.month,
                    selectedDate.day, selectedTime.hour, selectedTime.minute);
                dateTimeController.text =
                    '${DateFormat('EEEE, dd MMM yyyy, hh mm aa').format(finalDate)}';
                print('RESULT=====>$finalDate');
                setState(() {});
              }
            }
          },
          controller: dateTimeController,
          hintText: 'Select date-time here',
          readOnly: true,
          hintTextStyle: TextStyle(
            fontSize: 18,
            color: Color(0xffbcbcbc),
            fontFamily: 'NunitoSans',
          ),
          keyboardType: TextInputType.multiline,
          maxLines: null,
        ),
        SizedBox(height: 15),
      ],
    );
  }
}
