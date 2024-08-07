import 'package:doctor_appointment_booking/pages/reminder/models/Medicine.dart';
import 'package:doctor_appointment_booking/pages/reminder/remainder_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scoped_model/scoped_model.dart';

import '../database/moor_database.dart';

class MecicineCard extends StatefulWidget {
  final MedicinesTableData medicine;

  final bool isDark;

  MecicineCard(this.medicine, this.isDark);

  @override
  _MecicineCardState createState() => _MecicineCardState();
}

class _MecicineCardState extends State<MecicineCard> {
  @override
  void initState() {
    // TODO: implement initState

    // listenNotifications();
    super.initState();
  }

  // void listenNotifications() {
  //   NotificationApi.onNotifiactions.stream.listen((event) { })
  // }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return ScopedModelDescendant<MedicineModel>(
        builder: (context, child, model) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(10),
            width: Get.width * 0.27,
            height: Get.height * 0.13,
            child: Hero(
              tag: widget.medicine.name,
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
                  child: Container(
                    width: Get.width * 0.5,
                    child: Text(
                      widget.medicine.name,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: width * .04),
                    ),
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.01,
                ),
                Text(
                  widget.medicine.dose.toUpperCase(),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: width * 0.039,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.01,
                ),
                Text(
                  widget.medicine.time,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: width * 0.03,
                    fontWeight: FontWeight.w400,
                  ),
                )
              ],
            ),
          ),
          Spacer(),
          IconButton(
            onPressed: () {
              model.getDatabase().deleteMedicine(widget.medicine).then((value) {
                Get.off(RemainderPage());
                print('delete>>>>>>>>>>>>>?>?>??');
              });
              //remove the medicine notifcation
              model.notificationManager.removeReminder(widget.medicine.id);
              // for debugging
              print("Reminder deleted" + widget.medicine.toString());
              // show delete snakbar

              Scaffold.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(
                    'Reminder deleted',
                    style: TextStyle(fontSize: 22),
                  ),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            icon: Icon(Icons.delete),
          )
        ],
      );
    });
  }
}
