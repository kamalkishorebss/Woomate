import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shop_app/constants.dart';
import 'package:shop_app/model/category_model.dart';
import 'package:shop_app/model/product_model.dart';
import 'package:shop_app/model/recent_product.dart';
import 'package:shop_app/model/top_rated_product.dart';

class ApiService {
  Future<List<CategoryList>> fetchCategories() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}wp-json/wc/v3/products/categories'),
        headers: {
          'Authorization':
              'Basic Y2tfMDE3YTc5NTJiZWE5MGU0ZGZlMGMzYjI5ZDliZjMwMjE0NjkyOWY3MDpjc19mZTRlOTI0OWEwYWJlNTNjZDE3ODJjNDFmNmM0NTIwOTE5ZGI0NWU2',
          'Cookie':
              'mailchimp_landing_site=https%3A%2F%2Fallalgosdev.com%2Fdemosite%2Fdemosite%2Fwc%2Fv3%2Fproducts%3Forderby%3Ddate%26order%3Ddesc%26per_page%3D5',
        },
      );
      //print(json.decode(response.body));
      return CategoryList.fromJsonList(json.decode(response.body));
    } catch (error) {
      // Handle network error
      print('Network error occurred: $error');
      // Return an empty list or throw an error
      return []; // Return an empty list
    }
  }

  Future<List<RecentProductList>> fetchRecentProducts() async {
    try {
      final response = await http.get(
        Uri.parse(
            '${ApiConstants.baseUrl}wp-json/wc/v3/products?orderby=date&order=desc&per_page=5'),
        headers: {
          'Authorization':
              'Basic Y2tfMDE3YTc5NTJiZWE5MGU0ZGZlMGMzYjI5ZDliZjMwMjE0NjkyOWY3MDpjc19mZTRlOTI0OWEwYWJlNTNjZDE3ODJjNDFmNmM0NTIwOTE5ZGI0NWU2',
          'Cookie':
              'mailchimp_landing_site=https%3A%2F%2Fallalgosdev.com%2Fdemosite%2Fdemosite%2Fwc%2Fv3%2Fproducts%3Forderby%3Ddate%26order%3Ddesc%26per_page%3D5',
        },
      );
      //print(json.decode(response.body));
      return RecentProductList.fromJsonList(json.decode(response.body));
      // if (response.statusCode == 200) {
      //   return CategoryList.fromJsonList(json.decode(response.body));
      // } else {
      //   // Handle non-200 status code
      //   print('Failed to fetch categories: ${response.statusCode}');
      //   // Return an empty list or throw an error
      //   return []; // Return an empty list
      // }
    } catch (error) {
      // Handle network error
      print('Network error occurred: $error');
      // Return an empty list or throw an error
      return []; // Return an empty list
    }
  }

  Future<List<TopRatedProductList>> fetchTopRatedProducts() async {
    try {
      final response = await http.get(
        Uri.parse(
            '${ApiConstants.baseUrl}wp-json/wc/v3/products?orderby=rating&per_page=10'),
        headers: {
          'Authorization':
              'Basic Y2tfMDE3YTc5NTJiZWE5MGU0ZGZlMGMzYjI5ZDliZjMwMjE0NjkyOWY3MDpjc19mZTRlOTI0OWEwYWJlNTNjZDE3ODJjNDFmNmM0NTIwOTE5ZGI0NWU2',
          'Cookie':
              'mailchimp_landing_site=https%3A%2F%2Fallalgosdev.com%2Fdemosite%2Fdemosite%2Fwc%2Fv3%2Fproducts%3Forderby%3Ddate%26order%3Ddesc%26per_page%3D5',
        },
      );
      //print(json.decode(response.body));
      return TopRatedProductList.fromJsonList(json.decode(response.body));
    } catch (error) {
      // Handle network error
      print('Network error occurred: $error');
      // Return an empty list or throw an error
      return []; // Return an empty list
    }
  }

  Future<List<ProductList>> fetchProductByCategoryId(id) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}wp-json/wc/v3/products?category=$id'),
        headers: {
          'Authorization':
              'Basic Y2tfMDE3YTc5NTJiZWE5MGU0ZGZlMGMzYjI5ZDliZjMwMjE0NjkyOWY3MDpjc19mZTRlOTI0OWEwYWJlNTNjZDE3ODJjNDFmNmM0NTIwOTE5ZGI0NWU2',
          'Cookie':
              'mailchimp_landing_site=https%3A%2F%2Fallalgosdev.com%2Fdemosite%2Fdemosite%2Fwc%2Fv3%2Fproducts%3Forderby%3Ddate%26order%3Ddesc%26per_page%3D5',
        },
      );
      // print(json.decode(response.body));
      return ProductList.fromJsonList(json.decode(response.body));
    } catch (error) {
      // Handle network error
      print('Network error occurred: $error');
      // Return an empty list or throw an error
      return []; // Return an empty list
    }
  }

  static Future addToCart(
      userEmail, userPassword, String id, String quantity) async {
    print('userEmail: $userEmail,userPassword: $userPassword');
    // Prepare data payload
    Map<String, dynamic> data = {
      'id': id,
      'quantity': quantity,
    };

    // Convert data to JSON
    String jsonData = jsonEncode(data);

    // Prepare basic authentication
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$userEmail:$userPassword'));

    // Prepare request configuration
    var url = 'https://allalgosdev.com/demosite/wp-json/cocart/v2/cart/add-item';
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': basicAuth,
     };

    // Make POST request
    try {
      var response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonData,
      );

    
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse;

      //print(json.decode(response.body));
    } catch (error) {
      // Handle network error
      print('Network error occurred: $error');
      // Return an empty list or throw an error
      //return []; // Return an empty list
    }
  }

  Future fetchCartItems(basicAuth) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}wp-json/cocart/v2/cart'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': basicAuth,
        },
      );
      Map<String, dynamic> responseBody = json.decode(response.body);
      // Now access properties of responseBody safely
      List<dynamic> items = responseBody['items'];
      print(items);
      return items;

      // Access the 'items' property from the decoded JSON
    } catch (error) {
      // Handle network error
      print('Network error occurred: $error');
      // Return an empty list or throw an error
      return []; // Return an empty list
    }
  }

  static Future<bool> deleteItem(String id) async {
    final url = "${ApiConstants.baseUrl}wp-json/cocart/v2/cart/item/$id";
    print(url);
    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      print('delet api response ${response.body}');
      if (response.statusCode == 200) {
        return true; // Deletion successful
      } else {
        return false; // Deletion failed
      }
    } catch (error) {
      // Handle network error
      print('Network error occurred: $error');
      return false; // Return false indicating deletion failed
    }
  }

  Future orderPlace(data) async {
  print(data);
  var url = Uri.parse('https://allalgosdev.com/demosite/wp-json/wc/v3/orders');
  var headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Basic Y2tfMDE3YTc5NTJiZWE5MGU0ZGZlMGMzYjI5ZDliZjMwMjE0NjkyOWY3MDpjc19mZTRlOTI0OWEwYWJlNTNjZDE3ODJjNDFmNmM0NTIwOTE5ZGI0NWU2',
  };

  try {
    var response = await http.post(
      url,
      headers: headers,
      body: data,
    );
    var responseData = jsonDecode(response.body);
    if (responseData.containsKey('id') && responseData['id'] != null && responseData['id'] != '') {
      // 'id' exists in the response
      print("Full Response: $responseData");

      // You can send the full response here
      // Example: return the full response
      return responseData;
    } else {
      print("Failed to place order: ${responseData}"); 
      // Handle it accordingly, for example, return an error message
      return responseData;
    }
  } catch (error) {
    print("Error: $error");
    // Handle the error
    return {'error': error.toString()};
  }
}





  Future<List<dynamic>> fetchOrderHistory(String userId) async {
    try {
     final response = await http.get(
      Uri.parse('https://allalgosdev.com/demosite/wp-json/wc/v3/orders?customer=$userId'),
      headers: {
        'Authorization': 'Basic Y2tfMDE3YTc5NTJiZWE5MGU0ZGZlMGMzYjI5ZDliZjMwMjE0NjkyOWY3MDpjc19mZTRlOTI0OWEwYWJlNTNjZDE3ODJjNDFmNmM0NTIwOTE5ZGI0NWU2',
      },
    );
      
        // If the request is successful, parse the JSON response
        final List<dynamic> data = jsonDecode(response.body);
        //print(data);
        return data;

    } catch (e) {
      // Catch any errors that occur during the request
      throw Exception('Error fetching order history: $e');
    }
  }


}
