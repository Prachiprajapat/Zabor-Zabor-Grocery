import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zabor/constants/apis.dart';
import 'package:zabor/constants/app_utils.dart';
import 'package:zabor/constants/constants.dart';
import 'package:zabor/screens/add_address_module/add_address_screen.dart';
import 'package:zabor/screens/basket_screen_module/taxes_response_model.dart';
import 'package:zabor/screens/delivery_address_list_module/delivery_list_response_model.dart';
import 'package:zabor/screens/enter_card_detail_module/enter_card_detail_screen.dart';
import 'package:zabor/screens/food_list_module/cart_model.dart';
import 'package:zabor/screens/login_signup/login_signup.dart';
import 'package:zabor/screens/login_signup/model/model.dart';
import 'package:zabor/screens/reserve_seat_module/reserve_seat_screen.dart';
import 'package:zabor/screens/select_payment_gateway_screen/select_payment_gateway_screen.dart';
import 'package:zabor/screens/order_now_module/terms_agreement_screen.dart';
import 'package:zabor/screens/share_feedback/share_feedback_screen.dart';
import 'package:zabor/utils/k3webservice.dart';
import 'package:zabor/utils/utils.dart';

class DeliveryAddressListScreen extends StatefulWidget {
  final CartModel cartModel;
  final Tax tax;
  final int paymentMode; // 1 = Online; 2 = Cash on delivery
  final int deliveryMode; // 1 = home delivery; 2 = pick up
  final bool isWithoutLogin;
  final String amount;
  final int selectOffer;
  const DeliveryAddressListScreen(
      {Key key,
      @required this.cartModel,
      @required this.paymentMode,
      @required this.deliveryMode,
      @required this.tax,
      this.isWithoutLogin = false,
      this.amount,
      this.selectOffer})
      : super(key: key);
  @override
  _DeliveryAddressListScreenState createState() =>
      _DeliveryAddressListScreenState();
}

class _DeliveryAddressListScreenState extends State<DeliveryAddressListScreen> {
  int _selectedIndex = 0;
  bool _isLoading = false;
  bool _isAuthError = false;
  DeliveryAddressListResponseModel _deliveryAddressListResponseModel;
  List<Address> _address = [];
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List _loadingStateOnDelete = [false, -1];
  bool _loadingPlaceOrderState = false;
  CartModel _cartModel;
  String _orderConfirmedMessage = "Your order has been Confirmed";
  bool _orderPlaced = false;

  static const String _channel = 'com.flutter.payment/payment';
  static const platform = const MethodChannel(_channel);

