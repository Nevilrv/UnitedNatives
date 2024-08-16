import 'package:flutter/material.dart';
import 'package:united_natives/newModel/repo/reminder_response_model.dart';
import 'package:united_natives/pages/reminder2/widgets/MedicineCard.dart';

class MedicineGridView extends StatelessWidget {
  final bool isDark;
  final List<RemindersResponseModel> reminders;
  const MedicineGridView(this.isDark, {super.key, required this.reminders});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: const EdgeInsets.only(bottom: 85, top: 10),
      crossAxisCount: 1,
      shrinkWrap: true,
      childAspectRatio: 2 / 0.7,
      children: reminders.map((medicine) {
        return Card(
          margin: const EdgeInsets.all(10),
          child: MecicineCard(medicine: medicine, isDark),
        );
      }).toList(),
    );
  }
}
