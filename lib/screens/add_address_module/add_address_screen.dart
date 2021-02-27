import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:zabor/constants/apis.dart';
import 'package:zabor/constants/app_utils.dart';
import 'package:zabor/constants/constants.dart';
import 'package:zabor/screens/add_address_module/order_success_respons_model.dart';
import 'package:zabor/screens/basket_screen_module/taxes_response_model.dart';
import 'package:zabor/screens/delivery_address_list_module/delivery_list_response_model.dart';
import 'package:zabor/screens/enter_card_detail_module/enter_card_detail_screen.dart';
import 'package:zabor/screens/food_list_module/cart_model.dart';
import 'package:zabor/screens/login_signup/login_signup.dart';
import 'package:zabor/screens/login_signup/model/model.dart';
import 'package:zabor/screens/place_picker_screen/place_picker_screen.dart';
import 'package:zabor/screens/reserve_seat_module/reserve_seat_screen.dart';
import 'package:zabor/screens/select_payment_gateway_screen/select_payment_gateway_screen.dart';
import 'package:zabor/screens/share_feedback/share_feedback_screen.dart';
import 'package:zabor/utils/k3webservice.dart';
import 'package:zabor/utils/location_services.dart';
import 'package:zabor/utils/utils.dart';

GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
final homeScaffoldKey = GlobalKey<ScaffoldState>();
final searchScaffoldKey = GlobalKey<ScaffoldState>();

class AddAddressScreen extends StatefulWidget {
  final DeliveryCurdMode deliveryCurdMode;
  final Address address;
  final CartModel cartModel;
  final Tax tax;
  final int paymentMode; // 1 = Online; 2 = Cash on delivery
  final int deliveryMode; // 1 = home delivery; 2 = pick up
  final bool isWithoutLogin;
  const AddAddressScreen(
      {Key key,
      @required this.deliveryCurdMode,
      this.address,
      this.isWithoutLogin = false,
      this.cartModel,
      this.tax,
      this.paymentMode,
      this.deliveryMode})
      : super(key: key);
  @override
  _AddAddressScreenState createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  bool _isLoading = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isAuthError = false;
  Address _address;
  TextEditingController addressController = TextEditingController();
  String lati;
  String long;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _countryController = TextEditingController();
  User user;
  CartModel _cartModel;
  @override
  void initState() {
    super.initState();
    _cartModel = widget.cartModel;
    _address = widget.address;
    if (widget.deliveryCurdMode == DeliveryCurdMode.edit) {
      addressController.text = _address.address;
      lati = _address.lat.toString();
      long = _address.lng.toString();
      _nameController.text = _address.firstname;
      _phoneController.text = _address.phone;
      _emailController.text = _address.email;
      _cityController.text = _address.city;
      _countryController.text = _address.country;
    } else {
      getUser();
    }
  }

