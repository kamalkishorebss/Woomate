import 'package:flutter/material.dart';

class ExternalStyle {
  static final container = BoxDecoration(
    color: Color(0xFFD45803),
  );

  static final scrollView = EdgeInsets.all(20.0);

  static final headerView = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        spreadRadius: 2,
        blurRadius: 4,
        offset: Offset(0, 2),
      ),
    ],
  );

  static final drawerIconView =  BoxDecoration(
    //width: 0.1,
  );

 

  static final signInText = TextStyle(
    fontSize: 18,
    fontFamily: 'Poppins-Bold',
    color: Colors.white,
  );

  
  

  
}
