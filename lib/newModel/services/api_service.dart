import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart' as dio;
import 'package:http/http.dart' as http;
import 'package:united_natives/utils/pref_manager.dart';
import 'package:united_natives/newModel/apis/api_exception.dart';
import 'base_service.dart';

enum APIType { aPost, aGet, aDelete, aImageUpload }

class ApiService extends BaseService {
  var response;

  Future<dynamic> getResponse(
      {required APIType apiType,
      required String url,
      Map<String, dynamic>? body,
      bool fileUpload = false,
      bool withoutTypeHeader = false,
      bool medicalCenter = false,
      bool noHeader = false}) async {
    try {
      Map<String, String> header = {
        "Authorization": 'Bearer ${Prefs.getString(Prefs.BEARER)}',
        "Content-Type": "application/json",
      };
      Map<String, String> withoutHeader = {
        "Authorization": 'Bearer ${Prefs.getString(Prefs.BEARER)}',
      };
      Map<String, dynamic> headerDio = {
        "Authorization": 'Bearer ${Prefs.getString(Prefs.BEARER)}',
      };
      String mainUrl = baseURL + url;
      String medicalCenterUrl = medicalCenterURL + url;
      if (apiType == APIType.aGet) {
        var result = await http.get(
          Uri.parse(medicalCenter == true ? medicalCenterUrl : mainUrl),
          headers: withoutTypeHeader == true ? {} : header,
        );
        response = returnResponse(
          result.statusCode,
          result.body,
        );
      } else if (fileUpload) {
        dio.FormData formData = dio.FormData.fromMap(body ?? {});
        dio.Response result = await dio.Dio().post(baseURL + url,
            data: formData,
            options: dio.Options(headers: headerDio, contentType: 'form-data'));
        response = returnResponse(result.statusCode!, jsonEncode(result.data));
      } else if (apiType == APIType.aPost) {
        var encodeBody = jsonEncode(body);
        var result = await http.post(
          Uri.parse(medicalCenter == true ? medicalCenterUrl : mainUrl),
          headers: noHeader == true
              ? {'Content-Type': 'application/json'}
              : withoutTypeHeader == true
                  ? withoutHeader
                  : header,
          body: withoutTypeHeader == true ? body : encodeBody,
        );
        response = returnResponse(result.statusCode, result.body);
      } else if (apiType == APIType.aImageUpload) {
        log("REQUEST PARAMETER url  $url");
        final dio1 = dio.Dio();
        final formData = dio.FormData.fromMap(body ?? {});
        final result = await dio1.postUri(
          Uri.parse(medicalCenter == true ? medicalCenterUrl : mainUrl),
          data: formData,
          options: dio.Options(
            headers: noHeader == true
                ? {'Content-Type': 'application/json'}
                : withoutTypeHeader == true
                    ? withoutHeader
                    : header,
          ),
        );
        response = returnResponse(result.statusCode!, jsonEncode(result.data));
      } else if (apiType == APIType.aDelete) {
        var result =
            await http.delete(Uri.parse(baseURL + url), headers: header);
        response = returnResponse(
          result.statusCode,
          result.body,
        );
        log("response...RESPONSE...$response");
      }

      return response;
    } catch (e) {
      log('Error=>.ERROR. $e');
    }
  }

  returnResponse(int status, var result) {
    switch (status) {
      case 200:
        return jsonDecode(result);
      /*     case 256:
        return jsonDecode(result);*/

      case 400:
        throw BadRequestException('Bad Request');
      case 401:
        throw UnauthorisedException('Unauthorised user');
      case 404:
        throw ServerException('Server Error');
      case 500:
      default:
        throw FetchDataException('Internal Server Error');
    }
  }
}
