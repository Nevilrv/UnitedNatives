import 'dart:async';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:http_auth/http_auth.dart';

class PaypalServices {
  String domain = "https://api.sandbox.paypal.com"; // for sandbox mode
//  String domain = "https://api.paypal.com"; // for production mode

  // change clientId and secret with your own, provided by paypal
  // String clientId =
  //     'AYOJCALa_tp-zDDGfn27u-or_n-THGArZdFqfuIVRLXcQT3GQy8kDcvKigaTETbjy_Jz5tVuagBl15xS';
  // String secret =
  //     'EEXK9216nQ9G1Fcx0SK_23OlYx7kK9rRGKiQdNgV2_JxBFFtaPURIulK9jiH-vqSdOzG1YY6avE5fyfi';

  String clientId =
      'AeH1VUdPwLIouTJ9Bpa_PGUYJ8pMtw4hk7FxsN7mHToCRrNaIJ6W55sQpiOAkMs5KdIHEmSECIv3YBa_';
  String secret =
      'EKa_0vKbsMoT5wiV8V33SiotxMOtBa9wu9cnhwqmqUOOAQu4q5RJKbcq1cRdG-9y4Y1tCm2axbkNiGaF';

  // for getting the access token from Paypal
  Future<String?> getAccessToken() async {
    try {
      var client = BasicAuthClient(clientId, secret);
      var response = await client.post(
          Uri.parse('$domain/v1/oauth2/token?grant_type=client_credentials'));
      if (response.statusCode == 200) {
        final body = convert.jsonDecode(response.body);
        return body["access_token"];
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // for creating the payment request with Paypal
  Future<Map<String, String>?> createPaypalPayment(
      transactions, accessToken) async {
    try {
      var response = await http.post(Uri.parse("$domain/v1/payments/payment"),
          body: convert.jsonEncode(transactions),
          headers: {
            "content-type": "application/json",
            'Authorization': 'Bearer $accessToken'
          });

      final body = convert.jsonDecode(response.body);
      if (response.statusCode == 201) {
        if (body["links"] != null && body["links"].length > 0) {
          List links = body["links"];

          String executeUrl = "";
          String approvalUrl = "";
          final item = links.firstWhere((o) => o["rel"] == "approval_url",
              orElse: () => null);
          if (item != null) {
            approvalUrl = item["href"];
          }
          final item1 = links.firstWhere((o) => o["rel"] == "execute",
              orElse: () => null);
          if (item1 != null) {
            executeUrl = item1["href"];
          }
          return {"executeUrl": executeUrl, "approvalUrl": approvalUrl};
        }
        return null;
      } else {
        throw Exception(body["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  // for executing the payment transaction
  Future<String?> executePayment(url, payerId, accessToken) async {
    try {
      var response = await http.post(url,
          body: convert.jsonEncode({"payer_id": payerId}),
          headers: {
            "content-type": "application/json",
            'Authorization': 'Bearer $accessToken'
          });

      final body = convert.jsonDecode(response.body);
      if (response.statusCode == 200) {
        return body["id"];
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }
}
