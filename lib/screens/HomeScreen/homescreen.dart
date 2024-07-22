import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/model/category_model.dart';
import 'package:shop_app/model/recent_product.dart';
import 'package:shop_app/model/top_rated_product.dart';
import 'package:shop_app/screens/Drawer/drawer.dart';
import 'package:shop_app/screens/ProductStack/DetailScreen/detailscreen.dart';
import 'package:shop_app/screens/ProductStack/ProductList/products.dart';
import 'package:shop_app/services/api_services.dart';
import '../Shares/commonHeader.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}


class _HomeState extends State {
  
  final GlobalKey<ScaffoldState> _key = GlobalKey(); 

   late List<CategoryList>? categoryList = [];

   late List<RecentProductList>? recentProductList = [];

   late List<TopRatedProductList> topRatedProductList = [];

    bool _isLoading = false;


  @override
 
  void initState() {
    super.initState();
     setState(() {
        _isLoading = true; // Show loader
      });
    _getData();
    _getRecentProduct();
    _getTopProduct();
  }

  void _getData() async {
     
     try {
     await ApiService().fetchCategories().then((value){
       //print(value);
       setState(() {
         categoryList = value;
       });
     });
     }
     catch (error) {
      print('Error fetching categories: $error');
     }
      finally {
        setState(() {
          _isLoading = false; // Hide loader
        });
      }
   
  }

  

   void _getRecentProduct() async {
     try {
     await ApiService().fetchRecentProducts().then((value){
       //print(value);
       setState(() {
         recentProductList = value;
       });
     });
     }
     catch (error) {
      print('Error fetching _getRecentProduct: $error');
     }
      finally {
        setState(() {
          _isLoading = false; // Hide loader
        });
      }
   
  }

    void _getTopProduct() async {
     try {
     await ApiService().fetchTopRatedProducts().then((value){
       //print(value);
       setState(() {
         topRatedProductList = value;
       });
     });
     }
     catch (error) {
      print('Error fetching categories: $error');
     }
      finally {
        setState(() {
          _isLoading = false; // Hide loader
        });
      }
   
  }

 

  


  Widget build(BuildContext context) {
    return Scaffold(
       key: _key,
       drawer: NavDrawer(),
      appBar: Header('WooMate'), // Use CommonHeader widget
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(), // Show loader
            )
          :SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
            Container(
              height: 50,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: const Text(
                'Categories',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            Container(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categoryList!.length > 6 ? 6 : categoryList!.length, 
                itemBuilder: (context, index) {
                
                  return GestureDetector(
                    onTap: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProductListScreen(catName:categoryList![index].name,catId : categoryList![index].id)),
                      )
                    },
                    child: Container(
                    width: 140,
                    margin: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(child: Image.network(
                      categoryList![index].image,
                      width: 50, // Adjust size as needed
                      height: 50,
                    )),
                        SizedBox(height: 10),
                        Text(
                          categoryList![index].name,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.brown),
                        ),
                        SizedBox(height: 10)
                      ],
                    ),
                    )
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: 50,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Discount Guaranteed",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            Container(
              height:250,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: recentProductList!.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailsScreen(product: recentProductList![index]),
                        )
                      );
                    },
                    child: Container(
                      width: 140,
                      margin: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                          Image.network(
                            topRatedProductList[index].image,
                            width: 100, // Adjust size as needed
                            height:100,
                          ),
                          SizedBox(height: 5),
                          Text(
                            maxLines: 2, // Display only two lines
                            overflow: TextOverflow.ellipsis, // T
                            topRatedProductList[index].name,
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                          SizedBox(height: 5),
                          Text(
                            '\$${topRatedProductList[index].price}',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: orangeColor),
                          )
                        ]
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: 50,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Top Rated Product",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
       
            Container(
              height: 400,
              padding: EdgeInsets.all(10.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                itemCount: topRatedProductList.length > 4 ? 4 : topRatedProductList.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailsScreen(product: topRatedProductList[index]),
                        )
                      );
                    },
                  child :GridTile(
                    
                    child: Container(
                      color: Colors.white, // Just for visualization
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(
                            topRatedProductList[index].image,
                            width: 100, // Adjust size as needed
                            height:100,
                          ),
                          SizedBox(height: 5),
                          Text(
                            maxLines: 2, // Display only two lines
                            overflow: TextOverflow.ellipsis, // T
                            topRatedProductList[index].name,
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                          SizedBox(height: 5),
                          Text(
                            '\$${topRatedProductList[index].price}',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: orangeColor),
                          )
                        ],
                      ),
                    ),
                  )
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: 50,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Feature Products",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
           Container(
              height:250,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: recentProductList!.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailsScreen(product: recentProductList![index]),
                        )
                      );
                    },
                    child: Container(
                      width: 140,
                      margin: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                          Image.network(
                            topRatedProductList[index].image,
                            width: 100, // Adjust size as needed
                            height:100,
                          ),
                          SizedBox(height: 5),
                          Text(
                            maxLines: 2, // Display only two lines
                            overflow: TextOverflow.ellipsis, // T
                            topRatedProductList[index].name,
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                          SizedBox(height: 5),
                          Text(
                            '\$${topRatedProductList[index].price}',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: orangeColor),
                          )
                        ]
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
       
    );
  }
}
