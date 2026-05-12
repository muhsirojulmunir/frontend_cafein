class Post {
  final int id;
  final int idUser;
  final String? idKnowField;
  final String? title;
  final String description;
  final String? image;
  final String? doc;
  final String? status;
  final String? username;
  final String? accountName;
  final String? nickname;
  final String? fullname;
  final String? company;
  int? followStatus;
  int? voteStatus;
  int upvote;
  int downvote;
  final int point;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? knowFieldName;
  final String? knowFieldCode;
  final String? pinnedText;
  final List<dynamic>? badges;
  final String? parentNickname;
  final String? parentTitle;
  final String? parentDescription;

  Post({
    required this.id,
    required this.idUser,
    this.idKnowField,
    this.title,
    required this.description,
    this.image,
    this.doc,
    this.status,
    this.username,
    this.accountName,
    this.nickname,
    this.fullname,
    this.company,
    this.followStatus,
    this.voteStatus,
    this.upvote = 0,
    this.downvote = 0,
    this.point = 0,
    required this.createdAt,
    required this.updatedAt,
    this.knowFieldName,
    this.knowFieldCode,
    this.pinnedText,
    this.badges,
    this.parentNickname,
    this.parentTitle,
    this.parentDescription,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: _toInt(json['id']),
      idUser: _toInt(json['id_user']),
      idKnowField: json['id_knowField']?.toString(),
      title: json['title']?.toString(),
      description: json['description']?.toString() ?? '',
      image: json['image']?.toString(),
      doc: json['doc']?.toString(),
      status: json['status']?.toString(),
      username: json['username']?.toString(),
      accountName: json['account_name']?.toString(),
      nickname: json['nickname']?.toString(),
      fullname: json['fullname']?.toString(),
      company: json['company']?.toString(),
      followStatus: _toInt(json['follow_status']),
      voteStatus: json['vote_status'] != null
          ? _toInt(json['vote_status'])
          : null,
      upvote: _toInt(json['upvote']),
      downvote: _toInt(json['downvote']),
      point: _toInt(json['point']),
      createdAt:
          DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
      updatedAt:
          DateTime.tryParse(json['updated_at']?.toString() ?? '') ??
          DateTime.now(),
      knowFieldName: json['know_field_name']?.toString(),
      knowFieldCode: json['know_field_code']?.toString(),
      pinnedText: json['pinned_text']?.toString(),
      badges: json['badges'],
      parentNickname: json['parent_nickname']?.toString(),
      parentTitle: json['parent_title']?.toString(),
      parentDescription: json['parent_description']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_user': idUser,
      'id_knowField': idKnowField,
      'title': title,
      'description': description,
      'image': image,
      'doc': doc,
      'status': status,
      'username': username,
      'account_name': accountName,
      'nickname': nickname,
      'fullname': fullname,
      'company': company,
      'follow_status': followStatus,
      'vote_status': voteStatus,
      'upvote': upvote,
      'downvote': downvote,
      'point': point,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'know_field_name': knowFieldName,
      'know_field_code': knowFieldCode,
      'pinned_text': pinnedText,
      'badges': badges,
      'parent_nickname': parentNickname,
      'parent_title': parentTitle,
      'parent_description': parentDescription,
    };
  }

  static int _toInt(dynamic value, {int defaultValue = 0}) {
    if (value == null) return defaultValue;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? defaultValue;
    if (value is double) return value.toInt();
    return defaultValue;
  }
}
