import 'package:doctor_appointment_booking/controller/user_controller.dart';
import 'package:doctor_appointment_booking/utils/common_snackbar.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/utils/translate.dart';
import 'package:doctor_appointment_booking/newModel/apiModel/responseModel/my_doctor_list_reposne_model.dart';
import 'package:doctor_appointment_booking/utils/utils.dart';
import 'package:doctor_appointment_booking/viewModel/my_clinician_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class AddMyDocNotesScreen extends StatefulWidget {
  final DoctorData doctor;

  const AddMyDocNotesScreen({Key key, this.doctor}) : super(key: key);

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
      return WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          textController.clear();
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              Translate.of(context).translate('Add Notes'),
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
                    await controller.addNotesRepo1(
                        mobile: widget.doctor.doctorMobile,
                        doctorName: widget.doctor.doctorName,
                        patientId: '${userController.user.value.id}',
                        notes: textController.text);
                    textController.clear();
                    CommonSnackBar.snackBar(
                        message: 'Note added successfully.');
                    Navigator.pop(context, true);
                  }

                  // model.print('add');
                },
                icon: Icon(
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
          style: Theme.of(context).textTheme.subtitle1.copyWith(
                fontSize: 22,
              ),
        ),
        SizedBox(
          height: 15,
        ),
        TextFormField(
          style: TextStyle(fontSize: 20),
          validator: (text) {
            if (text.isEmpty) {
              return "*enter notes";
            }
            return null;
          },
          textInputAction: TextInputAction.done,
          controller: textController,
          minLines: 5,
          maxLines: 20,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(15),
            hintText: 'Enter notes here',
            hintStyle: TextStyle(
              fontSize: 20,
              color: Color(0xffbcbcbc),
              fontFamily: 'NunitoSans',
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xff575757).withOpacity(0.5),
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xff575757),
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
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
