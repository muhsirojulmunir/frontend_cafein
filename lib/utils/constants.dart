class AppConstants {
  static const String BASE_URL =
      'https://cafein.inkindojawatimur.org/api'; // Production Server
  static const String API_REGULASI = '/cafein/regulasi';
  static const String API_DOWNLOAD_REGULASI = '/cafein/downloadRegulasi';
  static const String API_VIEW_REGULASI = '/cafein/viewRegulasi';
  static const String API_JENIS = '/cafein/jenis';
  static const String API_KATEGORI = '/cafein/kategori';
  static const String API_MEDIA = '/cafein/media';
  static const String API_VIEW_MEDIA = '/cafein/viewFileMedia';
  static const String API_DOWNLOAD_MEDIA = '/cafein/downloadFileMedia';
  static const String API_PODCAST = '/cafein/podcast';
  static const String API_CAFE_ROOM = '/cafein/cafeRoom';
  static const String API_LOGIN = '/login-mobile';
  static const String API_PROFILE = '/showprofile';
  static const String API_REGISTER = '/register-mobile';
  static const String API_LOGOUT = '/logout';

  // PowerShare - Posting
  static const String API_POSTING = '/posting';
  static const String API_POSTING_FOLLOWING = '/posting/following';
  static const String API_POSTING_STORE = '/posting/store';
  static const String API_POSTING_SHOW_IMAGE = '/posting/showImagePost';
  static const String API_POSTING_DOWNLOAD_DOC = '/posting/downloadDoc';
  static const String API_POSTING_COMMENTS = '/posting/commentDetailPost';
  static const String API_POSTING_DESTROY = '/posting/deleteCommentDetailPost';
  static const String API_POSTING_INDEX_PROFILE = '/posting/indexProfile';
  static const String API_POSTING_INDEX_ANSWER = '/posting/indexProfileAnswer';
  static const String API_POSTING_SHOW = '/posting/show';
  static const String API_POSTING_SEARCH = '/posting/search';

  // PowerShare - Reply
  static const String API_REPLY_STORE = '/reply/store';

  // PowerShare - Vote
  static const String API_VOTE_STORE = '/vote/store';
  static const String API_POSTING_LIKE_DETAIL = '/posting/likeDetailPost';

  // PowerShare - Follow
  static const String API_FOLLOW_USER = '/followuser/follow';
  static const String API_FOLLOW_USER_SHOW_FOLLOWERS =
      '/followuser/showfollowers';
  static const String API_FOLLOW_USER_SHOW_FOLLOWINGS =
      '/followuser/showfollowings';

  // Credentials
  static const String API_CREDENTIAL_INDEX_USER = '/credential/indexUser';

  // Profile
  static const String API_UPDATE_PROFILE_PHOTO = '/employee/updateProfilePhoto';
  static const String API_UPDATE_ACCOUNT_NAME = '/employee/updateAccountName';
  static const String API_SHOW_IMAGE_AVA = '/employee/showImageAva';

  // KnowField (Cafe Room Detail)
  static const String API_KNOW_FIELD = '/knowField';
  static const String API_KNOW_FIELD_SHOW_DETAIL = '/knowField/showDetail';
  static const String API_KNOW_FIELD_SHOW = '/knowField/show';
  static const String API_KNOW_FIELD_FOLLOW = '/knowField/follow';

  // Notifications
  static const String API_NOTIF = '/notif';
  static const String API_NOTIF_UPDATE = '/notif/update';
  static const String API_KNOW_FIELD_SHOW_FOLLOW = '/knowField/showFollowIlmu';
}
