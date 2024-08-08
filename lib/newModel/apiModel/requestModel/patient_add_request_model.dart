class AddRequestModel {
  String? categoryId;
  String? date;
  String? time;
  String? notes;

  AddRequestModel({this.date, this.notes, this.time, this.categoryId});
  Future<Map<String, dynamic>> toJson() async {
    return {
      'category_id': categoryId,
      'date': date,
      'time': time,
      'notes': notes,
    };
  }
}
