import 'package:dio/dio.dart';

Dio pastebinDioInstance = Dio(BaseOptions(
  headers: {'content-Type': 'application/json'},
  responseType: ResponseType.json,
  baseUrl: 'https://pastebin.com',
  connectTimeout: Duration(seconds: 5),
  receiveTimeout: Duration(seconds: 15),
));
