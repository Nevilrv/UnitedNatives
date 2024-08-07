class DoctorSpecialitiesFilter {
  String specialityId;
  String userId;
  String availabilityFilter;
  String genderFilter;
  String feesFilter;

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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['speciality_id'] = this.specialityId;
    data['user_id'] = this.userId;
    data['availability_filter'] = this.availabilityFilter;
    data['gender_filter'] = this.genderFilter;
    data['fees_filter'] = this.feesFilter;
    return data;
  }
}
