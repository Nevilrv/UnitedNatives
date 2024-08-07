import 'dart:core';
import 'package:doctor_appointment_booking/controller/patient_homescreen_controller.dart';
import 'package:doctor_appointment_booking/model/booked_appointment_data.dart';
import 'package:doctor_appointment_booking/model/paymentPaypalModel.dart';
import 'package:doctor_appointment_booking/routes/routes.dart';
import 'package:doctor_appointment_booking/sevices/patient_home_screen_service.dart';
import 'package:doctor_appointment_booking/sevices/paypal_service.dart';
import 'package:doctor_appointment_booking/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaypalPayment extends StatefulWidget {
  final Function onFinish;
  final PaypalPaymentModel paypalPaymentModel;

  PaypalPayment({this.onFinish, this.paypalPaymentModel});

  @override
  State<StatefulWidget> createState() {
    return PaypalPaymentState();
  }
}

class PaypalPaymentState extends State<PaypalPayment> {
  PatientHomeScreenController _patientHomeScreenController = Get.find();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String checkoutUrl;
  String executeUrl;
  String accessToken;
  PaypalServices services = PaypalServices();
  String doctorFee;

  Map<dynamic, dynamic> defaultCurrency = {
    "symbol": "USD",
    "decimalDigits": 2,
    "symbolBeforeTheNumber": true,
    "currency": "USD"
  };

  bool isEnableShipping = false;
  bool isEnableAddress = false;

  String returnURL = 'return.example.com';
  String cancelURL = 'cancel.example.com';

  @override
  void initState() {
    super.initState();
    print('hello.......');
    doctorFee = widget.paypalPaymentModel.doctorFees;
    Future.delayed(Duration.zero, () async {
      print('hello.......111');
      try {
        print('hello.......122');
        accessToken = await services.getAccessToken();
        print('accessToken $accessToken');
        final transactions = getOrderParams();
        print('transactions $transactions');
        final res =
            await services.createPaypalPayment(transactions, accessToken);
        print('hello.......1');
        if (res != null) {
          setState(() {
            print("checkoutUrl  => $checkoutUrl");
            checkoutUrl = res["approvalUrl"];
            print("checkoutUrl  => $checkoutUrl");
            executeUrl = res["executeUrl"];
          });
        }
      } catch (e) {
        print('exception: ' + e.toString());
        final snackBar = SnackBar(
          content: Text(e.toString()),
          duration: Duration(seconds: 10),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        );
        _scaffoldKey.currentState.showSnackBar(snackBar);
      }
    });
  }

  // item name, price and quantity
  String itemName = 'Doctor Appoirment';
  //String itemPrice = '1.99';
  int quantity = 1;

  Map<String, dynamic> getOrderParams() {
    List items = [
      {
        "name": itemName,
        "quantity": quantity,
        "price": '100.00',
        "currency": defaultCurrency["currency"]
      }
    ];

    // checkout invoice details
    String totalAmount = doctorFee;
    String subTotalAmount = doctorFee;
    String shippingCost = '0';
    int shippingDiscountCost = 0;
    String userFirstName = widget.paypalPaymentModel.firstName;
    String userLastName = widget.paypalPaymentModel.lastName;
    String addressCity = 'Delhi';
    String addressStreet = 'Mathura Road';
    String addressZipCode = '110014';
    String addressCountry = 'India';
    String addressState = 'Delhi';
    String addressPhoneNumber = '+919990119091';

    Map<String, dynamic> temp = {
      "intent": "sale",
      "payer": {"payment_method": "paypal"},
      "transactions": [
        {
          "amount": {
            "total": totalAmount,
            "currency": defaultCurrency["currency"],
            "details": {
              "subtotal": subTotalAmount,
              "shipping": shippingCost,
              "shipping_discount": ((-1.0) * shippingDiscountCost).toString()
            }
          },
          "description": "The payment transaction description.",
          "payment_options": {
            "allowed_payment_method": "INSTANT_FUNDING_SOURCE"
          },
          "item_list": {
            "items": items,
            if (isEnableShipping && isEnableAddress)
              "shipping_address": {
                "line1": addressStreet,
                "line2": "",
                "city": addressCity,
                "country_code": addressCountry,
                "recipient_name": userFirstName + " " + userLastName,
                // "line1": addressStreet,
                // "line2": "",
                // "city": addressCity,
                // "country_code": addressCountry,
                "postal_code": addressZipCode,
                "phone": addressPhoneNumber,
                "state": addressState
              },
          }
        }
      ],
      "note_to_payer": "Contact us for any questions on your order.",
      "redirect_urls": {"return_url": returnURL, "cancel_url": cancelURL}
    };
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    print("doctorrrfeess ==> $doctorFee");
    if (checkoutUrl != null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          leading: GestureDetector(
            child: Icon(Icons.arrow_back_ios),
            onTap: () => Navigator.pop(context),
          ),
        ),
        body: WebView(
          initialUrl: checkoutUrl,
          javascriptMode: JavascriptMode.unrestricted,
          navigationDelegate: (NavigationRequest request) async {
            if (request.url.contains(returnURL)) {
              final uri = Uri.parse(request.url);
              final payerID = uri.queryParameters['PayerID'];
              final token = uri.queryParameters['token'];
              final paymentID = uri.queryParameters['paymentId'];
              print(
                  "token----->$token\npaymentID----->$paymentID\npayerID-------->$payerID");
              print(
                  "token----->$token\npaymentID----->$paymentID\npayerID-------->$payerID");
              if (payerID != null) {
                services
                    .executePayment(executeUrl, payerID, accessToken)
                    .then((id) {
                  widget.onFinish(id);
                });
                AppointmentBookedModel _appointmentBookedModel =
                    await _patientHomeScreenController.addPatientAppointment(
                  patientId: widget.paypalPaymentModel.patientId ?? "",
                  appointmentDate:
                      widget?.paypalPaymentModel?.appointmentDate ?? "",
                  appointmentTime:
                      widget.paypalPaymentModel.appointmentTime ?? "",
                  doctorId: widget.paypalPaymentModel.doctorId ?? "",
                  fullName: widget.paypalPaymentModel.fullName ?? "",
                  mobile: widget.paypalPaymentModel.mobile ?? "",
                  appointmentFor:
                      widget.paypalPaymentModel.appointmentFor ?? "",
                  email: widget.paypalPaymentModel.email ?? "",
                  patientMobile: widget.paypalPaymentModel.patientMobile ?? "",
                  purposeOfVisit:
                      widget?.paypalPaymentModel?.purposeOfVisit ?? "",
                );

                PatientHomeScreenService().getPaypalPayment(
                    appointmentId: _appointmentBookedModel.data,
                    payAmount: doctorFee,
                    paypalPayerId: payerID,
                    paypalpaymentId: paymentID,
                    paypalToken: accessToken,
                    payType: "paypal",
                    userId: widget.paypalPaymentModel.patientId);

                print("sucessfullpayment ==> ");
                await Get.offNamed(Routes.bookingStep5);
              } else {
                Navigator.of(context).pop();
              }
              Navigator.of(context).pop();
            }
            if (request.url.contains(cancelURL)) {
              Navigator.of(context).pop();
            }
            return NavigationDecision.navigate;
          },
        ),
      );
    } else {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          backgroundColor: Colors.black12,
          elevation: 0.0,
        ),
        body: Center(
            child: Container(
                child: Center(
          child: Utils.circular(),
        ))),
      );
    }
  }
}
