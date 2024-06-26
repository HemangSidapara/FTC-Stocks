import 'dart:convert';

/// code : "200"
/// msg : "Get Required Stock Successfully"
/// Data : [{"model_id":"1","name":"handle ","category":"Handle","model_meta":[{"meta_id":"1","size":"4","piece":"-23","weight":"-15.93 kg"}]},{"model_id":"2","name":"ball","category":"Main Door","model_meta":[{"meta_id":"3","size":"3","piece":"-100","weight":"-50 kg"},{"meta_id":"4","size":"6","piece":"-750","weight":"-450 kg"}]},{"model_id":"8","name":"Handle 2.0","category":"Handle","model_meta":[]},{"model_id":"9","name":"handle 3.0","category":"Handle","model_meta":[]}]

RequiredStockModel requiredStockModelFromJson(String str) => RequiredStockModel.fromJson(json.decode(str));
String requiredStockModelToJson(RequiredStockModel data) => json.encode(data.toJson());

class RequiredStockModel {
  RequiredStockModel({
    String? code,
    String? msg,
    List<Data>? data,
  }) {
    _code = code;
    _msg = msg;
    _data = data;
  }

  RequiredStockModel.fromJson(dynamic json) {
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
  RequiredStockModel copyWith({
    String? code,
    String? msg,
    List<Data>? data,
  }) =>
      RequiredStockModel(
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
/// name : "handle "
/// category : "Handle"
/// model_meta : [{"meta_id":"1","size":"4","piece":"-23","weight":"-15.93 kg"}]

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

/// meta_id : "1"
/// size : "4"
/// piece : "-23"
/// weight : "-15.93 kg"

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
