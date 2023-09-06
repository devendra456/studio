import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'api_routes.dart';
import 'pretty_dio_logger.dart';

class ApiBaseClient {
  static final BaseOptions _opts = BaseOptions(
    baseUrl: APIRoutes.baseURL,
    connectTimeout: const Duration(hours: 1),
  );

  static Dio _createDio() {
    return Dio(_opts);
  }

  static Dio _addInterceptors(Dio dio) {
    if (kDebugMode && !kIsWeb) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          error: true,
          compact: true,
        ),
      );
    }
    return dio;
  }

  static final _dio = _createDio();
  static final client = _addInterceptors(_dio);
}
