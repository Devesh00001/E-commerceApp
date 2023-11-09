import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider_example/selected_product.dart';
import 'package:http/http.dart' as http;
import 'package:provider_example/selected_product_list.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

List<SelectedProject> list = [];

late double totalAmount;
void getTotalAmount() {
  for (var i in list) {
    totalAmount += i.price;
  }
  print("\$ $totalAmount");
}

class _CartPageState extends State<CartPage> {
  Map<String, dynamic>? paymentIntentData;

  Future<void> makePayment() async {
    try {
      paymentIntentData =
          await createPaymentIntent(totalAmount.toStringAsFixed(2), 'USD');
      var gPay = const PaymentSheetGooglePay(
          merchantCountryCode: "US", currencyCode: "USD", testEnv: true);
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  setupIntentClientSecret:
                      'sk_test_51OA5VDSF5l2QMOmHFK3Uvd2DDzxNLewkfee2crxLSFdy0KLWvlq0fhVajMFJQnrHF9N5ZnbYttZEbugahQQV1VCi00zJEuxcZq',
                  paymentIntentClientSecret:
                      paymentIntentData!["client_secret"],
                  style: ThemeMode.dark,
                  customFlow: true,
                  googlePay: gPay,
                  merchantDisplayName: "Devesh"))
          .then((value) => ());

      displayPaymentSheet();
    } catch (e) {
      print(e.toString());
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((newValue) {
        ScaffoldMessenger.of(context as BuildContext)
            .showSnackBar(const SnackBar(content: Text("paid successfully")));

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
              ));
    } catch (e) {
      print(e.toString());
    }
  }

  createPaymentIntent(String amount, String currency) async {
    final intAmountInCents = (double.parse(amount) * 100).toInt();
    String amountString = intAmountInCents.toString();
    try {
      Map<String, dynamic> body = {
        "amount": amountString,
        "currency": currency,
        'payment_method_types[]': 'card'
      };
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization':
                'Bearer sk_test_51OA5VDSF5l2QMOmHFK3Uvd2DDzxNLewkfee2crxLSFdy0KLWvlq0fhVajMFJQnrHF9N5ZnbYttZEbugahQQV1VCi00zJEuxcZq',
            'Content-Type': 'application/x-www-form-urlencoded'
          });

      return jsonDecode(response.body);
    } catch (e) {
      print(e.toString());
    }
  }

  calculateAmount(double amount) {
    final newAmount = amount * 100;
    return newAmount.toString();
  }

  @override
  void initState() {
    totalAmount = 0;
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    totalAmount = 0;
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    totalAmount = 0;
    list = context.read<SelectedProductList>().list;
    getTotalAmount();

    return Scaffold(
        appBar: AppBar(
            title: const Icon(Icons.shopping_cart),
            backgroundColor: const Color.fromARGB(255, 48, 48, 48),
            iconTheme: const IconThemeData(
              color: Color.fromARGB(255, 165, 229, 75), //change your color here
            )),
        body: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.w, vertical: 8.h),
                            margin: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 10.h),
                            height: 40.h,
                            width: 250.w,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey, //New
                                  blurRadius: 10.0.r,
                                )
                              ],
                            ),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  FadeInImage(
                                      image: NetworkImage(list[index].image),
                                      placeholder: const AssetImage(
                                          "assets/images/picture.png"),
                                      imageErrorBuilder:
                                          (context, error, stackTrace) {
                                        return const Icon(Icons.image);
                                      }),
                                  Text("\$${list[index].price}"),
                                ]),
                          ),
                          GestureDetector(
                            onTap: () {
                              context
                                  .read<SelectedProductList>()
                                  .remove(list[index]);
                              setState(() {});
                            },
                            child: Container(
                              margin: EdgeInsets.fromLTRB(10.w, 10.h, 0, 10.h),
                              height: 40.h,
                              width: 80.w,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey, //New
                                    blurRadius: 10.0.r,
                                  )
                                ],
                              ),
                              child: const Center(child: Text('Remove')),
                            ),
                          )
                        ],
                      );
                    }),
              ),
              Container(
                height: 75.h,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                // ignore: prefer_const_constructors
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 216, 216, 216)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.all(8),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.r)),
                      child: Text("\$ $totalAmount"),
                    ),
                    GestureDetector(
                      child: Container(
                          height: 40.h,
                          width: 100.w,
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 165, 229, 75),
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          child: Center(
                            child: Text("Place Order",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.sp)),
                          )),
                      onTap: () async {
                        await makePayment();
                        print("done");
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
