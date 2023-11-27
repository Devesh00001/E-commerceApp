import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_example/background_page.dart';
import 'package:provider_example/product_service.dart';
import 'package:provider_example/stripe_payment_service.dart';

import 'package:shimmer/shimmer.dart';
import 'product.dart';
import 'selected_product_list.dart';
import 'cart_page.dart';
import 'product_detail_page.dart';

import 'notifi_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:readmore/readmore.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  bool isLoading = true; // Set to true to show the shimmer initially
  List<Product> productList = [];
  final productService =
      ProductService(); // Create an instance of ProductService

  NotificationService service = NotificationService();
  bool isWeb = false;

  @override
  void initState() {
    service.firebaseInit(context);
    service.isTokenRefresh();
    service.setupInteractMessage(context);
    service.requestNotificationPermission();
    service.getDeviceToken().then((value) {
      print("Device Token:");
      print(value);
    });
    super.initState();
    productService.fetchProduct(productList, isLoading).then((value) {
      setState(() {
        isLoading = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 244, 244, 244),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 165, 229, 75),
        child: const Icon(Icons.shopping_cart),
        onPressed: () {
          final StripePayment = StripePaymentService();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CartPage(
                StripePaymentS: StripePayment,
              ),
            ),
          );
        },
      ),
      appBar: AppBar(
        title: const Text(
          'Products',
          style: TextStyle(color: Color.fromARGB(255, 165, 229, 75)),
        ),
        backgroundColor: const Color.fromARGB(255, 48, 48, 48),
      ),
      body: SafeArea(
        child: isLoading
            ? Shimmer(
                gradient: LinearGradient(
                  colors: [
                    Colors.black,
                    Colors.grey[100]!,
                  ],
                  begin: const Alignment(-1.0, -0.3),
                  end: const Alignment(1.0, 0.3),
                ),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 3 / 3.5,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20),
                  itemCount: 20,
                  itemBuilder: (BuildContext context, index) {
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                      elevation: 1.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    );
                  },
                ),
              )
            : Container(
                padding: EdgeInsets.fromLTRB(20.w, 0, 0, 0),
                child: LayoutBuilder(builder: (context, constraints) {
                  if (constraints.maxWidth < 500) {
                    isWeb = false;
                  } else {
                    isWeb = true;
                  }
                  return GridView.builder(
                      itemCount: productList.length,
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: isWeb ? 200 : 200.w,
                          childAspectRatio: 3 / 3.5,
                          mainAxisSpacing: isWeb ? 20 : 20.h,
                          crossAxisSpacing: isWeb ? 20 : 20.w),
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          padding: EdgeInsets.all(8.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                key: GlobalKey(
                                    debugLabel: productList[index].image),
                                onTap: () {
                                  context
                                      .read<SelectedProductList>()
                                      .aladd(productList[index]);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ProductDetailPage(),
                                    ),
                                  );
                                },
                                child: Hero(
                                  tag: productList[index].image,
                                  child: Container(
                                    height: isWeb ? 90 : 90.h,
                                    width: isWeb ? 120 : 120.w,
                                    padding: EdgeInsets.all(10.h),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(
                                          isWeb ? 10 : 10.r),
                                    ),
                                    child: FadeInImage(
                                        image: NetworkImage(
                                            productList[index].image),
                                        placeholder: const AssetImage(
                                            "assets/images/picture.png"),
                                        imageErrorBuilder:
                                            (context, error, stackTrace) {
                                          return const Icon(Icons.image);
                                        }),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: isWeb ? 150 : 150.w,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: isWeb ? 4 : 4.w),
                                        child: ReadMoreText(
                                          productList[index].title,
                                          style: TextStyle(
                                              fontSize: isWeb ? 10 : 10.sp,
                                              fontWeight: FontWeight.bold),
                                          trimLines: 2,
                                          trimMode: TrimMode.Line,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: isWeb ? 5 : 5.w),
                                        child: Text(
                                          "\$ ${productList[index].price}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: isWeb ? 10 : 10.sp,
                                              color: Colors.lightGreen),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                }),
              ),
      ),
    );
  }
}
