class UpdateMeetingStatusModel {
  String? docId;
  String? id;
  String? meetingId;
  String? meetingStatus;

  UpdateMeetingStatusModel(
      {this.docId, this.id, this.meetingId, this.meetingStatus});
  Future<Map<String, dynamic>> toJson() async {
    return {
      "doctor_id": docId,
      "id": id,
      "meeting_id": meetingId,
      "meeting_status": meetingStatus
    };
  }
}
