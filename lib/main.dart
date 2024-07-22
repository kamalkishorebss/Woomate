import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/routes.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';



void main() async{
   //Initialize Flutter Binding
  WidgetsFlutterBinding.ensureInitialized();

  //Assign publishable key to flutter_stripe
  Stripe.publishableKey = "pk_test_51Ou94LSJc8B3J1qmANwHeXeF4WXqPwB3hC8WymykEF56pCncumAp9nLkGixBnfdmoPcej1RLeFzt0b468MTaDHTv00KQQ7rBgv";
  // StripePayment.setOptions(
  //   StripeOptions(publishableKey: "pk_test_51Ou94LSJc8B3J1qmANwHeXeF4WXqPwB3hC8WymykEF56pCncumAp9nLkGixBnfdmoPcej1RLeFzt0b468MTaDHTv00KQQ7rBgv"),
  // );

  //Load our .env file that contains our Stripe Secret key
  await dotenv.load(fileName: "assets/.env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: Theme.of(context).textTheme.apply(bodyColor: kTextColor),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home:  RootNavigator(),
    );
  }
}
