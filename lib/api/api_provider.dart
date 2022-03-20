import 'package:dio/dio.dart';
import 'package:q_test/api/endpoints.dart';
import 'package:q_test/models/comments_model.dart';
import 'package:q_test/providers/db_provider.dart';

class ApiProvider {
  Dio _dio = Dio();

  ApiProvider({Dio? dio}) {
    _dio = dio ?? Dio();
  }

  // GET comments
  Future<List<dynamic>> fetchComments(int pageNumber, int limit) async {
    try {
      final response = await _dio
          .get(Endpoints.getComments + '?_page=$pageNumber&_limit=$limit');

      return (response.data as List).map((comment) {
        DBProvider.db.insertComments(CommentsModel.fromJson(comment));
      }).toList();

      //return response.data;
    } catch (error) {
      rethrow;
    }
  }
}
