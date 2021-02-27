import 'package:flutter/material.dart';
import 'package:zabor/app_localizations/app_localizations.dart';
import 'package:zabor/constants/apis.dart';
import 'package:zabor/constants/app_utils.dart';
import 'package:zabor/constants/constants.dart';
import 'package:zabor/screens/basket_screen_module/taxes_response_model.dart';
import 'package:zabor/screens/food_list_module/cart_model.dart';
import 'package:zabor/screens/food_list_module/menu_response_model.dart';
import 'package:zabor/screens/login_signup/login_signup.dart';
import 'package:zabor/screens/login_signup/model/model.dart';
import 'package:zabor/screens/order_now_module/order_now_screen.dart';
import 'package:zabor/screens/order_now_module/order_mode_screen.dart';
import 'package:zabor/screens/share_feedback/share_feedback_screen.dart';
import 'package:zabor/utils/k3webservice.dart';
import 'package:zabor/utils/utils.dart';
import 'dart:convert';
import 'basket_response_model.dart';

class BasketScreen extends StatefulWidget {
  final CartModel cartModel;
  final bool isFromSettings;
  final bool isWithoutLogin;
  const BasketScreen(
      {Key key,
      this.cartModel,
      @required this.isFromSettings,
      this.isWithoutLogin = false})
      : super(key: key);
  @override
  _BasketScreenState createState() => _BasketScreenState();
}

class _BasketScreenState extends State<BasketScreen> {
  bool _isLoading = false;
  BasketModel _basketModel;
  Cart _cart;
  CartModel _cartModel;
  bool _isAuthError = false;
  bool _noData = false;
  Tax _tax;
  bool _isRestAvailable = true;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    print(
        'widget.cartModel****************************************************************');
    print(jsonEncode(widget.cartModel).toString());
    if (widget.isWithoutLogin) {
      _cartModel = widget.cartModel;
      callGetTaxesApi();
    } else {
      // _cartModel = CartModel();
      _cartModel = widget.cartModel;
      callGetTaxesApi();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: buildAppBar(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _isAuthError
              ? buildAuthWigdet(context)
              : _noData
                  ? buildNoDataWigdet(context)
                  : buildBody(),
    );
  }

