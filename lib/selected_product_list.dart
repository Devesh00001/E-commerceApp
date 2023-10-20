import 'package:flutter/material.dart';
import 'package:provider_example/product.dart';

import 'selected_product.dart';

class SelectedProductList extends ChangeNotifier {
  List<SelectedProject> list = [];
  Product allList = Product(0, "", "", "", "", "", {"rate": 0.0});
  void add(String image, dynamic price) {
    SelectedProject obj = SelectedProject(image, price);
    list.add(obj);
    notifyListeners();
  }

  void aladd(Product obj) {
    allList = obj;
    notifyListeners();
  }

  void remove(SelectedProject obj) {
    list.remove(obj);
    notifyListeners();
  }
}
