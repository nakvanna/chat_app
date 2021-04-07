import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pks_mobile/helper/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pks_mobile/routes/app_pages.dart';
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
  Get.toNamed(message.data['to'], arguments: {
    "docId": message.data['docId'],
    "username": message.data['username'],
    "photoUrl": message.data['photoUrl'],
    "deviceTokens": [message.data['deviceTokens']],
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

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

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  /*FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    Firebase.initializeApp();
    print(message.data['deviceTokens'].runtimeType);
    Get.toNamed(message.data['to'], arguments: {
      "docId": message.data['docId'],
      "username": message.data['username'],
      "photoUrl": message.data['photoUrl'],
      "deviceTokens": [message.data['deviceTokens']],
    });
  });*/
  /*FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification notification = message.notification;
    AndroidNotification android = message.notification?.android;
    if (notification != null &&
        android != null &&
        Constants.currentRoute.value != '/private_message') {
      flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channel.description,
              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              icon: 'launch_background',
            ),
          ));
    }
  });*/
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    Get.lazyPut<SharedPrefs>(() => SharedPrefs());
    return GetMaterialApp(
      onInit: () async {
        FirebaseMessaging.instance
            .getInitialMessage()
            .then((RemoteMessage message) {
          if (message != null) {
            print('Get init: $message');
          }
        });
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          RemoteNotification notification = message.notification;
          AndroidNotification android = message.notification?.android;
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
                ));
          }
        });
        FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
          Firebase.initializeApp();
          print(message.data['deviceTokens'].runtimeType);
          Get.toNamed(message.data['to'], arguments: {
            "docId": message.data['docId'],
            "username": message.data['username'],
            "photoUrl": message.data['photoUrl'],
            "deviceToken": message.data['deviceToken'],
          });
        });

        await Get.find<SharedPrefs>()
            .getUserInfo(); // Because the OnInit has initialized before the initialBinding
        Future.delayed(Duration(seconds: 3), () {
          Constants.isLogin.value == false
              ? Get.offNamed('/auth')
              : Get.offNamed('/home');
        });
      },
      debugShowCheckedModeBanner: true,
      title: 'PKS Mobile',
      initialRoute: AppPages.INITIAL,
      defaultTransition: Transition.rightToLeft,
      getPages: AppPages.routes,
    );
  }
}
