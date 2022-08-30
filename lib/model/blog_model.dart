class BlogModel {
  BlogModel({
    this.id,
    this.title,
    this.subtitle,
    this.image,
    this.description,
    this.isFavorite,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? title;
  String? subtitle;
  String? image;
  String? description;
  int? isFavorite;

  dynamic createdAt;
  dynamic updatedAt;

  factory BlogModel.fromJson(Map<String, dynamic> json) => BlogModel(
        id: json["id"],
        title: json["title"],
        subtitle: json["subtitle"],
        image: json["image"],
        description: json["description"],
        isFavorite: json["is_favorite"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "subtitle": subtitle,
        "image": image,
        "description": description,
        "is_favorite": isFavorite,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
