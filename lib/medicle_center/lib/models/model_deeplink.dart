import 'package:united_natives/medicle_center/lib/configs/routes.dart';
import 'package:united_natives/medicle_center/lib/models/model_booking_item.dart';
import 'package:united_natives/medicle_center/lib/models/model_product.dart';

import 'model_user.dart';

class DeepLinkModel {
  final String? action;
  final String? type;
  final String? target;
  final dynamic item;
  final bool? authentication;

  DeepLinkModel({
    this.action,
    this.type,
    this.target,
    this.item,
    this.authentication,
  });

  factory DeepLinkModel.fromString(String link) {
    try {
      final Uri uri = Uri.parse(link);
      final type = uri.queryParameters['type'] ?? '';
      final id = uri.queryParameters['id'] ?? '';

      String target = '';
      bool authentication = false;
      dynamic item;

      switch (type) {
        case 'listing':
          target = Routes.productDetail;
          item = ProductModel.fromNotification({'ID': id});
          break;

        case 'booking':
          authentication = true;
          target = Routes.bookingDetail;
          item = BookingItemModel.fromNotification({'booking_id': id});
          break;

        case 'profile':
          authentication = true;
          target = Routes.profile;
          item = UserModel.fromJson({'id': int.parse(id)});
          break;

        case 'review':
          authentication = true;
          target = Routes.review;
          item = ProductModel.fromJson({'ID': id});
          break;
        default:
      }

      return DeepLinkModel(
        action: uri.queryParameters['action'] ?? '',
        type: type,
        target: target,
        item: item,
        authentication: authentication,
      );
    } catch (e) {
      return DeepLinkModel(
        action: 'action',
        type: 'action',
        target: '',
        item: null,
        authentication: false,
      );
    }
  }
}
