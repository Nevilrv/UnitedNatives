import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:united_natives/utils/pref_manager.dart';
import 'package:united_natives/newModel/apiModel/responseModel/get_all_notes_model.dart';
import 'package:united_natives/newModel/services/base_service.dart';
import 'package:united_natives/utils/constants.dart';

class AddNotesRepo extends BaseService {
  Future<dynamic> addNotesRepo({String? patientId, String? doctorId}) async {
    var headers = {
      'Authorization': 'Bearer  ${Prefs.getString(Prefs.BEARER)}',
      'Content-Type': 'application/json',
    };
    var body = {
      "patient_id": '$patientId',
      "doctor_id": '$doctorId',
    };

    var req = http.Request(
      "GET",
      Uri.parse(Constants.baseUrl + Constants.getAllPatientNotes),
    );

    req.body = json.encode(body);
    req.headers.addAll(headers);
    http.StreamedResponse response = await req.send();
    if (response.statusCode == 200) {
      GetAllNotesModel getAllNotesModel = GetAllNotesModel.fromJson(
          jsonDecode(await response.stream.bytesToString()));

      return getAllNotesModel;
    } else {}
  }
}
