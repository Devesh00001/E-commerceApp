import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider_example/notifi_service.dart';
import 'package:provider_example/product.dart';
import 'package:provider_example/selected_product_list.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:flutter/services.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

const platform = MethodChannel("toast.flutter.io/toast");
const flashLightplatform = MethodChannel("flashlight");

class _ProductDetailPageState extends State<ProductDetailPage> {
  @override
  Widget build(BuildContext context) {
    Product product = context.read<SelectedProductList>().allList;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            title: const Text(
              'Detail',
              style: TextStyle(color: Color.fromARGB(255, 165, 229, 75)),
            ),
            backgroundColor: const Color.fromARGB(255, 48, 48, 48),
            iconTheme: const IconThemeData(
              color: Color.fromARGB(255, 165, 229, 75), //change your color here
            )),
        body: SafeArea(
            child: Stack(
          children: [
            Positioned(
              top: 150.h,
              left: 0,
              right: 0,
              bottom: 40.h,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromARGB(255, 182, 182, 182)),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.r),
                        topRight: Radius.circular(20.r)),
                    color: Colors.white),
                child: ListView(children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 8.h),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            product.title,
                            style: TextStyle(
                                fontSize: 15.sp, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          height: 20.h,
                          width: 100.w,
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 2.h),
                          margin: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 8.h),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(
                                  color: const Color.fromARGB(
                                      255, 182, 182, 182))),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                size: 10.h,
                                Icons.star,
                                color: const Color.fromARGB(255, 194, 240, 142),
                              ),
                              Text(
                                ' ${product.rating['rate']}',
                                style: TextStyle(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text('  ${product.rating['count']} reviews',
                                  style: TextStyle(
                                      fontSize: 8.sp,
                                      fontWeight: FontWeight.w200))
                            ],
                          ),
                        ),
                        Container(
                          height: 30.h,
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 8.h),
                          margin: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 8.h),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r),
                              color: const Color.fromARGB(255, 223, 223, 223)),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '\$ ${product.price}',
                                  style: TextStyle(fontSize: 10.sp),
                                ),
                                Text("Emi available",
                                    style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w200)),
                              ]),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 4.h),
                          child: Text("Product Detail : ",
                              style: TextStyle(fontSize: 15.sp)),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(16.w, 0, 8.w, 8.h),
                          child: ReadMoreText(
                            product.description,
                            style: TextStyle(fontSize: 12.sp),
                            trimLines: 4,
                            trimMode: TrimMode.Line,
                            lessStyle: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            moreStyle: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ]),
                ]),
              ),
            ),
            Positioned(
              top: 0,
              child: Container(
                height: 150.h,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                child: Hero(
                  tag: product.image,
                  child: FadeInImage(
                      image: NetworkImage(product.image),
                      placeholder:
                          const AssetImage("assets/images/picture.png"),
                      imageErrorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.image);
                      }),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                height: 50.h,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                // ignore: prefer_const_constructors
                decoration: BoxDecoration(color: Colors.white),
                child: GestureDetector(
                  child: Container(
                      height: 30.h,
                      width: 200.w,
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 165, 229, 75),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Center(
                        child: Text("Add To Cart",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15.sp)),
                      )),
                  onTap: () {
                    setState(() {
                      // NotificationService().showNotification(
                      //     title: "add to cart", body: product.title);

                      // platform.invokeMethod("showToast");
                      flashLightplatform.invokeListMethod("flashlight");
                      context
                          .read<SelectedProductList>()
                          .add(product.image, product.price);
                    });
                  },
                ),
              ),
            )
          ],
        )));
  }
}
