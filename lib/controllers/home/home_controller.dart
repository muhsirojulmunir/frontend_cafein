import 'package:cafein/resources/resources.dart';
import 'package:cafein/routes/page_names.dart';
import 'package:get/get.dart';
import 'package:cafein/services/auth_service.dart';
import 'package:cafein/services/local/token.dart';

class HomeController extends GetxController {
  final AuthService _authService = AuthService();

  final List<Map<String, dynamic>> menuItems = [
    {
      'title': 'Regulasi',
      'subtitle': 'Kebijakan dan panduan resmi',
      'image': appImages.imgRegulasi.path,
      'route': PageName.regulation,
    },
    {
      'title': 'Media',
      'subtitle': 'Berita, artikel, dan informasi terbaru',
      'image': appImages.imgMedia.path,
      'route': PageName.media,
    },
    {
      'title': 'Berbagi',
      'subtitle': 'Berbagi ide dan berkolaborasi',
      'image': appImages.imgPowershare.path,
      'route': PageName.navbar,
    },
    {
      'title': 'Podcast CafeIN',
      'subtitle': 'Dengarkan dan saksikan siaran kami',
      'image': appImages.imgPodcast.path,
      'route': PageName.podcast,
    },
    {
      'title': 'Pelatihan',
      'subtitle': 'Akses program pelatihan eksklusif',
      'image': appImages.imgPelatihan.path,
      'route': PageName.pelatihan,
    },
  ];

  void logout() async {
    try {
      await _authService.logout();
    } catch (_) {
      // ignore
    } finally {
      await Token.clearSession();
      Get.offAllNamed(PageName.login);
    }
  }
}
