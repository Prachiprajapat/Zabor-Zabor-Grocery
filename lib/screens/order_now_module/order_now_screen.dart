import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:zabor/app_localizations/app_localizations.dart';
import 'package:zabor/constants/constants.dart';
import 'package:zabor/screens/add_address_module/add_address_screen.dart';
import 'package:zabor/screens/basket_screen_module/taxes_response_model.dart';
import 'package:zabor/screens/delivery_address_list_module/delivery_address_list_screen.dart';
import 'package:zabor/screens/food_list_module/cart_model.dart';
import 'package:zabor/screens/order_summary_module/order_summary_screen.dart';
import 'package:zabor/screens/share_feedback/share_feedback_screen.dart';

class OrderNowScreen extends StatefulWidget {
  final CartModel cartModel;
  final Tax tax;
  final bool isWithoutLogin;
  const OrderNowScreen(
      {Key key,
      @required this.cartModel,
      @required this.tax,
      this.isWithoutLogin = false})
      : super(key: key);
  @override
  _OrderNowScreenState createState() => _OrderNowScreenState();
}

class _OrderNowScreenState extends State<OrderNowScreen> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  String deliverString = 'Deliver at home';
  String pickupString = 'Pickup from store';

  List<String> arrPaymentOptions = [];

  @override
  void initState() {
    super.initState();
    setPaymentOptions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                FormBuilder(
                  key: _fbKey,
                  initialValue: {
                    'date': DateTime.now(),
                    'time': DateTime.now(),
                    'accept_terms': false,
                  },
                  // autovalidate: true,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        AppLocalizations.of(context).translate('Payment Mode'),
                        style: TextStyle(
                            color: AppColors().kBlackColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      FormBuilderDropdown(
                        attribute: "paymentmode",
                        decoration:
                            InputDecoration(enabledBorder: InputBorder.none),
                        // initialValue: 'Male',
                        hint: Text(AppLocalizations.of(context)
                            .translate('Select Payment mode')),
                        validators: [FormBuilderValidators.required()],
                        items: arrPaymentOptions
                            .map((paymentmode) => DropdownMenuItem(
                                value: paymentmode,
                                child: Text("$paymentmode")))
                            .toList(),
                      ),
                      Divider(),
                      SizedBox(height: 20),
                      Text(
                        AppLocalizations.of(context)
                            .translate('Delivery Options'),
                        style: TextStyle(
                            color: AppColors().kBlackColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      FormBuilderDropdown(
                        attribute: "deliveryOption",
                        decoration:
                            InputDecoration(enabledBorder: InputBorder.none),
                        // initialValue: 'Male',
                        hint: Text(AppLocalizations.of(context)
                            .translate('Select Delivery option')),
                        validators: [FormBuilderValidators.required()],
                        items: [
                          AppLocalizations.of(context).translate(deliverString),
                          AppLocalizations.of(context).translate(pickupString)
                        ]
                            .map((paymentmode) => DropdownMenuItem(
                                value: paymentmode,
                                child: Text("$paymentmode")))
                            .toList(),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                ButtonWidget(
                  title: AppLocalizations.of(context).translate('SUBMIT'),
                  onPressed: () {
                    if (_fbKey.currentState.saveAndValidate()) {
                      print(_fbKey.currentState.value);
                      int paymentMode = 1;
                      int deliveryMode = 1;
                      if (_fbKey.currentState.value["paymentmode"].toString().toLowerCase() == "ath") {
                        paymentMode = 0;
                      } else if (_fbKey.currentState.value["paymentmode"].toString().toLowerCase() == "stripe"
                          // ||_fbKey.currentState.value["paymentmode"].toString().toLowerCase() == "Pago electrónico".toLowerCase()
                      ) {
                        paymentMode = 1;
                      } else {
                        paymentMode = 2;
                      }

                      if (_fbKey.currentState.value["deliveryOption"].toString().toLowerCase() == pickupString.toLowerCase()
                          ||_fbKey.currentState.value["deliveryOption"].toString().toLowerCase() == "Recoger del tienda".toLowerCase()) {
                        deliveryMode = 2;
                      }
                      print("Payment Mode: " + paymentMode.toString());
                      print("Delivery Mode: " + deliveryMode.toString());

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OrderSummaryScreen(
                                    tax: widget.tax,
                                    cartModel: widget.cartModel,
                                    paymentMode: paymentMode,
                                    deliveryMode: deliveryMode,
                                    isWithoutLogin: widget.isWithoutLogin,
                                  )));
                    }
                  },
                )
              ],
            ),
          ),
        ));
  }

  setPaymentOptions() async {
    await Future.delayed(Duration.zero);
    // arrPaymentOptions = [
    //   AppLocalizations.of(context).translate('Online'),
    // ];

    if (widget.cartModel.cod == 1) {
      arrPaymentOptions = [
        'Visa or Master Card',
        // AppLocalizations.of(context).translate('Online'),
        AppLocalizations.of(context).translate('Cash on delivery')
      ];
    }
    setState(() {});
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text(
        AppLocalizations.of(context).translate('ORDER NOW'),
      ),
      backgroundColor: AppColors().kWhiteColor,
      iconTheme: IconThemeData(color: AppColors().kBlackColor),
      textTheme: TextTheme(
          title: TextStyle(
              color: AppColors().kBlackColor,
              fontSize: 20,
              fontWeight: FontWeight.w600)),
    );
  }
}
