import 'package:doctor_appointment_booking/medicle_center/lib/configs/routes.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/models/model_booking_item.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/models/model_product.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationModel {
  final String type;
  final String action;
  final String target;
  final dynamic item;

  NotificationModel({
    this.type,
    this.action,
    this.target,
    this.item,
  });

  factory NotificationModel.fromJson(RemoteMessage message) {
    dynamic notificationItem(json) {
      switch (json['type']) {
        case 'booking':
          return BookingItemModel.fromNotification(json);
        case 'listing':
          return ProductModel.fromNotification(json);
        default:
          return null;
      }
    }

    String targetScreen(json) {
      switch (json['type']) {
        case 'booking':
          return Routes.bookingDetail;
        case 'listing':
          return Routes.productDetail;
        default:
          return null;
      }
    }

    return NotificationModel(
      type: message.data['type'] ?? 'Unknown',
      action: message.data['action'] ?? 'Unknown',
      target: targetScreen(message.data),
      item: notificationItem(message.data),
    );
  }
}
