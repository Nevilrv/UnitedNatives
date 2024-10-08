import 'package:united_natives/medicle_center/lib/models/model_bank_account.dart';
import 'package:united_natives/medicle_center/lib/models/model_payment_method.dart';

class BookingPaymentModel {
  bool? use;
  String? term;
  PaymentMethodModel? method;
  List<PaymentMethodModel>? listMethod;
  List<BankAccountModel>? listAccount;

  BookingPaymentModel({
    this.use,
    this.term,
    this.method,
    this.listMethod,
    this.listAccount,
  });

  factory BookingPaymentModel.fromJson(Map<String, dynamic> json) {
    PaymentMethodModel? method;
    if (json['use'] == true) {
      method = PaymentMethodModel.fromJson(
          List.from(json['list'] ?? []).firstWhere((e) {
        return e['method'] == json['default'];
      }, orElse: () {
        return json['list'][0];
      }));
    }
    return BookingPaymentModel(
      use: json['use'] ?? false,
      term: json['term_condition_page'] ?? '',
      method: method,
      listMethod: List.from(json['list'] ?? []).map((e) {
        return PaymentMethodModel.fromJson(e);
      }).toList(),
      listAccount: List.from(json['bank_account_list'] ?? []).map((e) {
        return BankAccountModel.fromJson(e);
      }).toList(),
    );
  }
}
