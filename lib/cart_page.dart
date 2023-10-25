import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:provider_example/selected_product_list.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    final list = context.read<SelectedProductList>().list;
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
          child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index) {
                return Row(
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        context.read<SelectedProductList>().remove(list[index]);
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
        ));
  }
}
