import 'package:dio/dio.dart';

Dio dioInstance = Dio(BaseOptions(
  headers: {'content-Type': 'application/json'},
  responseType: ResponseType.json,
  baseUrl: 'https://europe-west3-truckonia-f976d.cloudfunctions.net',
  connectTimeout: Duration(seconds: 5),
  receiveTimeout: Duration(seconds: 15),
));
