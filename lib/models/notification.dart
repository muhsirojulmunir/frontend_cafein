class NotificationItem {
  final int id;
  final String title;
  final String body;
  int statusRead; // 0 (Unread) or 1 (Read)
  final String? type; // 'like', 'comment', 'follow', or null
  final int? postId;
  final int? actorUserId; // id_user_follow — siapa yang melakukan aksi
  final String? actorName;
  final DateTime createdAt;

  NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.statusRead,
    this.type,
    this.postId,
    this.actorUserId,
    this.actorName,
    required this.createdAt,
  });

  bool get isRead => statusRead == 1;
  set isRead(bool value) => statusRead = value ? 1 : 0;

  /// Tentukan tipe notifikasi secara akurat
  /// Backend tidak selalu menyimpan 'type', jadi fallback menggunakan title/body
  String get resolvedType {
    if (type != null && type!.isNotEmpty) return type!;
    final lower = '${title.toLowerCase()} ${body.toLowerCase()}';
    if (lower.contains('mengikuti')) return 'follow';
    if (lower.contains('menyukai')) return 'like';
    if (lower.contains('komentar') || lower.contains('membalas')) return 'comment';
    return 'other';
  }

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: _toInt(json['id']),
      title: json['title']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
      statusRead: _toInt(json['status_read']),
      type: json['type']?.toString(),
      postId: _toNullableInt(json['post_id']),
      actorUserId: _toNullableInt(json['id_user_follow']),
      actorName: (json['actor_nickname'] ?? json['actor_fullname'])?.toString(),
      createdAt:
          DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  static int _toInt(dynamic value, {int defaultValue = 0}) {
    if (value == null) return defaultValue;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? defaultValue;
    if (value is double) return value.toInt();
    return defaultValue;
  }

  static int? _toNullableInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    if (value is double) return value.toInt();
    return null;
  }
}
