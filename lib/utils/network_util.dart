import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:united_natives/utils/exception.dart';

import 'constants.dart';

class NetworkAPICall {
  static final NetworkAPICall _networkAPICall = NetworkAPICall._internal();

  factory NetworkAPICall() {
    return _networkAPICall;
  }

  NetworkAPICall._internal();

  // static const BASE_URL = 'https://unhbackend.com/AppServices/';

  Future<dynamic> post(
    String url,
    dynamic body, {
    required Map<String, String> header,
  }) async {
    log('url==========>>>>>$url');
    var client = http.Client();
    try {
      String fullURL = Constants.baseUrl + url;
      log(':::::_API_::::: $fullURL');
      var response =
          await client.post(Uri.parse(fullURL), body: body, headers: header);

      log(':::::_BODY_::::: $body');
      log(':::::_HEADER_::::: $header');
      log(':::::_API_::::: $fullURL');
      log(':::::::::: ${response.statusCode}');
      log(':::::_RESPONSE_BODY_:::::  ${response.body}', level: 500);

      return checkResponse(response);
    } catch (exception, stackTrace) {
      client.close();
      throw AppException.exceptionHandler(exception, stackTrace);
    }
  }

  Future<dynamic> delete(
    String url,
    dynamic body, {
    required Map<String, String> header,
  }) async {
    var client = http.Client();
    try {
      String fullURL = Constants.baseUrl1 + url;

      var response =
          await client.delete(Uri.parse(fullURL), body: body, headers: header);

      log(':::::_BODY_::::: $body');
      log(':::::_HEADER_::::: $header');
      log(':::::_API_::::: $fullURL');
      log(':::::::::: ${response.statusCode}');
      log(':::::_RESPONSE_BODY_:::::  ${response.body}', level: 500);

      return checkResponse(response);
    } catch (exception, stackTrace) {
      client.close();
      throw AppException.exceptionHandler(exception, stackTrace);
    }
  }

  Future<Response> postCustomUrl(
    String url,
    dynamic body, {
    required Map<String, String> header,
  }) async {
    var client = http.Client();
    String fullURL = Constants.baseUrl1 + url;
    try {
      var response =
          await client.post(Uri.parse(fullURL), body: body, headers: header);

      log(':::::_BODY_::::: $body');
      log(':::::_HEADER_::::: $header');
      log(':::::_API_::::: $fullURL');
      log(':::::::::: ${response.statusCode}');
      log(':::::_RESPONSE_BODY_:::::  ${response.body}', level: 500);

      return response;
    } catch (exception, stackTrace) {
      client.close();
      throw AppException.exceptionHandler(exception, stackTrace);
    }
  }

  Future<dynamic> get(String url, {required Map<String, String> header}) async {
    var client = http.Client();
    try {
      String fullURL = Constants.baseUrl1 + url;
      log(':::::_API_::::: $fullURL');
      var response = await client.get(Uri.parse(fullURL), headers: header);

      log(':::::_HEADER_::::: $header');
      log(':::::_API_::::: $fullURL');
      log(':::::::::: ${response.statusCode}');
      log(':::::_RESPONSE_BODY_:::::  ${response.body}', level: 500);

      return checkResponse(response);
    } catch (exception, stackTrace) {
      client.close();
      throw AppException.exceptionHandler(exception, stackTrace);
    }
  }

  dynamic checkResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        try {
          /*print("Json Decode ===> ${json.decode(decodeUtf16(response.bodyBytes))}");
          var jsonData = json.decode(decodeUtf16(response.bodyBytes));
          print(JsonEncoder.withIndent('  ').convert(jsonData));
          return jsonData;*/
          var json = jsonDecode(response.body);
          if (json["status"] == "Fail") {
            throw AppException(
                message: json['message'],
                errorCode: response.statusCode,
                tag: '');
          }
          return json;
        } catch (e, stackTrace) {
          throw AppException.exceptionHandler(e, stackTrace);
        }
      case 201:
        throw AppException(
            message: "No message", errorCode: response.statusCode, tag: '');
      case 500:
        throw AppException(
            message: "No message", errorCode: response.statusCode, tag: '');
      default:
        throw AppException(
            message: "Unknown error : ${response.statusCode}",
            errorCode: response.statusCode,
            tag: "");
    }
  }

  Future multipartRequestPost(String url, Map<String, String> body,
      {Map<String, String>? header,
      File? image1,
      File? image2,
      String? image1Key,
      String? image2Key}) async {
    var client = http.Client();
    try {
      String fullURL = Constants.baseUrl1 + url;

      log('API Url: $fullURL', level: 1);
      log('API body: $body');
      log('API header: $header');

      var request = http.MultipartRequest('POST', Uri.parse(fullURL));
      request.headers.addAll(header!);
      request.fields.addAll(body);
      if (image1 != null && image1.path != "") {
        request.files.add(await http.MultipartFile.fromPath(
            image1Key ?? "", image1.absolute.path));
      }
      if (image2 != null && image2.path != "") {
        request.files.add(await http.MultipartFile.fromPath(
            image2Key ?? "", image2.absolute.path));
      }

      http.StreamedResponse response = await request.send();

      String jsonDataString = await response.stream.bytesToString();
      final jsonData = jsonDecode(jsonDataString);

      if (jsonData["status"] == "Fail") {
        throw AppException(
            message: jsonData['message'],
            errorCode: response.statusCode,
            tag: '');
      }

      return jsonData;
    } catch (exception, stackTrace) {
      client.close();
      throw AppException.exceptionHandler(exception, stackTrace);
    }
  }
}

// class NetworkUtil {
//
//   static NetworkUtil _instance = new NetworkUtil.internal();
//   NetworkUtil.internal();
//   factory NetworkUtil() => _instance;
//
//   final JsonDecoder _decoder = new JsonDecoder();
//
//   Future<dynamic> get(String url) {
//     return http.get(url).then((http.Response response) {
//       final String res = response.body;
//       final int statusCode = response.statusCode;
//
//       if (statusCode < 200 || statusCode > 400 || json == null) {
//         throw new Exception("Error while fetching data");
//       }
//       return _decoder.convert(res);
//     });
//   }
//   Future<dynamic> post(String url, {Map headers, body, encoding}) {
//     return http
//         .post(url, body: body, headers: headers, encoding: encoding)
//         .then((http.Response response) {
//       final String res = response.body;
//       final int statusCode = response.statusCode;
//
//       if (statusCode < 200 || statusCode > 400 || json == null) {
//         throw new Exception("Error while fetching data");
//       }
//       return _decoder.convert(res);
//     });
//   }
// }
