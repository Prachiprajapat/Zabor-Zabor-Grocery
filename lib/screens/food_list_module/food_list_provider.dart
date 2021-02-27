import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:zabor/constants/apis.dart';
import 'package:zabor/constants/app_utils.dart';
import 'package:zabor/constants/constants.dart';
import 'package:zabor/screens/basket_screen_module/basket_screen.dart';
import 'package:zabor/screens/login_signup/login_signup.dart';
import 'package:zabor/utils/k3webservice.dart';
import 'package:zabor/utils/utils.dart';

import 'cart_model.dart';

class FoodListProvider extends ChangeNotifier {
  CartModel cartModel = CartModel();
  bool isLoading = false;

  List<CheckUncheckCustomizationOuterModel>
      checkUncheckCustomizationOuterModel = [];

  addData(CheckUncheckCustomizationOuterModel data) {
    checkUncheckCustomizationOuterModel.add(data);
  }

  bool isCustomizationExists(int itemId, int cId) {
    if (cartModel.cart == null) return false;
    for (int i = 0; i < cartModel.cart.length; i++) {
      if (itemId == cartModel.cart[i].itemId) {
        if (cartModel.cart[i].customization == null) return false;
        for (int j = 0; j < cartModel.cart[i].customization.length; j++) {
          if (cId == cartModel.cart[i].customization[j].optionId) {
            return true;
          }
        }
      }
    }
    return false;
  }

  addItemToCartCustomizationArray(int outerIndex, int innerIndex) {
    checkUncheckCustomizationOuterModel[outerIndex]
            .checkUncheckCustomizationInnerModel[innerIndex]
            .isExits = !checkUncheckCustomizationOuterModel[outerIndex]
            .checkUncheckCustomizationInnerModel[innerIndex]
            .isExits;
    notifyListeners();
  }

  removeCartCustomization(int outerIndex, int innerIndex) {
    checkUncheckCustomizationOuterModel[outerIndex]
            .checkUncheckCustomizationInnerModel[innerIndex]
            .isExits =
        !checkUncheckCustomizationOuterModel[outerIndex]
            .checkUncheckCustomizationInnerModel[innerIndex]
            .isExits;
    notifyListeners();
  }

