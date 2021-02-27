import 'package:zabor/screens/food_list_module/cart_model.dart';

class OrderHistoryResponseModel {
    bool status;
    String msg;
    List<Datum> data;

    OrderHistoryResponseModel({
        this.status,
        this.msg,
        this.data,
    });

    factory OrderHistoryResponseModel.fromJson(Map<String, dynamic> json) => OrderHistoryResponseModel(
        status: json["status"] == null ? null : json["status"],
        msg: json["msg"] == null ? null : json["msg"],
        data: json["data"] == null ? null : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "msg": msg == null ? null : msg,
        "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    int id;
    int userId;
    int resId;
    int cartId;
    String cart;
    double foodTax;
    double drinkTax;
    double subtotal;
    double tax;
    double total;
    String status;
    String orderBy;
    DateTime createdDate;
    String resName;
    dynamic orderCode;
    int deliveryMode;
    dynamic deliveryCharge;
       dynamic cityTax;
    dynamic stateTax;
    dynamic cancelCharge;

    Datum({
        this.id,
        this.userId,
        this.resId,
        this.cartId,
        this.cart,
        this.foodTax,
        this.drinkTax,
        this.subtotal,
        this.tax,
        this.total,
        this.status,
        this.orderBy,
        this.createdDate,
        this.resName,
        this.orderCode,
        this.deliveryMode,
        this.deliveryCharge,
         this.cityTax,
        this.stateTax,
        this.cancelCharge,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"] == null ? null : json["id"],
        userId: json["user_id"] == null ? null : json["user_id"],
        resId: json["res_id"] == null ? null : json["res_id"],
        cartId: json["cart_id"] == null ? null : json["cart_id"],
        cart: json["cart"] == null ? null : json["cart"],
        foodTax: json["food_tax"] == null ? null : json["food_tax"].toDouble(),
        drinkTax: json["drink_tax"] == null ? null : json["drink_tax"].toDouble(),
        subtotal: json["subtotal"] == null ? null : json["subtotal"].toDouble(),
        tax: json["tax"] == null ? null : json["tax"].toDouble(),
        total: json["total"] == null ? null : json["total"].toDouble(),
        status: json["status"] == null ? null : json["status"],
        orderBy: json["order_by"] == null ? null : json["order_by"],
        createdDate: json["created_date"] == null ? null : DateTime.parse(json["created_date"]),
        resName: json["res_name"] == null ? null : json["res_name"],
        orderCode: json["order_code"] == null ? null : json["order_code"],
        deliveryMode: json["delivery_mode"] == null ? null : json["delivery_mode"],
        deliveryCharge: json["delivery_charge"] == null ? null : json["delivery_charge"],
        cityTax: json["city_tax"] == null ? null : json["city_tax"],
        stateTax: json["state_tax"] == null ? null : json["state_tax"],
        cancelCharge: json["cancel_charge"] == null ? null : json["cancel_charge"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "user_id": userId == null ? null : userId,
        "res_id": resId == null ? null : resId,
        "cart_id": cartId == null ? null : cartId,
        "cart": cart == null ? null : cart,
        "food_tax": foodTax == null ? null : foodTax,
        "drink_tax": drinkTax == null ? null : drinkTax,
        "subtotal": subtotal == null ? null : subtotal,
        "tax": tax == null ? null : tax,
        "total": total == null ? null : total,
        "status": status == null ? null : status,
        "order_by": orderBy == null ? null : orderBy,
        "created_date": createdDate == null ? null : "${createdDate.year.toString().padLeft(4, '0')}-${createdDate.month.toString().padLeft(2, '0')}-${createdDate.day.toString().padLeft(2, '0')}",
        "res_name": resName == null ? null : resName,
        "order_code": orderCode == null ? null : orderCode,
        "delivery_mode": deliveryMode== null ? null : deliveryMode,
        "delivery_charge": deliveryCharge== null ? null : deliveryCharge,
         "city_tax": cityTax == null ? null : cityTax,
        "state_tax": stateTax == null ? null : stateTax,
        "cancel_charge": cancelCharge == null ? null : cancelCharge,
    };
}

class ModDatum {
    int id;
    int userId;
    int resId;
    int cartId;
    List<Cart>  cart;
    double foodTax;
    double drinkTax;
    double subtotal;
    double tax;
    double total;
    String status;
    String orderBy;
    DateTime createdDate;
    String resName;
    dynamic orderCode;
    int deliveryMode;
    dynamic deliveryCharge;
    dynamic cityTax;
    dynamic stateTax;
    dynamic cancelCharge;

    ModDatum({
        this.id,
        this.userId,
        this.resId,
        this.cartId,
        this.cart,
        this.foodTax,
        this.drinkTax,
        this.subtotal,
        this.tax,
        this.total,
        this.status,
        this.orderBy,
        this.createdDate,
        this.resName,
        this.orderCode,
        this.deliveryMode,
        this.deliveryCharge,
         this.cityTax,
        this.stateTax,
        this.cancelCharge,
    });

    factory ModDatum.fromJson(Map<String, dynamic> json) => ModDatum(
        id: json["id"] == null ? null : json["id"],
        userId: json["user_id"] == null ? null : json["user_id"],
        resId: json["res_id"] == null ? null : json["res_id"],
        cartId: json["cart_id"] == null ? null : json["cart_id"],
        cart: json["cart"] == null ? null : List<Cart>.from(json["cart"].map((x) => Cart.fromJson(x))),
        foodTax: json["food_tax"] == null ? null : json["food_tax"].toDouble(),
        drinkTax: json["drink_tax"] == null ? null : json["drink_tax"].toDouble(),
        subtotal: json["subtotal"] == null ? null : json["subtotal"].toDouble(),
        tax: json["tax"] == null ? null : json["tax"].toDouble(),
        total: json["total"] == null ? null : json["total"].toDouble(),
        status: json["status"] == null ? null : json["status"],
        orderBy: json["order_by"] == null ? null : json["order_by"],
        createdDate: json["created_date"] == null ? null : DateTime.parse(json["created_date"]),
        resName: json["res_name"] == null ? null : json["res_name"],
        orderCode: json["order_code"] == null ? null : json["order_code"],
        deliveryMode: json["delivery_mode"] == null ? null : json["delivery_mode"],
        deliveryCharge: json["delivery_charge"] == null ? null : json["delivery_charge"],
        cityTax: json["city_tax"] == null ? null : json["city_tax"],
        stateTax: json["state_tax"] == null ? null : json["state_tax"],
        cancelCharge: json["cancel_charge"] == null ? null : json["cancel_charge"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "user_id": userId == null ? null : userId,
        "res_id": resId == null ? null : resId,
        "cart_id": cartId == null ? null : cartId,
        "cart": cart == null ? null : List<dynamic>.from(cart.map((x) => x.toJson())),
        "food_tax": foodTax == null ? null : foodTax,
        "drink_tax": drinkTax == null ? null : drinkTax,
        "subtotal": subtotal == null ? null : subtotal,
        "tax": tax == null ? null : tax,
        "total": total == null ? null : total,
        "status": status == null ? null : status,
        "order_by": orderBy == null ? null : orderBy,
        "created_date": createdDate == null ? null : "${createdDate.year.toString().padLeft(4, '0')}-${createdDate.month.toString().padLeft(2, '0')}-${createdDate.day.toString().padLeft(2, '0')}",
        "res_name": resName == null ? null : resName,
        "order_code": orderCode == null ? null : orderCode,
        "delivery_mode": deliveryMode== null ? null : deliveryMode,
        "delivery_charge": deliveryCharge == null ? null : deliveryCharge,
         "city_tax": cityTax == null ? null : cityTax,
        "state_tax": stateTax == null ? null : stateTax,
        "cancel_charge": cancelCharge == null ? null : cancelCharge,
    };
}


class OrderDetailResponseModel {
    bool status;
    String msg;
    Datum data;

    OrderDetailResponseModel({
        this.status,
        this.msg,
        this.data,
    });

    factory OrderDetailResponseModel.fromJson(Map<String, dynamic> json) => OrderDetailResponseModel(
        status: json["status"] == null ? null : json["status"],
        msg: json["msg"] == null ? null : json["msg"],
        data: json["data"] == null ? null : Datum.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "msg": msg == null ? null : msg,
        "data": data == null ? null : data.toJson(),
    };
}