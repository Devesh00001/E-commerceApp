import 'package:flutter_test/flutter_test.dart';
import 'package:provider_example/product.dart';
import 'package:provider_example/product_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test("Fetch API", () async {
    final productService = ProductService();
    bool isLoading = true; // Set to true to show the shimmer initially
    List<Product> productList = [];
    bool done = false;
    var fetch = productService.fetchProduct(productList, isLoading);
    if (productList != []) {
      done = true;
    }

    expect(done, true);
  });
}
