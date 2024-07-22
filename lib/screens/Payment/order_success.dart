import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/screens/BottomTabScreen/bottomTab.dart';
import 'external_style.dart';

class OrderPlacedScreen extends StatelessWidget {
  const OrderPlacedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: orangeColor,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.check_circle, // Tick icon
                        color: Colors.white, // Color of the tick icon
                        size: 48.0, // Size of the tick icon
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Order Placed Successfully',
                        style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Thank you for your order!',
                        style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                AnimatedOpacity(
                  opacity: 1.0, // Set the initial opacity to 1.0
                  duration: Duration(milliseconds: 200), // Animation duration
                  child: GestureDetector(
                    onTap: () {
                    Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (context) => BottomNavigation()),
);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white, // Set the button color
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      alignment: Alignment.center,
                      child: Text(
                        'Continue Shopping',
                        style: TextStyle(
                          color:orangeColor ,
                          fontFamily: 'halter',
                          fontSize: 14,
                          package: 'flutter_credit_card',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
