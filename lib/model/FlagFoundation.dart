class FlagFoundation {
  FlagFoundation({
      this.image = "",
      this.title = "",});

  FlagFoundation.fromJson(dynamic json) {
    image = json['image'];
    title = json['title'];
  }
  String image = "";
  String title = "";

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['image'] = image;
    map['title'] = title;
    return map;
  }

}