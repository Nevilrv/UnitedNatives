class SetRatingForTheDoctorRequestModel {
  String patientId;
  String doctorId;
  String rating;
  String review;

  SetRatingForTheDoctorRequestModel(
      {this.patientId, this.doctorId, this.rating, this.review});

  SetRatingForTheDoctorRequestModel.fromJson(Map<String, dynamic> json) {
    patientId = json['patient_id'];
    doctorId = json['doctor_id'];
    rating = json['rating'];
    review = json['review'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['patient_id'] = this.patientId;
    data['doctor_id'] = this.doctorId;
    data['rating'] = this.rating;
    data['review'] = this.review;
    return data;
  }
}