  @override
  void dispose() {
    super.dispose();
    lati = null;
    long = null;
    addressController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: buildAppBar(),
      body: _isAuthError ? buildAuthWigdet(context) : buildBody(),
    );
  }

  SingleChildScrollView buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            FormBuilder(
              key: _fbKey,
              // autovalidate: true,
              initialValue: {
                "firstname": widget.deliveryCurdMode == DeliveryCurdMode.edit
                    ? _address.firstname
                    : "",
                "lastname": widget.deliveryCurdMode == DeliveryCurdMode.edit
                    ? _address.lastname
                    : "",
                "phone": widget.deliveryCurdMode == DeliveryCurdMode.edit
                    ? _address.phone
                    : "",
                "country": widget.deliveryCurdMode == DeliveryCurdMode.edit
                    ? _address.country
                    : "",
                "city": widget.deliveryCurdMode == DeliveryCurdMode.edit
                    ? _address.city
                    : "",
                "hono": widget.deliveryCurdMode == DeliveryCurdMode.edit
                    ? _address.houseno
                    : "",
                // "address": widget.deliveryCurdMode == DeliveryCurdMode.edit
                //     ? addressController.text = _address.address
                //     : addressController.text = "",
                "pincode": widget.deliveryCurdMode == DeliveryCurdMode.edit
                    ? _address.pincode.toString()
                    : "",
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  FormBuilderTextField(
                    attribute: "firstname",
                    decoration: InputDecoration(labelText: "First Name"),
                    validators: [
                      FormBuilderValidators.required(
                          errorText: "Please enter first name"),
                      FormBuilderValidators.maxLength(200),
                    ],
                    controller: _nameController,
                  ),
                  Divider(),
                  SizedBox(
                    height: 20,
                  ),
                  FormBuilderTextField(
                    attribute: "lastname",
                    decoration: InputDecoration(labelText: "Last Name"),
                    validators: [
                      FormBuilderValidators.required(
                          errorText: "Please enter last name"),
                      FormBuilderValidators.maxLength(200),
                    ],
                  ),
                  Divider(),
                  SizedBox(
                    height: 20,
                  ),
                  FormBuilderTextField(
                    attribute: "phone",
                    decoration: InputDecoration(labelText: "Phone Number"),
                    validators: [
                      FormBuilderValidators.required(
                          errorText: "Please enter please enter phone number"),
                      FormBuilderValidators.maxLength(20),
                    ],
                    controller: _phoneController,
                  ),
                  Divider(),
                  SizedBox(
                    height: 20,
                  ),
                  FormBuilderTextField(
                    attribute: "email",
                    decoration: InputDecoration(labelText: "Email Address"),
                    validators: [
                      FormBuilderValidators.required(
                          errorText: "Please enter please enter email address"),
                    ],
                    controller: _emailController,
                  ),
                  Divider(),
                  SizedBox(
                    height: 20,
                  ),
                  FormBuilderTextField(
                    controller: addressController,
                    enabled: false,
                    attribute: "address",
                    decoration: InputDecoration(
                        labelText: "Address Line 1",
                        suffixIcon: IconButton(
                            icon: Icon(Icons.location_on),
                            onPressed: () async {
                              dynamic data = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PlacePickerScreen()));
                              String place = data['place'];
                              String country = data['country'];
                              CameraPosition cameraPosition = data['latlong'];
                              print(place);
                              print(cameraPosition);
                              setState(() {
                                addressController.text = place;
                                _countryController.text = country;
                                lati = "${cameraPosition.target.latitude}";
                                long = "${cameraPosition.target.longitude}";
                              });
                              //openPrediction();
                            })),
                    validators: [
                      FormBuilderValidators.required(
                          errorText: "Please enter address"),
                    ],
                  ),
                  // Positioned(
                  //     top: 0,
                  //     bottom: 0,
                  //     left: 0,
                  //     right: 0,
                  //     child: FlatButton(
                  //         onPressed: () async {
                  //           dynamic data = await Navigator.push(
                  //               context,
                  //               MaterialPageRoute(
                  //                   builder: (context) =>
                  //                       PlacePickerScreen()));
                  //           String place = data['place'];
                  //           String country = data['country'];
                  //           CameraPosition cameraPosition = data['latlong'];
                  //           print(place);
                  //           print(cameraPosition);
                  //           setState(() {
                  //             addressController.text = place;
                  //             _countryController.text = country;
                  //             lati = "${cameraPosition.target.latitude}";
                  //             long = "${cameraPosition.target.longitude}";
                  //           });
                  //           //openPrediction();
                  //         },
                  //         child: Text(''))),
                  Divider(),
                  SizedBox(
                    height: 20,
                  ),
                  FormBuilderTextField(
                    attribute: "hono",
                    decoration: InputDecoration(labelText: "Address Line 2"),
                    validators: [
                      FormBuilderValidators.required(
                          errorText: "Please enter Address Line "),
                      FormBuilderValidators.maxLength(200),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Apartment, suite, unit, building, floor, etc',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                  // Divider(),
                  // FormBuilderTextField(
                  //   attribute: "country",
                  //   controller: _countryController,
                  //   decoration: InputDecoration(labelText: "Country"),
                  //   validators: [
                  //     FormBuilderValidators.required(
                  //         errorText: "Please enter country name"),
                  //     FormBuilderValidators.maxLength(200),
                  //   ],
                  // ),
                  Divider(),
                  SizedBox(
                    height: 20,
                  ),
                  FormBuilderTextField(
                    attribute: "city",
                    decoration: InputDecoration(labelText: "City"),
                    validators: [
                      FormBuilderValidators.required(
                          errorText: "Please enter city name"),
                      FormBuilderValidators.maxLength(200),
                    ],
                    controller: _cityController,
                  ),
                  Divider(),
                  SizedBox(
                    height: 20,
                  ),
                  // SizedBox(
                  //   height: 20,
                  // ),
                  // FormBuilderTextField(
                  //   attribute: "pincode",
                  //   decoration: InputDecoration(labelText: "Zipcode"),
                  //   validators: [
                  //     FormBuilderValidators.required(
                  //         errorText: "Please enter pincode"),
                  //     FormBuilderValidators.maxLength(10),
                  //   ],
                  // ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            _isLoading
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  )
                : ButtonWidget(
                    title: 'ADD',
                    onPressed: () {
                      if (_fbKey.currentState.saveAndValidate()) {
                        print(_fbKey.currentState.value);
                        callAddAddresApi(_fbKey.currentState.value);
                      }
                    },
                  ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  openPrediction() async {
    Prediction p = await PlacesAutocomplete.show(
      context: context,
      apiKey: kGoogleApiKey,
      onError: onError,
      mode: Mode.fullscreen,
      // language: "fr",
      // components: [Component(Component.country, "fr")],
    );

    displayPrediction(p, homeScaffoldKey.currentState);
  }

  Future<Null> displayPrediction(Prediction p, ScaffoldState scaffold) async {
    if (p != null) {
      // get detail (lat/lng)
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId);
      final lat = detail.result.geometry.location.lat;
      final lng = detail.result.geometry.location.lng;

      setState(() {
        addressController.text = p.description;
        lati = "$lat";
        long = "$lng";
      });

      // scaffold.showSnackBar(
      //   SnackBar(content: Text("${p.description} - $lat/$lng")),
      // );
    }
  }

  void onError(PlacesAutocompleteResponse response) {
    homeScaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(response.errorMessage)),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text(
        widget.deliveryCurdMode == DeliveryCurdMode.edit
            ? 'EDIT ADDRESS'
            : 'ADD ADDRESS',
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

  callAddAddresApi(Map<String, dynamic> values) async {
    if (widget.isWithoutLogin) {
      callPlaceOrderApi(values);
      return;
    }

    setState(() {
      _isLoading = true;
    });
    dynamic token = await AppUtils.getToken();
    User user = await AppUtils.getUser();
    ApiResponse<CommonResponseModel> apiResponse =
        await K3Webservice.postMethod(
            apisToUrls(Apis.addAddress),
            json.encode({
              "firstname": values["firstname"],
              "lastname": values["lastname"],
              "country": null, //values["country"],
              "phone": values["phone"],
              "email": values["email"],
              "city": values["city"],
              "pincode": null, //values["pincode"],
              "houseno": values["hono"],
              "address": values["address"],
              "user_id": user.id,
              "formattedAddress": values["address"],
              "lat": lati,
              "lng": long,
              "id": widget.deliveryCurdMode == DeliveryCurdMode.edit
                  ? _address.id
                  : -1
            }),
            {
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
      Navigator.pop(context);
    }
  }

  callPlaceOrderApi(Map<String, dynamic> values) async {
    String stripeToken;
    Map<String, dynamic> authorizeDict = {};
    //var paymentMode = 2; // When authorize was there
    var paymentMode = widget.paymentMode;
    // if (widget.paymentMode == 1)
    //   paymentMode = await Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //           builder: (context) => SelectPaymentGatewayScreen(),
    //           fullscreenDialog: true));

    if (paymentMode == 1) {
      stripeToken = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EnterCardDetailScreen(
                    paymentMode: paymentMode,
                  )));
      if (stripeToken == null) {
        return;
      }
    } else if (paymentMode == 3) {
      authorizeDict = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  EnterCardDetailScreen(paymentMode: paymentMode)));
      if (authorizeDict == null) {
        return;
      }
    }

    setState(() {
      _isLoading = true;
    });

    for (int i = 0; i < _cartModel.cart.length; i++) {
      if (_cartModel.cart[i].customization == null) {
        _cartModel.cart[i].customization = [];
      }
    }

    Map<String, dynamic> timeslotdata = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ReserveSeatScreen(
                  resId: _cartModel.resId,
                )));

    int selectedId = timeslotdata == null ? -1 : timeslotdata['selectedId'];

    String contactMode = "call";
    ConfirmAction confirmAction = await showAlertWithTwoButton(
        context, 'Please select the contact mode', 'Call', 'Text');

    if (confirmAction == ConfirmAction.ACCEPT) {
      contactMode = "text";
    }

    dynamic token = await AppUtils.getToken();
    // User user = await AppUtils.getUser();
    ApiResponse<OrderSuccessResponseModel> apiResponse =
        await K3Webservice.postMethod(
            apisToUrls(Apis.placeOrder),
            json.encode({
              "address": {
                "firstname": values["firstname"],
                "lastname": values["lastname"],
                "country": null, //values["country"],
                "phone": values["phone"],
                "email": values["email"],
                "city": values["city"],
                "pincode": null, //values["pincode"],
                "houseno": values["hono"],
                "address": values["address"],
                "user_id": _cartModel.userId,
                "formattedAddress": values["address"],
                "lat": lati,
                "lng": long,
                "id": widget.deliveryCurdMode == DeliveryCurdMode.edit
                    ? _address.id
                    : -1
              },
              "total": (_cartModel.getTotal() +
                      double.parse(widget.deliveryMode == 2
                          ? "0"
                          : (widget.tax.deliveryCharge ?? "0")))
                  .toStringAsFixed(2),
              "cart": _cartModel.toJson()["cart"],
              "cart_id": _cartModel.id ?? -1,
              "res_id": _cartModel.resId,
              "payment_mode": paymentMode,
              "delivery_mode": widget.deliveryMode,
              "selectedtimeslot": selectedId,
              "token": stripeToken,
              'Anet_credit_card': authorizeDict,
              "extra": {
                "food_tax": _cartModel.getFoodTax(),
                "drink_tax": _cartModel.getDrinkTax(),
                "city_tax": _cartModel.getCityTax(),
                "state_tax": _cartModel.getStateTax(),
                "subtotal": _cartModel.getSubtotal(),
                "tax": _cartModel.getTax(),
                "contact_mode": contactMode,
                "delivery_charge": widget.deliveryMode == 2
                    ? "0"
                    : (widget.tax.deliveryCharge ?? "0")
              },
              "user_id": _cartModel.userId
            }),
            {
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
      showSnackBar(_scaffoldKey, apiResponse.data.msg, null);
      AppUtils.saveLastOrderId(apiResponse.data.orderId);
      await Future.delayed(Duration(seconds: 2));
      Navigator.popUntil(
          context, ModalRoute.withName(Navigator.defaultRouteName));
    }
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

  getUser() async {
    User tempUser = await AppUtils.getUser();
    setState(() {
      user = tempUser;
      _nameController.text = user.name;
      _phoneController.text = user.phone;
      _emailController.text = user.email;
      _cityController.text = user.city;
      lati = position.latitude.toString();
      long = position.longitude.toString();
    });
  }
}
