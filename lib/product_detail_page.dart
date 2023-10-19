import 'package:flutter/material.dart';
import 'package:provider_example/product.dart';
import 'package:provider_example/selected_product_list.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

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
              top: 200,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 700,
                width: 410,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromARGB(255, 182, 182, 182)),
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          product.title,
                          style: const TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        height: 40,
                        width: 150,
                        padding: const EdgeInsets.all(2),
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color:
                                    const Color.fromARGB(255, 182, 182, 182))),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.star,
                              color: Color.fromARGB(255, 194, 240, 142),
                            ),
                            Text(
                              ' ${product.rating['rate']}',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            Text('  ${product.rating['count']} reviews',
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w200))
                          ],
                        ),
                      ),
                      Container(
                        height: 60,
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: const Color.fromARGB(255, 223, 223, 223)),
                        child: ListTile(
                          leading: Text(
                            '\$ ${product.price}',
                            style: const TextStyle(fontSize: 20),
                          ),
                          trailing: const Text("Emi available",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w200)),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(8, 8, 8, 4),
                        child: Text("Product Detail : ",
                            style: TextStyle(fontSize: 15)),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 8, 8),
                        child: ReadMoreText(
                          product.description,
                          style: const TextStyle(fontSize: 15),
                          trimLines: 4,
                          trimMode: TrimMode.Line,
                          lessStyle: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                          moreStyle: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ]),
              ),
            ),
            Positioned(
              top: 0,
              child: Container(
                height: 200,
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
                height: 100,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                // ignore: prefer_const_constructors
                decoration: BoxDecoration(color: Colors.white),
                child: GestureDetector(
                  child: Container(
                      height: 50,
                      width: 300,
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 165, 229, 75),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text("Add To Cart",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20)),
                      )),
                  onTap: () {
                    setState(() {
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
