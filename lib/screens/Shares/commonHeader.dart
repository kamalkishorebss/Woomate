import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/screens/Auth/login.dart';
import 'package:shop_app/screens/Cart/cart.dart';
import 'package:shop_app/screens/Drawer/drawer.dart';

class Header extends StatefulWidget implements PreferredSizeWidget {
  const Header(this.heading, {Key? key});

  final String heading;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
 
  void getData() async {
   SharedPreferences prefs = await SharedPreferences.getInstance();
   String? isLoggedIn = prefs.getString('logged');
   print("jjjjj,$isLoggedIn");
   // ignore: unrelated_type_equality_checks
   if (isLoggedIn == 'true') {
    // User is logged in, navigate to home screen
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyCart(),
        ),
      );
  } else {
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
  }
   
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
     

      // Assuming this is what the heading argument is for
      title: Text(widget.heading), 
actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.shopping_cart, size: 30.0),
          tooltip: '',
          onPressed: getData
          // () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => MyCart(),
          //       ),
          //     );
          
          // },
        ),
      ],
      
    );
  }
}
