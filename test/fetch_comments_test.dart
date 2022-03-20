import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:q_test/api/api_provider.dart';
import 'package:q_test/api/endpoints.dart';

import 'test_constants.dart';

void main() async {
  final dio = Dio();
  final dioAdapter = DioAdapter(dio: dio);
  const int pageNumber = 1;
  const int limit = 2;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();

    const MethodChannel channel =
        MethodChannel('plugins.flutter.io/path_provider');
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return ".";
    });
    dio.httpClientAdapter = dioAdapter;
  });

  group('API test - fetch comments', () {
    test('Get comments from API', () async {
      dioAdapter.onGet(
        Endpoints.getComments + '?_page=$pageNumber&_limit=$limit',
        (request) {
          return request.reply(200, data);
        },
        data: null,
      );

      final service = ApiProvider(
        dio: dio,
      );

      final response = await service.fetchComments(pageNumber, limit);

      expect(response, data);
    });
  });
}
