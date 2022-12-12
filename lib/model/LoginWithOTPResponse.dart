import 'dart:convert';
/// success : 1
/// message : "OTP Verified successfully!"
/// user : {"user_id":9,"first_name":"","last_name":"","middle_name":"","email":"","mobile":"8469940500","dob":"","has_login_pin":false,"access_token":"ODJlZmU3OTc0NGY4YjU2OTg0Njc2ZmY1MmZlMDY4MTA=","company_id":"","company":""}

LoginWithOtpResponse loginWithOtpResponseFromJson(String str) => LoginWithOtpResponse.fromJson(json.decode(str));
String loginWithOtpResponseToJson(LoginWithOtpResponse data) => json.encode(data.toJson());
class LoginWithOtpResponse {
  LoginWithOtpResponse({
      num? success, 
      String? message, 
      User? user,}){
    _success = success;
    _message = message;
    _user = user;
}

  LoginWithOtpResponse.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _user = json['user'] != null ? User.fromJson(json['user']) : null;
  }
  num? _success;
  String? _message;
  User? _user;
LoginWithOtpResponse copyWith({  num? success,
  String? message,
  User? user,
}) => LoginWithOtpResponse(  success: success ?? _success,
  message: message ?? _message,
  user: user ?? _user,
);
  num? get success => _success;
  String? get message => _message;
  User? get user => _user;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['message'] = _message;
    if (_user != null) {
      map['user'] = _user?.toJson();
    }
    return map;
  }

}

/// user_id : 9
/// first_name : ""
/// last_name : ""
/// middle_name : ""
/// email : ""
/// mobile : "8469940500"
/// dob : ""
/// has_login_pin : false
/// access_token : "ODJlZmU3OTc0NGY4YjU2OTg0Njc2ZmY1MmZlMDY4MTA="
/// company_id : ""
/// company : ""

User userFromJson(String str) => User.fromJson(json.decode(str));
String userToJson(User data) => json.encode(data.toJson());
class User {
  User({
      num? userId, 
      String? firstName, 
      String? lastName, 
      String? middleName, 
      String? email, 
      String? mobile, 
      String? dob, 
      bool? hasLoginPin, 
      String? accessToken, 
      String? companyId, 
      String? company,}){
    _userId = userId;
    _firstName = firstName;
    _lastName = lastName;
    _middleName = middleName;
    _email = email;
    _mobile = mobile;
    _dob = dob;
    _hasLoginPin = hasLoginPin;
    _accessToken = accessToken;
    _companyId = companyId;
    _company = company;
}

  User.fromJson(dynamic json) {
    _userId = json['user_id'];
    _firstName = json['first_name'];
    _lastName = json['last_name'];
    _middleName = json['middle_name'];
    _email = json['email'];
    _mobile = json['mobile'];
    _dob = json['dob'];
    _hasLoginPin = json['has_login_pin'];
    _accessToken = json['access_token'];
    _companyId = json['company_id'];
    _company = json['company'];
  }
  num? _userId;
  String? _firstName;
  String? _lastName;
  String? _middleName;
  String? _email;
  String? _mobile;
  String? _dob;
  bool? _hasLoginPin;
  String? _accessToken;
  String? _companyId;
  String? _company;
User copyWith({  num? userId,
  String? firstName,
  String? lastName,
  String? middleName,
  String? email,
  String? mobile,
  String? dob,
  bool? hasLoginPin,
  String? accessToken,
  String? companyId,
  String? company,
}) => User(  userId: userId ?? _userId,
  firstName: firstName ?? _firstName,
  lastName: lastName ?? _lastName,
  middleName: middleName ?? _middleName,
  email: email ?? _email,
  mobile: mobile ?? _mobile,
  dob: dob ?? _dob,
  hasLoginPin: hasLoginPin ?? _hasLoginPin,
  accessToken: accessToken ?? _accessToken,
  companyId: companyId ?? _companyId,
  company: company ?? _company,
);
  num? get userId => _userId;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get middleName => _middleName;
  String? get email => _email;
  String? get mobile => _mobile;
  String? get dob => _dob;
  bool? get hasLoginPin => _hasLoginPin;
  String? get accessToken => _accessToken;
  String? get companyId => _companyId;
  String? get company => _company;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user_id'] = _userId;
    map['first_name'] = _firstName;
    map['last_name'] = _lastName;
    map['middle_name'] = _middleName;
    map['email'] = _email;
    map['mobile'] = _mobile;
    map['dob'] = _dob;
    map['has_login_pin'] = _hasLoginPin;
    map['access_token'] = _accessToken;
    map['company_id'] = _companyId;
    map['company'] = _company;
    return map;
  }

}