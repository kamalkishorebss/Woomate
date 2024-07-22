import 'dart:convert';

class RecentProductList {
  
  final String name;
  final String price;
  final String image;
  final String description;
  

  RecentProductList(
      {
      required this.name,
      required this.price,
      required this.image,
      required this.description
   });

  factory RecentProductList.fromJson(Map<String, dynamic> json) {
    return RecentProductList(
        name : json['name'],
        price: json['price'],
        image: json['images'] != null ? json['images'][0]['src'] :'',
        description:json['description'],
      );
  }

  static List<RecentProductList> fromJsonList(dynamic jsonList) {
    final recentProductList = <RecentProductList>[];
    if (jsonList == null) return recentProductList;

    if (jsonList is List<dynamic>) {
      for (final json in jsonList) {
        recentProductList.add(
          RecentProductList.fromJson(json),
        );
      }
    }

    return recentProductList;
  }
}