import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shop_app/screens/Auth/login.dart';
import 'package:shop_app/screens/Shares/normalHeader.dart';
import 'package:shop_app/services/auth_service_api.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreen createState() => _RegisterScreen();
}

class _RegisterScreen extends State<RegisterScreen> {
  
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _firstname = '';
  String _lastname  = '';
  String _username  = '';
  String _email     = '';
  String _password  = '';
  
  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // This triggers the onSaved callbacks

      AuthService.register(_firstname, _lastname, _username, _email, _password).then((response) {
        // Check if the response indicates success
        bool success = response['success'];
        if (success == true) {
          // Registration was successful, navigate to the next screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ),
          );
        } else {
          // Registration failed, handle the failure scenario
          print('Registration failed: ${response.toString()}');
          // You can optionally show an error message to the user here
        }
      }).catchError((error) {
        // Handle any errors that occurred during the registration process
        print('Error registering: $error');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: Header(title:"Register"),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(26.0),
          child : Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(
                  child: Text(
                    'Create an account',
                    style: TextStyle(fontSize: 22,fontWeight: FontWeight.w700,color: Colors.black),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'First Name',
                  ),
                  key: UniqueKey(), 
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _firstname = value!;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Last Name',
                  ),
                  key: UniqueKey(), 
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your last name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _lastname = value!;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Username',
                  ),
                  key: UniqueKey(), 
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _username = value!;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Email',
                  ),
                  key: UniqueKey(), 
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _email = value!;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  obscureText: true,
                  decoration:  const InputDecoration(
                    hintText: 'Password',
                  ),
                  key: UniqueKey(), 
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _password = value!;
                  },
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _submit,
                  child: const Text(
                    'Register',
                    style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xFFD35804), // Use your custom color
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'By signing in, you agree to our Terms of Service and Privacy Policy',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account? '),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Sign in',
                        style: TextStyle(
                          color:Color(0xFFD35804),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
