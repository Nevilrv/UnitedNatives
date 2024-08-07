import 'package:doctor_appointment_booking/medicle_center/lib/models/model_discovery.dart';

abstract class DiscoveryState {}

class DiscoveryLoading extends DiscoveryState {}

class DiscoverySuccess extends DiscoveryState {
  final List<DiscoveryModel> list;
  DiscoverySuccess(this.list);
}
