import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shop_app/screens/Shares/normalHeader.dart';

class OrderDetail extends StatefulWidget {
  final dynamic data;
  const OrderDetail({Key? key, required this.data}) : super(key: key);

  @override
  _OrderDetailState createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  late String firstName;
  late List<dynamic> billingAddress;
  late List<dynamic> shippingAddress;
  late String lastName;
  late String userEmail;
  late dynamic userDetail;

  @override
  void initState() {
    super.initState();
  }

  Future<void> payment() async {
    print('ffff');
  }

  @override

  Widget build(BuildContext context) {
     List<dynamic> lineItems = widget.data['line_items'];
    return Scaffold(
      appBar: Header(title: '#${widget.data['id'].toString()} - Details'),
      body: SingleChildScrollView(
        child: Container(
          color: Color.fromRGBO(250, 250, 250, 1.0),
          // Modify externalStyle.container to fit your design
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                // onTap: {},
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(157, 64, 62, 62),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      '${widget.data['status']}',
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
               Text(
                '${widget.data['date_modified']}',
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
               Text(
                '${widget.data['status']}',
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black),
              ),
              SizedBox(height: 20),
              Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(children: [
                    Container(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Product',
                                textAlign: TextAlign.left,
                                style: const TextStyle(fontSize: 18.0),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Total',
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        )),
                    Divider(),
                    SizedBox(height: 15),
                    Container(
                        padding: const EdgeInsets.all(16.0),
                        child:ListView.builder(
                        itemCount: lineItems.length,
                        itemBuilder: (BuildContext context, int index) {
                          Map<String, dynamic> lineItem = lineItems[index];
                          return ListTile(
                            title: Text(lineItem['name'] ?? ''),
                           
                 
                           // Assuming there's an image object
                          );
                        },
                      ),
    
                    ),
                    SizedBox(height: 15),
                    Divider(),
                    SizedBox(height: 15),
                    Container(
                        padding: const EdgeInsets.all(16.0),
                        child:  Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Shipping',
                                textAlign: TextAlign.left,
                                style: const TextStyle(fontSize: 18.0),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '\$${widget.data['shipping_total']}',
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        )),
                    SizedBox(height: 15),
                    Container(
                        padding: const EdgeInsets.all(16.0),
                        child:  Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Tax',
                                textAlign: TextAlign.left,
                                style: const TextStyle(fontSize: 18.0),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '\$ ${widget.data['total_tax']}',
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        )),
                    SizedBox(height: 15),
                    Divider(),
                    SizedBox(height: 15),
                    Container(
                        padding: const EdgeInsets.all(16.0),
                        child:  Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Total',
                                textAlign: TextAlign.left,
                                style: const TextStyle(fontSize: 18.0),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '\$ ${widget.data['total']}',
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        )),
                    SizedBox(height: 15),
                    Divider(),
                    widget.data['status'] == "completed"
                        ? SizedBox(height: 5)
                        : Container(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Payment Method',
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(fontSize: 18.0),
                                  ),
                                ),
                                TextButton(
                                  onPressed: payment,
                                  child: Text('Pay Here',
                                      textAlign: TextAlign.end,
                                      style: const TextStyle(
                                          fontSize: 18.0,
                                          color: Color(0xFFD35804),
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),
                  ])),
              SizedBox(height: 15),
              Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: Image.asset(
                      'lib/images/location.png',
                      width: 26.0,
                      height: 26.0,
                    ),
                    title: Text('Billing Address',
                        style: const TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold)),
                    subtitle: Text('${widget.data['billing']['first_name']} ${widget.data['billing']['last_name']} ${widget.data['billing']['address_1']} ${widget.data['billing']['city']} ${widget.data['billing']['state']} ${widget.data['billing']['country']}'),
                  )),
              SizedBox(height: 15),
              Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: Image.asset(
                      'lib/images/delivery-truck.png',
                      width: 26.0,
                      height: 26.0,
                    ),
                    title: Text('Shipping Address',
                        style: const TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold)),
                    subtitle: Text( '${widget.data['shipping']['first_name']} ${widget.data['shipping']['last_name']} ${widget.data['shipping']['address_1']} ${widget.data['shipping']['city']} ${widget.data['shipping']['state']} ${widget.data['shipping']['country']}'),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
