import 'dart:convert';

class DocNotification {
  int? id;
  String? title;
  String? body;
  String? icon;
  String? date;

  DocNotification({
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

  factory DocNotification.fromMap(Map<String, dynamic>? map) {
    return DocNotification(
      id: map?['id'],
      title: map?['title'],
      body: map?['body'],
      icon: map?['icon'],
      date: map?['date'],
    );
  }

  String toJson() => json.encode(toMap());

  factory DocNotification.fromJson(String source) =>
      DocNotification.fromMap(json.decode(source));
}

final notifications = [
  DocNotification(
    title: 'Appointment Information',
    body: 'You received a new appointment with Michel Hawel',
    icon: 'assets/images/patient04.png',
    date: '2h',
  ),
  DocNotification(
    title: 'Appointment Information',
    body: 'You received a new appointment with Garcel park',
    icon: 'assets/images/baby.png',
    date: '1d',
  ),
  DocNotification(
    title: 'Appointment Information',
    body: 'You received a new appointment with Moruga moon',
    icon: 'assets/images/icon_man.png',
    date: '2d',
  ),
];
