import 'dart:convert';
/// success : 1
/// message : "total unread notification counts"
/// total_unread : "12"

NotificationCountResponse notificationCountResponseFromJson(String str) => NotificationCountResponse.fromJson(json.decode(str));
String notificationCountResponseToJson(NotificationCountResponse data) => json.encode(data.toJson());
class NotificationCountResponse {
  NotificationCountResponse({
      num? success, 
      String? message, 
      String? totalUnread,}){
    _success = success;
    _message = message;
    _totalUnread = totalUnread;
}

  NotificationCountResponse.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _totalUnread = json['total_unread'];
  }
  num? _success;
  String? _message;
  String? _totalUnread;
NotificationCountResponse copyWith({  num? success,
  String? message,
  String? totalUnread,
}) => NotificationCountResponse(  success: success ?? _success,
  message: message ?? _message,
  totalUnread: totalUnread ?? _totalUnread,
);
  num? get success => _success;
  String? get message => _message;
  String? get totalUnread => _totalUnread;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['message'] = _message;
    map['total_unread'] = _totalUnread;
    return map;
  }

}