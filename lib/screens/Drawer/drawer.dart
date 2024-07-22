import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/screens/Auth/login.dart';
import 'package:shop_app/screens/BottomTabScreen/bottomTab.dart';
import 'package:shop_app/screens/HomeScreen/homescreen.dart';
class NavDrawer extends StatefulWidget{
  const NavDrawer({super.key});

   @override
   _NavDrawer createState() => _NavDrawer();
}
 
class _NavDrawer extends State<NavDrawer> {
    String _myData = '';
    

  @override
  void initState() {
    super.initState();
    getData();
   
  }

  void getData() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? isLoggedIn = prefs.getString('logged');
      print("jjjjj,$isLoggedIn");
       setState(() {
        _myData = isLoggedIn!;
       }); 
  }

   void showLogutPopup()async {
    showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Confirm Logout'),
                  content: Text('Are you sure you want to logout?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close dialog
                      },
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () async {
                        // Perform logout and clear SharedPreferences
                        await logout();
                        // Navigate back to the login screen
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => BottomNavigation()),
                        );
                      },
                      child: Text('Logout'),
                    ),
                  ],
                );
              },
            );
          }
  

  Future<void> logout() async {
    // Get instance of SharedPreferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Clear all key-value pairs from SharedPreferences
    await prefs.clear();

  }


  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
               SizedBox(height: 50.0),
                _myData == 'true'?SizedBox():Container(
                height: 80,
                margin: EdgeInsets.all(16.0),
                 decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFFD35804)), // Add border for visual indication
                    borderRadius: BorderRadius.circular(5),
                  ),
                child:Container(
                  alignment: Alignment.center,
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.5,
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFFD35804)), // Add border for visual indication
                    borderRadius: BorderRadius.circular(5),
                  ),
                 child : GestureDetector(
                  onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        )
                      );
                    },
                  child: const Text(
                    'Login/Register',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFD35804), // Set text color
                    ),
                  ),
                ),
                )
              ),
              SizedBox(height: 16.0),
              ListTile(
               onTap: () {
              Navigator.pop(context);
            },
                leading: Image.asset(
                  'lib/images/info.png',
                  width: 24.0,
                  height: 24.0,
                ),
                title: Text('About Us'),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
              ListTile(
                onTap: () {
              Navigator.pop(context);
               Navigator.pushNamed(context, '/aboutUs');
            },
                leading: Image.asset(
                  'lib/images/telephone.png',
                  width: 24.0,
                  height: 24.0,
                ),
                title: Text('Contact Us'),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
              ListTile(
                onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/aboutUs');
              },
                leading: Image.asset(
                  'lib/images/insurance.png',
                  width: 24.0,
                  height: 24.0,
                ),
                title: Text('Privacy Policy'),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
              ListTile(
                onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/aboutUs');
            },
                leading: Image.asset(
                  'lib/images/document.png',
                  width: 24.0,
                  height: 24.0,
                ),
                title: Text('Terms and Conditions'),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
              _myData == 'true'? ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('LogOut'),
            onTap: showLogutPopup
          ):SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
  
  
}
