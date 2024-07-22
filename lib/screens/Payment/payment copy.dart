import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:shop_app/constants.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shop_app/screens/Shares/normalHeader.dart';

class PaymentForm extends StatefulWidget {
  final int orderId;
  const PaymentForm({Key? key, required this.orderId}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PaymentFormState();
}

class PaymentFormState extends State<PaymentForm> {
  bool isLightTheme = false;
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;
  bool useFloatingAnimation = true;
  bool _isLoading = false;
  final OutlineInputBorder border = OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.grey.withOpacity(0.7),
      width: 2.0,
    ),
  );
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late Map<String, dynamic>? paymentIntent;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      isLightTheme ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
    );
    return MaterialApp(
      title: 'Flutter Credit Card View Demo',
      debugShowCheckedModeBanner: false,
      themeMode: isLightTheme ? ThemeMode.light : ThemeMode.dark,
      theme: ThemeData(
        textTheme: const TextTheme(
          // Text style for text fields' input.
          titleMedium: TextStyle(color: Colors.black, fontSize: 18),
        ),
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.light,
          seedColor: Colors.white,
          background: Colors.black,
          // Defines colors like cursor color of the text fields.
          primary: Colors.black,
        ),
        // Decoration theme for the text fields.
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: const TextStyle(color: Colors.black),
          labelStyle: const TextStyle(color: Colors.black),
          focusedBorder: border,
          enabledBorder: border,
        ),
      ),
      darkTheme: ThemeData(
        textTheme: const TextTheme(
          // Text style for text fields' input.
          titleMedium: TextStyle(color: Colors.white, fontSize: 18),
        ),
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: Colors.black,
          background: Colors.white,
          // Defines colors like cursor color of the text fields.
          primary: Colors.white,
        ),
        // Decoration theme for the text fields.
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: const TextStyle(color: Colors.white),
          labelStyle: const TextStyle(color: Colors.white),
          focusedBorder: border,
          enabledBorder: border,
        ),
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Builder(
          builder: (BuildContext context) {
            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: ExactAssetImage(
                    isLightTheme
                        ? 'lib/images/bg-light.png'
                        : 'lib/images/bg-dark.png',
                  ),
                  fit: BoxFit.fill,
                ),
              ),
              child: SafeArea(
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(), // Show loader
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Container(
                                    color: Colors.red,
                                    height: 100, // Adjust the height as needed
                                    child: Center(child: Text('Division 1')),
                                  ),
                                ),
                                SizedBox(
                                    width:
                                        8), // Adjust the spacing between divisions
                                Expanded(
                                  child: Container(
                                    color: Colors.blue,
                                    height: 100, // Adjust the height as needed
                                    child: Center(child: Text('Division 2')),
                                  ),
                                ),
                                SizedBox(
                                    width:
                                        8), // Adjust the spacing between divisions
                                Expanded(
                                  child: Container(
                                    color: Colors.green,
                                    height: 100, // Adjust the height as needed
                                    child: Center(child: Text('Division 3')),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () => setState(() {
                              isLightTheme = !isLightTheme;
                            }),
                            icon: Icon(
                              isLightTheme ? Icons.light_mode : Icons.dark_mode,
                            ),
                          ),
                          CreditCardWidget(
                            enableFloatingCard: useFloatingAnimation,
                            glassmorphismConfig: _getGlassmorphismConfig(),
                            cardNumber: cardNumber,
                            expiryDate: expiryDate,
                            cardHolderName: cardHolderName,
                            cvvCode: cvvCode,
                            bankName: 'Axis Bank',
                            frontCardBorder: useGlassMorphism
                                ? null
                                : Border.all(color: Colors.grey),
                            backCardBorder: useGlassMorphism
                                ? null
                                : Border.all(color: Colors.grey),
                            showBackView: isCvvFocused,
                            obscureCardNumber: true,
                            obscureCardCvv: true,
                            isHolderNameVisible: true,
                            cardBgColor: isLightTheme
                                ? AppColors.cardBgLightColor
                                : AppColors.cardBgColor,
                            backgroundImage: useBackgroundImage
                                ? 'lib/images/card_bg.png'
                                : null,
                            isSwipeGestureEnabled: true,
                            onCreditCardWidgetChange:
                                (CreditCardBrand creditCardBrand) {},
                            customCardTypeIcons: <CustomCardTypeIcon>[
                              CustomCardTypeIcon(
                                cardType: CardType.mastercard,
                                cardImage: Image.asset(
                                  'lib/images/mastercard.png',
                                  height: 48,
                                  width: 48,
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  CreditCardForm(
                                    formKey: formKey,
                                    obscureCvv: true,
                                    obscureNumber: true,
                                    cardNumber: cardNumber,
                                    cvvCode: cvvCode,
                                    isHolderNameVisible: true,
                                    isCardNumberVisible: true,
                                    isExpiryDateVisible: true,
                                    cardHolderName: cardHolderName,
                                    expiryDate: expiryDate,
                                    inputConfiguration:
                                        const InputConfiguration(
                                      cardNumberDecoration: InputDecoration(
                                        labelText: 'Number',
                                        hintText: 'XXXX XXXX XXXX XXXX',
                                      ),
                                      expiryDateDecoration: InputDecoration(
                                        labelText: 'Expired Date',
                                        hintText: 'XX/XX',
                                      ),
                                      cvvCodeDecoration: InputDecoration(
                                        labelText: 'CVV',
                                        hintText: 'XXX',
                                      ),
                                      cardHolderDecoration: InputDecoration(
                                        labelText: 'Card Holder',
                                      ),
                                    ),
                                    onCreditCardModelChange:
                                        onCreditCardModelChange,
                                  ),
                                  const SizedBox(height: 20),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        const Text('Glassmorphism'),
                                        const Spacer(),
                                        Switch(
                                          value: useGlassMorphism,
                                          inactiveTrackColor: Colors.grey,
                                          activeColor: Colors.white,
                                          activeTrackColor:
                                              AppColors.colorE5D1B2,
                                          onChanged: (bool value) =>
                                              setState(() {
                                            useGlassMorphism = value;
                                          }),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        const Text('Card Image'),
                                        const Spacer(),
                                        Switch(
                                          value: useBackgroundImage,
                                          inactiveTrackColor: Colors.grey,
                                          activeColor: Colors.white,
                                          activeTrackColor:
                                              AppColors.colorE5D1B2,
                                          onChanged: (bool value) =>
                                              setState(() {
                                            useBackgroundImage = value;
                                          }),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        const Text('Floating Card'),
                                        const Spacer(),
                                        Switch(
                                          value: useFloatingAnimation,
                                          inactiveTrackColor: Colors.grey,
                                          activeColor: Colors.white,
                                          activeTrackColor:
                                              AppColors.colorE5D1B2,
                                          onChanged: (bool value) =>
                                              setState(() {
                                            useFloatingAnimation = value;
                                          }),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  GestureDetector(
                                    onTap: _onValidate,
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      decoration: const BoxDecoration(
                                        color: orangeColor,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15),
                                      alignment: Alignment.center,
                                      child: const Text(
                                        'Pay',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'halter',
                                          fontSize: 14,
                                          package: 'flutter_credit_card',
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _onValidate() {
    if (formKey.currentState?.validate() ?? false) {
      print('valid!');
      makePayment(widget.orderId);
    } else {
      print('invalid!');
    }
  }

  Future<void> makePayment(id) async {
    setState(() {
      _isLoading = true;
    });
    try {
      await createPaymentIntent('100', 'USD');
    } catch (err) {
      throw Exception(err);
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      //Request body

      var data = jsonEncode({
        // "payment_method": "stripe",
        "order_id": widget.orderId,
        "token": "tok_visa",
        "card_number": cardNumber,
        "exp_month": expiryDate.split("/").first,
        "exp_year": expiryDate.split("/").last,
        "cvc": cvvCode
      });
      print('data:$data');

      //Make post request to Stripe
      var response = await http.post(
        Uri.parse(
            'https://allalgosdev.com/demosite/wp-json/my/v1/process-payment'),
        headers: {
          'Content-Type': 'application/json',
          // 'Cookie': 'wordpress_logged_in_a90f7fee4974be019f49e21ddad3165a=kriti1%7C1711717817%7CT8WafBdE5XstE9hA5Cv6Ipl2wQEaNxy6WSMoqxhw2K0%7C8c08b13843dcdf73ccf3cd99979628006d4e54ec376e39fc5f4574dce9e27e29; wp_cocart_session_a90f7fee4974be019f49e21ddad3165a=3208%7C%7C1710759922%7C%7C1710673522%7C%7C1b0d4d85938e452571ecf3b792a458a3'
        },
        body: data,
      );
      setState(() {
        _isLoading = false;
      });

      dynamic responseBody = json.decode(response.body);

      // Check if the response body contains "Payment successful"
      if (responseBody is String &&
          responseBody.contains("Payment successful")) {
        // Navigate to the next screen
        showPopUp("Payment done");
        print("Navigating to the next screen...");
        // Replace the print statement with your navigation logic
        Navigator.pushNamed(context, '/thankyou');
      } else {
        showPopUp(responseBody);
        // print("Payment was not successful.");
      }
    } catch (err) {
      // throw Exception(err.toString())
      showPopUp(err.toString());
    }
  }

  calculateAmount(String amount) {
    final calculatedAmout = (int.parse(amount)) * 100;
    return calculatedAmout.toString();
  }

  Glassmorphism? _getGlassmorphismConfig() {
    if (!useGlassMorphism) {
      return null;
    }

    final LinearGradient gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[Colors.grey.withAlpha(50), Colors.grey.withAlpha(50)],
      stops: const <double>[0.3, 0],
    );

    return isLightTheme
        ? Glassmorphism(blurX: 8.0, blurY: 16.0, gradient: gradient)
        : Glassmorphism.defaultConfig();
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

  void showPopUp(e) {
    showToast(
      e,
      context: context,
      axis: Axis.horizontal,
      alignment: Alignment.center,
      position: StyledToastPosition.top,
      toastHorizontalMargin: 20,
      backgroundColor: orangeColor,
      fullWidth: true,
    );
  }
}
