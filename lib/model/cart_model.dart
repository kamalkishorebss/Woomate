import 'dart:convert';

class CartList {
  final int id;
  final String name;
  final String price;
  final String image;
  final String description;
  

  CartList({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.description,
    
  });

  factory CartList.fromJson(Map<String, dynamic> json) {
  return CartList(
    id: json['id'],
    name: json['name'],
    price: json['price'].toString(), // Convert price to String
    image: json['images'] != null ? json['images'][0]['src'] : '',
    description: json['description'],
   // Initialize variations with an empty list if null
  );
}
  static List<CartList> fromJsonList(dynamic jsonList) {
    final cartList = <CartList>[];
    if (jsonList == null) return cartList;

    if (jsonList is List<dynamic>) {
      for (final json in jsonList) {
        cartList.add(
          CartList.fromJson(json),
        );
      }
    }

    return cartList;
  }
}
