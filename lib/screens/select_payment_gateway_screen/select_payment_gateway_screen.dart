import 'package:flutter/material.dart';
import 'package:zabor/screens/share_feedback/share_feedback_screen.dart';

class SelectPaymentGatewayScreen extends StatefulWidget {
  @override
  _SelectPaymentGatewayScreenState createState() => _SelectPaymentGatewayScreenState();
}

class _SelectPaymentGatewayScreenState extends State<SelectPaymentGatewayScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
    child:Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
             Text(
            'Select Payment Gateway',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 30),
      ButtonWidget(title:'Stripe',onPressed: (){
        Navigator.pop(context,1);
      },),
      ButtonWidget(title: 'Authorize.Net',onPressed: (){
        Navigator.pop(context,3);
      },)
    ],)
        ),
      );
  }
}