import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:zabor/app_localizations/app_localizations.dart';
import 'package:zabor/constants/apis.dart';
import 'package:zabor/constants/app_utils.dart';
import 'package:zabor/constants/constants.dart';
import 'package:zabor/screens/food_list_module/cart_model.dart';
import 'package:zabor/screens/login_signup/login_signup.dart';
import 'package:zabor/screens/login_signup/model/model.dart';
import 'package:zabor/screens/timeline_screen/timeline_screen.dart';
import 'package:zabor/utils/k3webservice.dart';
import 'package:zabor/utils/utils.dart';

import 'order_history_response_model.dart';

class OrderHistoryScreen extends StatefulWidget {
  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  ScrollController _scrollController = new ScrollController();
  bool _isLoading = false;
  bool _isAuthError = false;
  OrderHistoryResponseModel _orderHistoryResponseModel;
  List<ModDatum> _modData = [];
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int _page = 1;
  bool _isCall = true;

  @override
  void initState() {
    super.initState();
    callOrderHistoryApi();
    _scrollController.addListener(() async {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _page = _page + 1;
        print(_page);
        if (_isCall) {
          callOrderHistoryApi();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: buildAppBar(),
      body: _isAuthError ? buildAuthWigdet(context) : buildBody(),
    );
  }

  Padding buildBody() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        children: <Widget>[
          _isLoading
              ? LinearProgressIndicator(
                  backgroundColor: AppColors().kGreyColor200,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors().kPrimaryColor,
                  ))
              : Container(),
          Expanded(
            child: ListView.builder(
                controller: _scrollController,
                itemCount: _modData.length,
                itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(
                          top: 8, bottom: 15, left: 8, right: 8),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5,
                                spreadRadius: 2)
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          _modData[index].resName ?? "",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        Text(
                                            DateFormat("dd-MMM-yyyy")
                                                    .format(_modData[index]
                                                        .createdDate)
                                                    .toString() ??
                                                "",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey)),
                                        Text(
                                          '#' + _modData[index].id.toString() ??
                                              "",
                                          style: TextStyle(
                                              fontSize: 14, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                  RaisedButton(
                                    onPressed: () async {
                                      // User user = await AppUtils.getUser();
                                      // if (user == null) return;
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) => Example6(
                                      //             orderId:
                                      //                 _modData[index].id)));
                                    },
                                    child: Text(
                                      '${_modData[index].status}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              ),
                              Divider(),
                              Column(
                                children: getInternalItems(index),
                              ),
                              // SizedBox(
                              //   height: 5,
                              // ),
                              // (_modData[index].status.toLowerCase() == "delivered" || _modData[index].status.toLowerCase() == "cancelled")
                              //     ? Container()
                              //     : Row(
                              //         children: <Widget>[
                              //           Expanded(
                              //               child: Text(
                              //                   'Order Verification Code: ${_modData[index].orderCode ?? ''}')),
                              //         ],
                              //       ),
                              SizedBox(
                                height: 5,
                              ),
                              buildPriceColumn(index),
                              Divider(),
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors().kPrimaryColor,
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 5,
                                        spreadRadius: 2)
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        AppLocalizations.of(context)
                                            .translate('Payable amount'),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: AppColors().kWhiteColor),
                                      ),
                                      Text(
                                        '\$${_modData[index].total}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: AppColors().kWhiteColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              buildCancelRaisedButton(index)
                            ],
                          ),
                        ),
                      ),
                    )),
          ),
        ],
      ),
    );
  }

  List<Widget> getInternalItems(int index) {
    List<Widget> tempWidget = [];
    for (int i = 0; i < _modData[index].cart.length; i++) {
      tempWidget.add(buildItemCell(index, i));
    }
    return tempWidget;
  }

  Widget buildItemCell(int outerIndex, int innerIndex) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                        '${_modData[outerIndex].cart[innerIndex].quantity ?? ""}x',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      )),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '${_modData[outerIndex].cart[innerIndex].itemName ?? ""}',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(width: 10),
                          Text(
                            '\$ ${_modData[outerIndex].cart[innerIndex].itemPrice.toStringAsFixed(2) ?? ""}',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          Text(getCustomizationsList(outerIndex, innerIndex),
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          Divider()
        ],
      ),
    );
  }

  String getCustomizationsList(int outerIndex, int innerIndex) {
    String string = "";
    for (int i = 0;
        i < _modData[outerIndex].cart[innerIndex].customization.length;
        i++) {
      CartCustomization cartCustomization =
          _modData[outerIndex].cart[innerIndex].customization[i];
      string += "+ ${cartCustomization.optionName}\n";
    }
    return string;
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text(
        AppLocalizations.of(context).translate('Order History').toUpperCase(),
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

  Widget buildPriceColumn(int index) => Padding(
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
                  '\$${(_modData[index].total - _modData[index].stateTax - _modData[index].cityTax).toStringAsFixed(2)}',
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
                  '\$${_modData[index].cityTax.toStringAsFixed(2)}',
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
                  '\$${_modData[index].stateTax.toStringAsFixed(2)}',
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
            //       '\$${_modData[index].tax.toStringAsFixed(2)}',
            //       style: TextStyle(color: Colors.grey, fontSize: 13),
            //     ),
            //   ],
            // ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '+Delivery Charge',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                Text(
                  '\$${_modData[index].deliveryCharge.toStringAsFixed(2) ?? 0}',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ]),
        ),
      );

  Future<void> callOrderHistoryApi() async {
    setState(() {
      _isLoading = true;
    });
    dynamic token = await AppUtils.getToken();
    User user = await AppUtils.getUser();

    if (user == null) {
      setState(() {
        _isLoading = false;
      });
      callOrderDetailApi();
      return;
    }
    ApiResponse<OrderHistoryResponseModel> apiResponse =
        await K3Webservice.getMethod(
            apisToUrls(Apis.orderHistory) + '?user_id=${user.id}&page=$_page', {
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
        _orderHistoryResponseModel = apiResponse.data;
        if (apiResponse.data.data == null) {
          _isCall = false;
          return;
        }
        if (_orderHistoryResponseModel.data.length == 0 ||
            (_orderHistoryResponseModel.data.length) < 10) {
          _isCall = false;
        }
        for (int i = 0; i < _orderHistoryResponseModel.data.length; i++) {
          Datum tempActualData = _orderHistoryResponseModel.data[i];
          final cart = json.decode(tempActualData.cart);
          List<Cart> tempCartList = [];
          for (int j = 0; j < cart.length; j++) {
            tempCartList.add(cartModelfromJson(cart[j]));
          }
          ModDatum tempModData = ModDatum(
              id: tempActualData.id,
              userId: tempActualData.userId,
              resId: tempActualData.resId,
              cartId: tempActualData.cartId,
              cart: tempCartList,
              foodTax: tempActualData.foodTax,
              drinkTax: tempActualData.drinkTax,
              subtotal: tempActualData.subtotal,
              tax: tempActualData.tax,
              total: tempActualData.total,
              status: tempActualData.status,
              orderBy: tempActualData.orderBy,
              createdDate: tempActualData.createdDate,
              resName: tempActualData.resName,
              deliveryMode: tempActualData.deliveryMode,
              orderCode: tempActualData.orderCode,
              deliveryCharge: tempActualData.deliveryCharge,
               cityTax: tempActualData.cityTax,
            stateTax: tempActualData.stateTax,
            cancelCharge: tempActualData.cancelCharge
              );
          _modData.add(tempModData);
        }
      });
    }
  }

  Future<void> callCancelOrderApi(dynamic orderId) async {
    setState(() {
      _isLoading = true;
    });

    User user = await AppUtils.getUser();
    dynamic token = await AppUtils.getToken();
    ApiResponse<CommonResponseModel> apiResponse =
        await K3Webservice.postMethod(
            apisToUrls(Apis.cancelOrder), jsonEncode({'order_id': orderId}), {
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
      _modData = [];
      if (user == null) {
        callOrderDetailApi();
      } else {
        callOrderHistoryApi();
      }
    }
  }

  Future<void> callOrderDetailApi() async {
    setState(() {
      _isLoading = true;
    });
    dynamic orderId = await AppUtils.getLastOrderId();

    if (orderId == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    ApiResponse<OrderDetailResponseModel> apiResponse =
        await K3Webservice.postMethod(
            apisToUrls(Apis.getOrderDetails),
            json.encode({"order_id": int.parse(orderId)}),
            {"Content-Type": "application/json"});
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
        if (apiResponse.data.data == null) {
          _isCall = false;
          return;
        }

        Datum tempActualData = apiResponse.data.data;
        final cart = json.decode(tempActualData.cart);
        List<Cart> tempCartList = [];
        for (int j = 0; j < cart.length; j++) {
          tempCartList.add(cartModelfromJson(cart[j]));
        }
        ModDatum tempModData = ModDatum(
            id: tempActualData.id,
            userId: tempActualData.userId,
            resId: tempActualData.resId,
            cartId: tempActualData.cartId,
            cart: tempCartList,
            foodTax: tempActualData.foodTax,
            drinkTax: tempActualData.drinkTax,
            subtotal: tempActualData.subtotal,
            tax: tempActualData.tax,
            total: tempActualData.total,
            status: tempActualData.status,
            orderBy: tempActualData.orderBy,
            createdDate: tempActualData.createdDate,
            resName: tempActualData.resName,
            deliveryMode: tempActualData.deliveryMode,
            orderCode: tempActualData.orderCode,
            deliveryCharge: tempActualData.deliveryCharge,
            cityTax: tempActualData.cityTax,
            stateTax: tempActualData.stateTax,
            cancelCharge: tempActualData.cancelCharge,
            );
        _modData.add(tempModData);
      });
    }
  }

  Widget buildCancelRaisedButton(int index) =>
      (_modData[index].status == "received" ||
              _modData[index].status == "recieved")
          ? RaisedButton(
              onPressed: () async {
                double cancelCharge = 0.0;
                cancelCharge = (_modData[index].total - _modData[index].stateTax - _modData[index].cityTax) * (_modData[index].cancelCharge == null ? 5.0 : (double.tryParse(_modData[index].cancelCharge.toString())) ?? 5) / 100;
                ConfirmAction confirmAction = await showAlertWithTwoButton(
                    context,
                    'Cancellation charge will be \$${cancelCharge.toStringAsFixed(2)} on the order. Are you sure you want to cancel the order?',
                    'No',
                    'Yes');

                if (confirmAction == ConfirmAction.ACCEPT) {
                  callCancelOrderApi(_modData[index].id);
                }
              },
              child: Text('Cancel Order',
                  style: TextStyle(color: AppColors().kWhiteColor)),
              color: Colors.red,
            )
          : Container();

  Widget buildAuthWigdet(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(context,
            MaterialPageRoute(builder: (context) => LoginSignupScreen()));
        setState(() {
          _isAuthError = false;
        });
        callOrderHistoryApi();
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

  cartModelfromJson(Map<String, dynamic> json) => Cart(
        itemId: json["itemId"] == null ? null : json["itemId"],
        itemName: json["itemName"] == null ? null : json["itemName"],
        itemPrice:
            json["itemPrice"] == null ? null : json["itemPrice"],
        customization: json["customization"] == null
            ? null
            : List<CartCustomization>.from(json["customization"]
                .map((x) => CartCustomization.fromJson(x))),
        quantity: json["quantity"] == null ? null : json["quantity"],
        taxtype: json["taxtype"] == null ? null : json["taxtype"],
        taxvalue: json["taxvalue"] == null ? null : json["taxvalue"],
        cityTax: json["city_tax"] == null ? null : json["city_tax"],
        stateTax: json["state_tax"] == null ? null : json["state_tax"],
      );
}
