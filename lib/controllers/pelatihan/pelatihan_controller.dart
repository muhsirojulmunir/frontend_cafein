import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class PelatihanController extends GetxController {
  // Replace this URL with the actual training website URL
  final String trainingUrl = 'https://google.com';

  Future<void> launchTrainingUrl() async {
    final Uri uri = Uri.parse(trainingUrl);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      Get.snackbar('Error', 'Could not launch $trainingUrl');
    }
  }
}
