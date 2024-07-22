import 'package:flutter/material.dart';
import 'package:shop_app/screens/BottomTabScreen/bottomTab.dart';
import 'package:shop_app/screens/CheckoutScreen/checkout.dart';
import 'package:shop_app/screens/HomeScreen/homescreen.dart';
import 'package:shop_app/screens/Category/categories.dart';
import 'package:shop_app/screens/FavoriteScreen/favoritescreen.dart';
import 'package:shop_app/screens/MyAccount/Account/account.dart';
import 'package:shop_app/screens/MyAccount/AddBillingDetail/billing_detail.dart';
import 'package:shop_app/screens/MyAccount/AddShippingDetail/shipping_detail.dart';
import 'package:shop_app/screens/MyAccount/Contact/contact.dart';
import 'package:shop_app/screens/MyAccount/MyOrders/orderDetail.dart';
import 'package:shop_app/screens/MyAccount/MyOrders/orders.dart';
import 'package:shop_app/screens/Payment/order_success.dart';
import 'package:shop_app/screens/Payment/payment.dart';



class RootNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const BottomNavigation(),
      routes: {
        '/tabs'            : (context) => BottomNavigation(),
        '/home'            : (context) => HomeScreen(),  
        '/categories'      : (context) => Categories(), // Added route for Categories screen
        '/favourite'       : (context) => FavoriteScreen(), // Added route for FavoriteScreen
        '/account'         : (context) => AccountScreen(),  // Uncomment this line when ProfileScreen is implemented
        '/orders'          : (context) => OrderScreen(),
        '/checkout'        : (context) => Checkout(),
        '/thankyou'        : (context) => OrderPlacedScreen(),
        '/billing_detail'  : (context) => BillingDetailForm(),
        '/shipping_detail' : (context) => ShippingDetailForm(),
        '/aboutUs'         : (context) => AboutUsPage(),
       

       
      },
    );
  }
}
