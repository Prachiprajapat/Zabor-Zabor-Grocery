class GalleryResponseModel {
    bool status;
    List<Gallery> data;

    GalleryResponseModel({
        this.status,
        this.data,
    });

    factory GalleryResponseModel.fromJson(Map<String, dynamic> json) => GalleryResponseModel(
        status: json["status"] == null ? null : json["status"],
        data: json["data"] == null ? null : List<Gallery>.from(json["data"].map((x) => Gallery.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Gallery {
    String image;

    Gallery({
        this.image,
    });

    factory Gallery.fromJson(Map<String, dynamic> json) => Gallery(
        image: json["image"] == null ? null : json["image"],
    );

    Map<String, dynamic> toJson() => {
        "image": image == null ? null : image,
    };
}