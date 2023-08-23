import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iyzico_with_flutter/payment_cubit/payment_cubit.dart';
import 'package:iyzico_with_flutter/payment_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PaymentCubit>(
      create: (context) => PaymentCubit(),
      child: MaterialApp(
        title: 'Iyzico Integration With Flutter',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const PaymentView(),
      ),
    );
  }
}
