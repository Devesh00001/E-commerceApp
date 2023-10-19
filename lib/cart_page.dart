import 'package:flutter/material.dart';

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
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.all(10),
                      height: 80,
                      width: 300,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey, //New
                            blurRadius: 10.0,
                          )
                        ],
                      ),
                      child: ListTile(
                        leading: FadeInImage(
                            image: NetworkImage(list[index].image),
                            placeholder:
                                const AssetImage("assets/images/picture.png"),
                            imageErrorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.image);
                            }),
                        trailing: Text(list[index].price.toString()),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.read<SelectedProductList>().remove(list[index]);
                        setState(() {});
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                        height: 80,
                        width: 70,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey, //New
                              blurRadius: 10.0,
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
