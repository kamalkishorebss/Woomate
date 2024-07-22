import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/screens/MyAccount/MyOrders/orderDetail.dart';
import 'package:shop_app/screens/Shares/normalHeader.dart';
import 'package:shop_app/services/api_services.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  late List<Map<String, dynamic>> history = [];

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
      _getData(detail['id']);
    }
  }

  void _getData(id) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final List<dynamic> orderHistory =
          await ApiService().fetchOrderHistory(id.toString());

      setState(() {
        _isLoading = false;
        history = orderHistory.cast<Map<String, dynamic>>();
      });
    } catch (error) {
      // Handle errors
      print('Error fetching orders: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(title: "My Orders"),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(), // Show loader
            )
          : ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: Color(0xFFD35804)), // Border color
                    borderRadius: BorderRadius.circular(10), // Border radius
                  ),
                  margin: EdgeInsets.all(8), // Margin around each ListTile
                  child: ListTile(
                    title: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('\# ${history[index]['id']}',
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                              Text('${history[index]['date_created']}',
                                  style: TextStyle(
                                      fontSize: 14.0, color: Colors.grey)),
                            ],
                          ),
                        ),
                        Text('${history[index]['status']}',
                            style: const TextStyle(
                              fontSize: 22.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            )),
                      ],
                    ),
                    subtitle: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('\$ ${history[index]['total']}',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500)),
                              Text(
                                  'for ${history[index]['line_items'][0]['quantity']} item',
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OrderDetail(
                                  data: history[index],
                                ),
                              ),
                            );
                          },
                          child: Text('View Details',
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color: Color(0xFFD35804),
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
