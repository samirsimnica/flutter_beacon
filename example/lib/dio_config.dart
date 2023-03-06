import 'package:dio/dio.dart';

class DioConfig {
  DioConfig();

  Dio? getBaseConfig() {
    Dio dio = Dio();

    BaseOptions options = BaseOptions(
      headers: {'content-Type': 'application/json'},
      responseType: ResponseType.json,
      baseUrl: '10.0.2.2',
      connectTimeout: Duration(seconds: 5),
      receiveTimeout: Duration(seconds: 15),
    );
    dio.interceptors.add(InterceptorsWrapper(
      onError: ((e, handler) {
        print(e);
        handler.next(e);
      }),
      onRequest: (options, handler) async {
        handler.next(options);
      },
      onResponse: (e, handler) {
        print(e);
        handler.next(e);
      },
    ));

    dio.options = options;
    return dio;
  }
}