  @override
  void initState() {
    super.initState();
    _cartModel = widget.cartModel;
    callDeliveryListApi();
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
              : _orderPlaced
                  ? buildOrderConfirmedWigdet(context)
                  : _address.length == 0
                      ? Center(child: Text('No address, please add.'))
                      : buildBody(),
    );
  }

  ListView buildBody() {
    return ListView.builder(
      itemCount: _address.length + 1,
      itemBuilder: (context, index) => index == _address.length
          ? Padding(
              padding: const EdgeInsets.only(top: 50),
              child: _loadingPlaceOrderState
                  ? Center(child: CircularProgressIndicator())
                  : ButtonWidget(
                      title: 'CONTINUE',
                      onPressed: () {
                        callPlaceOrderApi();
                      },
                    ),
            )
          : buildDeliveryAddressCell(index),
    );
  }

  Widget buildDeliveryAddressCell(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(
                    '${_address[index].firstname ?? ""}',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                ),
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddAddressScreen(
                                      deliveryCurdMode: DeliveryCurdMode.edit,
                                      address: _address[index],
                                    )));
                        callDeliveryListApi();
                      },
                    ),
                    (_loadingStateOnDelete[0] == true &&
                            _loadingStateOnDelete[0] == index)
                        ? Container(
                            height: 15,
                            width: 15,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(
                                strokeWidth: 1,
                              ),
                            ))
                        : IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              callDeleteAddressApi(index);
                            })

                    // })
                  ],
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(child: Text('${_address[index].address ?? ""}')),
                      _selectedIndex == index
                          ? Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 30,
                            )
                          : SizedBox(height: 30)
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: _selectedIndex == index
                            ? Colors.green
                            : Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                    color: _selectedIndex == index
                        ? Colors.green[50]
                        : Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text(
        _orderPlaced ? 'ORDER PLACED' : 'SHIPPING DETAILS',
      ),
      actions: <Widget>[
        _orderPlaced
            ? Container()
            : IconButton(
                icon: Icon(Icons.add),
                onPressed: () async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddAddressScreen(
                                deliveryCurdMode: DeliveryCurdMode.add,
                              )));
                  callDeliveryListApi();
                })
      ],
      leading: _orderPlaced
          ? Container()
          : IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              }),
      backgroundColor: AppColors().kWhiteColor,
      iconTheme: IconThemeData(color: AppColors().kBlackColor),
      textTheme: TextTheme(
          title: TextStyle(
              color: AppColors().kBlackColor,
              fontSize: 20,
              fontWeight: FontWeight.w600)),
    );
  }

  Widget buildAuthWigdet(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => LoginSignupScreen()));
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

  Widget buildOrderConfirmedWigdet(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.popUntil(
            context, ModalRoute.withName(Navigator.defaultRouteName));
      },
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.check_circle,
              color: AppColors().kPrimaryColor,
              size: 150,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              _orderConfirmedMessage,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            )
          ],
        ),
      ),
    );
  }

  callDeliveryListApi() async {
    setState(() {
      _isLoading = true;
    });

    dynamic token = await AppUtils.getToken();
    User user = await AppUtils.getUser();
    ApiResponse<DeliveryAddressListResponseModel> apiResponse =
        await K3Webservice.getMethod(
            apisToUrls(Apis.getAddress) + '?user_id=${user.id}', {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json"
    });
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
        _deliveryAddressListResponseModel = apiResponse.data;
        _address = _deliveryAddressListResponseModel.address;
      });
    }
  }

  callDeleteAddressApi(int index) async {
    setState(() {
      _loadingStateOnDelete = [true, index];
    });

    dynamic token = await AppUtils.getToken();
    User user = await AppUtils.getUser();
    ApiResponse<CommonResponseModel> apiResponse =
        await K3Webservice.postMethod(apisToUrls(Apis.deleteAddress),
            json.encode({"id": _address[index].id, "user_id": user.id}), {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json"
    });
    setState(() {
      _loadingStateOnDelete = [false, -1];
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
      callDeliveryListApi();
    }
  }

  callPlaceOrderApi() async {
    String stripeToken;
    Map<String, dynamic> authorizeDict = {};
    //var paymentMode = 2; // When athorize was there
    var paymentMode = widget.paymentMode;
    // if (widget.paymentMode == 1)
    //   paymentMode = await Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //           builder: (context) => SelectPaymentGatewayScreen(),
    //           fullscreenDialog: true));

    // if (stripeToken == null) {
    //   return;
    // }

    double total = _cartModel.getTotal() +
        double.parse(widget.deliveryMode == 2
            ? "0"
            : (widget.tax.deliveryCharge ?? "0"));

    if (paymentMode == 0) {
      // if (Platform.isAndroid) {
      //   try {
      //     await platform.invokeMethod('startATHPaymentActivity', {"totalPrice": total});
      //   } on PlatformException catch (e) {
      //     print(e.message);
      //   }
      // } else {
      //
      // }
    }
    if (paymentMode == 1) {
      stripeToken = await Navigator.push(context,
          MaterialPageRoute(builder: (context) => EnterCardDetailScreen(paymentMode: paymentMode,)));
      if (stripeToken == null) {
        return;
      }
    } else if (paymentMode == 3) {
      authorizeDict = await Navigator.push(context,
          MaterialPageRoute(builder: (context) => EnterCardDetailScreen(paymentMode: paymentMode)));
      if (authorizeDict == null) {
        return;
      }
    }

    Map<String, dynamic> isAcceptTermsAgree = await Navigator.push(context, MaterialPageRoute(builder: (context) => TermsAgreementScreen()));
    if (isAcceptTermsAgree == null || !isAcceptTermsAgree['isAggree']) {
      return;
    }

    if (_address.length == 0) return;
    setState(() {
      _loadingPlaceOrderState = true;
    });

    for (int i = 0; i < _cartModel.cart.length; i++) {
      if (_cartModel.cart[i].customization == null) {
        _cartModel.cart[i].customization = [];
      }
    }

    Map<String, dynamic> timeslotdata = await Navigator.push(context,
        MaterialPageRoute(
            builder: (context) => ReserveSeatScreen(
              resId: _cartModel.resId,
            )));

    int selectedId = timeslotdata == null ? -1 : timeslotdata['selectedId'];

  // if (selectedId == -1) {
  //   showSnackBar(_scaffoldKey, 'Please select time slot', null);
  //   return;
  // }
    String contactMode = "call";
    ConfirmAction confirmAction = await showAlertWithTwoButton(context, 'Please select the contact mode', 'Call', 'Text');

    if (confirmAction == ConfirmAction.ACCEPT) {
      contactMode = "text";
    }

    dynamic token = await AppUtils.getToken();
    User user = await AppUtils.getUser();


    ApiResponse<CommonResponseModel> apiResponse =
        await K3Webservice.postMethod(
            apisToUrls(Apis.placeOrder),
            json.encode({
              "address": _address[_selectedIndex].toJson(),
              "total": total.toStringAsFixed(2),
              "cart": _cartModel.toJson()["cart"],
              "cart_id": _cartModel.id,
              "res_id": _cartModel.resId,
              "payment_mode": paymentMode,
              "delivery_mode": widget.deliveryMode,
              "selectOffer": widget.selectOffer,
              "token": stripeToken,
              'Anet_credit_card':authorizeDict,
              "selectedtimeslot": selectedId,
              "extra": {
                "food_tax": _cartModel.getFoodTax(),
                "drink_tax": _cartModel.getDrinkTax(),
                "city_tax": _cartModel.getCityTax(),
                "state_tax": _cartModel.getStateTax(),
                "subtotal": _cartModel.getSubtotal(),
                "tax": _cartModel.getTax(),
                "contact_mode":contactMode,
                "delivery_charge": widget.deliveryMode == 2
                    ? "0"
                    : (widget.tax.deliveryCharge ?? "0")
              },
              "user_id": user.id,
              "stamp_paid": _cartModel.stamp_paid
            }),
            {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        });
    setState(() {
      _loadingPlaceOrderState = false;
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
      _orderConfirmedMessage = apiResponse.data.msg;
      callClearCartApi();
    }
  }

  callClearCartApi() async {
    setState(() {
      _loadingPlaceOrderState = true;
      setState(() {
        _orderPlaced = true;
      });
    });

    dynamic token = await AppUtils.getToken();
    User user = await AppUtils.getUser();
    ApiResponse<CommonResponseModel> apiResponse = await K3Webservice.getMethod(
        apisToUrls(Apis.clearCart) + '?user_id=${user.id}',
        {"Authorization": "Bearer $token", "Content-Type": "application/json"});
    setState(() {
      _loadingPlaceOrderState = false;
    });

    if (apiResponse.error) {
      showSnackBar(_scaffoldKey, apiResponse.message, null);
      if (apiResponse.message == sessionExpiredText) {
        setState(() {
          _isAuthError = true;
        });
      }
      return;
    } else {}
  }
}
//address, total, cart, cart_id, user_id, res_id, extra

// food_tax: Number(foodTax.toFixed(2)),
//       drink_tax: Number(drinkTax.toFixed(2)),
//       subtotal: Number(subtotal.toFixed(2)),
//       tax: Number(((subtotal * this.grand_tax) / 100).toFixed(2))
