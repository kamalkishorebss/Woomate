import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/screens/Auth/login.dart';
import 'package:shop_app/screens/Shares/normalHeader.dart';
import 'package:shop_app/services/api_services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class ProductDetailsScreen extends StatefulWidget {
  
  final product;

  ProductDetailsScreen({Key? key, required this.product}) : super(key: key);

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  
  int quantity = 1;
  
  late BuildContext _context; // Store the context variable

  String id = '';
  
  String _email = '';
  
  String _password= '';

  

  @override
  void initState() {
    super.initState();

    if (widget.product.variations.isNotEmpty) {
      setState(() {
        id = widget.product.variations[0].toString();
      });
    } else {
      id = widget.product.id.toString();
    }
    getUserDetail();
  }

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

  void getUserDetail() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userDetail = prefs.getString("User_Detail");
  if (userDetail != null) {
    Map<String, dynamic> detail = jsonDecode(userDetail);
   
    setState(() {
      _email = detail['email'] ?? '';
      _password = detail['password'] ?? '';
    }
    );
    
  }
  }

  void _addToCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? isLoggedIn = prefs.getString('logged');
  
    if (isLoggedIn == 'true') {
      ApiService.addToCart(_email, _password, id, quantity.toString()).then((value) {
        print(value);

        showToast(
          ' Item added to cart! ',
          context: context,
          axis: Axis.horizontal,
          alignment: Alignment.center,
          position: StyledToastPosition.top,
          toastHorizontalMargin: 20,
          backgroundColor: orangeColor,
          fullWidth: true,
        );
      });
    } else {
      Navigator.push(
        _context, // Use the stored context variable
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      appBar: Header(title: ""),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 10),
                  Container(
                    height: 250,
                    alignment: Alignment.center,
                    child: Image.network(
                      widget.product.image,
                      height: 250.0,
                      width: 300.0,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.product.name,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const Row(
                                    children: [
                                      Icon(Icons.star,
                                          color:
                                              Color.fromRGBO(240, 197, 23, 1)),
                                      SizedBox(width: 5),
                                      Text(
                                        '4.50 (2 reviews)',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ])),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: decrementQuantity,
                              child: Container(
                                padding: EdgeInsets.all(8),
                                child: Icon(Icons.remove,
                                    color:
                                        const Color.fromARGB(255, 10, 10, 10)),
                              ),
                            ),
                            Text(
                              '$quantity',
                              style: TextStyle(fontSize: 16),
                            ),
                            GestureDetector(
                              onTap: incrementQuantity,
                              child: Container(
                                padding: EdgeInsets.all(8),
                                child: Icon(Icons.add,
                                    color:
                                        const Color.fromARGB(255, 10, 10, 10)),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      // widget.product.description,
                      'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, 'Rating');
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Review (Tap to view all)',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(Icons.star,
                                  color: Color.fromRGBO(240, 197, 23, 1)),
                              SizedBox(width: 5),
                              Text(
                                '4.50 (2 reviews)',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Price',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins-Medium'),
                      ),
                      Text(
                        '\$ ${widget.product.price}',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: _addToCart,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Color(0xFFD35804),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.shopping_cart, color: Colors.white),
                        SizedBox(width: 5),
                        Text(
                          'Add to Cart',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
