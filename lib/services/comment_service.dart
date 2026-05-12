import 'package:cafein/models/comment.dart';
import 'package:cafein/services/api/api_client.dart';
import 'package:cafein/utils/constants.dart';
import 'package:dio/dio.dart';

class CommentService {
  final ApiClient _apiClient = ApiClient();

  /// Fetch threaded comments for a post
  Future<List<Comment>> fetchComments(int postId) async {
    try {
      final response = await _apiClient.dio.get(
        '${AppConstants.API_POSTING_COMMENTS}/$postId',
      );

      if (response.statusCode == 200) {
        final data = response.data;
        // Response can be a list directly or nested inside 'data'
        List<dynamic> commentsJson;
        if (data is List) {
          commentsJson = data;
        } else if (data is Map && data.containsKey('data')) {
          commentsJson = data['data'] is List ? data['data'] : [];
        } else {
          commentsJson = [];
        }
        return commentsJson
            .map((j) => Comment.fromJson(Map<String, dynamic>.from(j)))
            .toList();
      } else {
        throw Exception('Gagal memuat komentar');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  /// Fetch comment count for a post (lightweight)
  Future<int> fetchCommentCount(int postId) async {
    try {
      final result = await fetchComments(postId);
      // Extract actual comments (same logic as controllers)
      List<Comment> actualComments;
      if (result.isNotEmpty && result.first.repliedData.isNotEmpty) {
        actualComments = result.first.repliedData;
      } else if (result.isNotEmpty && result.first.repliedData.isEmpty) {
        actualComments = [];
      } else {
        actualComments = result;
      }
      return _countAllComments(actualComments);
    } catch (_) {
      return 0;
    }
  }

  /// Add a comment/reply to a post
  Future<bool> addComment({
    required int postId,
    String? title,
    required String description,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        AppConstants.API_REPLY_STORE,
        data: {
          'id_postings': postId,
          'title': title ?? 'Komentar',
          'description': description,
        },
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } on DioException catch (e) {
      throw Exception('Gagal menambah komentar: ${e.message}');
    }
  }

  /// Recursively count all comments including nested replies
  int _countAllComments(List<Comment> comments) {
    int count = comments.length;
    for (final comment in comments) {
      count += _countAllComments(comment.repliedData);
    }
    return count;
  }
}