  Column buildBody() {
    return Column(children: [
      SizedBox(
        height: 40,
      ),
      Expanded(
          child: ListView.builder(
        itemBuilder: (context, index) => index == _cartModel.cart.length
            ? buildPriceColumn()
            : buildBasketItemRow(index),
        itemCount: _cartModel.cart.length + 1,
      )),
      ButtonWidget(
        title: 'CONTINUE',
        color: AppColors.kGreenColor,


        onPressed: () {

          // if (!widget.isWithoutLogin){
          // if (!_isRestAvailable) {
          //   showSnackBar(
          //       _scaffoldKey,
          //       'The restaurant is closed at the moment. Please try again later.',
          //       null);
          //   return;
          // }
          // }

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OrderModeScreen(
                        cartModel: _cartModel,
                        tax: _tax,
                        isWithoutLogin: widget.isWithoutLogin,
                      )));

          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => OrderNowScreen(
          //           cartModel: _cartModel,
          //           tax: _tax,
          //           isWithoutLogin: widget.isWithoutLogin,
          //         )));
        },
      ),
      SizedBox(
        height: 20,
      ),
    ]);
  }

  Widget buildPriceColumn() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Total',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${(_cartModel.getTotal() - (_cartModel.getCityTax() + _cartModel.getStateTax())).toStringAsFixed(2)}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '+ City Tax',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                Text(
                  '\$${_cartModel.getCityTax().toStringAsFixed(2)}',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '+ State Tax',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                Text(
                  '\$${_cartModel.getStateTax().toStringAsFixed(2)}',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
            // SizedBox(height: 5),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: <Widget>[
            //     Text(
            //       '+Grand Tax',
            //       style: TextStyle(color: Colors.grey, fontSize: 13),
            //     ),
            //     Text(
            //       '\$${0.0}',
            //       style: TextStyle(color: Colors.grey, fontSize: 13),
            //     ),
            //   ],
            // ),
            SizedBox(height: 5),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: <Widget>[
            //     Text(
            //       '+Delivery Charge',
            //       style: TextStyle(color: Colors.grey, fontSize: 13),
            //     ),
            //     Text(
            //       '\$${_tax.deliveryCharge ?? "0"}',
            //       style: TextStyle(color: Colors.grey, fontSize: 13),
            //     ),
            //   ],
            // ),
            // SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context).translate('Payable amount'),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${_cartModel.getTotal().toStringAsFixed(2)}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ]),
        ),
      );

  Widget buildBasketItemRow(int index) {
    return GestureDetector(
      onTap: widget.isFromSettings ? null : () => {Navigator.pop(context)},
      child: Container(
        color: Colors.indigo[50],
        child: Padding(
          padding:
              const EdgeInsets.only(top: 12, bottom: 0, left: 16, right: 8),
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              color: Colors.green,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 5,
                                    spreadRadius: 3)
                              ],
                              borderRadius: BorderRadius.circular(5)),
                          child: Center(
                              child: Text(
                            '${_cartModel.cart[index].quantity}x',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                _cartModel.cart[index].itemName,
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(width: 10),
                              Text(
                                '\$ ${_cartModel.cart[index].itemPrice} ${_cartModel.cart[index].customization == null ? '' : 'Customized'}',
                                style:
                                    TextStyle(fontSize: 11, color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  widget.isFromSettings ? Container() : buildIncDecButton(index)
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Divider()
            ],
          ),
        ),
      ),
    );
  }

  IconButton buildIconButton() {
    return IconButton(
        icon: Container(
          child: Icon(
            Icons.mode_edit,
            size: 14,
          ),
          decoration:
              BoxDecoration(border: Border.all(color: Colors.grey, width: 2)),
        ),
        onPressed: null);
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text(
        AppLocalizations.of(context).translate('YOUR BASKET'),
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

  Future<void> callBasketApi() async {
    if (widget.isWithoutLogin) {
      setState(() {});
      return;
    }

    setState(() {
      _isLoading = true;
      _isAuthError = false;
    });
    dynamic token = await AppUtils.getToken();
    User user = await AppUtils.getUser();
    ApiResponse<BasketResponseModel> apiResponse = await K3Webservice.getMethod(
        apisToUrls(Apis.myBasket) + '?user_id=${user.id}',
        {"Authorization": "Bearer $token", "Content-Type": "application/json"});
    setState(() {
      _isLoading = false;
    });
    if (apiResponse.error) {
      showSnackBar(_scaffoldKey, apiResponse.message, null);
      if (apiResponse.message == sessionExpiredText) {
        setState(() {
          _isAuthError = true;
        });
      }
      return;
    } else {
      setState(() {
        _basketModel = apiResponse.data.data;
        if (apiResponse.data.data == null) {
          _noData = true;
          return;
        }

        _isRestAvailable = checkifResAvailable(apiResponse.data.data.toJson());
        final cart = json.decode(_basketModel.cart);
        print(cart);
        List<Cart> tempCartList = [];
        for (int i = 0; i < cart.length; i++) {
          tempCartList.add(cartModelfromJson(cart[i]));
        }
        _cartModel.id = _basketModel.id;
        _cartModel.cart = tempCartList;
        _cartModel.longitude = _basketModel.longitude;
        _cartModel.latitude = _basketModel.latitude;
        // _cartModel.drinkTax = 0.0;
        // _cartModel.foodTax = 0.0;
        // _cartModel.cityTax = double.parse(_basketModel.cityTax.toString());
        // _cartModel.stateTax = double.parse(_basketModel.stateTax.toString());
        _cartModel.resId = _basketModel.resId;
        // _cartModel.subtotal = _basketModel.total;
        // _cartModel.tax = _basketModel.tax ?? 0.0;
        // _cartModel.total = _basketModel.total;
        _cartModel.userId = _basketModel.userId;
        _cartModel.cod = _basketModel.cod;
        print(_cartModel.cart.first.itemName);
      });
    }
  }

  callGetTaxesApi() async {
    setState(() {
      _isLoading = true;
      _isAuthError = false;
    });

    ApiResponse<TaxesResponseModel> apiResponse =
        await K3Webservice.getMethod(apisToUrls(Apis.getTaxes), null);
    setState(() {
      _isLoading = false;
    });

    if (apiResponse.error) {
      showSnackBar(_scaffoldKey, apiResponse.message, null);
      if (apiResponse.message == sessionExpiredText) {
        setState(() {
          _isAuthError = true;
        });
      }
      return;
    } else {
      _tax = apiResponse.data.data;
      callBasketApi();
    }
  }

  cartModelfromJson(Map<String, dynamic> json) => Cart(
        itemId: json["itemId"] == null ? null : json["itemId"],
        itemName: json["itemName"] == null ? null : json["itemName"],
        itemPrice: json["itemPrice"] == null ? null : json["itemPrice"].toDouble(),
        cityTax: json["city_tax"] == null ? null : json["city_tax"].toDouble(),
        stateTax: json["state_tax"] == null ? null : json["state_tax"].toDouble(),
        customization: json["customization"] == null ? null : List<CartCustomization>.from(json["customization"].map((x) => CartCustomization.fromJson(x))),
        quantity: json["quantity"] == null ? null : json["quantity"],
        min_qty: json["min_qty"] == null ? null : json["min_qty"],
        is_stamp: json["is_stamp"] == null ? null : json["is_stamp"],
        taxtype: json["taxtype"] == null ? null : json["taxtype"],
        taxvalue: json["taxvalue"] == null ? null : json["taxvalue"].toDouble(),
        customQunatity: json["custom_qua"] == null ? null : json["custom_qua"],
        citytaxvalue: double.tryParse(_tax.cityTax) == null ? null : double.tryParse(_tax.cityTax),
        statetaxvalue: double.tryParse(_tax.stateTax) == null ? null : double.tryParse(_tax.stateTax),
      );

  Widget buildAuthWigdet(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(context,
            MaterialPageRoute(builder: (context) => LoginSignupScreen()));
        callBasketApi();
      },
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.error,
              color: AppColors().kPrimaryColor,
              size: 50,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              sessionExpiredText,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }

  Widget buildNoDataWigdet(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Navigator.pop(context);
      },
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.shopping_basket,
              color: AppColors().kPrimaryColor,
              size: 150,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "No item added to the basket.",
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }

  bool checkifResAvailable(Map<String, dynamic> value) {
    var days = ['mon', 'tue', 'wed ', 'thu', 'fri', 'sat', 'sun'];
    var d = DateTime.now();
    var day = days[d.weekday - 1];
    //get open and close time of day of restaurant

    if (value[day + 'open_time'] == null && value[day + 'close_time'] == null) {
      return false;
    }

    if (value[day + 'open_time'] != '' && value[day + 'close_time'] != '') {
      if (d.compareTo(DateTime(
                  d.year,
                  d.month,
                  d.day,
                  int.parse(value[day + 'open_time'].split(':')[0]),
                  int.parse(value[day + 'open_time'].split(':')[1]))) >
              0 &&
          d.compareTo(DateTime(
                  d.year,
                  d.month,
                  d.day,
                  int.parse(value[day + 'close_time'].split(':')[0]),
                  int.parse(value[day + 'close_time'].split(':')[1]))) <
              0) {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }

  convertDateFromString(String strDate) {
    DateTime todayDate = DateTime.parse(strDate);
    print(todayDate);
  }

  Opacity buildIncDecButton(int index) {
    return Opacity(
      opacity: 0.5,
      child: Container(
        decoration: BoxDecoration(
            color: AppColors().kPrimaryColor,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                  color: AppColors().kBlackColor54,
                  blurRadius: 5,
                  spreadRadius: 0.5)
            ]),
        child: Column(children: [
          IconButton(
            icon: Icon(Icons.remove),
            onPressed: () {
              _decreaseQunatity(index);
            },
          ),
          Text(_cartModel.cart[index].quantity.toString()),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _increaseQunatity(index);
            },
          )
        ]),
      ),
    );
  }

  _increaseQunatity(int index) {
    if (_cartModel.cart[index].customQunatity == 1) {
      if (_cartModel.cart[index].quantity == 0) {
        _cartModel.cart[index].quantity += 1;
      } else {
        _cartModel.cart[index].quantity += 0.25;
      }
    } else {
      _cartModel.cart[index].quantity += 1;
    }
    setState(() {
    });
    // _calculateAmount();
  }

  _decreaseQunatity(int index) {
    if (_cartModel.cart[index].quantity <= _cartModel.cart[index].min_qty) {
      _cartModel.cart.removeAt(index);
    } else {
      if (_cartModel.cart[index].customQunatity == 1) {
        if (_cartModel.cart[index].quantity == 1) {
          _cartModel.cart[index].quantity -= 1;
        } else {
          _cartModel.cart[index].quantity -= 0.25;
        }
      } else {
        _cartModel.cart[index].quantity -= 1;
      }
    }
    setState(() {
    });
    // _calculateAmount();
  }

  _calculateAmount() {
    // final jsonCartModel = _cartModel.toJson();
    // CartModel tempCartModel = CartModel.fromJson(jsonCartModel);
    // double foodTax = 0.0;
    // double drinkTax = 0.0;
    // double cityTax = 0.0;
    // double stateTax = 0.0;
    // double total = 0.0;
    // double tax = 0.0;
    // double subTotal = 0.0;
    //
    // for (int i = 0; i < tempCartModel.cart.length; i++) {
    //   double itemPrice = 0.0;
    //   double singleObjectPrice = 0.0;
    //   itemPrice +=
    //       (tempCartModel.cart[i].itemPrice * tempCartModel.cart[i].quantity);
    //   singleObjectPrice += tempCartModel.cart[i].itemPrice;
    //
    //   if (tempCartModel.cart[i].customization != null) {
    //     for (int j = 0; j < tempCartModel.cart[i].customization.length; j++) {
    //       itemPrice += (tempCartModel.cart[i].customization[j].optionPrice * tempCartModel.cart[i].quantity);
    //       singleObjectPrice += tempCartModel.cart[i].customization[j].optionPrice;
    //     }
    //   }
    //
    //   tempCartModel.cart[i].itemPrice = singleObjectPrice;
    //
    //   if (tempCartModel.cart[i].cityTax > 0) {
    //     tempCartModel.cart[i].cityTax = double.parse(((singleObjectPrice * tempCartModel.cart[i].citytaxvalue) / 100).toStringAsFixed(2));
    //     double itemPriceWithQuantity = (tempCartModel.cart[i].itemPrice * tempCartModel.cart[i].quantity);
    //     cityTax += double.parse(((itemPriceWithQuantity * tempCartModel.cart[i].citytaxvalue) / 100).toStringAsFixed(2));
    //     itemPrice += double.parse(((itemPriceWithQuantity * tempCartModel.cart[i].citytaxvalue) / 100).toStringAsFixed(2));
    //   } else {
    //     tempCartModel.cart[i].cityTax = 0.0;
    //   }
    //
    //   if (tempCartModel.cart[i].stateTax > 0) {
    //     tempCartModel.cart[i].stateTax = double.parse(((singleObjectPrice * tempCartModel.cart[i].statetaxvalue) / 100).toStringAsFixed(2));
    //     double itemPriceWithQuantity = (tempCartModel.cart[i].itemPrice * tempCartModel.cart[i].quantity);
    //     stateTax += double.parse(((itemPriceWithQuantity * tempCartModel.cart[i].statetaxvalue) / 100).toStringAsFixed(2));
    //     itemPrice += double.parse(((itemPriceWithQuantity * tempCartModel.cart[i].statetaxvalue) / 100).toStringAsFixed(2));
    //   } else {
    //     tempCartModel.cart[i].stateTax = 0.0;
    //   }
    //   subTotal += itemPrice;
    // }
    // // tax = double.parse(((subTotal * tempCartModel.getTax()) / 100).toStringAsFixed(2));
    // // tempCartModel.tax = tax;
    //
    // //total = subTotal + tax;
    // total = subTotal;

    // tempCartModel.foodTax = double.parse(foodTax.toStringAsFixed(2));
    // tempCartModel.drinkTax = double.parse(drinkTax.toStringAsFixed(2));
    // tempCartModel.cityTax = double.parse(cityTax.toStringAsFixed(2));
    // tempCartModel.stateTax = double.parse(stateTax.toStringAsFixed(2));
    // tempCartModel.subtotal = double.parse(subTotal.toStringAsFixed(2));
    // tempCartModel.total = double.parse(total.toStringAsFixed(2));

    // print("food tax => " + tempCartModel.getFoodTax().toString());
    // print("drink tax => " + tempCartModel.getDrinkTax().toString());
    // print("food tax => " + tempCartModel.getCityTax().toString());
    // print("drink tax => " + tempCartModel.getStateTax().toString());
    // print("subTotal => " + tempCartModel.getSubtotal().toString());
    // print("tax => " + tempCartModel.getTax().toString());
    // print("total => " + tempCartModel.getTotal().toString());
    //
    // setState(() {
    //   _cartModel = tempCartModel;
    // });
  }
}
