import 'dart:convert';
/// success : 1
/// tags : [{"tag_id":"1","tag_name":"steel"},{"tag_id":"2","tag_name":"corona"},{"tag_id":"3","tag_name":"irus"}]

TagListResponse tagListResponseFromJson(String str) => TagListResponse.fromJson(json.decode(str));
String tagListResponseToJson(TagListResponse data) => json.encode(data.toJson());
class TagListResponse {
  TagListResponse({
      num? success, 
      List<Tags>? tags,}){
    _success = success;
    _tags = tags;
}

  TagListResponse.fromJson(dynamic json) {
    _success = json['success'];
    if (json['tags'] != null) {
      _tags = [];
      json['tags'].forEach((v) {
        _tags?.add(Tags.fromJson(v));
      });
    }
  }
  num? _success;
  List<Tags>? _tags;
TagListResponse copyWith({  num? success,
  List<Tags>? tags,
}) => TagListResponse(  success: success ?? _success,
  tags: tags ?? _tags,
);
  num? get success => _success;
  List<Tags>? get tags => _tags;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    if (_tags != null) {
      map['tags'] = _tags?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// tag_id : "1"
/// tag_name : "steel"

Tags tagsFromJson(String str) => Tags.fromJson(json.decode(str));
String tagsToJson(Tags data) => json.encode(data.toJson());
class Tags {
  Tags({
      String? tagId, 
      String? tagName,}){
    _tagId = tagId;
    _tagName = tagName;
}

  Tags.fromJson(dynamic json) {
    _tagId = json['tag_id'];
    _tagName = json['tag_name'];
  }
  String? _tagId;
  String? _tagName;
Tags copyWith({  String? tagId,
  String? tagName,
}) => Tags(  tagId: tagId ?? _tagId,
  tagName: tagName ?? _tagName,
);
  String? get tagId => _tagId;
  String? get tagName => _tagName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['tag_id'] = _tagId;
    map['tag_name'] = _tagName;
    return map;
  }

}