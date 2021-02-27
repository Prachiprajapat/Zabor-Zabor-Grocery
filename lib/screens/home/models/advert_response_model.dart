class AdvertResponseModel {
    AdvertResponseModel({
        this.status,
        this.msg,
        this.data,
    });

    bool status;
    String msg;
    AdvertData data;

    factory AdvertResponseModel.fromJson(Map<String, dynamic> json) => AdvertResponseModel(
        status: json["status"] == null ? null : json["status"],
        msg: json["msg"] == null ? null : json["msg"],
        data: json["data"] == null ? null : AdvertData.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "msg": msg == null ? null : msg,
        "data": data == null ? null : data.toJson(),
    };
}

class AdvertData {
    AdvertData({
        this.type,
        this.data,
    });

    int type;
    List<Advert> data;

    factory AdvertData.fromJson(Map<String, dynamic> json) => AdvertData(
        type: json["type"] == null ? null : json["type"],
        data: json["data"] == null ? null : List<Advert>.from(json["data"].map((x) => Advert.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "type": type == null ? null : type,
        "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Advert {
    Advert({
        this.id,
        this.restaurantId,
        this.video,
        this.pic,
        this.videoThumb,
        this.restaurantpic,
        this.name,
        this.address,
        this.distance,
    });

    int id;
    int restaurantId;
    String video;
    String pic;
    String videoThumb;
    String restaurantpic;
    String name;
    String address;
    double distance;

    factory Advert.fromJson(Map<String, dynamic> json) => Advert(
        id: json["id"] == null ? null : json["id"],
        restaurantId: json["restaurant_id"] == null ? null : json["restaurant_id"],
        video: json["video"] == null ? null : json["video"],
        pic: json["pic"] == null ? null : json["pic"],
        videoThumb: json["video_thumb"] == null ? null : json["video_thumb"],
        restaurantpic: json["restaurantpic"] == null ? null : json["restaurantpic"],
        name: json["name"] == null ? null : json["name"],
        address: json["address"] == null ? null : json["address"],
        distance: json["distance"] == null ? null : json["distance"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "restaurant_id": restaurantId == null ? null : restaurantId,
        "video": video == null ? null : video,
        "pic": pic == null ? null : pic,
        "video_thumb": videoThumb == null ? null : videoThumb,
        "restaurantpic": restaurantpic == null ? null : restaurantpic,
        "name": name == null ? null : name,
        "address": address == null ? null : address,
        "distance": distance == null ? null : distance,
    };
}
