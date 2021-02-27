class BasketResponseModel {
    bool status;
    BasketModel data;

    BasketResponseModel({
        this.status,
        this.data,
    });

    factory BasketResponseModel.fromJson(Map<String, dynamic> json) => BasketResponseModel(
        status: json["status"] == null ? null : json["status"],
        data: json["data"] == null ? null : BasketModel.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "data": data == null ? null : data.toJson(),
    };
}

class BasketModel {
    BasketModel({
        this.cod,
        this.resName,
        this.id,
        this.userId,
        this.resId,
        this.cart,
        this.foodTax,
        this.drinkTax,
        this.subtotal,
        this.tax,
        this.total,
        this.ordered,
        this.createdDate,
        this.monopenTime,
        this.moncloseTime,
        this.tueopenTime,
        this.tuecloseTime,
        this.wedopenTime,
        this.wedcloseTime,
        this.thuopenTime,
        this.thucloseTime,
        this.friopenTime,
        this.fricloseTime,
        this.satopenTime,
        this.satcloseTime,
        this.sunopenTime,
        this.suncloseTime,
        this.latitude,
        this.longitude,
         this.cityTax,
        this.stateTax,
    });

    int cod;
    String resName;
    int id;
    int userId;
    int resId;
    String cart;
    dynamic foodTax;
    dynamic drinkTax;
    double subtotal;
    double tax;
    double total;
    int ordered;
    DateTime createdDate;
    String monopenTime;
    String moncloseTime;
    String tueopenTime;
    String tuecloseTime;
    String wedopenTime;
    String wedcloseTime;
    String thuopenTime;
    String thucloseTime;
    String friopenTime;
    String fricloseTime;
    String satopenTime;
    String satcloseTime;
    String sunopenTime;
    String suncloseTime;
    double latitude;
    double longitude;
     dynamic cityTax;
    dynamic stateTax;

    factory BasketModel.fromJson(Map<String, dynamic> json) => BasketModel(
        cod: json["cod"] == null ? null : json["cod"],
        resName: json["res_name"] == null ? null : json["res_name"],
        id: json["id"] == null ? null : json["id"],
        userId: json["user_id"] == null ? null : json["user_id"],
        resId: json["res_id"] == null ? null : json["res_id"],
        cart: json["cart"] == null ? null : json["cart"],
        foodTax: json["food_tax"] == null ? null : json["food_tax"].toDouble(),
        drinkTax: json["drink_tax"] == null ? null : json["drink_tax"],
        subtotal: json["subtotal"] == null ? null : json["subtotal"].toDouble(),
        tax: json["tax"] == null ? null : json["tax"].toDouble(),
        total: json["total"] == null ? null : json["total"].toDouble(),
        ordered: json["ordered"] == null ? null : json["ordered"],
        createdDate: json["created_date"] == null ? null : DateTime.parse(json["created_date"]),
        monopenTime: json["monopen_time"] == null ? null : json["monopen_time"],
        moncloseTime: json["monclose_time"] == null ? null : json["monclose_time"],
        tueopenTime: json["tueopen_time"] == null ? null : json["tueopen_time"],
        tuecloseTime: json["tueclose_time"] == null ? null : json["tueclose_time"],
        wedopenTime: json["wedopen_time"] == null ? null : json["wedopen_time"],
        wedcloseTime: json["wedclose_time"] == null ? null : json["wedclose_time"],
        thuopenTime: json["thuopen_time"] == null ? null : json["thuopen_time"],
        thucloseTime: json["thuclose_time"] == null ? null : json["thuclose_time"],
        friopenTime: json["friopen_time"] == null ? null : json["friopen_time"],
        fricloseTime: json["friclose_time"] == null ? null : json["friclose_time"],
        satopenTime: json["satopen_time"] == null ? null : json["satopen_time"],
        satcloseTime: json["satclose_time"] == null ? null : json["satclose_time"],
        sunopenTime: json["sunopen_time"] == null ? null : json["sunopen_time"],
        suncloseTime: json["sunclose_time"] == null ? null : json["sunclose_time"],
        latitude: json["latitude"] == null ? null : json["latitude"].toDouble(),
        longitude: json["longitude"] == null ? null : json["longitude"].toDouble(),
        cityTax: json["city_tax"] == null ? null : json["city_tax"],
        stateTax: json["state_tax"] == null ? null : json["state_tax"],
    );

    Map<String, dynamic> toJson() => {
        "cod": cod == null ? null : cod,
        "res_name": resName == null ? null : resName,
        "id": id == null ? null : id,
        "user_id": userId == null ? null : userId,
        "res_id": resId == null ? null : resId,
        "cart": cart == null ? null : cart,
        "food_tax": foodTax == null ? null : foodTax,
        "drink_tax": drinkTax == null ? null : drinkTax,
        "subtotal": subtotal == null ? null : subtotal,
        "tax": tax == null ? null : tax,
        "total": total == null ? null : total,
        "ordered": ordered == null ? null : ordered,
        "created_date": createdDate == null ? null : createdDate.toIso8601String(),
        "monopen_time": monopenTime == null ? null : monopenTime,
        "monclose_time": moncloseTime == null ? null : moncloseTime,
        "tueopen_time": tueopenTime == null ? null : tueopenTime,
        "tueclose_time": tuecloseTime == null ? null : tuecloseTime,
        "wedopen_time": wedopenTime == null ? null : wedopenTime,
        "wedclose_time": wedcloseTime == null ? null : wedcloseTime,
        "thuopen_time": thuopenTime == null ? null : thuopenTime,
        "thuclose_time": thucloseTime == null ? null : thucloseTime,
        "friopen_time": friopenTime == null ? null : friopenTime,
        "friclose_time": fricloseTime == null ? null : fricloseTime,
        "satopen_time": satopenTime == null ? null : satopenTime,
        "satclose_time": satcloseTime == null ? null : satcloseTime,
        "sunopen_time": sunopenTime == null ? null : sunopenTime,
        "sunclose_time": suncloseTime == null ? null : suncloseTime,
        "latitude": latitude == null ? null : latitude,
        "longitude": longitude == null ? null : longitude,
         "city_tax": cityTax == null ? null : cityTax,
        "state_tax": stateTax == null ? null : stateTax,

    };
}
