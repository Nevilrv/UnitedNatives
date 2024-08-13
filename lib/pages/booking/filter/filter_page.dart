import 'package:united_natives/controller/book_appointment_controller.dart';
import 'package:united_natives/controller/user_controller.dart';
import 'package:united_natives/medicle_center/lib/utils/translate.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import '../../../components/custom_button.dart';
import '../../../data/pref_manager.dart';
import '../../../utils/constants.dart';

class FilterPage extends StatefulWidget {
  final String? id;
  final String? medicalCenterIid;

  const FilterPage({
    super.key,
    this.id,
    this.medicalCenterIid,
  });

  @override
  _FilterPageState createState() {
    return _FilterPageState();
  }
}

BookAppointmentController _bookAppointmentController =
    Get.find<BookAppointmentController>();
UserController _userController = Get.find();

enum Availability { anyDay, today, next3Days, commingWeekend }

enum ConsultationFee { free, range1, range2, range3, range4 }

class _FilterPageState extends State<FilterPage> {
  final bool _isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);
  late Color _color;
  Availability _availability = Availability.anyDay;
  ConsultationFee _consultationFee = ConsultationFee.free;
  bool _male = true;
  bool _female = true;

  @override
  void initState() {
    super.initState();
    _color = (_isDark ? Colors.white.withOpacity(0.12) : Colors.grey[200])!;
  }

  @override
  Widget build(BuildContext context) {
    // print('${_availability.index}');
    // print('${_consultationFee.toString()}');
    // print('${_male.toString()}');
    // print('${_female.toString()}');
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: kColorBlue,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.close,
            color: Colors.white,
          ),
        ),
        title: Text(
          Translate.of(context)!.translate('filter'),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // SortWidget(
                      //   color: _color,
                      // ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            color: _color,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 15),
                              child: Text(
                                Translate.of(context)!
                                    .translate('availability'),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          RadioListTile(
                            value: Availability.anyDay,
                            onChanged: (value) {
                              setState(() {
                                _availability = value!;
                              });
                            },
                            groupValue: _availability,
                            title: Text(
                              Translate.of(context)!
                                  .translate('available_any_day'),
                            ),
                          ),
                          RadioListTile(
                            value: Availability.today,
                            onChanged: (value) {
                              setState(() {
                                _availability = value!;
                              });
                            },
                            groupValue: _availability,
                            title: Text(
                              Translate.of(context)!
                                  .translate('available_today'),
                            ),
                          ),
                          RadioListTile(
                            value: Availability.next3Days,
                            onChanged: (value) {
                              setState(() {
                                _availability = value!;
                              });
                            },
                            groupValue: _availability,
                            title: Text(
                              Translate.of(context)!
                                  .translate('available_in_next_3_days'),
                            ),
                          ),
                          RadioListTile(
                            value: Availability.commingWeekend,
                            onChanged: (value) {
                              setState(() {
                                _availability = value!;
                              });
                            },
                            groupValue: _availability,
                            title: Text(
                              Translate.of(context)!
                                  .translate('available_coming_weekend'),
                            ),
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            color: _color,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 15),
                              child: Text(
                                Translate.of(context)!.translate('gender'),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          CheckboxListTile(
                            value: _male,
                            onChanged: (value) {
                              setState(() {
                                _male = value!;
                              });
                            },
                            title: Text(
                              Translate.of(context)!.translate('male_doctor'),
                            ),
                          ),
                          CheckboxListTile(
                            value: _female,
                            onChanged: (value) {
                              setState(() {
                                _female = value!;
                              });
                            },
                            title: Text(
                              Translate.of(context)!.translate('female_doctor'),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            color: _color,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 15),
                              child: Text(
                                Translate.of(context)!
                                    .translate('consultaion_fee'),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          RadioListTile(
                            value: ConsultationFee.free,
                            onChanged: (value) {
                              setState(() {
                                _consultationFee = value!;
                              });
                            },
                            groupValue: _consultationFee,
                            title: Text(
                              Translate.of(context)!.translate('free'),
                            ),
                          ),
                          RadioListTile(
                            value: ConsultationFee.range1,
                            onChanged: (value) {
                              setState(() {
                                _consultationFee = value!;
                              });
                            },
                            groupValue: _consultationFee,
                            title: const Text('1-50'),
                          ),
                          RadioListTile(
                            value: ConsultationFee.range2,
                            onChanged: (value) {
                              setState(() {
                                _consultationFee = value!;
                              });
                            },
                            groupValue: _consultationFee,
                            title: const Text('51-100'),
                          ),
                          RadioListTile(
                            value: ConsultationFee.range3,
                            onChanged: (value) {
                              setState(() {
                                _consultationFee = value!;
                              });
                            },
                            groupValue: _consultationFee,
                            title: const Text('101-150'),
                          ),
                          RadioListTile(
                            value: ConsultationFee.range4,
                            onChanged: (value) {
                              setState(() {
                                _consultationFee = value!;
                              });
                            },
                            groupValue: _consultationFee,
                            title: const Text('151+'),
                          )
                        ],
                      ),
                      Container(
                        width: double.infinity,
                        height: 10,
                        color: _color,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: CustomButton(
                textSize: 24,
                onPressed: () async {
                  Navigator.of(context).pop();
                  // await _userController.userRegister(userData, 2, useProfilePic: _image);
                  // _patientHomeScreenController.addPatientAppointment(
                  //   _userController.user.value.id,
                  //   widget.doctorDetails.id,
                  //   _purposeOfVisitController.text,
                  //   "26-11-2020",
                  //   "9:30 AM",
                  //   _patient ?? true ? 'self' : 'someone else',
                  //   _patient ?? true
                  //       ? _userController.user.value.firstName
                  //       : _nameController.text,
                  //   _patient ?? true ? 'NA' : _patientPhoneController.text,
                  //   _emailController.text,
                  //   _phoneController.text,
                  // );

                  await _bookAppointmentController.getFilteredDoctor(
                      '0',
                      _userController.user.value.id,
                      '${_availability.index}',
                      _male == true ? 'male' : 'female',
                      '${_consultationFee.index}',
                      "${widget.medicalCenterIid}");
                  // Navigator.of(context).pop();
                  // print("Nisarg1111=====>${_bookAppointmentController.doctorSpecialitiesFilterData.value.specialityId}");
                },
                text: Translate.of(context)!.translate('apply'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
