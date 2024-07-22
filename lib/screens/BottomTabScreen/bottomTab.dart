import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/screens/Drawer/drawer.dart';
import 'package:shop_app/screens/FavoriteScreen/favoritescreen.dart';
import 'package:shop_app/screens/Category/categories.dart';
import 'package:shop_app/screens/HomeScreen/homescreen.dart';
import 'package:shop_app/screens/MyAccount/Account/account.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(),
      
      body: IndexedStack(
        
        index: _selectedTab,

        children: [
          HomeScreen(),
          Categories(),
          FavoriteScreen(),
          AccountScreen()
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        
        currentIndex: _selectedTab,
        
        onTap: (int newIndex) {
          setState(() {
            _selectedTab = newIndex;
          });
        },
        
        selectedItemColor: orangeColor,
        
        unselectedItemColor: Colors.grey,

        items: const <BottomNavigationBarItem>[
          
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home"
          ),
          
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_outlined),
            label: "Categories"),
          
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_rounded),
            label: "Favorite"),
          
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Account"
          ),
        ],
      ),
    );
  }
}
