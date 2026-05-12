class NotificationItem {
  final int id;
  final String title;
  final String body;
  int statusRead; // 0 (Unread) or 1 (Read)
  final String? type; // Optional extra info
  final int? postId;
  final String? actorName;
  final DateTime createdAt;

  NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.statusRead,
    this.type,
    this.postId,
    this.actorName,
    required this.createdAt,
  });

  bool get isRead => statusRead == 1;
  set isRead(bool value) => statusRead = value ? 1 : 0;

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      statusRead: json['status_read'] ?? 0,
      type: json['type'],
      postId: json['post_id'],
      actorName: json['actor_nickname'] ?? json['actor_fullname'],
      createdAt:
          DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
    );
  }
}
