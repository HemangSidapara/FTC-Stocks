import 'dart:convert';

/// code : "200"
/// msg : "Login Successfully"
/// token : "abc"
/// Data : [{"user_id":"1","phone":"+918128500576"}]

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));
String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  LoginModel({
    String? code,
    String? msg,
    String? token,
    List<Data>? data,
  }) {
    _code = code;
    _msg = msg;
    _token = token;
    _data = data;
  }

  LoginModel.fromJson(dynamic json) {
    _code = json['code'];
    _msg = json['msg'];
    _token = json['token'];
    if (json['Data'] != null) {
      _data = [];
      json['Data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
  }
  String? _code;
  String? _msg;
  String? _token;
  List<Data>? _data;
  LoginModel copyWith({
    String? code,
    String? msg,
    String? token,
    List<Data>? data,
  }) =>
      LoginModel(
        code: code ?? _code,
        msg: msg ?? _msg,
        token: token ?? _token,
        data: data ?? _data,
      );
  String? get code => _code;
  String? get msg => _msg;
  String? get token => _token;
  List<Data>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = _code;
    map['msg'] = _msg;
    map['token'] = _token;
    if (_data != null) {
      map['Data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// user_id : "1"
/// phone : "+918128500576"

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());

class Data {
  Data({
    String? userId,
    String? phone,
  }) {
    _userId = userId;
    _phone = phone;
  }

  Data.fromJson(dynamic json) {
    _userId = json['user_id'];
    _phone = json['phone'];
  }
  String? _userId;
  String? _phone;
  Data copyWith({
    String? userId,
    String? phone,
  }) =>
      Data(
        userId: userId ?? _userId,
        phone: phone ?? _phone,
      );
  String? get userId => _userId;
  String? get phone => _phone;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user_id'] = _userId;
    map['phone'] = _phone;
    return map;
  }
}
