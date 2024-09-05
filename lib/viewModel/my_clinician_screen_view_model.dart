import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:united_natives/utils/pref_manager.dart';
import 'package:united_natives/utils/common_snackbar.dart';
import 'package:united_natives/utils/constants.dart';

class MyClinicianScreenViewModel extends GetxController {
  bool isLoad = false;

  Future addNotesRepo(
      {var patientId, var doctorId, required String notes}) async {
    isLoad = true;
    update();
    var headers = {
      // 'Authorization': 'Bearer 81dc9bdb52d04dc20036dbd8313ed055',
      "Authorization": 'Bearer ${Prefs.getString(Prefs.BEARER)}',
      'Content-Type': 'application/json',
    };

    var body = json.encode(
        {"patient_id": '$patientId', "doctor_id": doctorId, "notes": notes});

    http.Response response = await http.post(
      Uri.parse(
        Constants.baseUrl + Constants.patientNotes,
      ),
      body: body,
      headers: headers,
    );
    if (response.statusCode == 200) {
      isLoad = false;

      update();
      var result = jsonDecode(response.body);
      return result;
    } else {
      isLoad = false;

      update();
      CommonSnackBar.snackBar(
          message: 'Something went wrong please try again !');
    }
  }

  Future addNotesRepo1(
      {var patientId,
      required String doctorName,
      required String notes,
      required String mobile,
      int? id}) async {
    isLoad = true;
    update();
    var headers = {
      "Authorization": 'Bearer ${Prefs.getString(Prefs.BEARER)}',
      'Content-Type': 'application/json',
    };

    var body = json.encode({
      "patient_id": '$patientId',
      "doctor_name": doctorName,
      "doctor_mobile": mobile,
      "notes": notes
    });

    http.Response response = await http.post(
      Uri.parse(
        Constants.baseUrl + Constants.addDoctorByPatient,
      ),
      body: body,
      headers: headers,
    );
    if (response.statusCode == 200) {
      isLoad = false;

      update();
      var result = jsonDecode(response.body);
      return result;
    } else {
      isLoad = false;

      update();
      CommonSnackBar.snackBar(
          message: 'Something went wrong please try again !');
    }
  }

  Future updateNotesRepo1(
      {required int patientId,
      required String doctorName,
      required String notes,
      required String mobile,
      required int notesId,
      required int id}) async {
    isLoad = true;
    update();
    var headers = {
      "Authorization": 'Bearer ${Prefs.getString(Prefs.BEARER)}',
      'Content-Type': 'application/json',
    };

    var body = json.encode({
      "patient_id": '$patientId',
      "doctor_name": doctorName,
      "doctor_mobile": mobile,
      "notes_id": notesId,
      "id": id,
      "notes": notes
    });

    http.Response response = await http.post(
      Uri.parse(
        Constants.baseUrl + Constants.updateDoctorByPatient,
      ),
      body: body,
      headers: headers,
    );
    if (response.statusCode == 200) {
      isLoad = false;

      update();
      var result = jsonDecode(response.body);
      return result;
    } else {
      isLoad = false;

      update();
      CommonSnackBar.snackBar(
          message: 'Something went wrong please try again !');
    }
  }
}
