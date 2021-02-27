class MyReservationResponseModel {
    bool status;
    String msg;
    List<MyReservation> data;

    MyReservationResponseModel({
        this.status,
        this.msg,
        this.data,
    });

    factory MyReservationResponseModel.fromJson(Map<String, dynamic> json) => MyReservationResponseModel(
        status: json["status"] == null ? null : json["status"],
        msg: json["msg"] == null ? null : json["msg"],
        data: json["data"] == null ? null : List<MyReservation>.from(json["data"].map((x) => MyReservation.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "msg": msg == null ? null : msg,
        "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class MyReservation {
    String resName;
    String restaurantpic;
    int people;
    String date;
    String time;
    int confirmed;

    MyReservation({
        this.resName,
        this.restaurantpic,
        this.people,
        this.date,
        this.time,
        this.confirmed,
    });

    factory MyReservation.fromJson(Map<String, dynamic> json) => MyReservation(
        resName: json["res_name"] == null ? null : json["res_name"],
        restaurantpic: json["restaurantpic"] == null ? null : json["restaurantpic"],
        people: json["people"] == null ? null : json["people"],
        date: json["date"] == null ? null : json["date"],
        time: json["time"] == null ? null : json["time"],
        confirmed: json["confirmed"] == null ? null : json["confirmed"],
    );

    Map<String, dynamic> toJson() => {
        "res_name": resName == null ? null : resName,
        "restaurantpic": restaurantpic == null ? null : restaurantpic,
        "people": people == null ? null : people,
        "date": date == null ? null : date,
        "time": time == null ? null : time,
        "confirmed": confirmed == null ? null : confirmed,
    };
}
