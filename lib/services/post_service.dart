import 'package:cafein/models/post.dart';
import 'package:cafein/services/api/api_client.dart';
import 'package:cafein/services/local/token.dart';
import 'package:cafein/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;

class PostService {
  final ApiClient _apiClient = ApiClient();

  /// Fetch home feed (posts from users NOT followed) with pagination
  Future<Map<String, dynamic>> fetchFeed({int page = 1}) async {
    try {
      final response = await _apiClient.dio.get(
        AppConstants.API_POSTING,
        queryParameters: {'page': page},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final List<dynamic> postsJson = data['data'] ?? [];
        final posts = postsJson
            .map((j) => Post.fromJson(Map<String, dynamic>.from(j)))
            .toList();
        return {
          'posts': posts,
          'lastPage': data['last_page'] ?? 1,
          'currentPage': data['current_page'] ?? page,
        };
      } else {
        throw Exception('Gagal memuat feed');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  /// Fetch following feed (posts from users followed) with pagination
  Future<Map<String, dynamic>> fetchFollowingFeed({int page = 1}) async {
    try {
      final response = await _apiClient.dio.get(
        AppConstants.API_POSTING_FOLLOWING,
        queryParameters: {'page': page},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final List<dynamic> postsJson = data['data'] ?? [];
        final posts = postsJson
            .map((j) => Post.fromJson(Map<String, dynamic>.from(j)))
            .toList();
        return {
          'posts': posts,
          'lastPage': data['last_page'] ?? 1,
          'currentPage': data['current_page'] ?? page,
        };
      } else {
        throw Exception('Gagal memuat feed mengikuti');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  /// Create a new post (multipart form-data)
  Future<bool> createPost({
    required String title,
    required String description,
    PlatformFile? image,
    PlatformFile? doc,
    String? codeIlmu,
  }) async {
    try {
      final formData = FormData.fromMap({
        'title': title,
        'description': description,
        if (codeIlmu != null && codeIlmu.isNotEmpty) 'id_knowField': codeIlmu,
      });

      if (image != null) {
        if (kIsWeb) {
          formData.files.add(
            MapEntry(
              'image',
              MultipartFile.fromBytes(image.bytes!, filename: image.name),
            ),
          );
        } else {
          formData.files.add(
            MapEntry(
              'image',
              await MultipartFile.fromFile(
                image.path!,
                filename: p.basename(image.path!),
              ),
            ),
          );
        }
      }

      if (doc != null) {
        if (kIsWeb) {
          formData.files.add(
            MapEntry(
              'doc',
              MultipartFile.fromBytes(doc.bytes!, filename: doc.name),
            ),
          );
        } else {
          formData.files.add(
            MapEntry(
              'doc',
              await MultipartFile.fromFile(
                doc.path!,
                filename: p.basename(doc.path!),
              ),
            ),
          );
        }
      }

      final response = await _apiClient.dio.post(
        AppConstants.API_POSTING_STORE,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } on DioException catch (e) {
      throw Exception('Gagal membuat posting: ${e.message}');
    }
  }

  /// Update an existing post
  Future<bool> updatePost({
    required int postId,
    required String title,
    required String description,
    PlatformFile? image,
    PlatformFile? doc,
    String? codeIlmu,
  }) async {
    try {
      final formData = FormData.fromMap({
        'title': title,
        'description': description,
        if (codeIlmu != null && codeIlmu.isNotEmpty) 'id_knowField': codeIlmu,
      });

      if (image != null) {
        if (kIsWeb) {
          formData.files.add(
            MapEntry(
              'image',
              MultipartFile.fromBytes(image.bytes!, filename: image.name),
            ),
          );
        } else {
          formData.files.add(
            MapEntry(
              'image',
              await MultipartFile.fromFile(
                image.path!,
                filename: p.basename(image.path!),
              ),
            ),
          );
        }
      }

      if (doc != null) {
        if (kIsWeb) {
          formData.files.add(
            MapEntry(
              'doc',
              MultipartFile.fromBytes(doc.bytes!, filename: doc.name),
            ),
          );
        } else {
          formData.files.add(
            MapEntry(
              'doc',
              await MultipartFile.fromFile(
                doc.path!,
                filename: p.basename(doc.path!),
              ),
            ),
          );
        }
      }

      final response = await _apiClient.dio.post(
        '${AppConstants.API_POSTING}/update/$postId',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } on DioException catch (e) {
      throw Exception('Gagal memperbarui posting: ${e.message}');
    }
  }

  /// Vote on a post (1=upvote, 2=downvote)
  Future<bool> vote({required int postId, required int voteStatus}) async {
    try {
      final response = await _apiClient.dio.post(
        AppConstants.API_VOTE_STORE,
        data: {'id_postings': postId, 'vote_status': voteStatus},
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } on DioException catch (e) {
      throw Exception('Gagal memberikan vote: ${e.message}');
    }
  }

  /// Follow or unfollow a user
  /// [followStatus] = 1 for follow, 3 for unfollow
  Future<bool> followUser({
    required int userId,
    required int followStatus,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        AppConstants.API_FOLLOW_USER,
        data: {'following_id': userId, 'follow_status': followStatus},
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } on DioException catch (e) {
      throw Exception('Gagal mengubah status follow: ${e.message}');
    }
  }

  /// Delete a post
  Future<bool> deletePost(int postId) async {
    try {
      final response = await _apiClient.dio.post(
        '${AppConstants.API_POSTING_DESTROY}/$postId',
      );
      return response.statusCode == 200 || response.statusCode == 204;
    } on DioException catch (e) {
      throw Exception('Gagal menghapus posting: ${e.message}');
    }
  }

  /// Fetch user profile details
  Future<Map<String, dynamic>> fetchUserProfile(int userId) async {
    try {
      final response = await _apiClient.dio.get(
        '${AppConstants.API_PROFILE}/$userId',
      );
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map) {
          if (data.containsKey('data') && data['data'] != null) {
            return Map<String, dynamic>.from(data['data']);
          }
          // If the backend returned the user object directly without 'data' wrapper
          return Map<String, dynamic>.from(data);
        }
        throw Exception('Data profil tidak valid');
      } else {
        throw Exception('Gagal memuat profil user');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  /// Fetch posts by a specific user
  Future<List<Post>> fetchUserPosts(int userId) async {
    try {
      final response = await _apiClient.dio.get(
        '${AppConstants.API_POSTING_INDEX_PROFILE}/$userId',
      );
      if (response.statusCode == 200) {
        final List<dynamic> postsJson = response.data['data'] ?? [];
        return postsJson
            .map((j) => Post.fromJson(Map<String, dynamic>.from(j)))
            .toList();
      } else {
        throw Exception('Gagal memuat postingan user');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  /// Fetch answers/comments by a specific user
  Future<List<Post>> fetchUserAnswers(int userId) async {
    try {
      final response = await _apiClient.dio.get(
        '${AppConstants.API_POSTING_INDEX_ANSWER}/$userId',
      );
      if (response.statusCode == 200) {
        final List<dynamic> postsJson = response.data['data'] ?? [];
        return postsJson
            .map((j) => Post.fromJson(Map<String, dynamic>.from(j)))
            .toList();
      } else {
        throw Exception('Gagal memuat jawaban user');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  /// Fetch a single post by ID
  Future<Map<String, dynamic>?> fetchPostById(int postId) async {
    try {
      final response = await _apiClient.dio.get(
        '${AppConstants.API_POSTING_SHOW}/$postId',
      );
      if (response.statusCode == 200 && response.data != null) {
        return response.data['data'];
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Fetch user followers
  Future<List<dynamic>> fetchUserFollowers(int userId) async {
    try {
      final response = await _apiClient.dio.get(
        '${AppConstants.API_FOLLOW_USER_SHOW_FOLLOWERS}/$userId',
      );
      if (response.data is Map && response.data.containsKey('data')) {
        return response.data['data'] ?? [];
      }
      return response.data is List ? response.data : [];
    } catch (e) {
      return [];
    }
  }

  /// Fetch user following
  Future<List<dynamic>> fetchUserFollowing(int userId) async {
    try {
      final response = await _apiClient.dio.get(
        '${AppConstants.API_FOLLOW_USER_SHOW_FOLLOWINGS}/$userId',
      );
      if (response.data is Map && response.data.containsKey('data')) {
        return response.data['data'] ?? [];
      }
      return response.data is List ? response.data : [];
    } catch (e) {
      return [];
    }
  }

  /// Fetch user credentials
  Future<List<dynamic>> fetchUserCredentials(int userId) async {
    try {
      final response = await _apiClient.dio.get(
        '${AppConstants.API_CREDENTIAL_INDEX_USER}/$userId',
      );
      if (response.data != null) {
        if (response.data is Map && response.data.containsKey('data')) {
          return response.data['data'] ?? [];
        } else if (response.data is List) {
          return response.data;
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Submit a comment to a post
  Future<bool> submitComment({
    required int postId,
    required String description,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        AppConstants.API_REPLY_STORE,
        data: {'id_postings': postId, 'description': description},
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } on DioException catch (e) {
      throw Exception('Gagal mengirim komentar: ${e.message}');
    }
  }

  /// Build authenticated image URL for a post image
  Future<Map<String, String>> getImageHeaders() async {
    final token = await Token.getToken();
    return {'Authorization': 'Bearer $token', 'Accept': 'application/json'};
  }

  /// Get the full URL for a post image
  String getImageUrl(String imageName) {
    return '${AppConstants.BASE_URL}${AppConstants.API_POSTING_SHOW_IMAGE}/$imageName';
  }

  /// Get the full URL for downloading a doc
  String getDocDownloadUrl(int docId) {
    return '${AppConstants.BASE_URL}${AppConstants.API_POSTING_DOWNLOAD_DOC}/$docId';
  }

  /// Update profile photo
  Future<String?> updateProfilePhoto(String imagePath) async {
    try {
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          imagePath,
          filename: p.basename(imagePath),
        ),
      });

      final response = await _apiClient.dio.post(
        AppConstants.API_UPDATE_PROFILE_PHOTO,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      if (response.statusCode == 200) {
        return null; // Success
      }
      return 'Gagal memperbarui foto profil';
    } on DioException catch (e) {
      if (e.response != null && e.response!.data != null) {
        final data = e.response!.data;
        if (data is Map && data.containsKey('msg')) {
          final errors = data['msg'];
          if (errors is Map && errors.containsKey('image')) {
            return errors['image'][0].toString();
          } else if (errors is String) {
            return errors;
          }
        }
      }
      return 'Terjadi kesalahan: ${e.message}';
    }
  }
 
  /// Update account name (display name)
  Future<bool> updateAccountName(String newName) async {
    try {
      final response = await _apiClient.dio.post(
        AppConstants.API_UPDATE_ACCOUNT_NAME,
        data: {'account_name': newName},
      );
      return response.statusCode == 200;
    } on DioException catch (e) {
      throw Exception('Gagal memperbarui nama: ${e.message}');
    }
  }

  /// Get the full URL for profile image
  String getProfileImageUrl(String imageName) {
    return '${AppConstants.BASE_URL}${AppConstants.API_SHOW_IMAGE_AVA}/$imageName';
  }

  /// Search posts by query
  Future<List<Post>> searchPosts(String query) async {
    try {
      final response = await _apiClient.dio.get(
        AppConstants.API_POSTING_SEARCH,
        queryParameters: {'q': query},
      );

      if (response.statusCode == 200) {
        final List<dynamic> postsJson = response.data['data'] ?? [];
        return postsJson
            .map((j) => Post.fromJson(Map<String, dynamic>.from(j)))
            .toList();
      } else {
        throw Exception('Gagal mencari postingan');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }
}
