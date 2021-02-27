import 'dart:math' as Math;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zabor/constants/apis.dart';
import 'package:zabor/constants/app_utils.dart';
import 'package:zabor/constants/constants.dart';
import 'package:zabor/screens/add_address_module/add_address_screen.dart';
import 'package:zabor/screens/basket_screen_module/taxes_response_model.dart';
import 'package:zabor/screens/delivery_address_list_module/delivery_address_list_screen.dart';
import 'package:zabor/screens/delivery_address_list_module/delivery_list_response_model.dart';
import 'package:zabor/screens/food_list_module/cart_model.dart';
import 'package:zabor/screens/login_signup/model/model.dart';
import 'package:zabor/screens/offers_screen/offers_response_model.dart';
import 'package:zabor/screens/share_feedback/share_feedback_screen.dart';
import 'package:zabor/utils/k3webservice.dart';
import 'package:zabor/utils/utils.dart';
import 'package:geolocator/geolocator.dart';
import 'package:zabor/utils/location_services.dart';

class OrderSummaryScreen extends StatefulWidget {
  final CartModel cartModel;
  final Tax tax;
  final int paymentMode; // 0 = ATH  1 = Stripe; 2 = Cash on delivery
  final int deliveryMode;
  final bool isWithoutLogin;

  const OrderSummaryScreen(
      {Key key,
      @required this.cartModel,
      @required this.tax,
      @required this.paymentMode,
      @required this.deliveryMode,
      this.isWithoutLogin = false})
      : super(key: key);
  @override
  _OrderSummaryScreenState createState() => _OrderSummaryScreenState();
}

class _OrderSummaryScreenState extends State<OrderSummaryScreen> {
  CartModel get _cartModel => widget.cartModel;
  Tax get _tax => widget.tax;
  bool _isLoading = false;
  bool _isAuthError = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Offer> _arrOffers = [];
  int _appliedIndex = -1;
  String _amount = '0.0';
  double _discount = 0.0;
  double _delivery_fee = 0.0;
  int selectOffer = -1;

