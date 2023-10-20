import 'package:hive/hive.dart';

part 'product.g.dart';

@HiveType(typeId: 1)
class Product {
  @HiveField(0)
  late int id;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late dynamic price;

  @HiveField(3)
  late String description;

  @HiveField(4)
  late String category;

  @HiveField(5)
  late String image;

  @HiveField(6)
  late Map<String, dynamic> rating;

  Product(this.id, this.title, this.price, this.description, this.category,
      this.image, this.rating);
}
