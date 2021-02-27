import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:zabor/app_localizations/app_localizations.dart';
import 'package:zabor/constants/constants.dart';
import 'package:zabor/screens/basket_screen_module/taxes_response_model.dart';
import 'package:zabor/screens/food_list_module/cart_model.dart';
import 'package:zabor/screens/order_now_module/order_now_screen.dart';

class OrderAdvancedScreen extends StatefulWidget {
  final CartModel cartModel;
  final Tax tax;
  final bool isWithoutLogin;
  const OrderAdvancedScreen(
      {Key key,
      @required this.cartModel,
      @required this.tax,
      this.isWithoutLogin = false})
      : super(key: key);
  @override
  _OrderAdvancedScreenState createState() => _OrderAdvancedScreenState();
}

class _OrderAdvancedScreenState extends State<OrderAdvancedScreen> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  List<String> arrPaymentOptions = [];
  List<Cart> arrAdvancedPayment = [];

  @override
  void initState() {
    super.initState();
    setPaymentOptions();
    getAdvancedPaymentList();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: buildAppBar(),
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, position) {
                        return Container(
                          padding: EdgeInsets.symmetric(vertical: 5.0),
                          width: double.infinity,
                          child: Container(
                            margin: EdgeInsets.only(left: 16, right: 16),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      arrAdvancedPayment[position].itemName,
                                    ),
                                    Text(
                                      // 'text2',
                                      arrAdvancedPayment[position].quantity.toString(),
                                    ),
                                    Text(
                                      "\$" + (arrAdvancedPayment[position].itemPrice * arrAdvancedPayment[position].quantity).toString(),
                                    ),
                                  ],
                                ),
                                Divider(
                                  thickness: 1,
                                  indent: 6.0,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: arrAdvancedPayment.length,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5.0),
                    width: double.infinity,
                    child: Container(
                      margin: EdgeInsets.only(left: 16, right: 16),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total",
                              ),
                              Text(
                                // 'text2',
                                "",
                              ),
                              Text(
                                "\$" + getSumAdvancedPaymentPrice().toString(),
                              ),
                            ],
                          ),
                          Divider(
                            thickness: 1,
                            indent: 6.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(left: 16, right: 16),
                    child: FormBuilderDropdown(
                        attribute: "paymentmode",
                        decoration: InputDecoration(enabledBorder: InputBorder.none),
                        initialValue: 'Cash on delivery',
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
                  ),
                  Container(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        FlatButton (
                          color: Colors.red,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(AppLocalizations.of(context).translate('Back'),
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                          shape:
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        FlatButton (
                          color: Colors.green,
                          onPressed: () {
                            widget.cartModel.stamp_paid = 1;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OrderNowScreen(
                                    cartModel: widget.cartModel,
                                    tax: widget.tax,
                                    isWithoutLogin: widget.isWithoutLogin,
                                  )));
                          },
                          child: Text(AppLocalizations.of(context).translate('Submit'),
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                          shape:
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        )
                      ]
                    )
                  )
                ]
              )
            )
          )
        ));
  }

  setPaymentOptions() async {
    await Future.delayed(Duration.zero);
    arrPaymentOptions = [
      "Foodstamps Gateway",
      "Cash on delivery"
    ];
    setState(() {});
  }

  getAdvancedPaymentList()  {
    // List<Cart>
    arrAdvancedPayment = new List<Cart>();
    for( int i = 0; i < widget.cartModel.cart.length; i++) {
      // widget.cartModel[i]
      if (widget.cartModel.cart[i].is_stamp) {
        arrAdvancedPayment.add(widget.cartModel.cart[i]);
      }
    }
    return arrAdvancedPayment;
  }

  getSumAdvancedPaymentPrice()  {
    // List<Cart>
    double dSum = 0;
    for( int i = 0; i < widget.cartModel.cart.length; i++) {
      // widget.cartModel[i]
      if (widget.cartModel.cart[i].is_stamp) {
        dSum += widget.cartModel.cart[i].quantity * widget.cartModel.cart[i].itemPrice;
      }
    }
    return dSum;
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text(
        AppLocalizations.of(context).translate('ADVANCED PAY'),
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
