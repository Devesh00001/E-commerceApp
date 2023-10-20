import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider_example/main.dart';
import 'package:provider_example/product_detail_page.dart';
import 'package:provider_example/selected_product_list.dart';
import 'package:shimmer/shimmer.dart';
import 'cart_page.dart';
import 'product.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  bool isLoading = true; // Set to true to show the shimmer initially
  List<Product> ProductList = [];

  String api = "https://fakestoreapi.com/products";

  Future<void> fetchProduct() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      try {
        final response = await http.get(Uri.parse(api));
        if (response.statusCode == 200) {
          print(response.body);
          List responseJson = json.decode(response.body.toString());

          ProductList = createProductList(responseJson);

          // Data is loaded, so set isLoading to false to stop shimmer
          setState(() {
            isLoading = false;
          });
        } else {
          print("Error in calling API");
        }
      } catch (e) {
        print("Error: $e");
      }
      print("Internet connection is from Mobile data");
    } else {
      setState(() {
        isLoading = false;
      });
      final productsBox = await Hive.openBox<Product>("productbox");
      ProductList = productsBox.values.toList();

      print("not connected");
    }
  }

  List<Product> createProductList(List data) {
    List<Product> list = [];
    for (int i = 0; i < data.length; i++) {
      String title = data[i]["title"];
      int id = data[i]["id"];
      dynamic price = data[i]["price"];
      String description = data[i]['description'];
      String category = data[i]['category'];
      String image = data[i]['image'];
      Map<String, dynamic> rating = data[i]['rating'];

      Product product =
          Product(id, title, price, description, category, image, rating);
      box!.clear();
      box!.put(i, product);
      list.add(product);
    }
    return list;
  }

  @override
  void initState() {
    super.initState();
    fetchProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 244, 244, 244),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 165, 229, 75),
        child: const Icon(Icons.shopping_cart),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CartPage(),
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
                  begin: Alignment(-1.0, -0.3),
                  end: Alignment(1.0, 0.3),
                ),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 3 / 3.5,
                      crossAxisSpacing: 20),
                  itemCount: 10,
                  itemBuilder: (BuildContext context, index) {
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      elevation: 1.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    );
                  },
                ),
              )
            : Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: GridView.builder(
                    itemCount: ProductList.length,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 3 / 3.5,
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 20),
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                context
                                    .read<SelectedProductList>()
                                    .aladd(ProductList[index]);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ProductDetailPage(),
                                  ),
                                );
                              },
                              child: Hero(
                                tag: ProductList[index].image,
                                child: Container(
                                  height: 120,
                                  width: 150,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: FadeInImage(
                                      image: NetworkImage(
                                          ProductList[index].image),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 150,
                                      padding: const EdgeInsets.all(4),
                                      child: ReadMoreText(
                                        ProductList[index].title,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                        trimLines: 2,
                                        trimMode: TrimMode.Line,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: Text(
                                        "\$ ${ProductList[index].price}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 25,
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
                    }),
              ),
      ),
    );
  }
}
