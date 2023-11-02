
import 'package:dio/dio.dart';

class ResponseModel {
  int? statusCode;
  Response? response;

  ResponseModel({this.statusCode, this.response});

  get data => response!.data['data'];

  get message => response!.data['message'];

  getExtraData(String paramName){
    return response!.data[paramName];
  }

}

