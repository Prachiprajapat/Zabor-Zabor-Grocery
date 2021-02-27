class SlotResponseModel {
    bool status;
    String msg;
    List<Slot> data;

    SlotResponseModel({
        this.status,
        this.msg,
        this.data,
    });

    factory SlotResponseModel.fromJson(Map<String, dynamic> json) => SlotResponseModel(
        status: json["status"] == null ? null : json["status"],
        msg: json["msg"] == null ? null : json["msg"],
        data: json["data"] == null ? null : List<Slot>.from(json["data"].map((x) => Slot.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "msg": msg == null ? null : msg,
        "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Slot {
    int id;
    int resId;
    DateTime date;
    String slotTime;
    int seat;
    int availSeat;
    DateTime createdDate;

    Slot({
        this.id,
        this.resId,
        this.date,
        this.slotTime,
        this.seat,
        this.availSeat,
        this.createdDate,
    });

    factory Slot.fromJson(Map<String, dynamic> json) => Slot(
        id: json["id"] == null ? null : json["id"],
        resId: json["res_id"] == null ? null : json["res_id"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        slotTime: json["slot_time"] == null ? null : json["slot_time"],
        seat: json["seat"] == null ? null : json["seat"],
        availSeat: json["avail_seat"] == null ? null : json["avail_seat"],
        createdDate: json["created_date"] == null ? null : DateTime.parse(json["created_date"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "res_id": resId == null ? null : resId,
        "date": date == null ? null : date.toIso8601String(),
        "slot_time": slotTime == null ? null : slotTime,
        "seat": seat == null ? null : seat,
        "avail_seat": availSeat == null ? null : availSeat,
        "created_date": createdDate == null ? null : createdDate.toIso8601String(),
    };
}


class TimeSlotGroceryResponseModel {
    TimeSlotGroceryResponseModel({
        this.status,
        this.msg,
        this.data,
    });

    bool status;
    String msg;
    List<TimeSlot> data;

    factory TimeSlotGroceryResponseModel.fromJson(Map<String, dynamic> json) => TimeSlotGroceryResponseModel(
        status: json["status"] == null ? null : json["status"],
        msg: json["msg"] == null ? null : json["msg"],
        data: json["data"] == null ? null : List<TimeSlot>.from(json["data"].map((x) => TimeSlot.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "msg": msg == null ? null : msg,
        "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class TimeSlot {
    TimeSlot({
        this.id,
        this.resId,
        this.date,
        this.fromTimeslot,
        this.toTimeslot,
        this.createdDate,
    });

    int id;
    int resId;
    DateTime date;
    String fromTimeslot;
    String toTimeslot;
    DateTime createdDate;

    factory TimeSlot.fromJson(Map<String, dynamic> json) => TimeSlot(
        id: json["id"] == null ? null : json["id"],
        resId: json["res_id"] == null ? null : json["res_id"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        fromTimeslot: json["from_timeslot"] == null ? null : json["from_timeslot"],
        toTimeslot: json["to_timeslot"] == null ? null : json["to_timeslot"],
        createdDate: json["created_date"] == null ? null : DateTime.parse(json["created_date"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "res_id": resId == null ? null : resId,
        "date": date == null ? null : "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "from_timeslot": fromTimeslot == null ? null : fromTimeslot,
        "to_timeslot": toTimeslot == null ? null : toTimeslot,
        "created_date": createdDate == null ? null : createdDate.toIso8601String(),
    };
}
