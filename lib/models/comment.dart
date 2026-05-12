class Comment {
  final int id;
  final int idUser;
  final String? title;
  final String? description;
  final String? username;
  final String? accountName;
  final String? nickname;
  final String? fullname;
  final String? company;
  final String? toAnswerPosting;
  final List<Comment> repliedData;
  final DateTime? createdAt;
  int upvote;
  int downvote;

  Comment({
    required this.id,
    this.idUser = 0,
    this.title,
    this.description,
    this.username,
    this.accountName,
    this.nickname,
    this.fullname,
    this.company,
    this.toAnswerPosting,
    this.repliedData = const [],
    this.createdAt,
    this.upvote = 0,
    this.downvote = 0,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    List<Comment> replies = [];
    if (json['repliedData'] != null && json['repliedData'] is List) {
      replies = (json['repliedData'] as List)
          .map((r) => Comment.fromJson(Map<String, dynamic>.from(r)))
          .toList();
    }
    return Comment(
      id: _toInt(json['id']),
      idUser: _toInt(json['id_user']),
      title: json['title']?.toString(),
      description: json['description']?.toString(),
      username: json['username']?.toString(),
      accountName: json['account_name']?.toString(),
      nickname: json['nickname']?.toString(),
      fullname: json['fullname']?.toString(),
      company: json['company']?.toString(),
      toAnswerPosting: json['toAnswer_posting']?.toString(),
      repliedData: replies,
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
      upvote: _toInt(json['upvote']),
      downvote: _toInt(json['downvote']),
    );
  }

  static int _toInt(dynamic value, {int defaultValue = 0}) {
    if (value == null) return defaultValue;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? defaultValue;
    if (value is double) return value.toInt();
    return defaultValue;
  }
}
