// To parse this JSON data, do
//
//     final product = productFromMap(jsonString);

import 'dart:convert';

class Product {
  Product({
    required this.available,
    this.image,
    required this.name,
    required this.price,
    this.id,
  });

  bool available;
  String? image;
  String name;
  double price;
  String? id;

  factory Product.fromJson(String str) => Product.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Product.fromMap(Map<String, dynamic> json) => Product(
        available: json["available"],
        image: json["image"],
        name: json["name"],
        price: json["price"].toDouble(),
      );

  Map<String, dynamic> toMap() => {
        "available": available,
        "image": image,
        "name": name,
        "price": price,
      };

  Product copy() => Product(
        available: available,
        name: name,
        price: price,
        id: id,
        image: image,
      );
}
