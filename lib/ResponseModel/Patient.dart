import 'working_day.dart';

class Patient {
  String? id;
  String? name;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? speciality;
  String? about;
  String? avatar;
  double? rating;
  int? price;
  int? idSpeciality;
  int? goodReviews;
  int? totalScore;
  int? satisfaction;
  int? visitDuration;
  List<WorkingDay>? workingDays;

  Patient({
    this.id,
    this.name,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.speciality,
    this.about,
    this.avatar,
    this.rating,
    this.price,
    this.idSpeciality,
    this.goodReviews,
    this.totalScore,
    this.satisfaction,
    this.visitDuration,
    this.workingDays,
  });

  factory Patient.fromJson(Map<dynamic, dynamic> parsedJson) {
    var list = parsedJson['working_days'] as List;
    List<WorkingDay> workingDaysList =
        list.map((i) => WorkingDay.fromJson(i)).toList();
    return Patient(
      id: parsedJson['user_id'],
      firstName: parsedJson['first_name'],
      lastName: parsedJson['last_name'],
      email: parsedJson['email'],
      phone: parsedJson['phone'],
      about: parsedJson['about'],
      rating: parsedJson['rating'],
      price: parsedJson['price'],
      idSpeciality: parsedJson['id_speciality'],
      speciality: parsedJson['speciality'],
      goodReviews: parsedJson['good_reviews'],
      totalScore: parsedJson['tota_score'],
      satisfaction: parsedJson['satisfaction'],
      visitDuration: parsedJson['visit_duration'],
      workingDays: workingDaysList,
      //workingDays: new List<WorkingDay>.from(parsedJson['working_days']),
    );
  }
}

class Patients {
  List<Patient>? patientList;

  Patients({this.patientList});

  factory Patients.fromJSON(Map<dynamic, dynamic> json) {
    return Patients(patientList: parserecipes(json));
  }

  static List<Patient> parserecipes(patientJSON) {
    var dList = patientJSON['Patients'] as List;
    List<Patient> patientList =
        dList.map((data) => Patient.fromJson(data)).toList();
    return patientList;
  }
}

final patients = [
  Patient(
    name: 'Michel hawel',
    speciality: 'Cold and cough',
    about:
        'Candidate of medical sciences, gynecologist, specialist with experience more than 5 years.',
    avatar: 'assets/images/girl_avathar.jpg',
    rating: 4.5,
    price: 100,
  ),
  Patient(
    name: 'Garcel park',
    speciality: 'Viral Fever',
    about:
        'Candidate of medical sciences, gynecologist, specialist with experience more than 5 years.',
    avatar: 'assets/images/baby.png',
    rating: 4.7,
    price: 90,
  ),
  Patient(
    name: 'Moruga moon',
    speciality: 'Heat pain',
    about:
        'Candidate of medical sciences, gynecologist, specialist with experience more than 5 years.',
    avatar: 'assets/images/boy_avathar.jpg',
    rating: 4.3,
    price: 100,
  ),
  Patient(
    name: 'Gabriel Moreira',
    speciality: 'General Checkup',
    about:
        'Candidate of medical sciences, gynecologist, specialist with experience more than 5 years.',
    avatar: 'assets/images/patient04.png',
    rating: 4.7,
    price: 100,
  ),
  Patient(
    name: 'Liana Lee',
    speciality: 'Covid-19 Symptoms',
    about:
        'Candidate of medical sciences, gynecologist, specialist with experience more than 5 years.',
    avatar: 'assets/images/baby.png',
    rating: 4.7,
    price: 100,
  ),
];
