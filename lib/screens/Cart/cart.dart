import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/model/cart_model.dart';
import 'package:shop_app/model/product_model.dart';
import 'package:shop_app/services/api_services.dart';

class MyCart extends StatefulWidget {
  MyCart({Key? key}) : super(key: key);

  @override
  _MyCart createState() => _MyCart();
}

class _MyCart extends State<MyCart> {
  late List cartItem = [];
  int quantity = 1;
  String? userEmail;
  String? userPassword;
  double total = 0;

  bool _isLoading = false;

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
    getUserDetail();
  }

  void getUserDetail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDetail = prefs.getString("User_Detail");
    if (userDetail != null) {
      Map<String, dynamic> detail = jsonDecode(userDetail);
      print(detail);
      setState(() {
        userEmail = detail['email'];
        userPassword = detail['password'];
      });
      _getData();
    }
  }

  void _getData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      print('$userEmail:$userPassword');
      String basicAuth = 'Basic ' + base64Encode(utf8.encode('$userEmail:$userPassword'));

      await ApiService().fetchCartItems(basicAuth).then((value) {
        if (value is List<dynamic>) {
          List<Map<String, dynamic>> cartItems = [];
          for (var item in value) {
            if (item is Map<String, dynamic>) {
              cartItems.add(item);
            }
          }
          getTotalPrice(cartItems);
          setState(() {
            cartItem = cartItems;
          });
        } else {
          print('Error: Unexpected format of cart items');
        }
      });
    } catch (error) {
      print('Error fetching cartItem: $error');
    }
    finally{
      setState(() {
        _isLoading = false;
      });
    }
  }

  double getTotalPrice(List<Map<String, dynamic>> items) {
    double totalPrice = 0.0;

    for (var item in items) {
      // Check if the price field is not null before parsing
      if (item['price'] != null) {
        double price = double.parse(item['price']) / 100;
        totalPrice += price;
      }
    }

    print('Total Price: ${totalPrice.toStringAsFixed(2)}');
    setState(() {
      total = totalPrice;
    });
    return totalPrice;
  }

  void removeItem(String itemId) async {
    try {
      print('Deleting item...');
      bool success = await ApiService.deleteItem(itemId);
      if (success) {
        print('Item removed successfully');
        setState(() {
          // Update the UI by removing the item from the list
          cartItem.removeWhere((item) => item['item_key'] == itemId);
        });
      } else {
        print('Error: Failed to delete item');
      }
    } catch (error) {
      print('Error deleting item: $error');
    }
  }

  Widget buildCartItem(BuildContext context, Map<dynamic, dynamic> item) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      padding: EdgeInsets.all(5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 100,
            alignment: Alignment.center,
            child: item['featured_image'] != null
                ? Image.network(
                    item['featured_image'],
                    height: 90.0,
                    width: 90.0,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons
                          .error); // Replace with your error handling widget
                    },
                  )
                : Placeholder(),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        // Use Expanded to allow the text to take available space
                        child: Text(
                          item['title'],
                          overflow: TextOverflow
                              .visible, // Allows the text to overflow the widget's bounds
                          maxLines: 2, // Maximum 2 lines before wrapping
                          softWrap: true, // Enables text wrapping
                          style: const TextStyle(
                              fontSize: 14.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          removeItem(item['item_key']);
                        },
                        child: const Icon(Icons.delete,
                            color: Color.fromARGB(255, 10, 10, 10)),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$ ${(double.parse(item['price']) / 100).toStringAsFixed(2)}',
                        style: TextStyle(
                            fontSize: 14.0, fontWeight: FontWeight.normal),
                      ),
                      const Text(
                        '',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            // onTap: decrementQuantity,
                            child: Container(
                              padding: EdgeInsets.all(8),
                              child: Icon(Icons.remove,
                                  color: const Color.fromARGB(255, 10, 10, 10)),
                            ),
                          ),
                          Text(
                            '$quantity',
                            style: TextStyle(fontSize: 16),
                          ),
                          GestureDetector(
                            // onTap: incrementQuantity,
                            child: Container(
                              padding: EdgeInsets.all(8),
                              child: Icon(Icons.add,
                                  color: const Color.fromARGB(255, 10, 10, 10)),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '\$ ${(double.parse(item['price']) / 100).toStringAsFixed(2)}',
                        style: TextStyle(
                            fontSize: 20.0,
                            color: Color(0xFFD35804),
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MyCart',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body:  _isLoading
          ? Center(
              child: CircularProgressIndicator(), // Show loader
            )
          :SafeArea(
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartItem.length,
                  itemBuilder: (context, index) {
                    return buildCartItem(context, cartItem[index] as Map);
                  },
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.68,
                      decoration: BoxDecoration(
                        color: Color(0xFFF3E1E4),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                      child: Row(
                        children: [
                          Image.asset(
                            'lib/images/gift.png', // Make sure the path is correct relative to your pubspec.yaml
                            width: 24, // Adjust the width as needed
                            height: 24, // Adjust the height as needed
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Coupon Code',
                            style: TextStyle(
                                color: Color(
                                    0xFFD35804)), // Apply style from externalStyle.coupanCodeText
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 5),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.20,
                      decoration: BoxDecoration(
                        color: Color(
                            0xFFD35804), // Apply background color from colors.login
                        borderRadius: BorderRadius.circular(7),
                      ),
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(12.0),
                      child: GestureDetector(
                        onTap: () {
                          // Handle apply button press
                        },
                        child: Text(
                          'Apply',
                          style: TextStyle(
                              color: Color.fromARGB(255, 252, 251,
                                  251)), // Apply style from externalStyle.applyText
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Shipping Options',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    // Include shipping options here
                    SizedBox(height: 10.0),
                    Text(
                      'Shipping: € 5.00',
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'Fees: € 0.00',
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'Tax: € 5.00',
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'Discount: € 5.00',
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'Total: € ${total.toStringAsFixed(2)}',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
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
                    Navigator.pushNamed(context, '/checkout', arguments: {
                      'items': cartItem,
                      // Add more parameters as needed
                    });
                  },
                  child: Text(
                    'Proceed To Checkout',
                    style: TextStyle(
                        color: Color.fromARGB(255, 252, 251, 251),
                        fontSize: 20,
                        fontWeight: FontWeight
                            .w500), // Apply style from externalStyle.applyText
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
