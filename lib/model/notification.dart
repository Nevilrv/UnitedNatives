import 'dart:convert';

class Notification {
  int? id;
  String? title;
  String? body;
  String? icon;
  String? date;

  Notification({
    this.id,
    this.title,
    this.body,
    this.icon,
    this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'icon': icon,
      'date': date,
    };
  }

  factory Notification.fromMap(Map<String, dynamic>? map) {
    return Notification(
      id: map?['id'],
      title: map?['title'],
      body: map?['body'],
      icon: map?['icon'],
      date: map?['date'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Notification.fromJson(String source) =>
      Notification.fromMap(json.decode(source));
}

final notifications = [
  Notification(
    title: 'Appointment confirmation',
    body: 'Provider. Lee has accepted your appointment',
    icon: 'assets/images/Doctor_lee.png',
    date: '2h',
  ),
  Notification(
    title: 'Appointment Information',
    body: 'Dr.Gaberial unavailable and has declined your appointment',
    icon: 'assets/images/icon_doctor_4.png',
    date: '1d',
  ),
  Notification(
    title: 'Appointment confirmation',
    body: 'Dr.Liana Lee confirmed your booking appointment',
    icon: 'assets/images/icon_doctor_5.png',
    date: '1d',
  ),
  Notification(
    title: 'Appointment Information',
    body: 'Dr.Lee unavailable and has declined your appointment',
    icon: 'assets/images/Doctor_lee.png',
    date: '1 week',
  ),
];
