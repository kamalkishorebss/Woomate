import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/constants.dart';
import 'package:http/http.dart' as http;

class BillingDetailForm extends StatefulWidget {
  @override
  _BillingDetailFormState createState() => _BillingDetailFormState();
}

class _BillingDetailFormState extends State<BillingDetailForm> {
  final _formKey = GlobalKey<FormState>();
  String billingAddress = '';
  int  userId  = 0; 
  String _firstName = '';
  String _lastName = '';
  String _phoneNumber = '';
  String _email = '';
  String _company = "";
  String _address = '';
  String _city = '';
  String _state = '';
  String _country = '';
  String _postcode = '';
  bool _isLoading = false;
  
  void initState() {
    super.initState();
    getUserDetail();
  }
  void getUserDetail() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userDetail = prefs.getString("User_Detail");
  if (userDetail != null) {
    Map<String, dynamic> detail = jsonDecode(userDetail);
    //print("rrrrr: ${detail['email']}");
    setState(() {
      billingAddress = detail['billing'] ?? ''; // Handle null case
      userId     = detail['id'];
      _firstName = detail['first_name'] ?? '';
      _lastName = detail['last_name'] ?? '';
      _email = detail['email'] ?? '';
      _phoneNumber = detail['billing']?['phone'] ?? '';
      _company = detail['billing']?['company'] ?? '';
      _address = detail['billing']?['address_1'] ?? '';
      _address = detail['billing']?['address_2'] ?? '';
      _city = detail['billing']?['city'] ?? '';
      _state = detail['billing']?['state'] ?? '';
      _country = detail['billing']?['country'] ?? '';
      _postcode = detail['billing']?['postcode'] ?? '';
    });
  } else {
    // Handle the case where userDetail is null
    // You can show an error message or take appropriate action
  }
}

void _submit() async {
 
 if (_formKey.currentState!.validate()) {
    _formKey.currentState!.save(); //
    setState(() {
      _isLoading = true; // Show loader
    });
    var data = jsonEncode({
      "billing": {
        "first_name": _firstName,
        "last_name": _lastName,
        "company": _company,
        "address_1": _address,
        "address_2": _address,
        "city": _city,
        "state": _state,
        "postcode": _postcode,
        "country": _country,
        "email": _email,
        "phone": _phoneNumber
      },
      "shipping": {}
    });

    try {
      final response = await http.put(
        Uri.parse('https://allalgosdev.com/demosite/wp-json/wc/v3/customers/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Basic Y2tfMDE3YTc5NTJiZWE5MGU0ZGZlMGMzYjI5ZDliZjMwMjE0NjkyOWY3MDpjc19mZTRlOTI0OWEwYWJlNTNjZDE3ODJjNDFmNmM0NTIwOTE5ZGI0NWU2',
          'Cookie': 'wordpress_logged_in_a90f7fee4974be019f49e21ddad3165a=Fdgdfg%7C1711349253%7CN5jr5pYsw4LeoUp0NXy0TYwyi8WOh3gViN0Wx2TBWBr%7Cb2532dbdf2b6abf633b946c4c39e2008bc73c4f78c5034bbac6c8defaaeaf36f; wp_cocart_session_a90f7fee4974be019f49e21ddad3165a=3218%7C%7C1710759922%7C%7C1710673522%7C%7Cd4e4e0a09e8b42d88ecf5cb50c21f3db'
        },
        body: data,
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['id'] == userId) {
          // Successfully updated user details
          // You can add further handling here, such as navigation or displaying a message
       
           // ignore: use_build_context_synchronously
           showToast(
            'Billing Address saved successfully',
            context: context,
            axis: Axis.horizontal,
            alignment: Alignment.center,
            position: StyledToastPosition.top,
            toastHorizontalMargin: 20,
            backgroundColor: orangeColor,
            fullWidth: true,
          );
          Navigator.of(context).pop();
          // Here you can also update local storage if needed
        } else {
          // Handle the case where the response data doesn't match the expected user ID
        //  print('Unexpected response: ${response.body}');
           // ignore: use_build_context_synchronously
           showToast(
            '${response.body}',
            context: context,
            axis: Axis.horizontal,
            alignment: Alignment.center,
            position: StyledToastPosition.top,
            toastHorizontalMargin: 20,
            backgroundColor: orangeColor,
            fullWidth: true,
          );
        }
      } else {
        // Handle errors here, such as displaying an error message
       
        // ignore: use_build_context_synchronously
        showToast(
            'Error:  ${response.statusCode}',
            context: context,
            axis: Axis.horizontal,
            alignment: Alignment.center,
            position: StyledToastPosition.top,
            toastHorizontalMargin: 20,
            backgroundColor: orangeColor,
            fullWidth: true,
          );
      }
    } catch (error) {
      // Handle network errors or other exceptions
      print('Error: $error');
    } 
    finally {
      setState(() {
        _isLoading = false; // Hide loader
      });
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Billing Detail'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
               SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person, size: 30),
                  labelText: 'First Name *',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter First Name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _firstName = value!;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person, size: 30),
                  labelText: 'Last Name',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Last Name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _lastName = value!;
                },
              ),
              SizedBox(height: 20),

              TextFormField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.phone, size: 30),
                  labelText: 'Phone Number *',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter phone number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _phoneNumber = value!;
                },
              ),
              SizedBox(height: 20),
              
              TextFormField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person, size: 30),
                  labelText: 'Email *',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
               
               initialValue: _email, // Set initial value
              // enabled: false, 
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.real_estate_agent, size: 30),
                  labelText: 'Company',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter company';
                  }
                  return null;
                },
                 onSaved: (value) {
                  _company = value!;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.location_searching, size: 30),
                  labelText: 'Address *',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter address';
                  }
                  return null;
                },
                 onSaved: (value) {
                  _address = value!;
                 },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.location_city, size: 30),
                  labelText: 'City *',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter city';
                  }
                  return null;
                },
                onSaved: (value) {
                  _city = value!;
                 },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.flag, size: 30),
                  labelText: 'Country *',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter country';
                  }
                  return null;
                },
                onSaved: (value) {
                  _country = value!;
                 },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.location_on, size: 30),
                  labelText: 'Zip Code *',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
                
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter zip code';
                  }
                  return null;
                },
                onSaved: (value) {
                  _postcode = value!;
                 },
              ),
              // Add more TextFormField widgets for other fields
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  primary: orangeColor, // Background color
                ),
                child: Text(
                  'Save',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
               SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
