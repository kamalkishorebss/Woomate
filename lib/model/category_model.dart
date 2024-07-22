import 'dart:convert';

class CategoryList {
  
  final String name;
  final int id;
  final String image;
  

  CategoryList(
      {
      required this.name,
      required this.id,
      required this.image,
   });

  factory CategoryList.fromJson(Map<String, dynamic> json) {
    return CategoryList(
        id   : json['id'],
        name : json['name'],
        image: json['image'] != null ? json['image']['src'] : '',
       // image: json['image'],
      );
  }

  static List<CategoryList> fromJsonList(dynamic jsonList) {
    final categoryList = <CategoryList>[];
    if (jsonList == null) return categoryList;

    if (jsonList is List<dynamic>) {
      for (final json in jsonList) {
        categoryList.add(
          CategoryList.fromJson(json),
        );
      }
    }

    return categoryList;
  }
}