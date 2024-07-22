import 'dart:convert';

class TopRatedProductList {
  
  final String name;
  final String price;
  final String image;
  final String description;
  

  TopRatedProductList(
      {
      required this.name,
      required this.price,
      required this.image,
      required this.description

   });

  factory TopRatedProductList.fromJson(Map<String, dynamic> json) {
    return TopRatedProductList(
        name : json['name'],
        price: json['price'],
        image: json['images'] != null ? json['images'][0]['src'] :'',
        description:json['description'],
      );
  }

  static List<TopRatedProductList> fromJsonList(dynamic jsonList) {
    final topRatedProductList = <TopRatedProductList>[];
    if (jsonList == null) return topRatedProductList;

    if (jsonList is List<dynamic>) {
      for (final json in jsonList) {
        topRatedProductList.add(
          TopRatedProductList.fromJson(json),
        );
      }
    }

    return topRatedProductList;
  }
}