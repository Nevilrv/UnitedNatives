import 'package:united_natives/newModel/apiModel/responseModel/services_response_model.dart';
import 'package:united_natives/newModel/services/api_service.dart';
import 'package:united_natives/newModel/services/base_service.dart';

class ServicesRepo extends BaseService {
  /// patient services
  Future<dynamic> getServicesPatientRepo(String id) async {
    String url = '$patientServicesURL/$id';

    var response =
        await ApiService().getResponse(apiType: APIType.aGet, url: url);
    ServicesResponseModel servicesResponseModel =
        ServicesResponseModel.fromJson(response);

    return servicesResponseModel;
  }

  /// doctor services
  Future<dynamic> getServicesDoctorRepo(String id) async {
    String url = '$doctorServicesURL/$id';

    var response =
        await ApiService().getResponse(apiType: APIType.aGet, url: url);
    ServicesResponseModel servicesResponseModel =
        ServicesResponseModel.fromJson(response);

    return servicesResponseModel;
  }
}
