class DoctorSpecialitiesFilter {
  String? specialityId;
  String? userId;
  String? availabilityFilter;
  String? genderFilter;
  String? feesFilter;

  DoctorSpecialitiesFilter(
      {this.specialityId,
      this.userId,
      this.availabilityFilter,
      this.genderFilter,
      this.feesFilter});

  DoctorSpecialitiesFilter.fromJson(Map<String, dynamic> json) {
    specialityId = json['speciality_id'];
    userId = json['user_id'];
    availabilityFilter = json['availability_filter'];
    genderFilter = json['gender_filter'];
    feesFilter = json['fees_filter'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['speciality_id'] = specialityId;
    data['user_id'] = userId;
    data['availability_filter'] = availabilityFilter;
    data['gender_filter'] = genderFilter;
    data['fees_filter'] = feesFilter;
    return data;
  }
}
