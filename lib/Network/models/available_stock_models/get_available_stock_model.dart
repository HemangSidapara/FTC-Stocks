import 'dart:convert';

/// code : "200"
/// msg : "Get Avaiable Stock Successfully"
/// Data : [{"model_id":"1","name":"Handle 1.0","category":"Handle","model_meta":[{"meta_id":"47","size":"3","piece":"40","weight":"9.6"},{"meta_id":"48","size":"6","piece":"50","weight":"100"}]},{"model_id":"2","name":"Handle 1.1","category":"Handle","model_meta":[{"meta_id":"55","size":"3","piece":"190","weight":"19"}]},{"model_id":"3","name":"Door Handle","category":"Handle","model_meta":[{"meta_id":"56","size":"4","piece":"156","weight":"29"},{"meta_id":"57","size":"6","piece":"10","weight":"1.2"}]},{"model_id":"10","name":"custom size","category":"Dabbi","model_meta":[{"meta_id":"59","size":"10 dabbi","piece":"60","weight":"5.34"}]}]

GetAvailableStockModel getAvailableStockModelFromJson(String str) => GetAvailableStockModel.fromJson(json.decode(str));
String getAvailableStockModelToJson(GetAvailableStockModel data) => json.encode(data.toJson());

class GetAvailableStockModel {
  GetAvailableStockModel({
    String? code,
    String? msg,
    List<Data>? data,
  }) {
    _code = code;
    _msg = msg;
    _data = data;
  }

  GetAvailableStockModel.fromJson(dynamic json) {
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
  GetAvailableStockModel copyWith({
    String? code,
    String? msg,
    List<Data>? data,
  }) =>
      GetAvailableStockModel(
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

/// model_id : "1"
/// name : "Handle 1.0"
/// category : "Handle"
/// model_meta : [{"meta_id":"47","size":"3","piece":"40","weight":"9.6"},{"meta_id":"48","size":"6","piece":"50","weight":"100"}]

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());

class Data {
  Data({
    String? modelId,
    String? name,
    String? category,
    List<ModelMeta>? modelMeta,
  }) {
    _modelId = modelId;
    _name = name;
    _category = category;
    _modelMeta = modelMeta;
  }

  Data.fromJson(dynamic json) {
    _modelId = json['model_id'];
    _name = json['name'];
    _category = json['category'];
    if (json['model_meta'] != null) {
      _modelMeta = [];
      json['model_meta'].forEach((v) {
        _modelMeta?.add(ModelMeta.fromJson(v));
      });
    }
  }
  String? _modelId;
  String? _name;
  String? _category;
  List<ModelMeta>? _modelMeta;
  Data copyWith({
    String? modelId,
    String? name,
    String? category,
    List<ModelMeta>? modelMeta,
  }) =>
      Data(
        modelId: modelId ?? _modelId,
        name: name ?? _name,
        category: category ?? _category,
        modelMeta: modelMeta ?? _modelMeta,
      );
  String? get modelId => _modelId;
  String? get name => _name;
  String? get category => _category;
  List<ModelMeta>? get modelMeta => _modelMeta;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['model_id'] = _modelId;
    map['name'] = _name;
    map['category'] = _category;
    if (_modelMeta != null) {
      map['model_meta'] = _modelMeta?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// meta_id : "47"
/// size : "3"
/// piece : "40"
/// weight : "9.6"

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
