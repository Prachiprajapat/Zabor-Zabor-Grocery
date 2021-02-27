// To parse this JSON data, do
//
//     final cartModel = cartModelFromJson(jsonString);

import 'dart:convert';

CartModel cartModelFromJson(String str) => CartModel.fromJson(json.decode(str));

String cartModelToJson(CartModel data) => json.encode(data.toJson());

class CartModel {
    int id;
    int userId;
    int resId;
    List<Cart> cart;
    // double foodTax;
    // double drinkTax;
    // double tax;
    // double total;
    // double subtotal;
    // double cityTax;
    // double stateTax;
    double appendTax;
    int cod;
    // int min_qty;
    // bool is_stamp;
    int stamp_paid;
    double latitude;
    double longitude;
    CartModel({
        this.id,
        this.userId,
        this.resId,
        this.cart,
        // this.foodTax,
        // this.drinkTax,
        // this.tax,
        // this.total,
        // this.subtotal,
        // this.cityTax,
        // this.stateTax,
        this.appendTax,
        this.cod,
        // this.is_stamp,
        this.stamp_paid,
        this.latitude,
        this.longitude
    });

    double getFoodTax() {
      double sum = 0;
      return sum;
    }

    double getDrinkTax() {
      double sum = 0;
      return sum;
    }

    double getTax() {
      double sum = 0;
      for(int i = 0; i < this.cart.length; i++) {
        if (this.stamp_paid == 1 && this.cart[i].is_stamp) {
          continue;
        }
        sum+= this.cart[i].taxvalue;
      }
      if (appendTax != null) {
        sum += appendTax;
      }

      return sum;
    }

    double getTotal() {
      return double.parse(getSubtotal().toStringAsFixed(2));
    }

    double getSubtotal() {
      double sum = 0;
      for(int i = 0; i < this.cart.length; i++) {
        if (this.stamp_paid == 1 && this.cart[i].is_stamp) {
          continue;
        }
        double itemPrice = 0.0;
        double singleObjectPrice = 0.0;
        itemPrice += (this.cart[i].itemPrice * this.cart[i].quantity);
        singleObjectPrice += this.cart[i].itemPrice;

        if (this.cart[i].customization != null) {
          for (int j = 0; j < this.cart[i].customization.length; j++) {
            itemPrice += (this.cart[i].customization[j].optionPrice * this.cart[i].quantity);
            singleObjectPrice += this.cart[i].customization[j].optionPrice;
          }
        }

        this.cart[i].itemPrice = singleObjectPrice;

        if (this.cart[i].cityTax > 0) {
          this.cart[i].cityTax = double.parse(((singleObjectPrice * this.cart[i].citytaxvalue) / 100).toStringAsFixed(2));
          double itemPriceWithQuantity = (this.cart[i].itemPrice * this.cart[i].quantity);
          itemPrice += double.parse(((itemPriceWithQuantity * this.cart[i].citytaxvalue) / 100).toStringAsFixed(2));
        }

        if (this.cart[i].stateTax > 0) {
          this.cart[i].stateTax = double.parse(((singleObjectPrice * this.cart[i].statetaxvalue) / 100).toStringAsFixed(2));
          double itemPriceWithQuantity = (this.cart[i].itemPrice * this.cart[i].quantity);
          itemPrice += double.parse(((itemPriceWithQuantity * this.cart[i].statetaxvalue) / 100).toStringAsFixed(2));
        }
        sum += itemPrice;
      }
      return sum;
    }

    double getCityTax() {
      double sum = 0;
      for(int i = 0; i < this.cart.length; i++) {
        if (this.stamp_paid == 1 && this.cart[i].is_stamp) {
          continue;
        }
        if (this.cart[i].cityTax > 0) {
          double itemPriceWithQuantity = (this.cart[i].itemPrice * this.cart[i].quantity);
          sum += double.parse(((itemPriceWithQuantity * this.cart[i].citytaxvalue) / 100).toStringAsFixed(2));
        } else {

        }
      }
      return sum;
    }

    double getStateTax() {
      double sum = 0;
      for(int i = 0; i < this.cart.length; i++) {
        if (this.stamp_paid == 1 && this.cart[i].is_stamp) {
          continue;
        }
        if (this.cart[i].stateTax > 0) {
          double itemPriceWithQuantity = (this.cart[i].itemPrice * this.cart[i].quantity);
          sum += double.parse(((itemPriceWithQuantity * this.cart[i].statetaxvalue) / 100).toStringAsFixed(2));
        }
        else {
        }
      }
      return sum;
    }

    factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
      id: json["id"] == null ? null : json["id"],
      userId: json["user_id"] == null ? null : json["user_id"],
      resId: json["res_id"] == null ? null : json["res_id"],
      cart: json["cart"] == null ? null : List<Cart>.from(json["cart"].map((x) => Cart.fromJson(x))),
      // foodTax: json["food_tax"] == null ? null : json["food_tax"].toDouble(),
      // drinkTax: json["drink_tax"] == null ? null : json["drink_tax"].toDouble(),
      // tax: json["tax"] == null ? null : json["tax"].toDouble(),
      // total: json["total"] == null ? null : json["total"].toDouble(),
      // subtotal: json["subtotal"] == null ? null : json["subtotal"].toDouble(),
      // cityTax: json["city_tax"] == null ? null : json["city_tax"].toDouble(),
      // stateTax: json["state_tax"] == null ? null : json["state_tax"].toDouble(),
      cod: json["cod"] == null ? null : json["cod"],
      // is_stamp: json["is_stamp"] == null ? null : json["is_stamp"],
      stamp_paid: json["stamp_paid"] == null ? null : json["stamp_paid"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "user_id": userId == null ? null : userId,
        "res_id": resId == null ? null : resId,
        "cart": cart == null ? null : List<dynamic>.from(cart.map((x) => x.toJson())),
        "food_tax": getFoodTax(),
        "drink_tax": getDrinkTax(),
        "tax": getTax(),
        "total": getTotal(),
        "subtotal": getSubtotal(),
        "city_tax": getCityTax(),
        "state_tax": getStateTax(),
        // "food_tax": foodTax == null ? null : foodTax,
        // "drink_tax": drinkTax == null ? null : drinkTax,
        // "tax": tax == null ? null : tax,
        // "total": total == null ? null : total,
        // "subtotal": subtotal == null ? null : subtotal,
        // "city_tax": cityTax == null ? null : cityTax,
        // "state_tax": stateTax == null ? null : stateTax,
        "cod": cod == null ? null : cod,
        // "is_stamp": is_stamp == null ? 0 : is_stamp,
        "stamp_paid": stamp_paid == null ? 0 : stamp_paid
    };
}

class Cart {
    int itemId;
    String itemName;
    dynamic itemPrice;
    dynamic sp;
    List<CartCustomization> customization;
    dynamic quantity;
    dynamic customQunatity;
    String taxtype;
    dynamic taxvalue;
    double citytaxvalue;
    double statetaxvalue;
    dynamic cityTax;
    dynamic stateTax;
    int min_qty;
    bool is_stamp;
    Cart({
        this.itemId,
        this.itemName,
        this.itemPrice,
        this.sp,
        this.customization,
        this.quantity,
        this.customQunatity,
        this.taxtype,
        this.taxvalue,
        this.citytaxvalue,this.statetaxvalue,
        this.cityTax,
        this.stateTax,
        this.min_qty,
        this.is_stamp,
    });

     factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        itemId: json["itemId"] == null ? null : json["itemId"],
        itemName: json["itemName"] == null ? null : json["itemName"],
        itemPrice: json["itemPrice"] == null ? null : json["itemPrice"].toDouble(),
        sp: json["sp"] == null ? null : json["sp"],
        customization: json["customization"] == null ? null : List<CartCustomization>.from(json["customization"].map((x) => CartCustomization.fromJson(x))),
        quantity: json["quantity"] == null ? null : json["quantity"],
        customQunatity: json["custom_qua"] == null ? null : json["custom_qua"],
        taxtype: json["taxtype"] == null ? null : json["taxtype"],
        taxvalue: json["taxvalue"] == null ? null : json["taxvalue"].toDouble(),
        citytaxvalue: json["citytaxvalue"] == null ? null : json["citytaxvalue"].toDouble(),
        statetaxvalue: json["statetaxvalue"] == null ? null : json["statetaxvalue"].toDouble(),
        cityTax: json["city_tax"] == null ? null : json["city_tax"],
        stateTax: json["state_tax"] == null ? null : json["state_tax"],
        min_qty: json["min_qty"] == null ? null : json["min_qty"],
        is_stamp: json["is_stamp"] == null ? null : json["is_stamp"],
    );

    Map<String, dynamic> toJson() => {
        "itemId": itemId == null ? null : itemId,
        "itemName": itemName == null ? null : itemName,
        "itemPrice": itemPrice == null ? null : itemPrice,
        "sp": sp == null ? null : sp,
        "customization": customization == null ? null : List<dynamic>.from(customization.map((x) => x.toJson())),
        "quantity": quantity == null ? null : quantity,
        "custom_qua": customQunatity == null ? null : customQunatity,
        "taxtype": taxtype == null ? null : taxtype,
        "taxvalue": taxvalue == null ? null : taxvalue,
        "citytaxvalue": citytaxvalue == null ? null : citytaxvalue,
        "statetaxvalue": statetaxvalue == null ? null : statetaxvalue,
        "city_tax": cityTax == null ? null : cityTax,
        "state_tax": stateTax == null ? null : stateTax,
        "min_qty": min_qty == null ? null : min_qty,
        "is_stamp": is_stamp == null ? null : is_stamp,
    };
}

class CartCustomization {
    int optionId;
    String optionName;
    dynamic optionPrice;

    CartCustomization({
        this.optionId,
        this.optionName,
        this.optionPrice,
    });

   factory CartCustomization.fromJson(Map<String, dynamic> json) => CartCustomization(
        optionId: json["option_id"] == null ? null : json["option_id"],
        optionName: json["option_name"] == null ? null : json["option_name"],
        optionPrice: json["option_price"] == null ? null : json["option_price"],
    );

    Map<String, dynamic> toJson() => {
        "option_id": optionId == null ? null : optionId,
        "option_name": optionName == null ? null : optionName,
        "option_price": optionPrice == null ? null : optionPrice,
    };
}


class CheckUncheckCustomizationOuterModel{
  int id;
  List<CheckUncheckCustomizationInnerModel> checkUncheckCustomizationInnerModel;
  CheckUncheckCustomizationOuterModel({this.id, this.checkUncheckCustomizationInnerModel});
}

class CheckUncheckCustomizationInnerModel{
  bool isExits;
  CheckUncheckCustomizationInnerModel({this.isExits});
}

class TaxType{
  static String food = "food";
  static String drink = "drink";
}
