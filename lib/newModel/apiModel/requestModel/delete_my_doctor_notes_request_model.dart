class DeleteNotesRequestModel {
  int id;
  int noteId;
  int patientId;

  DeleteNotesRequestModel({this.id, this.noteId, this.patientId});

  DeleteNotesRequestModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    noteId = json['note_id'];
    patientId = json['patient_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['note_id'] = this.noteId;
    data['patient_id'] = this.patientId;
    return data;
  }
}
