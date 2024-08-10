import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:united_natives/controller/user_controller.dart';
import 'package:united_natives/medicle_center/lib/utils/translate.dart';
import 'package:united_natives/utils/common_snackbar.dart';
import 'package:united_natives/utils/utils.dart';
import 'package:united_natives/viewModel/my_clinician_screen_view_model.dart';

class AddIHNotesScreen extends StatefulWidget {
  final doctorId;

  const AddIHNotesScreen({super.key, this.doctorId});

  @override
  State<AddIHNotesScreen> createState() => _AddIHNotesScreenState();
}

class _AddIHNotesScreenState extends State<AddIHNotesScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final textController = TextEditingController();
  // bool isLoad = false;
  // TextEditingController text = TextEditingController();
  /// post ////
  // Future addNotesRepo({var patientId, var doctorId, String notes}) async {
  //   setState(() {
  //     isLoad = true;
  //   });
  //   var headers = {
  //     // 'Authorization': 'Bearer 81dc9bdb52d04dc20036dbd8313ed055',
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
  final UserController userController = Get.find();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyClinicianScreenViewModel>(builder: (controller) {
      return PopScope(
        canPop: true,
        onPopInvokedWithResult: (didPop, result) {
          textController.clear();
        },
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
                textController.clear();
              },
              child: const Icon(
                Icons.arrow_back_ios,
                color: Colors.blue,
              ),
            ),
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
                    await controller.addNotesRepo(
                        doctorId: '${widget.doctorId}',
                        patientId: '${userController.user.value.id}',
                        notes: textController.text);
                    Navigator.pop(context, true);
                    textController.clear();
                    CommonSnackBar.snackBar(
                        message: 'Note added successfully.');
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
          style: const TextStyle(
            fontSize: 22,
          ),
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
              fontSize: 22,
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
}
