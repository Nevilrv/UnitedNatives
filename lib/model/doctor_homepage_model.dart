import 'package:united_natives/model/prescription.dart';
import 'package:united_natives/model/visited_patient_model.dart';

class DoctorHomePageModel {
  String? status;
  Data? data;
  String? message;

  DoctorHomePageModel({this.status, this.data, this.message});

  DoctorHomePageModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data?.toJson();
    }
    data['message'] = message;
    return data;
  }
}

class Data {
  List<VisitedPatient>? upcomingAppointments;
  List<VisitedPatient>? pastAppointments;
  List<Prescription>? prescriptions;
  List<ResearchDocs>? researchDocs;

  Data(
      {this.upcomingAppointments,
      this.pastAppointments,
      this.prescriptions,
      this.researchDocs});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['upcoming_appointments'] != null) {
      upcomingAppointments = <VisitedPatient>[];
      json['upcoming_appointments'].forEach((v) {
        upcomingAppointments?.add(VisitedPatient.fromJson(v));
      });
    }
    if (json['past_appointments'] != null) {
      pastAppointments = <VisitedPatient>[];
      json['past_appointments'].forEach((v) {
        pastAppointments?.add(VisitedPatient.fromJson(v));
      });
    }
    if (json['prescriptions'] != null) {
      prescriptions = <Prescription>[];
      json['prescriptions'].forEach((v) {
        prescriptions?.add(Prescription.fromJson(v));
      });
    }
    if (json['researchDocs'] != null) {
      researchDocs = <ResearchDocs>[];
      json['researchDocs'].forEach((v) {
        researchDocs?.add(ResearchDocs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (upcomingAppointments != null) {
      data['upcoming_appointments'] =
          upcomingAppointments?.map((v) => v.toJson()).toList();
    }
    if (pastAppointments != null) {
      data['past_appointments'] =
          pastAppointments?.map((v) => v.toJson()).toList();
    }
    if (prescriptions != null) {
      data['prescriptions'] = prescriptions?.map((v) => v.toJson()).toList();
    }
    if (researchDocs != null) {
      data['researchDocs'] = researchDocs?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ResearchDocs {
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

  ResearchDocs(
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

  ResearchDocs.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}
