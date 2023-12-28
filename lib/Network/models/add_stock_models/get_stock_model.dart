import 'dart:convert';

/// code : "200"
/// msg : "get Model Successfully"
/// Data : [{"model_id":"1","name":"Test","category":"Test","model_meta":[{"meta_id":"1","size":"4","weight":"8 kg","piece":"12"},{"meta_id":"2","size":"5","weight":"8 kg","piece":"12"},{"meta_id":"3","size":"6","weight":"8 kg","piece":"12"},{"meta_id":"6","size":"8","weight":"8 kg","piece":"16"}]},{"model_id":"2","name":"","category":"Main Door","model_meta":[{"meta_id":"7","size":"6","weight":"","piece":""},{"meta_id":"8","size":"8","weight":"","piece":""}]}]

GetStockModel getStockModelFromJson(String str) => GetStockModel.fromJson(json.decode(str));
String getStockModelToJson(GetStockModel data) => json.encode(data.toJson());

class GetStockModel {
  GetStockModel({
    String? code,
    String? msg,
    List<Data>? data,
  }) {
    _code = code;
    _msg = msg;
    _data = data;
  }

  GetStockModel.fromJson(dynamic json) {
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
  GetStockModel copyWith({
    String? code,
    String? msg,
    List<Data>? data,
  }) =>
      GetStockModel(
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
/// name : "Test"
/// category : "Test"
/// model_meta : [{"meta_id":"1","size":"4","weight":"8 kg","piece":"12"},{"meta_id":"2","size":"5","weight":"8 kg","piece":"12"},{"meta_id":"3","size":"6","weight":"8 kg","piece":"12"},{"meta_id":"6","size":"8","weight":"8 kg","piece":"16"}]

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
/// weight : "8 kg"
/// piece : "12"

ModelMeta modelMetaFromJson(String str) => ModelMeta.fromJson(json.decode(str));
String modelMetaToJson(ModelMeta data) => json.encode(data.toJson());

class ModelMeta {
  ModelMeta({
    String? metaId,
    String? size,
    String? weightOfPiece,
    String? weight,
    String? piece,
  }) {
    _metaId = metaId;
    _size = size;
    _weightOfPiece = weightOfPiece;
    _weight = weight;
    _piece = piece;
  }

  ModelMeta.fromJson(dynamic json) {
    _metaId = json['meta_id'];
    _size = json['size'];
    _weightOfPiece = json['weightOfPiece'];
    _weight = json['weight'];
    _piece = json['piece'];
  }
  String? _metaId;
  String? _size;
  String? _weightOfPiece;
  String? _weight;
  String? _piece;
  ModelMeta copyWith({
    String? metaId,
    String? size,
    String? weightOfPiece,
    String? weight,
    String? piece,
  }) =>
      ModelMeta(
        metaId: metaId ?? _metaId,
        size: size ?? _size,
        weightOfPiece: weightOfPiece ?? _weightOfPiece,
        weight: weight ?? _weight,
        piece: piece ?? _piece,
      );
  String? get metaId => _metaId;
  String? get size => _size;
  String? get weightOfPiece => _weightOfPiece;
  String? get weight => _weight;
  String? get piece => _piece;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['meta_id'] = _metaId;
    map['size'] = _size;
    map['weightOfPiece'] = _weightOfPiece;
    map['weight'] = _weight;
    map['piece'] = _piece;
    return map;
  }
}
