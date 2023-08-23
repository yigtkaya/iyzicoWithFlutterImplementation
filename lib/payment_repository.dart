import 'dart:convert';
import 'package:dio/dio.dart';

class PaymentRepository {

  final dio = Dio();

  Future<Map<String, dynamic>> createPayment(String surName, String firstName, double price, String cardHolderName, String cardNumber, String expireMonth, String expireYear, String cvc) async {
    // make request to firebase function with dio package
    final result = await dio.post(
      'http://10.0.2.2:3000/api/iyzico/pay',
      data: {
        'contactName': '$firstName $surName',
        'city': 'Istanbul',
        'surName': surName,
        'country': 'Turkey',
        'address': 'Nidakule Göztepe, Merdivenköy Mah. Bora Sok. No:1',
        'email': "hasan.kays159@gmail.com",
        'price': price,
        'cardHolderName': cardHolderName,
        'cardNumber': cardNumber,
        'expireMonth': expireMonth,
        'expireYear': expireYear,
        'cvc': cvc,
      },
    );

    return result.data;
  }

  bool isCreditCardNumberValid(String cardNumber) {
    if (cardNumber.isEmpty) return false;

    int sum = 0;
    bool isDouble = false;

    for (int i = cardNumber.length - 1; i >= 0; i--) {
      int digit = int.parse(cardNumber[i]);

      if (isDouble) {
        digit *= 2;
        if (digit > 9) {
          digit -= 9;
        }
      }

      sum += digit;
      isDouble = !isDouble;
    }

    return sum % 10 == 0;
  }

  bool isCreditCardExpireDateValid(String expireMonth, String expireYear) {
    if (expireMonth.isEmpty || expireYear.isEmpty) return false;

    int month = int.parse(expireMonth);
    int year = int.parse(expireYear);

    if (month < 1 || month > 12) return false;

    DateTime now = DateTime.now();
    int currentYear = now.year % 100;

    if (year < currentYear) return false;

    if (year == currentYear && month < now.month) return false;

    return true;
  }

  bool isAmexCard(String cardNumber) {
    if (cardNumber.isEmpty) return false;

    String prefix = cardNumber.substring(0, 2);
    if (cardNumber.length == 15 && (prefix == '34' || prefix == '37')) {
      return true;
    }
    return false;
  }
}