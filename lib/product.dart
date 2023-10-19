class Product {
  late int id;
  late String title;
  late dynamic price;
  late String description;
  late String category;
  late String image;
  late Map<String, dynamic> rating;

  Product(this.id, this.title, this.price, this.description, this.category,
      this.image, this.rating);
}
