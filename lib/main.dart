import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider_example/product.dart';
import 'package:provider_example/product_page.dart';
import 'package:provider/provider.dart';
import 'package:provider_example/selected_product_list.dart';

Box? box;
void main() async {
  Hive.registerAdapter(ProductAdapter());
  await Hive.initFlutter();
  box = await Hive.openBox<Product>("productbox");

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => SelectedProductList())
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ProductPage(),
    );
  }
}
