import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:iyzico_with_flutter/payment_cubit/payment_cubit.dart';
import 'package:iyzico_with_flutter/payment_cubit/payment_state.dart';

class PaymentView extends StatefulWidget {
  const PaymentView({super.key});

  @override
  State<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  Color themeColor = Colors.deepPurple;
  bool isCvvFocused = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Iyzico Integration With Flutter',
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0),
            child: BlocBuilder<PaymentCubit, PaymentState>(
              builder: (context, state) {
                if (state is PaymentInitialState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CreditCardWidget(
                        cardNumber: cardNumber,
                        expiryDate: expiryDate,
                        cardHolderName: cardHolderName,
                        cvvCode: cvvCode,
                        showBackView: isCvvFocused,
                        onCreditCardWidgetChange: (creditCardModel) {},
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: CreditCardForm(
                            formKey: formKey,
                            cardNumber: cardNumber,
                            expiryDate: expiryDate,
                            cardHolderName: cardHolderName,
                            cvvCode: cvvCode,
                            onCreditCardModelChange: onCreditCardModelChange,
                            themeColor: themeColor,
                            obscureCvv: true,
                            obscureNumber: true,
                            isHolderNameVisible: true,
                            isCardNumberVisible: true,
                            isExpiryDateVisible: true,
                          ),
                        ),
                      ),
                      payButton(),
                    ],
                  );
                }
                if (state is PaymentLoadingState) {
                  return Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CreditCardWidget(
                            cardNumber: cardNumber,
                            expiryDate: expiryDate,
                            cardHolderName: cardHolderName,
                            cvvCode: cvvCode,
                            showBackView: isCvvFocused,
                            onCreditCardWidgetChange: (creditCardModel) {},
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: CreditCardForm(
                                formKey: formKey,
                                cardNumber: cardNumber,
                                expiryDate: expiryDate,
                                cardHolderName: cardHolderName,
                                cvvCode: cvvCode,
                                onCreditCardModelChange:
                                    onCreditCardModelChange,
                                themeColor: themeColor,
                                obscureCvv: true,
                                obscureNumber: true,
                                isHolderNameVisible: true,
                                isCardNumberVisible: true,
                                isExpiryDateVisible: true,
                              ),
                            ),
                          ),
                          payButton(),
                        ],
                      ),
                      Center(
                        child: CircularProgressIndicator(
                          color: Colors.deepPurple,
                        ),
                      ),
                    ],
                  );
                }
                if (state is PaymentSuccessState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Image.asset(
                          'assets/images/success.png',
                          height: 200,
                          width: 200,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Payment successful: ',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Paid Price ${state.paidPrice}',
                        style: const TextStyle(
                            fontSize: 20,
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      ElevatedButton(onPressed: () {
                        context.read<PaymentCubit>().resetState();
                      }, child: const Text('Try Again'),),
                    ],
                  );
                }
                if (state is PaymentFailedState) {
                  return Column(
                    children: [
                      Image.asset(
                        'assets/images/failure.png',
                        height: 200,
                        width: 200,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Text('failed with: ${state.errorMessage}'),
                      ),
                      const Spacer(),
                      ElevatedButton(onPressed: () {
                        context.read<PaymentCubit>().resetState();
                      }, child: const Text('Try Again'),),
                    ],
                  );
                }
                else {
                  return const Center(
                    child: Text("something went wrong"),
                  );
                }
              },
            )),
      ),
    );
  }

  Widget payButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          var expireMonth = expiryDate.split('/')[0];
          var expireYear = '20${expiryDate.split('/')[1]}';
          var firstName = cardHolderName.split(' ')[0];
          var surName = cardHolderName.split(' ')[1];
          var cardNum = cardNumber.replaceAll(' ', '');

          if (context.read<PaymentCubit>().isAmexCard(cardNum)) {
            if (context
                .read<PaymentCubit>()
                .isCreditCardExpireDateValid(expireMonth, expireYear)) {
              context.read<PaymentCubit>().createPayment(
                  firstName,
                  surName,
                  10.2,
                  cardHolderName,
                  cardNum,
                  expireMonth,
                  expireYear,
                  cvvCode);
            }
          } else {
            if (context
                    .read<PaymentCubit>()
                    .isCreditCardExpireDateValid(expireMonth, expireYear) &&
                context.read<PaymentCubit>().isCreditCardNumberValid(cardNum)) {
              context.read<PaymentCubit>().createPayment(
                  firstName,
                  surName,
                  11.2,
                  cardHolderName,
                  cardNum,
                  expireMonth,
                  expireYear,
                  cvvCode);
            }
          }
        },
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.deepPurple),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 14.0),
              child: Center(
                child: Text('Pay',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            )),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    setState(() {
      cardNumber = creditCardModel!.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      isCvvFocused = creditCardModel.isCvvFocused;
      if (creditCardModel.cvvCode.length <= 3) {
        cvvCode = creditCardModel.cvvCode;
      }
    });
  }
}
