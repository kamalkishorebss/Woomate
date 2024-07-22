import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shop_app/constants.dart';


class AuthService {

   static Future login(email,password) async {
   final url = "${ApiConstants.baseUrl}wp-json/custom/v1/login";
   print(url);
   try {
      final response = await http.post(
        Uri.parse(url),
        headers:{
        'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "username"     : email,
          "password"  : password 
        })
      );
       print('login api response ${response.body}');
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

   static Future register(firstname,lastname,username,email,password) async {
   final url = "${ApiConstants.baseUrl}wp-json/custom/v1/register";
   print(url);
   try {
      final response = await http.post(
        Uri.parse(url),

        headers:{
        'Content-Type': 'application/json',
        },
        
        body: jsonEncode({
          "username"  : username,
          "email"     : email,
          "password"  : password,
          "first_name": firstname,
          "last_name" : lastname,
        })

      );
       print('register api response ${response.body}');
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
  
  Future fetchUserDetail(int id) async {
 
   final url = "${ApiConstants.baseUrl}wp-json/wc/v3/customers/$id";
   
   print(url);
   
    try {
      final response = await http.post(Uri.parse(url),
        headers:{
        'Authorization':'Basic Y2tfMDE3YTc5NTJiZWE5MGU0ZGZlMGMzYjI5ZDliZjMwMjE0NjkyOWY3MDpjc19mZTRlOTI0OWEwYWJlNTNjZDE3ODJjNDFmNmM0NTIwOTE5ZGI0NWU2',
        'Content-Type': 'application/json',
        }
      );
       Map<String, dynamic> userData = jsonDecode(response.body);
       
     //  print('User data: $userData');

      if (response.statusCode == 200) {
        // Successful response
        Map<String, dynamic> userData = jsonDecode(response.body);
       // print('User data: $userData');
        return userData;
      } else {
        // Error handling
        print('Failed to fetch user details. Status code: ${response.statusCode}');
        return response.statusCode;
      }
    } catch (error) {
      // Network error handling
      print('Error fetching user details: $error');
      return error;

    }
}

  
  
 
  
  
}

