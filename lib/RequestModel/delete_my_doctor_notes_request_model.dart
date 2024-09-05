class DeleteNotesRequestModel {
  int? id;
  int? noteId;
  int? patientId;

  DeleteNotesRequestModel({this.id, this.noteId, this.patientId});

  DeleteNotesRequestModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    noteId = json['note_id'];
    patientId = json['patient_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['note_id'] = noteId;
    data['patient_id'] = patientId;
    return data;
  }
}
