import 'package:doctor_appointment_booking/components/text_form_field.dart';
import 'package:doctor_appointment_booking/controller/user_controller.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/utils/translate.dart';
import 'package:doctor_appointment_booking/newModel/apiModel/requestModel/add_my_doctors_request_model.dart';
import 'package:doctor_appointment_booking/newModel/apis/api_response.dart';
import 'package:doctor_appointment_booking/utils/common_snackbar.dart';
import 'package:doctor_appointment_booking/utils/utils.dart';
import 'package:doctor_appointment_booking/viewModel/add_my_doctors_and_notes_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class AddMyDoctorScreen extends StatefulWidget {
  // final DoctorData doctor;

  const AddMyDoctorScreen({super.key});

  @override
  State<AddMyDoctorScreen> createState() => _AddMyDoctorScreenState();
}

class _AddMyDoctorScreenState extends State<AddMyDoctorScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();

  MyDoctorNotesViewModel addMyDoctorNotesViewModel =
      Get.put(MyDoctorNotesViewModel());
  UserController _userController = Get.find<UserController>();
  @override
  void initState() {
    // nameController.text = widget.doctor.doctorName ?? "";
    // mobileNumberController.text = widget.doctor.doctorMobile ?? "";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            Translate.of(context).translate('Add Provider'),
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
                  AddMyDoctorRequestModel requestModel =
                      AddMyDoctorRequestModel(
                    doctorName: nameController.text,
                    contactNumber: mobileNumberController.text,
                    patientId: int.parse(_userController.user.value.id),
                  );

                  await addMyDoctorNotesViewModel.addNewDoctor(
                      model: requestModel);

                  if (addMyDoctorNotesViewModel
                          .addNewDoctorsApiResponse.status ==
                      Status.COMPLETE) {
                    Navigator.pop(context, [true]);
                    CommonSnackBar.snackBar(
                        message: addMyDoctorNotesViewModel
                            .addNewDoctorsApiResponse.data.message);
                  } else if (addMyDoctorNotesViewModel
                          .addNewDoctorsApiResponse.status ==
                      Status.LOADING) {
                  } else {
                    CommonSnackBar.snackBar(
                        message: addMyDoctorNotesViewModel
                            .addNewDoctorsApiResponse.message);
                  }
                }
              },
              icon: Icon(
                Icons.done,
              ),
            )
          ],
        ),
        body: GetBuilder<MyDoctorNotesViewModel>(
          builder: (controller) {
            if (controller.addNewDoctorsApiResponse.status == Status.LOADING) {
              // return Center(child: CircularProgressIndicator());
              return Center(
                child: Utils.circular(),
              );
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
                      nameWidget(),
                      contactWidget(),
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }

  Widget nameWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Name",
          style: Theme.of(context).textTheme.subtitle1,
        ),
        CustomTextFormField(
          textInputAction: TextInputAction.next,
          validator: (text) {
            if (text.isEmpty) {
              return '*enter provider name';
            }
            return null;
          },
          controller: nameController,
          hintText: 'Enter provider name',
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

  Widget contactWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Contact Number",
          style: Theme.of(context).textTheme.subtitle1,
        ),
        CustomTextFormField(
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.done,
          validator: (text) {
            if (text.isEmpty) {
              return "*enter provider's contact number";
            }
            return null;
          },
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          controller: mobileNumberController,
          hintText: 'Enter contact number here',
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
}
