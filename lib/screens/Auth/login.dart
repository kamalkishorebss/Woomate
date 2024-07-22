import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/screens/Auth/register.dart';
import 'package:shop_app/screens/BottomTabScreen/bottomTab.dart';
import 'package:shop_app/screens/HomeScreen/homescreen.dart';
import 'package:shop_app/services/auth_service_api.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreen createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _email     = '';
  String _password  = '';
  bool _isLoading   = false;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // This triggers the onSaved callbacks
      setState(() {
        _isLoading   = true;
      });
      AuthService.login(_email, _password).then( (response) async {
        // Check if the response indicates success
         setState(() {
          _isLoading   = false;
         });
        bool success = response['success'];
        if (success == true) {
          //print("54545454545: ${response['data']}");
          saveData();
          saveUserInfo(jsonEncode(response['data']));
          // Registration was successful, navigate to the next screen
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BottomNavigation()),
          );
        } else {
          
          showToast(
          '${response.toString()}',
          context: context,
          axis: Axis.horizontal,
          alignment: Alignment.center,
          position: StyledToastPosition.top,
          toastHorizontalMargin: 20,
          backgroundColor: orangeColor,
          fullWidth: true,
        );
          // You can optionally show an error message to the user here
        }
      }).catchError((error) {
        // Handle any errors that occurred during the registration process
        
        showToast(
          '$error',
          context: context,
          axis: Axis.horizontal,
          alignment: Alignment.center,
          position: StyledToastPosition.top,
          toastHorizontalMargin: 20,
          backgroundColor: orangeColor,
          fullWidth: true,
        );
      });
    }
  }

  void saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("logged", "true");
  }

  void saveUserInfo(data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("User_Detail",data);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          
          child: SingleChildScrollView(

            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 26.0),
               child : Form(
            key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 60.0),
                  const Text(
                    "Let's you in",
                    style: TextStyle(fontSize: 24.0,fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.0),
                   TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Email or Username',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                     key: UniqueKey(), 
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _email = value!;
                  },
                  ),
                  SizedBox(height: 10.0),
                   TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Password',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                     key: UniqueKey(), 
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _password = value!;
                  },
                    obscureText: true,
                  ),
                  SizedBox(height: 20.0),
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'By signing in, you agree to our ',
                        style: TextStyle(fontSize: 12.0),
                      ),
                       Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                         Text(
                        'Terms of Service',
                        style: TextStyle(fontSize: 12.0, color: Color(0xFFD35804)),
                      ),
                      Text(
                        ' and ',
                        style: TextStyle(fontSize: 12.0),
                      ),
                      Text(
                        'Privacy Policy',
                        style: TextStyle(fontSize: 12.0, color: Color(0xFFD35804)),
                      ),
                      ]
                       )
                    ],
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFD35804), // Use your custom color
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    // () {
                    //   Navigator.pop(context, '/tabs');
                    // },
                    child: _isLoading==true? CircularProgressIndicator(): Text(
                      'Sign in',
                      style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextButton(
                    onPressed: () {
                      // Handle forgot password action
                    },
                    child: const Text(
                      'Forgot your password?',
                     style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600, color: Color(0xFFD35804))
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Divider(
                    color: Colors.black,
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account? ',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      TextButton(
                        onPressed: () {
                         Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterScreen(),
                      ),
                    );
                        },
                        child: Text(
                          'Register',
                          style: TextStyle(fontSize: 16.0, color:Color(0xFFD35804)),
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => BottomNavigation()),
                        // );
                    },
                    child: const Text(
                      'Go Back',
                     style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600, color: Color(0xFFD35804))
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      )
    );
  }
}


