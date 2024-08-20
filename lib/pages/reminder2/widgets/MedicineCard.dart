import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:united_natives/controller/reminder_controller.dart';
import 'package:united_natives/newModel/repo/reminder_response_model.dart';

class MecicineCard extends StatefulWidget {
  final bool isDark;
  final RemindersResponseModel medicine;
  const MecicineCard(this.isDark, {super.key, required this.medicine});

  @override
  State<MecicineCard> createState() => _MecicineCardState();
}

class _MecicineCardState extends State<MecicineCard> {
  RemindersController remindersController = Get.put(RemindersController());

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(10),
          width: Get.width * 0.27,
          height: Get.height * 0.13,
          child: Hero(
            tag: "${widget.medicine.name}",
            child: Image.network(
              'https://i.guim.co.uk/img/media/20491572b80293361199ca2fc95e49dfd85e1f42/0_236_5157_3094/master/5157.jpg?width=1200&height=1200&quality=85&auto=format&fit=crop&s=fc5fad5b6c2b545b7143b9787d0c90b1',
              // medicine.image,
              fit: BoxFit.fill,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                child: SizedBox(
                  width: Get.width * 0.5,
                  child: Text(
                    "${widget.medicine.name}",
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: Get.width * 0.6,
                child: Text(
                  "${widget.medicine.dose}".toUpperCase(),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Builder(builder: (context) {
                final first = widget.medicine.time?.split(",").first;
                final last = widget.medicine.time?.split(",").last;
                String output = "";
                if (first!.contains(":")) {
                  DateTime dateTime =
                      DateFormat("HH:mm").parse(last!.split(" ").first);
                  String time12Hour = DateFormat("hh:mm a").format(dateTime);
                  output = time12Hour;
                } else {
                  List time = last!.split(" ");
                  DateTime dateTime = DateFormat("HH:mm").parse(time[1]);
                  String time12Hour = DateFormat("hh:mm a").format(dateTime);
                  output = "$first, $time12Hour";
                }
                return Text(
                  output,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                );
              })
            ],
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: () async {
            await remindersController.deleteReminder(
                widget.medicine.id!, context);
            await remindersController.getAllReminders();
          },
          icon: const Icon(Icons.delete),
        )
      ],
    );
  }
}
