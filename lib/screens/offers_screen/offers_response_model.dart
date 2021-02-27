class OffersResponseModel {
    OffersResponseModel({
        this.status,
        this.msg,
        this.data,
    });

    bool status;
    String msg;
    List<Offer> data;

    factory OffersResponseModel.fromJson(Map<String, dynamic> json) => OffersResponseModel(
        status: json["status"],
        msg: json["msg"],
        data: List<Offer>.from(json["data"].map((x) => Offer.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Offer {
    Offer({
        this.id,
        this.resId,
        this.userType,
        this.percentage,
        this.moa,
        this.mpd,
        this.disCondition,
        this.createdAt,
        this.name,
        this.restaurantpic,
    });

    int id;
    int resId;
    String userType;
    dynamic percentage;
    dynamic moa;
    dynamic mpd;
    String disCondition;
    DateTime createdAt;
    String name;
    String restaurantpic;

    factory Offer.fromJson(Map<String, dynamic> json) => Offer(
        id: json["id"] == null ? null : json["id"],
        resId: json["res_id"] == null ? null : json["res_id"],
        userType: json["user_type"] == null ? null : json["user_type"],
        percentage: json["percentage"] == null ? null : json["percentage"],
        moa: json["moa"] == null ? null : json["moa"],
        mpd: json["mpd"] == null ? null : json["mpd"],
        disCondition: json["dis_condition"] == null ? null : json["dis_condition"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        name: json["name"] == null ? null : json["name"],
        restaurantpic: json["restaurantpic"] == null ? null : json["restaurantpic"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "res_id": resId == null ? null : resId,
        "user_type": userType == null ? null : userType,
        "percentage": percentage == null ? null : percentage,
        "moa": moa == null ? null : moa,
        "mpd": mpd == null ? null : mpd,
        "dis_condition": disCondition == null ? null : disCondition,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "name": name == null ? null : name,
        "restaurantpic": restaurantpic == null ? null : restaurantpic,
    };
}