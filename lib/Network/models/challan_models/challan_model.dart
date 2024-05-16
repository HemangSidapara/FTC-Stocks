import 'dart:convert';

/// code : "200"
/// msg : "Get Order Successfully"
/// Data : [{"order_id":"1","party_name":"Varun Bhai","phone":"8140258309","datetime":"2024-05-11T05:46:06Z","model_meta":[{"model_id":"1","name":"handle ","category":"Handle","order_meta":[{"meta_id":"1","size":"4","piece":"12","weight":"8 kg","Invoice":"1.pdf"},{"meta_id":"5","size":"4","piece":"50","weight":"3.5 kg","Invoice":"5.pdf"}]},{"model_id":"2","name":"ball","category":"Main Door","order_meta":[{"meta_id":"4","size":"6","piece":"800","weight":"480.0 kg","Invoice":"4.pdf"},{"meta_id":"7","size":"6","piece":"56","weight":"33.6 kg","Invoice":"7.pdf"}]}]},{"order_id":"2","party_name":"Jojo","phone":"9626266066","datetime":"2024-05-11T08:26:43Z","model_meta":[]}]

ChallanModel challanModelFromJson(String str) => ChallanModel.fromJson(json.decode(str));
String challanModelToJson(ChallanModel data) => json.encode(data.toJson());

class ChallanModel {
  ChallanModel({
    String? code,
    String? msg,
    List<Data>? data,
  }) {
    _code = code;
    _msg = msg;
    _data = data;
  }

  ChallanModel.fromJson(dynamic json) {
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
  ChallanModel copyWith({
    String? code,
    String? msg,
    List<Data>? data,
  }) =>
      ChallanModel(
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
/// phone : "8140258309"
/// datetime : "2024-05-11T05:46:06Z"
/// model_meta : [{"model_id":"1","name":"handle ","category":"Handle","order_meta":[{"meta_id":"1","size":"4","piece":"12","weight":"8 kg","Invoice":"1.pdf"},{"meta_id":"5","size":"4","piece":"50","weight":"3.5 kg","Invoice":"5.pdf"}]},{"model_id":"2","name":"ball","category":"Main Door","order_meta":[{"meta_id":"4","size":"6","piece":"800","weight":"480.0 kg","Invoice":"4.pdf"},{"meta_id":"7","size":"6","piece":"56","weight":"33.6 kg","Invoice":"7.pdf"}]}]

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());

class Data {
  Data({
    String? orderId,
    String? partyName,
    String? phone,
    String? datetime,
    List<ModelMeta>? modelMeta,
  }) {
    _orderId = orderId;
    _partyName = partyName;
    _phone = phone;
    _datetime = datetime;
    _modelMeta = modelMeta;
  }

  Data.fromJson(dynamic json) {
    _orderId = json['order_id'];
    _partyName = json['party_name'];
    _phone = json['phone'];
    _datetime = json['datetime'];
    if (json['model_meta'] != null) {
      _modelMeta = [];
      json['model_meta'].forEach((v) {
        _modelMeta?.add(ModelMeta.fromJson(v));
      });
    }
  }
  String? _orderId;
  String? _partyName;
  String? _phone;
  String? _datetime;
  List<ModelMeta>? _modelMeta;
  Data copyWith({
    String? orderId,
    String? partyName,
    String? phone,
    String? datetime,
    List<ModelMeta>? modelMeta,
  }) =>
      Data(
        orderId: orderId ?? _orderId,
        partyName: partyName ?? _partyName,
        phone: phone ?? _phone,
        datetime: datetime ?? _datetime,
        modelMeta: modelMeta ?? _modelMeta,
      );
  String? get orderId => _orderId;
  String? get partyName => _partyName;
  String? get phone => _phone;
  String? get datetime => _datetime;
  List<ModelMeta>? get modelMeta => _modelMeta;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['order_id'] = _orderId;
    map['party_name'] = _partyName;
    map['phone'] = _phone;
    map['datetime'] = _datetime;
    if (_modelMeta != null) {
      map['model_meta'] = _modelMeta?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// model_id : "1"
/// name : "handle "
/// category : "Handle"
/// order_meta : [{"meta_id":"1","size":"4","piece":"12","weight":"8 kg","Invoice":"1.pdf"},{"meta_id":"5","size":"4","piece":"50","weight":"3.5 kg","Invoice":"5.pdf"}]

ModelMeta modelMetaFromJson(String str) => ModelMeta.fromJson(json.decode(str));
String modelMetaToJson(ModelMeta data) => json.encode(data.toJson());

class ModelMeta {
  ModelMeta({
    String? modelId,
    String? name,
    String? category,
    List<OrderMeta>? orderMeta,
  }) {
    _modelId = modelId;
    _name = name;
    _category = category;
    _orderMeta = orderMeta;
  }

  ModelMeta.fromJson(dynamic json) {
    _modelId = json['model_id'];
    _name = json['name'];
    _category = json['category'];
    if (json['order_meta'] != null) {
      _orderMeta = [];
      json['order_meta'].forEach((v) {
        _orderMeta?.add(OrderMeta.fromJson(v));
      });
    }
  }
  String? _modelId;
  String? _name;
  String? _category;
  List<OrderMeta>? _orderMeta;
  ModelMeta copyWith({
    String? modelId,
    String? name,
    String? category,
    List<OrderMeta>? orderMeta,
  }) =>
      ModelMeta(
        modelId: modelId ?? _modelId,
        name: name ?? _name,
        category: category ?? _category,
        orderMeta: orderMeta ?? _orderMeta,
      );
  String? get modelId => _modelId;
  String? get name => _name;
  String? get category => _category;
  List<OrderMeta>? get orderMeta => _orderMeta;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['model_id'] = _modelId;
    map['name'] = _name;
    map['category'] = _category;
    if (_orderMeta != null) {
      map['order_meta'] = _orderMeta?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// meta_id : "1"
/// size : "4"
/// piece : "12"
/// weight : "8 kg"
/// Invoice : "1.pdf"

OrderMeta orderMetaFromJson(String str) => OrderMeta.fromJson(json.decode(str));
String orderMetaToJson(OrderMeta data) => json.encode(data.toJson());

class OrderMeta {
  OrderMeta({
    String? metaId,
    String? size,
    String? piece,
    String? weight,
    String? invoice,
  }) {
    _metaId = metaId;
    _size = size;
    _piece = piece;
    _weight = weight;
    _invoice = invoice;
  }

  OrderMeta.fromJson(dynamic json) {
    _metaId = json['meta_id'];
    _size = json['size'];
    _piece = json['piece'];
    _weight = json['weight'];
    _invoice = json['Invoice'];
  }
  String? _metaId;
  String? _size;
  String? _piece;
  String? _weight;
  String? _invoice;
  OrderMeta copyWith({
    String? metaId,
    String? size,
    String? piece,
    String? weight,
    String? invoice,
  }) =>
      OrderMeta(
        metaId: metaId ?? _metaId,
        size: size ?? _size,
        piece: piece ?? _piece,
        weight: weight ?? _weight,
        invoice: invoice ?? _invoice,
      );
  String? get metaId => _metaId;
  String? get size => _size;
  String? get piece => _piece;
  String? get weight => _weight;
  String? get invoice => _invoice;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['meta_id'] = _metaId;
    map['size'] = _size;
    map['piece'] = _piece;
    map['weight'] = _weight;
    map['Invoice'] = _invoice;
    return map;
  }
}
