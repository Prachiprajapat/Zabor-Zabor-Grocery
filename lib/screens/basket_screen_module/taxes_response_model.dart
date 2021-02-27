class TaxesResponseModel {
    TaxesResponseModel({
        this.status,
        this.msg,
        this.data,
    });

    bool status;
    String msg;
    Tax data;

    factory TaxesResponseModel.fromJson(Map<String, dynamic> json) => TaxesResponseModel(
        status: json["status"] == null ? null : json["status"],
        msg: json["msg"] == null ? null : json["msg"],
        data: json["data"] == null ? null : Tax.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "msg": msg == null ? null : msg,
        "data": data == null ? null : data.toJson(),
    };
}

class Tax {
    Tax({
        this.foodTax,
        this.drinkTax,
        this.grandTax,
        this.deliveryCharge,
        this.cityTax,
        this.stateTax,
        this.driver_fee,
        this.pickup_fee
    });

    String foodTax;
    String drinkTax;
    String grandTax;
    String deliveryCharge;
    String cityTax;
    String stateTax;
    String driver_fee;
    String pickup_fee;

    factory Tax.fromJson(Map<String, dynamic> json) => Tax(
        foodTax: json["food_tax"] == null ? null : json["food_tax"],
        drinkTax: json["drink_tax"] == null ? null : json["drink_tax"],
        grandTax: json["grand_tax"] == null ? null : json["grand_tax"],
        deliveryCharge: json["delivery_charge"] == null ? null : json["delivery_charge"],
        cityTax: json["city_tax"] == null ? null : json["city_tax"],
        stateTax: json["state_tax"] == null ? null : json["state_tax"],
        driver_fee: json["driver_fee"] == null ? null : json["driver_fee"],
        pickup_fee: json["pickup_fee"] == null ? null : json["pickup_fee"],
    );

    Map<String, dynamic> toJson() => {
        "food_tax": foodTax == null ? null : foodTax,
        "drink_tax": drinkTax == null ? null : drinkTax,
        "grand_tax": grandTax == null ? null : grandTax,
        "delivery_charge": deliveryCharge == null ? null : deliveryCharge,
        "state_tax": stateTax == null ? null : stateTax,
        "city_tax": cityTax == null ? null : cityTax,
        "driver_fee": driver_fee == null ? null : driver_fee,
        "pickup_fee": pickup_fee == null ? null : pickup_fee,
    };
}
