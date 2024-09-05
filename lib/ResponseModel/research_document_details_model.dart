import 'api_state_enum.dart';

class ResearchDocumentDetailsModel {
  String? status;
  ResearchDocumentDetails? researchDocumentDetails;
  APIState? apiState;

  ResearchDocumentDetailsModel({this.status, this.researchDocumentDetails});

  ResearchDocumentDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    researchDocumentDetails = json['data'] != null
        ? ResearchDocumentDetails.fromJson(json['data'])
        : null;
    if (researchDocumentDetails == null) {
      apiState = APIState.COMPLETE_WITH_NO_DATA;
    } else {
      apiState = APIState.COMPLETE;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (researchDocumentDetails != null) {
      data['data'] = researchDocumentDetails?.toJson();
    }
    return data;
  }
}

class ResearchDocumentDetails {
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

  ResearchDocumentDetails(
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

  ResearchDocumentDetails.fromJson(Map<String, dynamic> json) {
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
