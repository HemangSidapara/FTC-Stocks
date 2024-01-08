import 'dart:convert';

/// code : "200"
/// msg : "Get Order Successfully"
/// Data : [{"order_id":"1","name":"Handle 1.0","category":"Test","model_meta":[{"meta_id":"1","size":"4","piece":"12","weight":"8 kg"}]},{"order_id":"2","name":"Handle 1.0","category":"Test","model_meta":[{"meta_id":"2","size":"4","piece":"12","weight":"8 kg"}]},{"order_id":"3","name":"Handle 1.0","category":"Test","model_meta":[{"meta_id":"3","size":"4","piece":"12","weight":"8 kg"}]}]

GetOrdersModel getOrdersModelFromJson(String str) => GetOrdersModel.fromJson(json.decode(str));
String getOrdersModelToJson(GetOrdersModel data) => json.encode(data.toJson());

class GetOrdersModel {
  GetOrdersModel({
    String? code,
    String? msg,
    List<Data>? data,
  }) {
    _code = code;
    _msg = msg;
    _data = data;
  }

  GetOrdersModel.fromJson(dynamic json) {
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
  GetOrdersModel copyWith({
    String? code,
    String? msg,
    List<Data>? data,
  }) =>
      GetOrdersModel(
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
/// name : "Handle 1.0"
/// category : "Test"
/// model_meta : [{"meta_id":"1","size":"4","piece":"12","weight":"8 kg"}]

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());

class Data {
  Data({
    String? orderId,
    String? name,
    String? category,
    String? partyName,
    String? datetime,
    List<ModelMeta>? modelMeta,
  }) {
    _orderId = orderId;
    _name = name;
    _category = category;
    _partyName = partyName;
    _datetime = datetime;
    _modelMeta = modelMeta;
  }

  Data.fromJson(dynamic json) {
    _orderId = json['order_id'];
    _name = json['name'];
    _category = json['category'];
    _partyName = json['party_name'];
    _datetime = json['datetime'];
    if (json['model_meta'] != null) {
      _modelMeta = [];
      json['model_meta'].forEach((v) {
        _modelMeta?.add(ModelMeta.fromJson(v));
      });
    }
  }
  String? _orderId;
  String? _name;
  String? _category;
  String? _partyName;
  String? _datetime;
  List<ModelMeta>? _modelMeta;
  Data copyWith({
    String? orderId,
    String? name,
    String? category,
    String? partyName,
    String? datetime,
    List<ModelMeta>? modelMeta,
  }) =>
      Data(
        orderId: orderId ?? _orderId,
        name: name ?? _name,
        category: category ?? _category,
        partyName: partyName ?? _partyName,
        datetime: datetime ?? _datetime,
        modelMeta: modelMeta ?? _modelMeta,
      );
  String? get orderId => _orderId;
  String? get name => _name;
  String? get category => _category;
  String? get partyName => _partyName;
  String? get datetime => _datetime;
  List<ModelMeta>? get modelMeta => _modelMeta;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['order_id'] = _orderId;
    map['name'] = _name;
    map['category'] = _category;
    map['party_name'] = _partyName;
    map['datetime'] = _datetime;
    if (_modelMeta != null) {
      map['model_meta'] = _modelMeta?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// meta_id : "1"
/// size : "4"
/// piece : "12"
/// weight : "8 kg"

ModelMeta modelMetaFromJson(String str) => ModelMeta.fromJson(json.decode(str));
String modelMetaToJson(ModelMeta data) => json.encode(data.toJson());

class ModelMeta {
  ModelMeta({
    String? metaId,
    String? size,
    String? piece,
    String? weight,
  }) {
    _metaId = metaId;
    _size = size;
    _piece = piece;
    _weight = weight;
  }

  ModelMeta.fromJson(dynamic json) {
    _metaId = json['meta_id'];
    _size = json['size'];
    _piece = json['piece'];
    _weight = json['weight'];
  }
  String? _metaId;
  String? _size;
  String? _piece;
  String? _weight;
  ModelMeta copyWith({
    String? metaId,
    String? size,
    String? piece,
    String? weight,
  }) =>
      ModelMeta(
        metaId: metaId ?? _metaId,
        size: size ?? _size,
        piece: piece ?? _piece,
        weight: weight ?? _weight,
      );
  String? get metaId => _metaId;
  String? get size => _size;
  String? get piece => _piece;
  String? get weight => _weight;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['meta_id'] = _metaId;
    map['size'] = _size;
    map['piece'] = _piece;
    map['weight'] = _weight;
    return map;
  }
}
