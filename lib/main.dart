import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pks_mobile/controllers/bindings/auth_binding.dart';
import 'package:pks_mobile/helper/constants.dart';
import 'package:pks_mobile/screen/authentication.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pks_mobile/screen/chat_room.dart';
import 'package:pks_mobile/screen/conversation.dart';
import 'package:pks_mobile/screen/home.dart';
import 'package:pks_mobile/screen/search_chat.dart';
import 'package:pks_mobile/screen/splash.dart';
import 'package:pks_mobile/shared_preferences/store_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return GetMaterialApp(
        onInit: () async {
          Constants.isLogin.value = await StoreAuth.getIsLogin();
          Constants.myUID.value = await StoreAuth.getMyUID();
          Constants.myEmail.value = await StoreAuth.getMyEmail();
          Constants.myUsername.value = await StoreAuth.getMyUsername();
          Future.delayed(Duration(seconds: 3), () {
            Constants.isLogin.value == false
                ? Get.offNamed('/auth')
                : Get.offNamed('/home');
          });
        },
        initialBinding: AuthBinding(),
        debugShowCheckedModeBanner: false,
        title: 'PKS Mobile',
        initialRoute: '/',
        defaultTransition: Transition.rightToLeft,
        getPages: [
          GetPage(name: '/', page: () => SplashScreen()),
          GetPage(
              name: '/auth',
              page: () => Authentication(),
              binding: AuthBinding()),
          GetPage(name: '/home', page: () => HomeScreen()),
          GetPage(
            name: '/chat_room',
            page: () => ChatRoom(),
          ),
          GetPage(
              name: '/search_chat',
              page: () => SearchChat(),
              transition: Transition.zoom),
          GetPage(
              name: '/conversation',
              page: () => Conversation(),
              transition: Transition.zoom),
        ],
      );
    });
  }
}
