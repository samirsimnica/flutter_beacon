import 'package:dio/dio.dart';

Dio dioInstance = Dio(BaseOptions(
  headers: {'content-Type': 'application/json'},
  responseType: ResponseType.json,
  baseUrl: 'http://10.0.2.2:5000',
  connectTimeout: Duration(seconds: 5),
  receiveTimeout: Duration(seconds: 15),
));
