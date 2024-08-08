import 'api_state_enum.dart';
import 'appointment.dart';

class VisitedDoctorUpcomingPastModel {
  String? status;
  String? message;
  List<Appointment>? upcoming;
  List<Appointment>? past;
  APIState? apiState;

  VisitedDoctorUpcomingPastModel(
      {this.status, this.message, this.upcoming, this.past});

  VisitedDoctorUpcomingPastModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      if (json['data']['upcoming'] != null) {
        upcoming = <Appointment>[];
        json['data']['upcoming'].forEach((v) {
          upcoming?.add(Appointment.fromJson(v));
        });
      }
      if (json['data']['past'] != null) {
        past = <Appointment>[];
        json['data']['past'].forEach((v) {
          past?.add(Appointment.fromJson(v));
        });
      }
    }
    apiState = APIState.COMPLETE;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['upcoming'] = upcoming?.map((v) => v.toJson()).toList();
    data['past'] = past?.map((v) => v.toJson()).toList();
    data['message'] = message;
    return data;
  }
}
