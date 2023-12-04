import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class StripePaymentService {
  //  Map<String, dynamic>? paymentIntentData;
  //
  //  Future<void> makePayment(double totalAmount,BuildContext context) async {
  //    try {
  //      // paymentIntentData = await createPaymentIntent('10', 'USD');
  //      paymentIntentData =
  //          await createPaymentIntent(totalAmount.toStringAsFixed(2), 'USD');
  //      var gPay = const PaymentSheetGooglePay(
  //          merchantCountryCode: "US", currencyCode: "USD");
  //      await Stripe.instance
  //          .initPaymentSheet(
  //          paymentSheetParameters: SetupPaymentSheetParameters(
  //              setupIntentClientSecret:
  //              'sk_test_51OA5VDSF5l2QMOmHFK3Uvd2DDzxNLewkfee2crxLSFdy0KLWvlq0fhVajMFJQnrHF9N5ZnbYttZEbugahQQV1VCi00zJEuxcZq',
  //              paymentIntentClientSecret:
  //              paymentIntentData!["client_secret"],
  //              style: ThemeMode.dark,
  //              // customFlow: true,
  //              googlePay: gPay,
  //              merchantDisplayName: "Devesh"))
  //          .then((value) => ());
  //
  //      displayPaymentSheet(context);
  //    } catch (e) {
  //      print(e.toString());
  //    }
  //  }
  //
  // displayPaymentSheet(BuildContext context) async {
  //
  //    try {
  //      await Stripe.instance.presentPaymentSheet().then((newValue) {
  //        ScaffoldMessenger.of(context)
  //            .showSnackBar(const SnackBar(content: Text("paid successfully")));
  //
  //        paymentIntentData = null;
  //      }).onError((error, stackTrace) {
  //        print('Exception/DISPLAYPAYMENTSHEET==> $error $stackTrace');
  //      });
  //    } on StripeException catch (e) {
  //      print('Exception/DISPLAYPAYMENTSHEET==> $e');
  //      // ignore: use_build_context_synchronously
  //      showDialog(
  //          context: context ,
  //          builder: (_) => const AlertDialog(
  //            content: Text("Cancelled "),
  //          ));
  //    } catch (e) {
  //      print(e.toString());
  //    }
  //  }
  //
  //  Future<Map<String, dynamic>>  createPaymentIntent(String amount, String currency) async {
  //    final intAmountInCents = (double.parse(amount) * 100).toInt();
  //    String amountString = intAmountInCents.toString();
  //    try {
  //      Map<String, dynamic> body = {
  //        "amount": amountString,
  //        "currency": currency,
  //      };
  //      var response = await http.post(
  //          Uri.parse('https://api.stripe.com/v1/payment_intents'),
  //          body: body,
  //          headers: {
  //            'Authorization':
  //            'Bearer sk_test_51OA5VDSF5l2QMOmHFK3Uvd2DDzxNLewkfee2crxLSFdy0KLWvlq0fhVajMFJQnrHF9N5ZnbYttZEbugahQQV1VCi00zJEuxcZq',
  //            'Content-Type': 'application/x-www-form-urlencoded'
  //          });
  //
  //      return jsonDecode(response.body);
  //    } catch (e) {
  //      print(e.toString());
  //      return{};
  //    }
  //  }
  //
  //  calculateAmount(double amount) {
  //    final newAmount = amount * 100;
  //    return newAmount.toString();
  //  }

  Map<String, dynamic>? paymentIntentData;

  Future<void> makePayment(
    double totalAmount,
    BuildContext context,
  ) async {
    try {
      paymentIntentData =
          await createPaymentIntent(totalAmount.toStringAsFixed(2), 'USD');

      var gPay = const PaymentSheetGooglePay(
        merchantCountryCode: "US",
        currencyCode: "USD",
      );

      await Stripe.instance
          .initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
              setupIntentClientSecret:
                  'sk_test_51OA5VDSF5l2QMOmHFK3Uvd2DDzxNLewkfee2crxLSFdy0KLWvlq0fhVajMFJQnrHF9N5ZnbYttZEbugahQQV1VCi00zJEuxcZq',
              paymentIntentClientSecret: paymentIntentData!["client_secret"],
              style: ThemeMode.dark,
              googlePay: gPay,
              merchantDisplayName: "Devesh",
            ),
          )
          .then((value) => ());

      displayPaymentSheet(context);
    } catch (e) {
      print(e.toString());
    }
  }

  displayPaymentSheet(
    BuildContext context,
  ) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((newValue) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Paid successfully")),
        );

        paymentIntentData = null;
      }).onError((error, stackTrace) {
        print('Exception/DISPLAYPAYMENTSHEET==> $error $stackTrace');
      });
    } on StripeException catch (e) {
      print('Exception/DISPLAYPAYMENTSHEET==> $e');
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          content: Text("Cancelled "),
        ),
      );
    } catch (e) {
      print(e.toString());
    }
  }

  Future<Map<String, dynamic>> createPaymentIntent(
    String amount,
    String currency,
  ) async {
    final intAmountInCents = (double.parse(amount) * 100).toInt();
    String amountString = intAmountInCents.toString();
    try {
      Map<String, dynamic> body = {
        "amount": amountString,
        "currency": currency,
      };
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        body: body,
        headers: {
          'Authorization':
              'Bearer sk_test_51OA5VDSF5l2QMOmHFK3Uvd2DDzxNLewkfee2crxLSFdy0KLWvlq0fhVajMFJQnrHF9N5ZnbYttZEbugahQQV1VCi00zJEuxcZq',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
      );

      return jsonDecode(response.body);
    } catch (e) {
      print(e.toString());
      return {};
    }
  }

  calculateAmount(double amount) {
    final newAmount = amount * 100;
    return newAmount.toString();
  }
}
