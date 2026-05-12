import 'package:cafein/models/notification.dart';
import 'package:cafein/services/api/api_client.dart';
import 'package:cafein/utils/constants.dart';

class NotificationService {
  final ApiClient _apiClient = ApiClient();

  Future<List<NotificationItem>> fetchNotifications() async {
    try {
      final response = await _apiClient.dio.get(AppConstants.API_NOTIF);
      
      if (response.statusCode == 200) {
        final List data = response.data['data'] ?? [];
        return data.map((json) => NotificationItem.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      // Return empty list on error for now to avoid breaking UI completely
      return [];
    }
  }

  Future<void> markAsRead(int notificationId) async {
    try {
      // Backend: POST /api/notif/update/{id}
      await _apiClient.dio.post('${AppConstants.API_NOTIF_UPDATE}/$notificationId');
    } catch (e) {
      // Silently fail or log
    }
  }
}
