import 'dart:convert';

class ProductList {
  final int id;
  final String name;
  final String price;
  final String image;
  final String description;
  final List<int> variations;

  ProductList({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.description,
    required this.variations,
  });

  factory ProductList.fromJson(Map<String, dynamic> json) {
  return ProductList(
    id: json['id'],
    name: json['name'],
    price: json['price'].toString(), // Convert price to String
    image: json['images'] != null ? json['images'][0]['src'] : '',
    description: json['description'],
    variations: List<int>.from(json['variations'] ?? []), // Initialize variations with an empty list if null
  );
}
  static List<ProductList> fromJsonList(dynamic jsonList) {
    final productList = <ProductList>[];
    if (jsonList == null) return productList;

    if (jsonList is List<dynamic>) {
      for (final json in jsonList) {
        productList.add(
          ProductList.fromJson(json),
        );
      }
    }

    return productList;
  }

  
}
