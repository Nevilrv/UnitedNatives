import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:united_natives/components/text_form_field.dart';
import 'package:united_natives/controller/user_controller.dart';
import 'package:united_natives/medicle_center/lib/utils/translate.dart';
import 'package:united_natives/newModel/apiModel/requestModel/update_my_doctor_request_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/my_doctor_list_reposne_model.dart';
import 'package:united_natives/newModel/apis/api_response.dart';
import 'package:united_natives/utils/common_snackbar.dart';
import 'package:united_natives/utils/utils.dart';
import 'package:united_natives/viewModel/add_my_doctors_and_notes_view_model.dart';

class EditMyDoctorScreen extends StatefulWidget {
  final DoctorData? doctor;

  const EditMyDoctorScreen({super.key, this.doctor});

  @override
  State<EditMyDoctorScreen> createState() => _EditMyDoctorScreenState();
}

class _EditMyDoctorScreenState extends State<EditMyDoctorScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();

  MyDoctorNotesViewModel addMyDoctorNotesViewModel =
      Get.put(MyDoctorNotesViewModel());
  final UserController _userController = Get.find<UserController>();
  @override
  void initState() {
    nameController.text = widget.doctor?.doctorName ?? "";
    mobileNumberController.text = widget.doctor?.doctorMobile ?? "";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log('doctor------NAME---->>>>>>>>${widget.doctor?.doctorName}');
    log('doctor-----MOBILE----->>>>>>>>${widget.doctor?.doctorMobile}');
    return Scaffold(
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          centerTitle: true,
          title: Text(
            Translate.of(context)!.translate('Edit Provider'),
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
                  UpdateDoctorRequestModel requestModel =
                      UpdateDoctorRequestModel(
                    id: int.parse(widget.doctor!.id!),
                    doctorName: nameController.text,
                    contactNumber: mobileNumberController.text,
                    patientId: int.parse(_userController.user.value.id!),
                  );

                  await addMyDoctorNotesViewModel.updateDoctor(
                      model: requestModel);

                  if (addMyDoctorNotesViewModel
                          .addNewDoctorsApiResponse.status ==
                      Status.COMPLETE) {
                    Navigator.pop(context, [true, nameController.text]);

                    CommonSnackBar.snackBar(
                        message: 'Provider details updated');
                  } else if (addMyDoctorNotesViewModel
                          .addNewDoctorsApiResponse.status ==
                      Status.LOADING) {
                  } else {
                    CommonSnackBar.snackBar(
                        message: addMyDoctorNotesViewModel
                            .addNewDoctorsApiResponse.message!);
                  }
                }
              },
              icon: const Icon(
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
              padding: const EdgeInsets.symmetric(
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
          style: Theme.of(context).textTheme.titleMedium,
        ),
        CustomTextFormField(
          textInputAction: TextInputAction.next,
          validator: (text) {
            if (text!.isEmpty) {
              return '*enter provider name';
            }
            return null;
          },
          controller: nameController,
          hintText: 'Enter provider name',
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

  Widget contactWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Contact Number",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        CustomTextFormField(
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.done,
          validator: (text) {
            if (text!.isEmpty) {
              return "*enter doctor's contact number";
            }
            return null;
          },
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          controller: mobileNumberController,
          hintText: 'Enter contact number here',
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
}
