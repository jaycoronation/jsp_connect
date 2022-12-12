import 'dart:convert';
/// status : 1
/// message : "Disliked"

CommanResponse commanResponseFromJson(String str) => CommanResponse.fromJson(json.decode(str));
String commanResponseToJson(CommanResponse data) => json.encode(data.toJson());
class CommanResponse {
  CommanResponse({
      num? status, 
      String? message,}){
    _status = status;
    _message = message;
}

  CommanResponse.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
  }
  num? _status;
  String? _message;
CommanResponse copyWith({  num? status,
  String? message,
}) => CommanResponse(  status: status ?? _status,
  message: message ?? _message,
);
  num? get status => _status;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    return map;
  }

}