class UserCheckInResponse {
    bool status;
    String msg;
    List<CheckIns> data;

    UserCheckInResponse({
        this.status,
        this.msg,
        this.data,
    });

    factory UserCheckInResponse.fromJson(Map<String, dynamic> json) => UserCheckInResponse(
        status: json["status"] == null ? null : json["status"],
        msg: json["msg"] == null ? null : json["msg"],
        data: json["data"] == null ? null : List<CheckIns>.from(json["data"].map((x) => CheckIns.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "msg": msg == null ? null : msg,
        "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class CheckIns {
    int id;
    int userId;
    int resId;
    String comment;
    DateTime createdAt;
    DateTime updatedAt;
    String userName;
    String resName;
    String restaurantpic;
    String pic;
    String address;

    CheckIns({
        this.id,
        this.userId,
        this.resId,
        this.comment,
        this.createdAt,
        this.updatedAt,
        this.userName,
        this.resName,
        this.restaurantpic,
        this.pic,
        this.address,
    });

    factory CheckIns.fromJson(Map<String, dynamic> json) => CheckIns(
        id: json["id"] == null ? null : json["id"],
        userId: json["user_id"] == null ? null : json["user_id"],
        resId: json["res_id"] == null ? null : json["res_id"],
        comment: json["comment"] == null ? null : json["comment"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        userName: json["user_name"] == null ? null : json["user_name"],
        resName: json["res_name"] == null ? null : json["res_name"],
        restaurantpic: json["restaurantpic"] == null ? null : json["restaurantpic"],
        pic: json["pic"] == null ? null : json["pic"],
        address: json["address"] == null ? null : json["address"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "user_id": userId == null ? null : userId,
        "res_id": resId == null ? null : resId,
        "comment": comment == null ? null : comment,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "user_name": userName == null ? null : userName,
        "res_name": resName == null ? null : resName,
        "restaurantpic": restaurantpic == null ? null : restaurantpic,
        "pic": pic == null ? null : pic,
        "address": address == null ? null : address,
    };
}
