class OrderSuccessResponseModel {
  bool status;
  String msg;
  dynamic orderId;

  OrderSuccessResponseModel({
    this.status,
    this.msg,
    this.orderId
  });

  factory OrderSuccessResponseModel.fromJson(Map<String, dynamic> json) =>
      OrderSuccessResponseModel(
        status: json["status"] == null ? null : json["status"],
        msg: json["msg"] == null ? null : json["msg"],
        orderId: json["order_id"] == null ? null : json["order_id"],
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "msg": msg == null ? null : msg,
        "order_id": orderId == null ? null : orderId,
      };
}