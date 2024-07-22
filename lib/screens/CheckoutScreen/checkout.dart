import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/services/api_services.dart';
import 'package:shop_app/services/auth_service_api.dart';
import 'package:shop_app/screens/Payment/payment.dart';

class Checkout extends StatefulWidget {
  Checkout({Key? key}) : super(key: key);

  @override
  _Checkout createState() => _Checkout();
}

class _Checkout extends State<Checkout> {
  late List<Map<String, dynamic>> cartItem = [];
  int quantity = 1;
  String? userEmail;
  String? userPassword;
  double total = 0;
  bool _isLoading = false;

  String firstName = '';
  String lastName = '';
  String address = '';
  String city = '';
  String country = '';
  String state = '';
  String postcode = '';
  Map<String, dynamic>? paymentIntent;

  void incrementQuantity() {
    setState(() {
      quantity++;
    });
  }

  void decrementQuantity() {
    setState(() {
      quantity = quantity > 1 ? quantity - 1 : quantity;
    });
  }

  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      // Access the passed arguments here
      Map<String, dynamic>? args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        setState(() {
          cartItem = args['items'] ??
              []; // Set the received items into the cartItem array
        });
      }
    });
    getUserDetail();
  }

  void getUserDetail() async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDetail = prefs.getString("User_Detail");
    if (userDetail != null) {
      Map<String, dynamic> detail = jsonDecode(userDetail);
      AuthService().fetchUserDetail(detail['id']).then((value) {
        print(value);
        setState(() {
          firstName = value['billing']['first_name'];
          lastName = value['billing']['last_name'];
          postcode = value['billing']['postcode'];
          address = value['billing']['address_1'];
          city = value['billing']['city'];
          state = value['billing']['state'];
          _isLoading = false;
        });
      }).catchError((error) {
        // Handle any errors that occur during the fetchUserDetail process
        print('Error fetching user detail: $error');
        setState(() {
          _isLoading = false; // Set isLoading to false in case of error
        });
      });
    }
  }

  void _placeOrder() async {
    setState(() {
      _isLoading = true;
    });

    // List<Map<String, dynamic>> lineItems = cartItem.map((item) {
    //   return {
    //     "product_id": item.id,
    //     "quantity": item.quantity.value,
    //   };
    // }).toList();

    var data = jsonEncode({
      "line_items": [
        {
          "product_id": '113504',
          "quantity": '2',
        }
      ],
      "customer_id": '3223',
      "billing": {
        'first_name': 'kamal',
        'last_name': 'kishor',
        'company': 'AllalgosItSolution',
        'address_1': 'ajjad',
        'address_2': 'ajjad',
        'city': 'mohali',
        'postcode': '123456',
        'country': 'india',
        'state': 'mohali',
        'email': 'kamalkishore273@gmail.com',
        'phone': '9876543210'
      },
      "shipping": {
        'first_name': 'kamal',
        'last_name': 'kishor',
        'company': 'AllalgosItSolution',
        'address_1': 'ajjad',
        'address_2': 'ajjad',
        'city': 'mohali',
        'postcode': '123456',
        'country': 'india',
        'state': 'mohali',
        'email': 'kamalkishore273@gmail.com',
        'phone': '9876543210'
      },
    });

    try {
      await ApiService().orderPlace(data).then((value) => {
            setState(() {
              _isLoading = false; // Set isLoading to false in case of error
            }),
            if (value.containsKey('id') &&
                value['id'] != null &&
                value['id'] != '')
              {
                // print("Full Response: $value"),

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            PaymentForm(orderId: value['id'])))
              }
            else
              {print("Failed to place order: Status is not pending")}
          });
    } catch (error) {
      print("Error: $error");
      setState(() {
        _isLoading = false; // Set isLoading to false in case of error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Checkout',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(), // Show loader
            )
          : SingleChildScrollView(
              child: Container(
                color: Color.fromRGBO(250, 250, 250, 1),
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white, // Set the background color

                            borderRadius: BorderRadius.circular(
                                10), // Set the radius for rounded corners
                          ), // Set the background color here
                          child: ListTile(
                            leading: Icon(Icons.location_on, size: 30),
                            title: Text('Billing Address',
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold)),
                            subtitle: firstName != null
                                ? Text(
                                    '$firstName $lastName $address $city $state $country',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 2.0,
                                      wordSpacing:
                                          3.5, // Adjust the word spacing value as needed
                                    ),
                                  )
                                : Text('No address'),
                            trailing: IconButton(
                              icon: Icon(Icons.edit, size: 30),
                              onPressed: () {
                                Navigator.pushNamed(context, '/billing_detail');
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white, // Set the background color

                            borderRadius: BorderRadius.circular(
                                10), // Set the radius for rounded corners
                          ),
                          child: ListTile(
                            leading: Icon(Icons.vertical_shades_closed_outlined,
                                size: 30),
                            title: Text('Shipping address',
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold)),
                            subtitle: firstName != null
                                ? Text(
                                    '$firstName $lastName $address $city $state $country',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 2.0,
                                      wordSpacing:
                                          3.5, // Adjust the word spacing value as needed
                                    ),
                                  )
                                : Text('No address'),
                            trailing: IconButton(
                              icon: Icon(Icons.edit, size: 30),
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, '/shipping_detail');
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 30),
                    Text(
                      'Order Summary',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    Column(
                      children: cartItem.map((item) {
                        return Container(
                          padding: EdgeInsets.symmetric(vertical: 5.0),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey,
                                width: 1.0, // Set the width of the border
                              ),
                            ),
                          ),
                          child: ListTile(
                            title: Text(
                              item['name'],
                              overflow: TextOverflow
                                  .visible, // Allows the text to overflow the widget's bounds
                              maxLines: 2, // Maximum 2 lines before wrapping
                              softWrap: true,
                              // Replace with your title
                              style: TextStyle(
                                  fontSize: 14.0, fontWeight: FontWeight.bold),
                            ),
                            trailing: Text(
                                '\$ ${(double.parse(item['price']) / 100).toStringAsFixed(2)}',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight
                                        .bold)), // Replace with your price
                          ),
                        );
                      }).toList(),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                            10), // Set the radius for rounded corners
                      ),
                      //margin: EdgeInsets.symmetric(vertical: 10.0),
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Shipping Options',
                            style: TextStyle(
                                color: orangeColor,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold),
                          ),
                          // Include shipping options here
                          SizedBox(height: 10.0),
                          Text(
                            'Shipping: € 5.00',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: orangeColor,
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            'Fees: € 0.00',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: orangeColor,
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            'Tax: € 5.00',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: orangeColor,
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            'Discount: € 5.00',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: orangeColor,
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            'Total: € ${total.toStringAsFixed(2)}',
                            style: TextStyle(
                                color: orangeColor,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      // width: MediaQuery.of(context).size.width * 0.20,
                      decoration: BoxDecoration(
                        color: Color(
                            0xFFD35804), // Apply background color from colors.login
                        borderRadius: BorderRadius.circular(7),
                      ),
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(12.0),
                      child: GestureDetector(
                        onTap: () {
                          _placeOrder();
                          // Handle apply button press
                        },
                        child: Text(
                          'Place Order',
                          style: TextStyle(
                              color: Color.fromARGB(255, 252, 251, 251),
                              fontSize: 20,
                              fontWeight: FontWeight
                                  .w500), // Apply style from externalStyle.applyText
                        ),
                      ),
                    ),
                    SizedBox(height: 20)
                  ],
                ),
              ),
            ),
    );
  }
}
