import 'package:flutter/material.dart';
import 'package:shop_app/model/category_model.dart';
import 'package:shop_app/screens/Drawer/drawer.dart';
import 'package:shop_app/screens/ProductStack/ProductList/products.dart';
import 'package:shop_app/services/api_services.dart';
import '../Shares/commonHeader.dart';


class Categories extends StatefulWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State {

  late List<CategoryList>? categoryList = [];
  final iconImage = 'lib/images/category/next.png';

  bool _isLoading = false;

  @override

   void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
     setState(() {
       _isLoading = true;
     });
     try {
     await ApiService().fetchCategories().then((value){
       print(value);
       setState(() {
         categoryList = value;
       });
     });
     }
     catch (error) {
      print('Error fetching categories: $error');
     }
     finally{
      setState(() {
        _isLoading = false;
      });
     }
   
  }

  Widget build(BuildContext context) {
    return Scaffold(
       drawer: NavDrawer(),
      appBar:Header('All Categories'),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(), // Show loader
            )
          :Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(248, 236, 215, 198), // Example background color
          ),
          child: ListView.builder(
        itemCount: categoryList!.length,
        itemBuilder: (context, index) {
          return Container(
           
            margin: const EdgeInsets.symmetric(vertical: 10.0), // Add margin from top and bottom
            child: ListTile(
              leading: Container(
                child:categoryList?[index].image==''?
                 Image.asset(
                      'lib/images/no-image.png',
                      width: 50, // Adjust size as needed
                      height: 50,
                    ):
                Image.network(
                      categoryList![index].image,
                      width: 50, // Adjust size as needed
                      height: 50,
                    )
                   
              ),
              title: Row(
                children: [
                  Text(
                    categoryList![index].name,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(), // Add spacer to push the icon to the end
                  Icon(Icons.arrow_forward), // Icon widget as trailing
                ],
              ),
               onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductListScreen(catName:categoryList![index].name,catId : categoryList![index].id)),
                )
               },
              // Add more customization as needed
            ),
          );
        },
      ),
      )
    );
  }
}
