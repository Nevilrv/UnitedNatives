import 'package:doctor_appointment_booking/controller/doctor_homescreen_controller.dart';
import 'package:doctor_appointment_booking/model/doctor_get_doctor_Appointments_model.dart';
import 'package:doctor_appointment_booking/routes/routes.dart';
import 'package:doctor_appointment_booking/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';

import '../../utils/constants.dart';

class AddPrescription extends StatefulWidget {
  final PatientAppoint patientAppoint;

  AddPrescription({this.patientAppoint});

  @override
  _AddPrescriptionState createState() => _AddPrescriptionState();
}

class _AddPrescriptionState extends State<AddPrescription> {
  bool morning = false;
  bool afternoon = false;
  bool night = false;
  bool isLoading = false;
  List<String> medicineTime = [];

  TextEditingController _medicineNameController = TextEditingController();
  TextEditingController _pillsPerDayController = TextEditingController();
  TextEditingController _additionalNoteController = TextEditingController();
  TextEditingController _daysOfTreatController = TextEditingController();

  DoctorHomeScreenController _doctorHomeScreenController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0.0,
            centerTitle: true,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Feather.chevron_left,
                size: 30,
              ),
            ),
            title: Text(
              'Add Prescription',
              style: TextStyle(
                fontSize: 23,
                color: Theme.of(context).textTheme.subtitle1.color,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      'Medicine name',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.subtitle1.color,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: kColorDarkBlue,
                            blurRadius: 10,
                            offset: Offset(2, 3),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _medicineNameController,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.subtitle1.color,
                        ),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter medicine name',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            )),
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      'When to take?',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.subtitle1.color,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              morning = !morning;
                              if (morning == true) {
                                medicineTime.add("Morning");
                              } else {
                                medicineTime.remove("Morning");
                              }
                            });
                          },
                          child: TimeCard(
                            icon: Feather.sunrise,
                            time: 'Morning',
                            isSelected: morning,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              afternoon = !afternoon;
                              if (afternoon == true) {
                                medicineTime.add("Afternoon");
                              } else {
                                medicineTime.remove("Afternoon");
                              }
                            });
                          },
                          child: TimeCard(
                            icon: Feather.sun,
                            time: 'Afternoon',
                            isSelected: afternoon,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              night = !night;
                              if (night == true) {
                                medicineTime.add("Night");
                              } else {
                                medicineTime.remove("Night");
                              }
                            });
                          },
                          child: TimeCard(
                            icon: Feather.moon,
                            time: 'Night',
                            isSelected: night,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Additional notes',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.subtitle1.color,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      height: 80,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: kColorDarkBlue,
                            blurRadius: 10,
                            offset: Offset(2, 3),
                          ),
                        ],
                      ),
                      child: TextField(
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.text,
                        controller: _additionalNoteController,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.subtitle1.color,
                        ),
                        maxLines: 2,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Additional notes...',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Days of Treat',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.subtitle1.color,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: kColorDarkBlue,
                            blurRadius: 10,
                            offset: Offset(2, 3),
                          ),
                        ],
                      ),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: _daysOfTreatController,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.subtitle1.color,
                        ),
                        maxLines: 2,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Days...',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Pills Per Day',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.subtitle1.color,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: kColorDarkBlue,
                            blurRadius: 10,
                            offset: Offset(2, 3),
                          ),
                        ],
                      ),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: _pillsPerDayController,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.subtitle1.color,
                        ),
                        maxLines: 2,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Pills Count',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: MaterialButton(
                                onPressed: () async {
                                  if (medicineTime.isEmpty ||
                                      _medicineNameController.text
                                          .toString()
                                          .isEmpty ||
                                      _pillsPerDayController.text
                                          .toString()
                                          .isEmpty ||
                                      _additionalNoteController.text
                                          .toString()
                                          .isEmpty ||
                                      _daysOfTreatController.text
                                          .toString()
                                          .isEmpty) {
                                    Utils.showSnackBar("Required Field",
                                        "Please enter all fields");
                                    return;
                                  }
                                  setState(() {
                                    isLoading = true;
                                  });
                                  await _doctorHomeScreenController
                                      .addPrescription(
                                          widget.patientAppoint.doctorId,
                                          widget.patientAppoint.patientId,
                                          widget.patientAppoint.id,
                                          _medicineNameController.text,
                                          medicineTime.join(""),
                                          _additionalNoteController.text,
                                          _daysOfTreatController.text,
                                          _pillsPerDayController.text);
                                  setState(() {
                                    isLoading = false;
                                  });
                                  Navigator.pop(context, true);
                                  Get.toNamed(Routes.addprescription,
                                      arguments: widget.patientAppoint);
                                },
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 20),
                                color: kColorBlue,
                                splashColor: kColorDarkBlue,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Submit & Add More',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: MaterialButton(
                                onPressed: () async {
                                  if (medicineTime.isEmpty ||
                                      _medicineNameController.text
                                          .toString()
                                          .isEmpty ||
                                      _pillsPerDayController.text
                                          .toString()
                                          .isEmpty ||
                                      _additionalNoteController.text
                                          .toString()
                                          .isEmpty ||
                                      _daysOfTreatController.text
                                          .toString()
                                          .isEmpty) {
                                    Utils.showSnackBar("Required Field",
                                        "Please enter all fields");
                                    return;
                                  }
                                  setState(() {
                                    isLoading = true;
                                  });
                                  await _doctorHomeScreenController
                                      .addPrescription(
                                          widget.patientAppoint.doctorId,
                                          widget.patientAppoint.patientId,
                                          widget.patientAppoint.id,
                                          _medicineNameController.text,
                                          medicineTime.join(""),
                                          _additionalNoteController.text,
                                          _daysOfTreatController.text,
                                          _pillsPerDayController.text);
                                  setState(() {
                                    isLoading = false;
                                  });

                                  Navigator.pop(context, true);
                                },
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 20),
                                color: kColorBlue,
                                splashColor: kColorDarkBlue,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Submit',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          child: isLoading
              ? Container(
                  color: Colors.black12,
                  child: Center(
                    child: Utils.loadingBar(),
                  ),
                )
              : SizedBox(),
        )
      ],
    );
  }
}

class TimeCard extends StatelessWidget {
  const TimeCard({
    Key key,
    this.icon,
    this.time,
    this.isSelected,
  }) : super(key: key);
  final IconData icon;
  final String time;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 105,
      width: 105,
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: isSelected ? kColorDarkBlue : kColorBlue,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: kColorDarkBlue,
            blurRadius: 10,
            offset: Offset(2, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.white : Colors.white,
            size: 40,
          ),
          SizedBox(height: 5),
          Text(
            time,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white,
              fontSize: 18,
            ),
          )
        ],
      ),
    );
  }
}
