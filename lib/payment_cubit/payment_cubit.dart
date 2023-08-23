
import 'package:bloc/bloc.dart';
import 'package:iyzico_with_flutter/payment_repository.dart';
import 'package:iyzico_with_flutter/payment_cubit/payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit() : super(const PaymentInitialState());

  PaymentRepository paymentRepoImpl = PaymentRepository();

  // create function to create payment
  Future<void> createPayment(
      String firstName, String surName,
      double price,
      String cardHolderName,
      String cardNumber,
      String expireMonth,
      String expireYear,
      String cvc) async {
    emit(const PaymentLoadingState());
    final result = await paymentRepoImpl.createPayment(firstName, surName, price, cardHolderName,
        cardNumber, expireMonth, expireYear, cvc);

    if (result.containsValue("success")) {
      emit(PaymentSuccessState(result["price"].toString()));
    } else {
      emit(PaymentFailedState(result["errorMessage"]));
    }
  }

  bool isCreditCardNumberValid(String cardNumber) {
    return paymentRepoImpl.isCreditCardNumberValid(cardNumber);
  }

  bool isCreditCardExpireDateValid(String expireMonth, String expireYear) {
    return paymentRepoImpl.isCreditCardExpireDateValid(expireMonth, expireYear);
  }

  bool isAmexCard(String cardNumber) {
    return paymentRepoImpl.isAmexCard(cardNumber);
  }

  resetState() {
    emit(const PaymentInitialState());
  }
}
