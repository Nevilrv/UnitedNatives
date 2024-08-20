import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:united_natives/controller/reminder_controller.dart';
import 'package:united_natives/pages/reminder2/animations/fade_animation.dart';
import 'package:united_natives/pages/reminder2/sqflite_database_helper.dart';

class AddMedicine extends StatefulWidget {
  final double height;

  const AddMedicine(this.height, {super.key});

  @override
  State<AddMedicine> createState() => _AddMedicineState();
}

class _AddMedicineState extends State<AddMedicine> {
  static final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _dose;
  bool isEveryday = false;
  final int _selectedIndex = 0;
  final dbHelper = DatabaseHelper();
  final List<String> _icons = ['drug.png'];
  final RemindersController remindersController =
      Get.put(RemindersController());

  @override
  initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        remindersController.initializeNotification();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FadeAnimation(
      0.3,
      Container(
          padding: const EdgeInsets.fromLTRB(25, 20, 25, 0),
          height: widget.height * .8,
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      'Add Reminder',
                      style: TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // back to main screen
                        Navigator.pop(context, null);
                      },
                      child: Icon(
                        Icons.close,
                        size: 30,
                        color: Theme.of(context).primaryColor.withOpacity(.65),
                      ),
                    )
                  ],
                ),
                _buildForm(),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Checkbox(
                      value: isEveryday,
                      onChanged: (value) {
                        setState(() {
                          isEveryday = !isEveryday;
                        });
                      },
                    ),
                    const Text('Remind me everyday')
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: double.infinity,
                  child: MaterialButton(
                    padding: const EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    onPressed: () {
                      _submit();
                    },
                    color: Theme.of(context).colorScheme.secondary,
                    textColor: Colors.white,
                    highlightColor: Theme.of(context).primaryColor,
                    child: Text(
                      'Add Reminder'.toUpperCase(),
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Form _buildForm() {
    TextStyle labelsStyle =
        const TextStyle(fontWeight: FontWeight.w400, fontSize: 24);
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            style: const TextStyle(fontSize: 20),
            decoration: InputDecoration(
              labelText: 'Name',
              labelStyle: labelsStyle,
            ),
            validator: (input) => (input!.length < 5) ? 'Name is short' : null,
            onSaved: (input) => _name = input,
          ),
          TextFormField(
            style: const TextStyle(fontSize: 20),
            decoration: InputDecoration(
              labelText: 'Remarks',
              labelStyle: labelsStyle,
            ),
            validator: (input) =>
                (input!.length > 50) ? 'Remarks is long' : null,
            onSaved: (input) => _dose = input,
          )
        ],
      ),
    );
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      await showTimePicker(
        initialTime: TimeOfDay.now(),
        context: context,
      ).then((TimeOfDay? selectedTime) async {
        int hour = selectedTime!.hour;
        int minute = selectedTime.minute;
        String type = selectedTime.period.toString();
        var newString = type.substring(type.length - 2).toUpperCase();
        var everyDay = isEveryday == true
            ? 'Set for Everyday, $hour:$minute $newString'
            : '$hour:$minute $newString';
        MedicineReminder scope = MedicineReminder(
          name: _name.toString(),
          dose: _dose.toString(),
          image: 'assets/images/${_icons[_selectedIndex]}',
          time: everyDay,
          isEveryDay: isEveryday == true ? 1 : 0,
        );
        final id = await dbHelper.insertReminderDetails(scope);

        isEveryday == true
            ? remindersController.showNotification(
                id, _name!, _dose!, hour, minute)
            : remindersController.showOnceNotification(
                id, _name!, _dose!, hour, minute);
        Navigator.pop(context, id);
      });
    }
  }
}
