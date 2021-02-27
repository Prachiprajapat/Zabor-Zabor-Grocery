class TimeLineRepsonseModel {
    TimeLineRepsonseModel({
        this.status,
        this.msg,
        this.data,
    });

    bool status;
    String msg;
    List<TimeLineData> data;

    factory TimeLineRepsonseModel.fromJson(Map<String, dynamic> json) => TimeLineRepsonseModel(
        status: json["status"] == null ? null : json["status"],
        msg: json["msg"] == null ? null : json["msg"],
        data: json["data"] == null ? null : List<TimeLineData>.from(json["data"].map((x) => TimeLineData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "msg": msg == null ? null : msg,
        "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class TimeLineData {
    TimeLineData({
        this.id,
        this.orderId,
        this.status,
        this.createdDate,
        this.createdTime,
        this.timediff,
        this.cookingTime
    });

    int id;
    int orderId;
    String status;
    DateTime createdDate;
    String createdTime;
    String timediff;
    dynamic cookingTime;

    factory TimeLineData.fromJson(Map<String, dynamic> json) => TimeLineData(
        id: json["id"] == null ? null : json["id"],
        orderId: json["order_id"] == null ? null : json["order_id"],
        status: json["status"] == null ? null : json["status"],
        createdDate: json["created_date"] == null ? null : DateTime.parse(json["created_date"]),
        createdTime: json["created_time"] == null ? null : json["created_time"],
        timediff: json["timediff"] == null ? null : json["timediff"],
        cookingTime: json["cooking_time"] == null ? null : json["cooking_time"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "order_id": orderId == null ? null : orderId,
        "status": status == null ? null : status,
        "created_date": createdDate == null ? null : "${createdDate.year.toString().padLeft(4, '0')}-${createdDate.month.toString().padLeft(2, '0')}-${createdDate.day.toString().padLeft(2, '0')}",
        "created_time": createdTime == null ? null : createdTime,
        "timediff": timediff == null ? null : timediff,
        "cooking_time": cookingTime == null ? null : cookingTime,
    };
}