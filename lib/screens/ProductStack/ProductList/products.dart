import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/model/product_model.dart';
import 'package:shop_app/screens/ProductStack/DetailScreen/detailscreen.dart';
import 'package:shop_app/screens/Shares/normalHeader.dart';
import 'package:shop_app/services/api_services.dart';

class ProductListScreen extends StatefulWidget {
  final int catId;

  final String catName;

  const ProductListScreen(
      {Key? key, required this.catId, required this.catName})
      : super(key: key);

  @override
  _ProductListScreen createState() => _ProductListScreen();
}

class _ProductListScreen extends State<ProductListScreen> {
  late List<ProductList> productList = [];

  late List<ProductList> wishlist = [];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _getData(widget.catId);
  }

  void _getData(id) async {
    setState(() {
      _isLoading = true;
    });
    try {
      await ApiService().fetchProductByCategoryId(id).then((value) {
        print(value);
        setState(() {
          productList = value;
        });
      });
    } catch (error) {
      print('Error fetching categories: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  _saveSendToStorage(List<Map<String, dynamic>> send) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Convert the list of maps to a list of strings
    List<String> sendStringList = send.map((item) => jsonEncode(item)).toList();
    // Save the list of strings to storage
    await prefs.setStringList('send', sendStringList);
  }

  Widget build(BuildContext context) {
  return Scaffold(
    appBar: Header(title: 'More Products'),
    body: _isLoading
        ? Center(
            child: CircularProgressIndicator(), // Show loader
          )
        :Container(
          color: Color.fromRGBO(240, 240, 240, 1), 
        child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
             
            children: [
              Padding(
                
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  widget.catName,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(5.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: productList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailsScreen(
                              product: productList[index],
                            ),
                          ),
                        );
                      },
                      child: GridTile(
                        child:Container(
                          color:Colors.white, 
                           padding: const EdgeInsets.all(8.0),
                        child: Column(
                         
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            productList[index].image != null
                                ? Expanded(
                                    child: Image.network(
                                      productList[index].image,
                                      height: 120,
                                      width: 120,
                                      fit: BoxFit.cover,
                                      loadingBuilder: (context, child,
                                          loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                          ),
                                        );
                                      },
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Icon(
                                            Icons.error_outline); // Replace with your error handling widget
                                      },
                                    ),
                                  )
                                : Image.asset(
                                    'lib/images/no-image.png',
                                    width: 50, // Adjust size as needed
                                    height: 50,
                                  ),
                            SizedBox(height: 5),
                            Text(
                              productList[index].name,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                              maxLines: 2, // Display only two lines
                              overflow: TextOverflow.ellipsis,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '\$${productList[index].price}',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: orangeColor),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Map<String, dynamic> myObject = {
                                      'name': productList[index].name,
                                      'image': productList[index].image,
                                      'price': productList[index].price,
                                      'id': productList[index].id
                                    };
                                    List<Map<String, dynamic>> send = [];
                                    setState(() {
                                      send.add(myObject);
                                      _saveSendToStorage(send);
                                    });

                                    showToast(
                                      ' Item added to wishlist! ',
                                      context: context,
                                      axis: Axis.horizontal,
                                      alignment: Alignment.center,
                                      position: StyledToastPosition.top,
                                      toastHorizontalMargin: 20,
                                      backgroundColor: orangeColor,
                                      fullWidth: true,
                                    );
                                  },
                                  child: Icon(
                                    Icons.favorite_outline,
                                    color: orangeColor,
                                    size: 25,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                        )
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        )
  );
  
}

}
