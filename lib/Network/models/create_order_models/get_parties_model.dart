import 'dart:convert';

/// code : "200"
/// msg : "Get Parties Successfully"
/// Data : [{"order_id":"1","party_name":"Varun Bhai","category":"Test","phone":"8140258309"}]

GetPartiesModel getPartiesModelFromJson(String str) => GetPartiesModel.fromJson(json.decode(str));
String getPartiesModelToJson(GetPartiesModel data) => json.encode(data.toJson());

class GetPartiesModel {
  GetPartiesModel({
    String? code,
    String? msg,
    List<Data>? data,
  }) {
    _code = code;
    _msg = msg;
    _data = data;
  }

  GetPartiesModel.fromJson(dynamic json) {
    _code = json['code'];
    _msg = json['msg'];
    if (json['Data'] != null) {
      _data = [];
      json['Data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
  }
  String? _code;
  String? _msg;
  List<Data>? _data;
  GetPartiesModel copyWith({
    String? code,
    String? msg,
    List<Data>? data,
  }) =>
      GetPartiesModel(
        code: code ?? _code,
        msg: msg ?? _msg,
        data: data ?? _data,
      );
  String? get code => _code;
  String? get msg => _msg;
  List<Data>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = _code;
    map['msg'] = _msg;
    if (_data != null) {
      map['Data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// order_id : "1"
/// party_name : "Varun Bhai"
/// category : "Test"
/// phone : "8140258309"

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());

class Data {
  Data({
    String? orderId,
    String? partyName,
    String? category,
    String? phone,
  }) {
    _orderId = orderId;
    _partyName = partyName;
    _category = category;
    _phone = phone;
  }

  Data.fromJson(dynamic json) {
    _orderId = json['order_id'];
    _partyName = json['party_name'];
    _category = json['category'];
    _phone = json['phone'];
  }
  String? _orderId;
  String? _partyName;
  String? _category;
  String? _phone;
  Data copyWith({
    String? orderId,
    String? partyName,
    String? category,
    String? phone,
  }) =>
      Data(
        orderId: orderId ?? _orderId,
        partyName: partyName ?? _partyName,
        category: category ?? _category,
        phone: phone ?? _phone,
      );
  String? get orderId => _orderId;
  String? get partyName => _partyName;
  String? get category => _category;
  String? get phone => _phone;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['order_id'] = _orderId;
    map['party_name'] = _partyName;
    map['category'] = _category;
    map['phone'] = _phone;
    return map;
  }
}
