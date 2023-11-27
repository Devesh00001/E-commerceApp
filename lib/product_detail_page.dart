import 'package:floating/floating.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:provider_example/product.dart';
import 'package:provider_example/selected_product_list.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

const platform = MethodChannel("toast.flutter.io/toast");
const flashLightplatform = MethodChannel("flashlight");

bool isWeb = false;

class _ProductDetailPageState extends State<ProductDetailPage> {
  late Floating floating;
  bool isPipAvalable = false;
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    floating = Floating();
    requestPipAvalable();
    _controller = VideoPlayerController.networkUrl(Uri.parse(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'))
      ..initialize().then((_) {
        _controller.setLooping(true);
        _controller.play();
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  Widget justVideo() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: VideoPlayer(_controller),
    );
  }

  Future<void> requestPipAvalable() async {
    isPipAvalable = await floating.isPipAvailable;
  }

  @override
  void dispose() {
    floating.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Product product = context.read<SelectedProductList>().allList;

    return PiPSwitcher(
      childWhenDisabled: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
              title: const Text(
                'Detail',
                style: TextStyle(color: Color.fromARGB(255, 165, 229, 75)),
              ),
              backgroundColor: const Color.fromARGB(255, 48, 48, 48),
              iconTheme: const IconThemeData(
                color:
                    Color.fromARGB(255, 165, 229, 75), //change your color here
              )),
          floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.picture_in_picture),
              onPressed: isPipAvalable
                  ? () => floating.enable(aspectRatio: Rational.landscape())
                  : null),
          body: SafeArea(child: LayoutBuilder(builder: (context, constraints) {
            if (constraints.maxWidth < 500) {
              isWeb = false;
            } else {
              isWeb = true;
            }
            return Stack(
              children: [
                Positioned(
                  top: isWeb ? 150 : 150.h,
                  left: 0,
                  right: 0,
                  bottom: isWeb ? 40 : 40.h,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: isWeb ? 8 : 8.w, vertical: isWeb ? 8 : 8.h),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromARGB(255, 182, 182, 182)),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(isWeb ? 20 : 20.r),
                            topRight: Radius.circular(isWeb ? 20 : 20.r)),
                        color: Colors.white),
                    child: ListView(children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: isWeb ? 8 : 8.w,
                                  vertical: isWeb ? 8 : 8.h),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                product.title,
                                style: TextStyle(
                                    fontSize: isWeb ? 15 : 15.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              height: isWeb ? 20 : 20.h,
                              width: isWeb ? 100 : 100.w,
                              padding: EdgeInsets.symmetric(
                                  horizontal: isWeb ? 2 : 2.w,
                                  vertical: isWeb ? 2 : 2.h),
                              margin: EdgeInsets.symmetric(
                                  horizontal: isWeb ? 8 : 8.w,
                                  vertical: isWeb ? 8 : 8.h),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.circular(isWeb ? 8 : 8.r),
                                  border: Border.all(
                                      color: const Color.fromARGB(
                                          255, 182, 182, 182))),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    size: isWeb ? 10 : 10.h,
                                    Icons.star,
                                    color: const Color.fromARGB(
                                        255, 194, 240, 142),
                                  ),
                                  Text(
                                    ' ${product.rating['rate']}',
                                    style: TextStyle(
                                        fontSize: isWeb ? 10 : 10.sp,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text('  ${product.rating['count']} reviews',
                                      style: TextStyle(
                                          fontSize: isWeb ? 8 : 8.sp,
                                          fontWeight: FontWeight.w200))
                                ],
                              ),
                            ),
                            Container(
                              height: isWeb ? 30 : 30.h,
                              padding: EdgeInsets.symmetric(
                                  horizontal: isWeb ? 8 : 8.w,
                                  vertical: isWeb ? 8 : 8.h),
                              margin: EdgeInsets.symmetric(
                                  horizontal: isWeb ? 8 : 8.w,
                                  vertical: isWeb ? 8 : 8.h),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(isWeb ? 8 : 8.r),
                                  color:
                                      const Color.fromARGB(255, 223, 223, 223)),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '\$ ${product.price}',
                                      style: TextStyle(
                                          fontSize: isWeb ? 10 : 10.sp),
                                    ),
                                    Text("Emi available",
                                        style: TextStyle(
                                            fontSize: isWeb ? 12 : 12.sp,
                                            fontWeight: FontWeight.w200)),
                                  ]),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                  isWeb ? 8 : 8.w,
                                  isWeb ? 8 : 8.h,
                                  isWeb ? 8 : 8.w,
                                  isWeb ? 8 : 4.h),
                              child: Text("Product Detail : ",
                                  style:
                                      TextStyle(fontSize: isWeb ? 15 : 15.sp)),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(isWeb ? 16 : 16.w, 0,
                                  isWeb ? 8 : 8.w, isWeb ? 8 : 8.h),
                              child: ReadMoreText(
                                product.description,
                                style: TextStyle(fontSize: isWeb ? 12 : 12.sp),
                                trimLines: isWeb ? 8 : 4,
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
                    height: isWeb ? 150 : 150.h,
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
                    height: isWeb ? 50 : 50.h,
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    // ignore: prefer_const_constructors
                    decoration: BoxDecoration(color: Colors.white),
                    child: GestureDetector(
                      child: Container(
                          height: isWeb ? 30 : 30.h,
                          width: isWeb ? 200 : 200.w,
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 165, 229, 75),
                            borderRadius:
                                BorderRadius.circular(isWeb ? 12 : 12.r),
                          ),
                          child: Center(
                            child: Text("Add To Cart",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: isWeb ? 15 : 15.sp)),
                          )),
                      onTap: () {
                        setState(() {
                          // NotificationService().showNotification(
                          //     title: "add to cart", body: product.title);

                          platform.invokeMethod("showToast");
                          // flashLightplatform.invokeListMethod("flashlight");
                          context
                              .read<SelectedProductList>()
                              .add(product.image, product.price);
                        });
                      },
                    ),
                  ),
                )
              ],
            );
          }))),
      childWhenEnabled: justVideo(),
    );
  }
}
