class SetRatingForTheDoctorRequestModel {
  String? patientId;
  String? doctorId;
  String? rating;
  String? review;

  SetRatingForTheDoctorRequestModel(
      {this.patientId, this.doctorId, this.rating, this.review});

  SetRatingForTheDoctorRequestModel.fromJson(Map<String, dynamic> json) {
    patientId = json['patient_id'];
    doctorId = json['doctor_id'];
    rating = json['rating'];
    review = json['review'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['patient_id'] = patientId;
    data['doctor_id'] = doctorId;
    data['rating'] = rating;
    data['review'] = review;
    return data;
  }
}
