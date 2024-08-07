import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart' as dio;
import 'package:doctor_appointment_booking/data/pref_manager.dart';
import 'package:doctor_appointment_booking/newModel/apis/api_exception.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'base_service.dart';

enum APIType { aPost, aGet, aDelete, aImageUpload }

class ApiService extends BaseService {
  var response;

  Future<dynamic> getResponse(
      {@required APIType apiType,
      @required String url,
      Map<String, dynamic> body,
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
      log("URL ::::: FULL::URL ::::: ====> ${baseURL + url}");
      log("URL ::::: FULL::MEDICAL_CENTER_URL ::::: ====> $medicalCenterUrl");
      log("URL ::::: HEADER ::::: ====> ${jsonEncode(withoutHeader)}");

      log('withoutTypeHeader == true ? {} : header---------->>>>>>>>${withoutTypeHeader == true ? {} : header}');
      log('medicalCenter == true ? medicalCenterUrl : mainUrl---------->>>>>>>>${medicalCenter == true ? medicalCenterUrl : mainUrl}');
      if (apiType == APIType.aGet) {
        var result = await http.get(
          // Uri.parse(baseURL + url),
          Uri.parse(medicalCenter == true ? medicalCenterUrl : mainUrl),
          headers: withoutTypeHeader == true ? {} : header,
        );
        response = returnResponse(
          result.statusCode,
          result.body,
        );
        log("response...RESPONSE...$response");
      } else if (fileUpload) {
        dio.FormData formData = new dio.FormData.fromMap(body);
        log("POST REQUEST $body");

        dio.Response result = await dio.Dio().post(baseURL + url,
            data: formData,
            options: dio.Options(headers: headerDio, contentType: 'form-data'));
        print('responseType+>${result.data.runtimeType}');
        print(
            'responseType DAta ----> ${result.statusCode}   ${result.data}  $result');
        response = returnResponse(result.statusCode, jsonEncode(result.data));

        log("response...RESPONSE...$response");
      } else if (apiType == APIType.aPost) {
        var encodeBody = jsonEncode(body);
        log('POST URL :: $medicalCenterUrl');
        log("REQUEST ENCODE BODY $encodeBody");
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
        final formData = dio.FormData.fromMap(body);
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

        log('result-------->>>>>>$result');
        log('result.statusCode-------->>>>>>${result.statusCode}');

        response = returnResponse(result.statusCode, jsonEncode(result.data));
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
    print("status ---> $status");
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
