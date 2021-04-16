import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pks_mobile/helper/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pks_mobile/routes/app_pages.dart';
import 'package:pks_mobile/screens/home_screen.dart';
import 'package:pks_mobile/translations/text_translation.dart';
import 'controllers/shared_prefs_controller.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  print('On background ${message.data}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  /// Create an Android Notification Channel.
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

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
        await Get.find<SharedPrefs>().getLanguage();

        await Future.delayed(Duration(seconds: 3), () {
          Get.snackbar('Title', 'before init');
          if (Constants.isLogin.value == true) {
            Get.offAllNamed(Routes.HOME);
          } else {
            Get.offAllNamed(Routes.AUTH);
          }
        });

        await FirebaseMessaging.instance.getInitialMessage().then(
              (value) => print(value),
            );

        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          RemoteNotification notification = message.notification;
          AndroidNotification android = message.notification?.android;

          print('On message ${message.data}');

          if (notification != null && android != null) {
            flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  channel.description,
                  icon: 'launch_background',
                ),
              ),
            );
          }
        });

        FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
          Firebase.initializeApp();
          Get.toNamed(Routes.NOTIFICATIONS, arguments: message.data);
          print('On message open app ${message.data}');
        });
      },
      translations: LabelTranslation(),
      locale: Locale('en', 'US'),
      fallbackLocale: Locale('en', 'US'),
      debugShowCheckedModeBanner: false,
      title: 'PKS Mobile',
      initialRoute: AppPages.INITIAL,
      unknownRoute: GetPage(
          name: '/notfound',
          page: () => HomeScreen(),
          transition: Transition.fadeIn,
          transitionDuration: Duration(milliseconds: 1000)),
      defaultTransition: Transition.rightToLeftWithFade,
      getPages: AppPages.routes,
    );
  }
}
