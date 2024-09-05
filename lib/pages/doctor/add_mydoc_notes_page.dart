import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:united_natives/viewModel/user_controller.dart';
import 'package:united_natives/medicle_center/lib/utils/translate.dart';
import 'package:united_natives/newModel/apiModel/responseModel/my_doctor_list_reposne_model.dart';
import 'package:united_natives/utils/common_snackbar.dart';
import 'package:united_natives/utils/utils.dart';
import 'package:united_natives/viewModel/my_clinician_screen_view_model.dart';

class AddMyDocNotesScreen extends StatefulWidget {
  final DoctorData? doctor;

  const AddMyDocNotesScreen({super.key, this.doctor});

  @override
  State<AddMyDocNotesScreen> createState() => _AddMyDocNotesScreenState();
}

class _AddMyDocNotesScreenState extends State<AddMyDocNotesScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final textController = TextEditingController();
  final UserController userController = Get.find();
  // TextEditingController text = TextEditingController();
  // bool isLoad = false;
  /// post ////
  // Future addNotesRepo({var patientId, var doctorId, String notes}) async {
  //   setState(() {
  //     isLoad = true;
  //   });
  //
  //   var headers = {
  //     "Authorization": 'Bearer ${Prefs.getString(Prefs.BEARER)}',
  //     'Content-Type': 'application/json',
  //   };
  //
  //   var body = json.encode(
  //       {"patient_id": '$patientId', "doctor_id": doctorId, "notes": notes});
  //
  //   print("body----- $body");
  //   http.Response response = await http.post(
  //     Uri.parse(
  //       '${Constants.baseUrl}Patient/notes',
  //     ),
  //     body: body,
  //     headers: headers,
  //   );
  //   if (response.statusCode == 200) {
  //     setState(() {
  //       isLoad = false;
  //     });
  //     var result = jsonDecode(response.body);
  //     print('=====responseAddnote$result');
  //     return result;
  //   } else {
  //     setState(() {
  //       isLoad = false;
  //     });
  //     CommonSnackBar.snackBar(
  //         message: 'Something went wrong please try again !');
  //   }
  // }

  MyClinicianScreenViewModel myClinicianScreenViewModel =
      Get.put(MyClinicianScreenViewModel());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyClinicianScreenViewModel>(builder: (controller) {
      return PopScope(
        canPop: true,
        onPopInvoked: (didPop) {
          textController.clear();
        },
        child: Scaffold(
          appBar: AppBar(
            surfaceTintColor: Colors.transparent,
            centerTitle: true,
            title: Text(
              Translate.of(context)!.translate('Add Notes'),
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
                    await controller.addNotesRepo1(
                        mobile: widget.doctor?.doctorMobile ?? "",
                        doctorName: widget.doctor?.doctorName ?? "",
                        patientId: '${userController.user.value.id}',
                        notes: textController.text);
                    textController.clear();
                    CommonSnackBar.snackBar(
                        message: 'Note added successfully.');
                    Navigator.pop(context, true);
                  }

                  // model.print('add');
                },
                icon: const Icon(
                  Icons.done,
                ),
              )
            ],
          ),
          body: controller.isLoad
              // ? Center(child: CircularProgressIndicator())
              ? Center(
                  child: Utils.circular(),
                )
              : Padding(
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
                          // titleWidget(),
                          notesWidget(),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      );
    });
  }
  //
  // Widget titleWidget() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         "Name",
  //         style: Theme.of(context).textTheme.subtitle1,
  //       ),
  //       CustomTextFormField(
  //         textInputAction: TextInputAction.next,
  //         validator: (text) {
  //           if (text.isEmpty) {
  //             return '*enter doctor name';
  //           }
  //           return null;
  //         },
  //         controller: nameController,
  //         hintText: 'Enter doctor name',
  //         hintTextStyle: TextStyle(
  //           fontSize: 18,
  //           color: Color(0xffbcbcbc),
  //           fontFamily: 'NunitoSans',
  //         ),
  //       ),
  //       SizedBox(height: 15),
  //     ],
  //   );
  // }

  Widget notesWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Enter Note",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 22,
              ),
        ),
        const SizedBox(
          height: 15,
        ),
        TextFormField(
          style: const TextStyle(fontSize: 20),
          validator: (text) {
            if (text!.isEmpty) {
              return "*enter notes";
            }
            return null;
          },
          textInputAction: TextInputAction.done,
          controller: textController,
          minLines: 5,
          maxLines: 20,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(15),
            hintText: 'Enter notes here',
            hintStyle: const TextStyle(
              fontSize: 20,
              color: Color(0xffbcbcbc),
              fontFamily: 'NunitoSans',
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: const Color(0xff575757).withOpacity(0.5),
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color(0xff575757),
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.red,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color(0xff575757),
              ),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
        // CustomTextFormField(
        //   validator: (text) {
        //     if (text.isEmpty) {
        //       return "*enter notes";
        //     }
        //     return null;
        //   },
        //   controller: controller.text,
        //   hintText: 'Enter notes here',
        //   hintTextStyle: TextStyle(
        //     fontSize: 18,
        //     color: Color(0xffbcbcbc),
        //     fontFamily: 'NunitoSans',
        //   ),
        // ),
        // SizedBox(height: 15),
      ],
    );
  }

  // Widget notesWidget(controller) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         "Enter Note",
  //         style: Theme.of(context).textTheme.subtitle1,
  //       ),
  //       CustomTextFormField(
  //         validator: (text) {
  //           if (text.isEmpty) {
  //             return "*enter notes";
  //           }
  //           return null;
  //         },
  //         inputFormatters: [
  //           FilteringTextInputFormatter.digitsOnly,
  //           LengthLimitingTextInputFormatter(10),
  //         ],
  //         controller: controller.text,
  //         hintText: 'Enter notes here',
  //         hintTextStyle: TextStyle(
  //           fontSize: 18,
  //           color: Color(0xffbcbcbc),
  //           fontFamily: 'NunitoSans',
  //         ),
  //       ),
  //       SizedBox(height: 15),
  //     ],
  //   );
  // }
}
