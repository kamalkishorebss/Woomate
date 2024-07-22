import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/screens/Drawer/drawer.dart';
import '../Shares/commonHeader.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<Map<String, dynamic>> wishlist = [];

  @override
  void initState() {
    super.initState();
    _loadWishlist();
  }

  _loadWishlist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? sendStringList = prefs.getStringList('send');
    if (sendStringList != null) {
      // Convert the list of strings back to a list of maps
      setState(() {
        wishlist = sendStringList
            .map((item) => jsonDecode(item))
            .cast<Map<String, dynamic>>()
            .toList();
        print(wishlist);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: Header('Wishlist'),
      body: ListView.builder(
        itemCount: wishlist.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                   
                    child: Center(
                      child: Image.network(
                        wishlist[index]['image'],
                        width: 130,
                        height: 130,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                 
                ),
                Spacer(),
                Expanded(
                  flex: 5,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          wishlist[index]['name'],
                          style: const TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8), // Add spacing between the texts
                        Text(
                         '\$${wishlist[index]['price']}', // Assuming 'description' exists in your wishlist map
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Expanded(
                  flex: 1,
                  child: Container(
                   
                    child: Center(
                      child:Icon(Icons.favorite_sharp, color:orangeColor,size: 25) 
                      ),
                    ),
                  ),
                
              ],
            ),
          );
        },
      ),
    );
  }
}
