import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/screens/Drawer/drawer.dart';
import 'package:shop_app/services/auth_service_api.dart';
import '../../Shares/commonHeader.dart';



class AccountScreen extends StatefulWidget {
  
  
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  List userDetail = [];
  bool _isLoading = false;
  String firstName = '';
  String lastName = '';
  String address = '';
  String city = '';
  String country = '';
  String state = '';
  String username = ''; 
  String email = '';
  String postcode = '';

  @override
  void initState() {
    super.initState();
    getUserDetail();
  }

void getUserDetail() async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDetail = prefs.getString("User_Detail");
    if (userDetail != null) {
      Map<String, dynamic> detail = jsonDecode(userDetail);
      AuthService().fetchUserDetail(detail['id']).then((value) {
        print(value);
        setState(() {

          firstName = value['billing']['first_name'];
          lastName  = value['billing']['last_name'];
          username  = value['username'];
          email     = value['email']; 
          postcode  = value['billing']['postcode'];
          address   = value['billing']['address_1'];
          city      = value['billing']['city'];
          state     = value['billing']['state'];
          _isLoading = false;
        });
      }).catchError((error) {
        // Handle any errors that occur during the fetchUserDetail process
        print('Error fetching user detail: $error');
        setState(() {
          _isLoading = false; // Set isLoading to false in case of error
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
         appBar: Header('My Account'),
          drawer: NavDrawer(),
        body: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                     
                      Image.asset(
                        'lib/images/dummyUser.png',
                        width: 100.0,
                        height: 100.0,
                      ),
                       SizedBox(height: 10),
                      Text(
                         username != null ? username : 'customer',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                       SizedBox(height: 10),
                      Text(
                       email != null ? email :'customer@demo.com',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey,
                        ),
                      ),
                       SizedBox(height: 10),
                      GestureDetector(
                        
//onTap: () => Navigator.pushNamed(context, 'Edit', arguments: {'name': userDetail['slug']}),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'lib/images/pencil.png',
                              width: 22.0,
                              height: 22.0,
                            ),
                            SizedBox(width: 8.0),
                            Text(
                              'Edit Profile',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.0),
                ListTile(
                  onTap: () => Navigator.pushNamed(context, '/orders'),
                  leading: Image.asset(
                    'lib/images/approved.png',
                    width: 24.0,
                    height: 24.0,
                  ),
                  title: Text('My Orders'),
                  subtitle: Text('View your orders'),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
                ListTile(
                  onTap: () => Navigator.pushNamed(context, '/billing_detail'),
                  leading: Image.asset(
                    'lib/images/location.png',
                    width: 24.0,
                    height: 24.0,
                  ),
                  title: Text('Billing Address'),
                  subtitle: Text('No billing address'),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
                ListTile(
                  onTap: () => Navigator.pushNamed(context, '/shipping_detail'),
                  leading: Image.asset(
                    'lib/images/delivery-truck.png',
                    width: 24.0,
                    height: 24.0,
                  ),
                  title: Text('Shipping Address'),
                  subtitle: Text('No shipping address'),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
                ListTile(
                  onTap: () => Navigator.pushNamed(context, '/aboutUs'),
                  leading: Image.asset(
                    'lib/images/info.png',
                    width: 24.0,
                    height: 24.0,
                  ),
                  title: Text('About Us'),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
                ListTile(
                 onTap: () => Navigator.pushNamed(context, '/aboutUs'),
                  leading: Image.asset(
                    'lib/images/telephone.png',
                    width: 24.0,
                    height: 24.0,
                  ),
                  title: Text('Contact Us'),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
                ListTile(
                 onTap: () => Navigator.pushNamed(context, '/aboutUs'),
                  leading: Image.asset(
                    'lib/images/insurance.png',
                    width: 24.0,
                    height: 24.0,
                  ),
                  title: Text('Privacy Policy'),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
                ListTile(
                 // onTap: () => Navigator.pushNamed(context, 'TermsAndConditions'),
                  leading: Image.asset(
                    'lib/images/document.png',
                    width: 24.0,
                    height: 24.0,
                  ),
                  title: Text('Terms and Conditions'),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
          ),
        ),
     
    );
  }
}

