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
    try {
      String basicAuth =
          'Basic ' + base64Encode(utf8.encode('$userEmail:$userPassword'));
      await ApiService().fetchCartItems(basicAuth).then((value) {
         print('000000:$value');
        getTotalPrice(value);
        setState(() {
          cartItem = value;
        });
      });
    } catch (error) {
      print('Error fetching categories: $error');
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
                    height: 100.0,
                    width: 100.0,
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
                          // Handle delete action
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
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Image.asset("lib/images/back-arrow.png",
                        width: 24.0, height: 24.0),
                  ),
                  const Text(
                    'My Cart',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                      width: 24.0,
                      height: 24.0), // Placeholder for any icon you want to put
                ],
              ),
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
                    // Handle apply button press
                  },
                  child: Text(
                    'Proceed To CheckOut',
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
