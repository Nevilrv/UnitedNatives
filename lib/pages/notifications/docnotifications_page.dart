import 'package:doctor_appointment_booking/components/ads_bottom_bar.dart';
import 'package:doctor_appointment_booking/controller/ads_controller.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/utils/translate.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/notification.dart';
import 'widgets/docnotification_list_item.dart';

class NotificationsPage extends StatefulWidget {
  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  AdsController adsController = Get.find();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdsController>(builder: (ads) {
      return Scaffold(
        bottomNavigationBar: AdsBottomBar(
          ads: ads,
          context: context,
        ),
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          title: Text(Translate.of(context).translate('Notifications'),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.subtitle1.color,
                fontSize: 24,
              ),
              textAlign: TextAlign.center),
        ),
        body: ListView.separated(
          separatorBuilder: (context, index) =>
              Divider(indent: 0, endIndent: 0),
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            return NotificationListItem(
              notification: notifications[index],
              onTap: () {},
            );
          },
        ),
      );
    });
  }
}
