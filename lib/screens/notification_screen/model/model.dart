class NotificationResponseModel {
    bool status;
    List<NotificationModel> response;

    NotificationResponseModel({
        this.status,
        this.response,
    });

    factory NotificationResponseModel.fromJson(Map<String, dynamic> json) => NotificationResponseModel(
        status: json["status"] == null ? null : json["status"],
        response: json["response"] == null ? null : List<NotificationModel>.from(json["response"].map((x) => NotificationModel.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "response": response == null ? null : List<dynamic>.from(response.map((x) => x.toJson())),
    };
}

class NotificationModel {
    String msg;
    String createdAt;

    NotificationModel({
        this.msg,
        this.createdAt,
    });

    factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
        msg: json["msg"] == null ? null : json["msg"],
        createdAt: json["created_at"] == null ? null : json["created_at"],
    );

    Map<String, dynamic> toJson() => {
        "msg": msg == null ? null : msg,
        "created_at": createdAt == null ? null : createdAt,
    };
}