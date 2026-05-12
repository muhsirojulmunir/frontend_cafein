import 'package:cafein/pages/auth/auth_binding.dart';
import 'package:cafein/pages/auth/login/login_page.dart';
import 'package:cafein/pages/auth/register/register_page.dart';
import 'package:cafein/pages/auth/register/verify_otp_page.dart';
import 'package:cafein/pages/auth/forgot_password/forgot_password_email_page.dart';
import 'package:cafein/pages/auth/forgot_password/forgot_password_otp_page.dart';
import 'package:cafein/pages/auth/forgot_password/forgot_password_new_page.dart';
import 'package:cafein/pages/home/home_binding.dart';
import 'package:cafein/pages/home/home_page.dart';
import 'package:cafein/pages/media/media_binding.dart';
import 'package:cafein/pages/media/media_page.dart';
import 'package:cafein/pages/on_boarding/on_boarding_binding.dart';
import 'package:cafein/pages/on_boarding/on_boarding_page.dart';
import 'package:cafein/pages/power_share/actions/ask/ask_binding.dart';
import 'package:cafein/pages/power_share/actions/ask/ask_page.dart';
import 'package:cafein/pages/power_share/actions/edit/edit_post_page.dart';
import 'package:cafein/pages/power_share/actions/search/search_binding.dart';
import 'package:cafein/pages/power_share/actions/search/search_page.dart';
import 'package:cafein/pages/power_share/bottom_nav_bar/nav_tab_binding.dart';
import 'package:cafein/pages/power_share/bottom_nav_bar/nav_tab_page.dart';
import 'package:cafein/pages/power_share/actions/notification/notification_binding.dart';
import 'package:cafein/pages/power_share/actions/notification/notification_page.dart';
import 'package:cafein/pages/power_share/cafe_room/cafe_room_binding.dart';
import 'package:cafein/pages/power_share/cafe_room/cafe_room_page.dart';
import 'package:cafein/pages/power_share/cafe_room/cafe_room_detail_page.dart';
import 'package:cafein/pages/power_share/cafe_room/cafe_room_detail_binding.dart';
import 'package:cafein/pages/power_share/cafe_room/post_detail_page.dart';
import 'package:cafein/pages/power_share/follow/follow_binding.dart';
import 'package:cafein/pages/power_share/follow/follow_page.dart';
import 'package:cafein/pages/power_share/share/share_binding.dart';
import 'package:cafein/pages/power_share/share/share_page.dart';
import 'package:cafein/pages/regulation/regulation_binding.dart';
import 'package:cafein/pages/regulation/regulation_page.dart';
import 'package:cafein/pages/splash/splash_binding.dart';
import 'package:cafein/pages/splash/splash_page.dart';
import 'package:cafein/pages/podcast/podcast_binding.dart';
import 'package:cafein/pages/podcast/podcast_page.dart';
import 'package:cafein/pages/pelatihan/pelatihan_binding.dart';
import 'package:cafein/pages/pelatihan/pelatihan_page.dart';
import 'package:cafein/pages/profile/user_binding.dart';
import 'package:cafein/pages/profile/profile_page.dart';
import 'package:cafein/routes/page_names.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

class PageRoutes {
  static final pages = [
    // Welcome
    GetPage(
      name: PageName.splash,
      page: () => const SplashPage(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: PageName.onboarding,
      page: () => OnBoardingPage(),
      binding: OnBoardingBinding(),
    ),

    // Auth
    GetPage(
      name: PageName.login,
      page: () => LoginPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: PageName.register,
      page: () => RegisterPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: PageName.verifyOtp,
      page: () => const VerifyOtpPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: PageName.forgotPasswordEmail,
      page: () => const ForgotPasswordEmailPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: PageName.forgotPasswordOtp,
      page: () => const ForgotPasswordOtpPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: PageName.forgotPasswordNew,
      page: () => const ForgotPasswordNewPage(),
      binding: AuthBinding(),
    ),

    // Home
    GetPage(
      name: PageName.home,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),

    // Menu
    GetPage(
      name: PageName.regulation,
      page: () => const RegulationPage(),
      binding: RegulationBinding(),
    ),
    GetPage(
      name: PageName.media,
      page: () => const MediaPage(),
      binding: MediaBinding(),
    ),
    GetPage(
      name: PageName.navbar,
      page: () => const NavTabPage(),
      binding: NavTabBinding(),
    ),
    GetPage(
      name: PageName.notification,
      page: () => const NotificationPage(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: PageName.search,
      page: () => const SearchPage(),
      binding: SearchBinding(),
    ),
    GetPage(
      name: PageName.ask,
      page: () => const AskPage(),
      binding: AskBinding(),
    ),
    GetPage(name: PageName.editPost, page: () => const EditPostPage()),
    GetPage(
      name: PageName.cafeRoom,
      page: () => const CafeRoomPage(),
      binding: CafeRoomBinding(),
    ),
    GetPage(
      name: PageName.cafeRoomDetail,
      page: () => const CafeRoomDetailPage(),
      binding: CafeRoomDetailBinding(),
    ),
    GetPage(name: PageName.postDetail, page: () => const PostDetailPage()),
    GetPage(
      name: PageName.share,
      page: () => const SharePage(),
      binding: ShareBinding(),
    ),
    GetPage(
      name: PageName.follow,
      page: () => const FollowPage(),
      binding: FollowBinding(),
    ),
    GetPage(
      name: PageName.podcast,
      page: () => const PodcastPage(),
      binding: PodcastBinding(),
    ),
    GetPage(
      name: PageName.pelatihan,
      page: () => const PelatihanPage(),
      binding: PelatihanBinding(),
    ),
    GetPage(
      name: PageName.profile,
      page: () => const ProfilePage(),
      binding: UserBinding(),
    ),
  ];
}
