import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:provider_example/main.dart';
import 'package:provider_example/product.dart';


class ProductService {
  final String api = "https://fakestoreapi.com/products";

  Future<bool> fetchProduct(List<Product> productList, bool isLoading) async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      try {
        final response = await http.get(Uri.parse(api));
        if (response.statusCode == 200) {
          List responseJson = json.decode(response.body.toString());

          productList.clear();
          productList.addAll(createProductList(responseJson));
          print("Get data");

          // Data is loaded, so set isLoading to false to stop shimmer

          isLoading = false;
        } else {}
      } catch (e) {
        print("Error: $e");
      }
    } else {
      isLoading = false;
      final productsBox = await Hive.openBox<Product>("productbox");
      productList.clear();
      productList.addAll(productsBox.values);
    }
    return isLoading;
  }

  List<Product> createProductList(List data) {
    List<Product> list = [];
    box!.clear();
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

      box!.put(i, product);
      list.add(product);
    }
    return list;
  }
}
