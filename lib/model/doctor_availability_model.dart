class DoctorAvailability {
  String? s0;
  String? s1;
  String? s2;
  String? s3;
  String? s4;
  String? s5;
  String? s6;
  String? s7;
  String? s8;
  String? s9;
  String? s10;
  String? s11;
  String? s12;
  String? s13;
  String? s14;
  String? s15;
  String? s16;
  String? s17;
  String? s18;
  String? s19;
  String? s20;
  String? s21;
  String? s22;
  String? s23;
  String? userId;
  String? availabilityDate;

  DoctorAvailability(
      {this.s0,
      this.s1,
      this.s2,
      this.s3,
      this.s4,
      this.s5,
      this.s6,
      this.s7,
      this.s8,
      this.s9,
      this.s10,
      this.s11,
      this.s12,
      this.s13,
      this.s14,
      this.s15,
      this.s16,
      this.s17,
      this.s18,
      this.s19,
      this.s20,
      this.s21,
      this.s22,
      this.s23,
      this.userId,
      this.availabilityDate});

  DoctorAvailability.fromJson(Map<String, dynamic> json) {
    s0 = json['8'];
    s1 = json['9'];
    s2 = json['10'];
    s3 = json['11'];
    s4 = json['12'];
    s5 = json['13'];
    s6 = json['14'];
    s7 = json['15'];
    s8 = json['16'];
    s9 = json['17'];
    s10 = json['18'];
    s11 = json['19'];
    s12 = json['20'];
    s13 = json['13'];
    s14 = json['14'];
    s15 = json['15'];
    s16 = json['16'];
    s17 = json['17'];
    s18 = json['18'];
    s19 = json['19'];
    s20 = json['20'];
    s21 = json['21'];
    s22 = json['22'];
    s23 = json['23'];
    userId = json['user_id'];
    availabilityDate = json['availability_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['8'] = s0;
    data['9'] = s1;
    data['10'] = s2;
    data['11'] = s3;
    data['12'] = s4;
    data['13'] = s5;
    data['14'] = s6;
    data['15'] = s7;
    data['16'] = s8;
    data['17'] = s9;
    data['18'] = s10;
    data['19'] = s11;
    data['20'] = s12;
    data['13'] = s13;
    data['14'] = s14;
    data['15'] = s15;
    data['16'] = s16;
    data['17'] = s17;
    data['18'] = s18;
    data['19'] = s19;
    data['20'] = s20;
    data['21'] = s21;
    data['22'] = s22;
    data['23'] = s23;
    data['user_id'] = userId;
    data['availability_date'] = availabilityDate;
    return data;
  }
}
