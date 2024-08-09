import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:united_natives/controller/doctor_homescreen_controller.dart';
import 'package:united_natives/model/doctor_get_doctor_Appointments_model.dart';
import 'package:united_natives/routes/routes.dart';
import 'package:united_natives/utils/utils.dart';
import '../../utils/constants.dart';

class AddPrescription extends StatefulWidget {
  final PatientAppoint? patientAppoint;

  const AddPrescription({super.key, this.patientAppoint});

  @override
  State<AddPrescription> createState() => _AddPrescriptionState();
}

class _AddPrescriptionState extends State<AddPrescription> {
  bool morning = false;
  bool afternoon = false;
  bool night = false;
  bool isLoading = false;
  List<String> medicineTime = [];

  final TextEditingController _medicineNameController = TextEditingController();
  final TextEditingController _pillsPerDayController = TextEditingController();
  final TextEditingController _additionalNoteController =
      TextEditingController();
  final TextEditingController _daysOfTreatController = TextEditingController();

  final DoctorHomeScreenController _doctorHomeScreenController = Get.find();

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
              icon: const Icon(
                CupertinoIcons.left_chevron,
                size: 30,
              ),
            ),
            title: Text(
              'Add Prescription',
              style: TextStyle(
                fontSize: 23,
                color: Theme.of(context).textTheme.titleMedium?.color,
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
                    const SizedBox(height: 20),
                    Text(
                      'Medicine name',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.titleMedium?.color,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
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
                          color: Theme.of(context).textTheme.titleMedium?.color,
                        ),
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter medicine name',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            )),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'When to take?',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.titleMedium?.color,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 15),
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
                            icon: CupertinoIcons.sunrise,
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
                            icon: CupertinoIcons.sun_max_fill,
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
                            icon: CupertinoIcons.moon,
                            time: 'Night',
                            isSelected: night,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'Additional notes',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.titleMedium?.color,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      height: 80,
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
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
                          color: Theme.of(context).textTheme.titleMedium?.color,
                        ),
                        maxLines: 2,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Additional notes...',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'Days of Treat',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.titleMedium?.color,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
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
                          color: Theme.of(context).textTheme.titleMedium?.color,
                        ),
                        maxLines: 2,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Days...',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'Pills Per Day',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.titleMedium?.color,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
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
                          color: Theme.of(context).textTheme.titleMedium?.color,
                        ),
                        maxLines: 2,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Pills Count',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
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
                                          widget.patientAppoint!.doctorId!,
                                          widget.patientAppoint!.patientId,
                                          widget.patientAppoint!.id,
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 20),
                                color: kColorBlue,
                                splashColor: kColorDarkBlue,
                                child: const Row(
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
                          const SizedBox(width: 10),
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
                                          widget.patientAppoint!.doctorId!,
                                          widget.patientAppoint!.patientId,
                                          widget.patientAppoint!.id,
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 20),
                                color: kColorBlue,
                                splashColor: kColorDarkBlue,
                                child: const Row(
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
              : const SizedBox(),
        )
      ],
    );
  }
}

class TimeCard extends StatelessWidget {
  const TimeCard({
    super.key,
    this.icon,
    this.time,
    this.isSelected,
  });
  final IconData? icon;
  final String? time;
  final bool? isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 105,
      width: 105,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: isSelected! ? kColorDarkBlue : kColorBlue,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
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
            color: isSelected! ? Colors.white : Colors.white,
            size: 40,
          ),
          const SizedBox(height: 5),
          Text(
            time!,
            style: TextStyle(
              color: isSelected! ? Colors.white : Colors.white,
              fontSize: 18,
            ),
          )
        ],
      ),
    );
  }
}
