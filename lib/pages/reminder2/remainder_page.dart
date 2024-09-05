import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:united_natives/components/ads_bottom_bar.dart';
import 'package:united_natives/viewModel/ads_controller.dart';
import 'package:united_natives/viewModel/reminder_controller.dart';
import 'package:united_natives/utils/pref_manager.dart';
import 'package:united_natives/medicle_center/lib/utils/translate.dart';
import 'package:united_natives/pages/reminder2/widgets/AddMedicine.dart';
import 'package:united_natives/pages/reminder2/widgets/MedicineEmptyState.dart';
import 'package:united_natives/pages/reminder2/widgets/MedicineGridView.dart';
import 'package:united_natives/utils/constants.dart';
import 'package:united_natives/utils/utils.dart';

class RemainderPage extends StatefulWidget {
  const RemainderPage({super.key});
  @override
  State<RemainderPage> createState() => _RemainderPageState();
}

class _RemainderPageState extends State<RemainderPage> {
  AdsController adsController = Get.find();
  RemindersController reminderController = Get.put(RemindersController());
  final bool _isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      reminderController.getAllReminders();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: GetBuilder<AdsController>(
        builder: (ads) {
          return Scaffold(
            bottomNavigationBar: AdsBottomBar(
              ads: ads,
              context: context,
            ),
            appBar: AppBar(
              title: Text(
                Translate.of(context)!.translate('Reminder'),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.titleMedium?.color,
                    fontSize: 24),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                await buildBottomSheet(MediaQuery.of(context).size.height);
              },
              backgroundColor: kColorBlue,
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
            body: GetBuilder<RemindersController>(
              builder: (controller) {
                return Column(
                  children: <Widget>[
                    Expanded(
                        child: controller.getData
                            ? Center(
                                child: Utils.circular(),
                              )
                            : controller.reminders.isNotEmpty
                                ? MedicineGridView(_isDark,
                                    reminders: controller.reminders)
                                : const Center(child: MedicineEmptyState()))
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> buildBottomSheet(double height) async {
    var medicineId = await showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(45), topRight: Radius.circular(45))),
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return AddMedicine(height);
        });

    if (!mounted) return;
    if (medicineId != null) {
      Fluttertoast.showToast(
          msg: "The Reminder was added!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          textColor: Colors.white,
          fontSize: 17);
      reminderController.getAllReminders();
    }
  }
}
