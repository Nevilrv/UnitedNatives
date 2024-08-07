import 'package:doctor_appointment_booking/model/api_state_enum.dart';

class DoctorResearchDocumentModel {
  String status;
  List<DoctorResearchDocument> doctorResearchDocument;
  APIState apiState = APIState.NONE;

  DoctorResearchDocumentModel({this.status, this.doctorResearchDocument});

  DoctorResearchDocumentModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      doctorResearchDocument = <DoctorResearchDocument>[];
      json['data'].forEach((v) {
        doctorResearchDocument.add(new DoctorResearchDocument.fromJson(v));
      });
    }
    if (doctorResearchDocument?.isEmpty ?? true) {
      apiState = APIState.COMPLETE_WITH_NO_DATA;
    } else {
      apiState = APIState.COMPLETE;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.doctorResearchDocument != null) {
      data['data'] =
          this.doctorResearchDocument.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DoctorResearchDocument {
  String id;
  String doctorId;
  String researchAuthor;
  String researchTitle;
  String researchDescription;
  String researchDocument;
  String researchDocumentUrl;
  String researchImage;
  String researchVideo;
  String researchVideoUrl;
  String status;
  String created;
  String modified;

  DoctorResearchDocument(
      {this.id,
      this.doctorId,
      this.researchAuthor,
      this.researchTitle,
      this.researchDescription,
      this.researchDocument,
      this.researchDocumentUrl,
      this.researchImage,
      this.researchVideo,
      this.researchVideoUrl,
      this.status,
      this.created,
      this.modified});

  DoctorResearchDocument.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    doctorId = json['doctor_id'];
    researchAuthor = json['research_author'];
    researchTitle = json['research_title'];
    researchDescription = json['research_description'];
    researchDocument = json['research_document'];
    researchDocumentUrl = json['research_document_url'];
    researchImage = json['research_image'];
    researchVideo = json['research_video'];
    researchVideoUrl = json['research_video_url'];
    status = json['status'];
    created = json['created'];
    modified = json['modified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['doctor_id'] = this.doctorId;
    data['research_author'] = this.researchAuthor;
    data['research_title'] = this.researchTitle;
    data['research_description'] = this.researchDescription;
    data['research_document'] = this.researchDocument;
    data['research_document_url'] = this.researchDocumentUrl;
    data['research_image'] = this.researchImage;
    data['research_video'] = this.researchVideo;
    data['research_video_url'] = this.researchVideoUrl;
    data['status'] = this.status;
    data['created'] = this.created;
    data['modified'] = this.modified;
    return data;
  }
}
