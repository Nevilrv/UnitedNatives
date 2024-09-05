import 'api_state_enum.dart';

class DoctorResearchDocumentDetailsModel {
  String? status;
  DoctorResearchDocumentDetails? doctorResearchDocumentDetails;
  APIState? apiState;

  DoctorResearchDocumentDetailsModel(
      {this.status, this.doctorResearchDocumentDetails});

  DoctorResearchDocumentDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    doctorResearchDocumentDetails = json['data'] != null
        ? DoctorResearchDocumentDetails.fromJson(json['data'])
        : null;
    if (doctorResearchDocumentDetails == null) {
      apiState = APIState.COMPLETE_WITH_NO_DATA;
    } else {
      apiState = APIState.COMPLETE;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (doctorResearchDocumentDetails != null) {
      data['data'] = doctorResearchDocumentDetails?.toJson();
    }
    return data;
  }
}

class DoctorResearchDocumentDetails {
  String? id;
  String? doctorId;
  String? researchAuthor;
  String? researchTitle;
  String? researchDescription;
  String? researchDocument;
  String? researchDocumentUrl;
  String? researchImage;
  String? researchVideo;
  String? researchVideoUrl;
  String? status;
  String? created;
  String? modified;
  String? researcherSpeciality;

  DoctorResearchDocumentDetails(
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
      this.modified,
      this.researcherSpeciality});

  DoctorResearchDocumentDetails.fromJson(Map<String, dynamic> json) {
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
    researcherSpeciality = json['researcher_speciality'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['doctor_id'] = doctorId;
    data['research_author'] = researchAuthor;
    data['research_title'] = researchTitle;
    data['research_description'] = researchDescription;
    data['research_document'] = researchDocument;
    data['research_document_url'] = researchDocumentUrl;
    data['research_image'] = researchImage;
    data['research_video'] = researchVideo;
    data['research_video_url'] = researchVideoUrl;
    data['status'] = status;
    data['created'] = created;
    data['modified'] = modified;
    data['researcher_speciality'] = researcherSpeciality;
    return data;
  }
}
