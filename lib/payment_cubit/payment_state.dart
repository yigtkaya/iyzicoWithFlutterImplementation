import 'package:flutter/cupertino.dart';

import '../models/iyzico_error.dart';


@immutable
abstract class PaymentState {
  const PaymentState();
}
// create initial state
class PaymentInitialState extends PaymentState {
  const PaymentInitialState();
}

// create loading state
class PaymentLoadingState extends PaymentState {
  const PaymentLoadingState();
}

// create loaded state
class PaymentLoadedState extends PaymentState {
  const PaymentLoadedState();
}

class PaymentSuccessState extends PaymentState {
  final String paidPrice;
  const PaymentSuccessState(this.paidPrice);
}

class PaymentFailedState extends PaymentState {
  final String errorMessage;
  const PaymentFailedState(this.errorMessage);
}

// create error state
class PaymentErrorState extends PaymentState {
  final IyzicoError iyzicoError;
  const PaymentErrorState(this.iyzicoError);
}