  @override
  void initState() {
    super.initState();

    getAmount();
    callOffersApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: buildAppBar(),
      body: Center(child: buildPriceColumn()),
    );
  }

  Widget buildPriceColumn() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Column(children: [
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Total',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${(_cartModel.getTotal() - _cartModel.getCityTax() - _cartModel.getStateTax()).toStringAsFixed(2)}',
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
            //       '\$${_cartModel.tax.toStringAsFixed(2)}',
            //       style: TextStyle(color: Colors.grey, fontSize: 13),
            //     ),
            //   ],
            // ),
            SizedBox(height: 5),
            widget.deliveryMode == 1
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        '+ Delivery Charge',
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                      Text(
                        '\$${_delivery_fee.toStringAsFixed(2) ?? "0"}',
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  )
                :
                widget.deliveryMode == 2
                  ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      '+ Pickup Charge',
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    Text(
                      '\$${double.parse(_delivery_fee.toString()).toStringAsFixed(2) ?? "0"}',
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                )
                :
                Container(),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '- Discount',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                Text(
                  '\$${_discount.toStringAsFixed(2)}',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Payable amount',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${double.parse(_amount).toStringAsFixed(2) ?? "0"}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 30),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : Column(
                    children: getOffers(),
                  ),
            SizedBox(height: 30),
            ButtonWidget(
              title: 'CONTINUE',
              onPressed: () {
                if (widget.isWithoutLogin) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddAddressScreen(
                                deliveryCurdMode: DeliveryCurdMode.add,
                                isWithoutLogin: widget.isWithoutLogin,
                                tax: widget.tax,
                                cartModel: widget.cartModel,
                                paymentMode: widget.paymentMode,
                                deliveryMode: widget.deliveryMode,
                              )));
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DeliveryAddressListScreen(
                                tax: widget.tax,
                                cartModel: widget.cartModel,
                                paymentMode: widget.paymentMode,
                                deliveryMode: widget.deliveryMode,
                                selectOffer: selectOffer,
                                amount: _amount,
                              )));
                }
              },
            )
          ]),
        ),
      );

  AppBar buildAppBar() {
    return AppBar(
      title: Text(
        'ORDER SUMMARY',
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

  List<Widget> getOffers() {
    List<Widget> widgets = [];
    for (int i = 0; i < _arrOffers.length; i++) {
      widgets.add(buildOfferDetailRow(i));
    }
    return widgets;
  }

  Widget buildOfferDetailRow(int index) {
    return Column(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FaIcon(
                FontAwesomeIcons.tags,
                size: 40,
                color: AppColors().kPrimaryColor,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${_arrOffers[index].userType == "all_users" ? 'All User Offer: ' : 'First User Offer: '} Get flat ${_arrOffers[index].percentage ?? 0}% OFF on Order of \$${_arrOffers[index].moa ?? 0} and Above (Max Discount: \$${_arrOffers[index].mpd ?? 0})',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            RaisedButton(
                color: AppColors().kPrimaryColor,
                onPressed: () {
                  if (index == _appliedIndex) return;
                  calculateAmount(index);
                },
                child: Text(index == _appliedIndex ? 'Applied' : 'Apply',
                    style: TextStyle(color: AppColors().kWhiteColor))),
          ],
        )
      ],
    );
  }

  getAmount() async {
    Position position = null;
    if (position == null) {
      try {
        position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

        final lat = position.latitude;
        final lng = position.longitude;

        if (widget.deliveryMode == 1) {

          double distance = 3956 * 2 * Math.asin(Math.sqrt(Math.pow(Math.sin((lat - (_cartModel.latitude)) * Math.pi / 180 / 2), 2) + Math.cos(lat * Math.pi / 180 ) * Math.cos(_cartModel.latitude.abs() * Math.pi / 180) * Math.pow(Math.sin((lng - _cartModel.longitude) * Math.pi / 180 / 2), 2)));
          if (distance > 1) {
            _delivery_fee = double.parse(_tax.deliveryCharge ?? "0") + double.parse(_tax.driver_fee) * distance + this._delivery_fee;
            _amount = (_cartModel.getTotal() + _delivery_fee).toStringAsFixed(2);
          } else {
            _amount = (_cartModel.getTotal() + double.parse(_tax.deliveryCharge ?? "0")).toStringAsFixed(2);
          }
        } else if(widget.deliveryMode == 2) {
          _delivery_fee = double.parse(_tax.pickup_fee ?? "0");
          _amount = (_cartModel.getTotal() + _delivery_fee).toStringAsFixed(2);
        }
        setState(() {

        });
      } catch (error) {
        if (error.code == "PERMISSION_DENIED") {
          return;
        }
      }
    }

  }

  callOffersApi() async {
    setState(() {
      _isLoading = true;
    });
    dynamic token = await AppUtils.getToken();
    User user = await AppUtils.getUser();

    if (user == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    ApiResponse<OffersResponseModel> apiResponse = await K3Webservice.getMethod(
        apisToUrls(Apis.getDiscountWithUser) + '?user_id=${user.id}&res_id=${_cartModel.resId}',
        {"Authorization": "Bearer $token", "Content-Type": "application/json"});
    setState(() {
      _isLoading = false;
    });
    if (apiResponse.error) {
      //showSnackBar(_scaffoldKey, apiResponse.message, null);
      return;
    } else {
      setState(() {
        _arrOffers = apiResponse.data.data;
      });
    }
  }

  calculateAmount(int index) {
     String amountWithoutTaxDelivery = (_cartModel.getSubtotal()).toStringAsFixed(2);
    if (double.parse(amountWithoutTaxDelivery) <
        double.parse(_arrOffers[index].moa.toString())) {
      showSnackBar(_scaffoldKey,
          'Minimum order should be of \$${_arrOffers[index].moa}', null);
      return;
    }

    double discount = (double.parse(amountWithoutTaxDelivery) *
            double.parse(_arrOffers[index].percentage.toString())) /
        100;
    print('Discount: ' + discount.toString());
    print("calculateAmount");
    if (discount > double.parse(_arrOffers[index].mpd.toString())) {
      discount = double.parse(_arrOffers[index].mpd.toString());
    }
    setState(() {
      _appliedIndex = index;
      _discount = discount;
      _amount = (double.parse(_amount) - discount).toString();
      selectOffer = _arrOffers[index].id;
    });
  }
}
