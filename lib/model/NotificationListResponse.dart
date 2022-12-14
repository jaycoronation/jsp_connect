import 'dart:convert';
/// success : 1
/// message : "Notification List"
/// totalCount : 61
/// notificationList : [{"id":103,"message":"New post added for the Videos","to_user_id":9,"save_timestamp":"09 Dec 2022","post_id":76,"content_id":3,"content_type":"Videos"},{"id":109,"message":"New post added for the Videos","to_user_id":9,"save_timestamp":"09 Dec 2022","post_id":77,"content_id":3,"content_type":"Videos"},{"id":115,"message":"New post added for the Videos","to_user_id":9,"save_timestamp":"09 Dec 2022","post_id":78,"content_id":3,"content_type":"Videos"}]

NotificationListResponse notificationListResponseFromJson(String str) => NotificationListResponse.fromJson(json.decode(str));
String notificationListResponseToJson(NotificationListResponse data) => json.encode(data.toJson());
class NotificationListResponse {
  NotificationListResponse({
      num? success, 
      String? message, 
      num? totalCount, 
      List<NotificationList>? notificationList,}){
    _success = success;
    _message = message;
    _totalCount = totalCount;
    _notificationList = notificationList;
}

  NotificationListResponse.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _totalCount = json['totalCount'];
    if (json['notificationList'] != null) {
      _notificationList = [];
      json['notificationList'].forEach((v) {
        _notificationList?.add(NotificationList.fromJson(v));
      });
    }
  }
  num? _success;
  String? _message;
  num? _totalCount;
  List<NotificationList>? _notificationList;
NotificationListResponse copyWith({  num? success,
  String? message,
  num? totalCount,
  List<NotificationList>? notificationList,
}) => NotificationListResponse(  success: success ?? _success,
  message: message ?? _message,
  totalCount: totalCount ?? _totalCount,
  notificationList: notificationList ?? _notificationList,
);
  num? get success => _success;
  String? get message => _message;
  num? get totalCount => _totalCount;
  List<NotificationList>? get notificationList => _notificationList;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['message'] = _message;
    map['totalCount'] = _totalCount;
    if (_notificationList != null) {
      map['notificationList'] = _notificationList?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 103
/// message : "New post added for the Videos"
/// to_user_id : 9
/// save_timestamp : "09 Dec 2022"
/// post_id : 76
/// content_id : 3
/// content_type : "Videos"

NotificationList notificationListFromJson(String str) => NotificationList.fromJson(json.decode(str));
String notificationListToJson(NotificationList data) => json.encode(data.toJson());
class NotificationList {
  NotificationList({
      num? id, 
      String? message, 
      num? toUserId, 
      String? saveTimestamp, 
      num? postId, 
      num? contentId, 
      String? contentType,}){
    _id = id;
    _message = message;
    _toUserId = toUserId;
    _saveTimestamp = saveTimestamp;
    _postId = postId;
    _contentId = contentId;
    _contentType = contentType;
}

  NotificationList.fromJson(dynamic json) {
    _id = json['id'];
    _message = json['message'];
    _toUserId = json['to_user_id'];
    _saveTimestamp = json['save_timestamp'];
    _postId = json['post_id'];
    _contentId = json['content_id'];
    _contentType = json['content_type'];
  }
  num? _id;
  String? _message;
  num? _toUserId;
  String? _saveTimestamp;
  num? _postId;
  num? _contentId;
  String? _contentType;
NotificationList copyWith({  num? id,
  String? message,
  num? toUserId,
  String? saveTimestamp,
  num? postId,
  num? contentId,
  String? contentType,
}) => NotificationList(  id: id ?? _id,
  message: message ?? _message,
  toUserId: toUserId ?? _toUserId,
  saveTimestamp: saveTimestamp ?? _saveTimestamp,
  postId: postId ?? _postId,
  contentId: contentId ?? _contentId,
  contentType: contentType ?? _contentType,
);
  num? get id => _id;
  String? get message => _message;
  num? get toUserId => _toUserId;
  String? get saveTimestamp => _saveTimestamp;
  num? get postId => _postId;
  num? get contentId => _contentId;
  String? get contentType => _contentType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['message'] = _message;
    map['to_user_id'] = _toUserId;
    map['save_timestamp'] = _saveTimestamp;
    map['post_id'] = _postId;
    map['content_id'] = _contentId;
    map['content_type'] = _contentType;
    return map;
  }

}