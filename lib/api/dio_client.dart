import 'package:dio/dio.dart';

class DioClient {
  final Dio _dio;

  DioClient(this._dio);

  Future<dynamic> get(
    String uri, {
    Map<String, dynamic>? queryParams,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceivedProgress,
  }) async {
    try {
      final Response response = await _dio.get(
        uri,
        queryParameters: queryParams,
        options: options,
        onReceiveProgress: onReceivedProgress,
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
