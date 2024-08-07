import 'api_state_enum.dart';
import 'appointment.dart';

class VisitedDoctorUpcomingPastModel {
  String status;
  String message;
  List<Appointment> upcoming;
  List<Appointment> past;
  APIState apiState;

  VisitedDoctorUpcomingPastModel(
      {this.status, this.message, this.upcoming, this.past});

  VisitedDoctorUpcomingPastModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      if (json['data']['upcoming'] != null) {
        upcoming = <Appointment>[];
        json['data']['upcoming'].forEach((v) {
          upcoming.add(new Appointment.fromJson(v));
        });
      }
      if (json['data']['past'] != null) {
        past = <Appointment>[];
        json['data']['past'].forEach((v) {
          past.add(new Appointment.fromJson(v));
        });
      }
    }
    apiState = APIState.COMPLETE;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['upcoming'] = this.upcoming.map((v) => v.toJson()).toList();
    data['past'] = this.past.map((v) => v.toJson()).toList();
    data['message'] = this.message;
    return data;
  }
}
