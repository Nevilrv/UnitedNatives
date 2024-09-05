import 'package:united_natives/ResponseModel/doctor_by_specialities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:get/get.dart';
import '../../components/custom_button.dart';
import '../../routes/routes.dart';

class PaymentRegister extends StatefulWidget {
  final NavigationModel? navigationModel;

  const PaymentRegister({super.key, this.navigationModel});
  @override
  State<StatefulWidget> createState() {
    return PaymentRegisterState();
  }
}

class PaymentRegisterState extends State<PaymentRegister> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  GlobalKey<FormState> key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Payment details',
        ),
      ),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            CreditCardWidget(
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              showBackView: isCvvFocused,
              onCreditCardWidgetChange: (creditCardBrand) {},
            ),
            Expanded(
              child: SingleChildScrollView(
                child: CreditCardForm(
                  onCreditCardModelChange: onCreditCardModelChange,
                  cvvCode: '',
                  formKey: key,
                  cardNumber: '',
                  expiryDate: '',
                  cardHolderName: '',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 55),
              //color: Colors.white,
              child: CustomButton(
                textSize: 24,
                onPressed: () {
                  Get.toNamed(Routes.bookingStep5,
                      arguments: widget.navigationModel);
                },
                text: 'confirm',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}
