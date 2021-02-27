class StaticPageResponse {
    bool status;
    String msg;
    Data data;

    StaticPageResponse({
        this.status,
        this.msg,
        this.data,
    });

    factory StaticPageResponse.fromJson(Map<String, dynamic> json) => StaticPageResponse(
        status: json["status"] == null ? null : json["status"],
        msg: json["msg"] == null ? null : json["msg"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "msg": msg == null ? null : msg,
        "data": data == null ? null : data.toJson(),
    };
}

class Data {
    List<Resp> resp;

    Data({
        this.resp,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        resp: json["resp"] == null ? null : List<Resp>.from(json["resp"].map((x) => Resp.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "resp": resp == null ? null : List<dynamic>.from(resp.map((x) => x.toJson())),
    };
}

class Resp {
    int id;
    String page;
    String content;
    String content_es;
    DateTime createdAt;
    DateTime updatedAt;

    Resp({
        this.id,
        this.page,
        this.content,
        this.content_es,
        this.createdAt,
        this.updatedAt,
    });

    factory Resp.fromJson(Map<String, dynamic> json) => Resp(
        id: json["id"] == null ? null : json["id"],
        page: json["page"] == null ? null : json["page"],
        content: json["content"] == null ? null : json["content"],
        content_es: json["content_es"] == null ? null : json["content_es"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "page": page == null ? null : page,
        "content": content == null ? null : content,
        "content_es": content == null ? null : content_es,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
    };
}