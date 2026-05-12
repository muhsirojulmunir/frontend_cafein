import 'package:cafein/routes/page_names.dart';
import 'package:cafein/routes/page_routes.dart';
import 'package:cafein/services/push_notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp();
    await PushNotificationService.initialize();
  } catch (e) {
    debugPrint("Firebase initialization failed: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, screenType) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: PageName.splash,
          getPages: PageRoutes.pages,
          localizationsDelegates: const [GlobalMaterialLocalizations.delegate],
        );
      },
    );
  }
}
