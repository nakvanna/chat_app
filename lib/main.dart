import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pks_mobile/helper/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pks_mobile/routes/app_pages.dart';
import 'controllers/shared_prefs_controller.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    Get.lazyPut<SharedPrefs>(() => SharedPrefs());
    return GetMaterialApp(
      onInit: () async {
        await Get.find<SharedPrefs>()
            .getUserInfo(); // Because the OnInit has initialized before the initialBinding
        Future.delayed(Duration(seconds: 3), () {
          // Get.toNamed('/home');
          Constants.isLogin.value == false
              ? Get.offNamed('/auth')
              : Get.offNamed('/home');
        });
      },
      // initialBinding: CtrlBindings(),
      debugShowCheckedModeBanner: true,
      title: 'PKS Mobile',
      initialRoute: AppPages.INITIAL,
      defaultTransition: Transition.rightToLeft,
      getPages: AppPages.routes,
    );
  }
}