  callAddToCartApi(GlobalKey<ScaffoldState> scaffoldKey, BuildContext context, bool isWithoutLogin) async {

    dynamic token = await AppUtils.getToken();
    if (this.cartModel == null) return;
    final jsonCartModel = this.cartModel.toJson();
    CartModel tempCartModel = CartModel.fromJson(jsonCartModel);
    
    double foodTax = 0.0;
    double drinkTax = 0.0;
    double cityTax = 0.0;
    double stateTax = 0.0;
    double total = 0.0;
    // int min_qty = 0;
    double tax = 0.0;
    double subTotal = 0.0;
    // bool is_stamp = false;

    for (int i = 0; i < tempCartModel.cart.length; i++) {
      double itemPrice = 0.0;
      double singleObjectPrice = 0.0;
      // min_qty = tempCartModel.cart[i].min_qty;
      // is_stamp = tempCartModel.is_stamp;
      itemPrice += (tempCartModel.cart[i].itemPrice * tempCartModel.cart[i].quantity);
      singleObjectPrice += tempCartModel.cart[i].itemPrice;

      if (tempCartModel.cart[i].customization != null) {
        for (int j = 0; j < tempCartModel.cart[i].customization.length; j++) {
          itemPrice += (tempCartModel.cart[i].customization[j].optionPrice * tempCartModel.cart[i].quantity);
          singleObjectPrice += tempCartModel.cart[i].customization[j].optionPrice;
        }
      }

      tempCartModel.cart[i].itemPrice = singleObjectPrice;

      if (tempCartModel.cart[i].cityTax == 1) {
        tempCartModel.cart[i].cityTax = double.parse(((singleObjectPrice * tempCartModel.cart[i].citytaxvalue) / 100).toStringAsFixed(2));
        double itemPriceWithQuantity = (tempCartModel.cart[i].itemPrice * tempCartModel.cart[i].quantity);
        cityTax += double.parse(((itemPriceWithQuantity * tempCartModel.cart[i].citytaxvalue) / 100).toStringAsFixed(2));
        itemPrice += double.parse(((itemPriceWithQuantity * tempCartModel.cart[i].citytaxvalue) / 100).toStringAsFixed(2));
      }else{
        tempCartModel.cart[i].cityTax =0.0;
      }

      if (tempCartModel.cart[i].stateTax == 1) {
        tempCartModel.cart[i].stateTax = double.parse(((singleObjectPrice * tempCartModel.cart[i].statetaxvalue) / 100).toStringAsFixed(2));
        double itemPriceWithQuantity = (tempCartModel.cart[i].itemPrice * tempCartModel.cart[i].quantity);
        stateTax += double.parse(((itemPriceWithQuantity * tempCartModel.cart[i].statetaxvalue) / 100).toStringAsFixed(2));
        itemPrice += double.parse(((itemPriceWithQuantity * tempCartModel.cart[i].statetaxvalue) / 100).toStringAsFixed(2));
      }else{
        tempCartModel.cart[i].stateTax =0.0;
      }

      subTotal += itemPrice;
    }
    // tax = double.parse(((subTotal * tempCartModel.tax) / 100).toStringAsFixed(2));
    // tempCartModel.tax = tax;

    //total = subTotal + tax;
    total = subTotal;

    // tempCartModel.foodTax = double.parse(foodTax.toStringAsFixed(2));
    // tempCartModel.drinkTax = double.parse(drinkTax.toStringAsFixed(2));
    // tempCartModel.cityTax = double.parse(cityTax.toStringAsFixed(2));
    // tempCartModel.stateTax = double.parse(stateTax.toStringAsFixed(2));
    // tempCartModel.subtotal = double.parse(subTotal.toStringAsFixed(2));
    // tempCartModel.total = double.parse(total.toStringAsFixed(2));

    // print("food tax => " + tempCartModel.foodTax.toString());
    // print("drink tax => " + tempCartModel.drinkTax.toString());
    // print("food tax => " + tempCartModel.cityTax.toString());
    // print("drink tax => " + tempCartModel.stateTax.toString());
    // print("subTotal => " + tempCartModel.subtotal.toString());
    // print("tax => " + tempCartModel.tax.toString());
    // print("total => " + tempCartModel.total.toString());

    this.isLoading = true;

    notifyListeners();

    ApiResponse<CommonResponseModel> apiResponse;

    if (!isWithoutLogin) {
      apiResponse = await K3Webservice.postMethod<CommonResponseModel>(
          apisToUrls(Apis.addToCart),
          jsonEncode({
            "user_id": tempCartModel.userId,
            "res_id": tempCartModel.resId,
            "cart": tempCartModel.toJson()["cart"],
            "food_tax": tempCartModel.getFoodTax(),
            "drink_tax": tempCartModel.getDrinkTax(),
            "city_tax": tempCartModel.getCityTax(),
            "state_tax": tempCartModel.getStateTax(),
            "tax": tempCartModel.getTax(),
            "total": tempCartModel.getTotal(),
            "subtotal": tempCartModel.getSubtotal(),
            "stamp_paid": 0
          }),
          {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json"
          });
    }

    this.isLoading = false;

    notifyListeners();

    if (isWithoutLogin) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BasketScreen(
                    cartModel: tempCartModel,
                    isFromSettings: false,
                    isWithoutLogin: isWithoutLogin,
                  )));
      return;
    }

    if (apiResponse.error) {
      if (apiResponse.message == sessionExpiredText){
        showSnackBar(scaffoldKey, apiResponse.message, SnackBarAction(label: 'Login', onPressed: (){
          Navigator.push(context,
            MaterialPageRoute(builder: (context) => LoginSignupScreen()));
        }));
        return;
      }
      showSnackBar(scaffoldKey, apiResponse.message, null);
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BasketScreen(
                    cartModel: tempCartModel,
                    isFromSettings: false,
                  )));
    }
  }
}
