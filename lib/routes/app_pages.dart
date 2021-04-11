import 'package:get/get.dart';
import 'package:pks_mobile/bindings/controller_bindings.dart';
import 'package:pks_mobile/screens/authentication.dart';
import 'package:pks_mobile/screens/group_creator.dart';
import 'package:pks_mobile/screens/home_screen.dart';
import 'package:pks_mobile/screens/group_message.dart';
import 'package:pks_mobile/screens/meeting_room.dart';
import 'package:pks_mobile/screens/private_message.dart';
import 'package:pks_mobile/screens/search_partner_to_message.dart';
import 'package:pks_mobile/screens/splash.dart';
import 'package:pks_mobile/screens/test_push_notification.dart';
import 'package:pks_mobile/screens/users.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => SplashScreen(),
    ),
    GetPage(
      name: _Paths.AUTH,
      page: () => Authentication(),
      binding: ControllerBinding(),
    ),
    GetPage(
        name: _Paths.HOME,
        page: () => HomeScreen(),
        binding: ControllerBinding()),
    GetPage(
      name: _Paths.LIST_GROUP_MESSAGE,
      page: () => GroupMessage(),
      binding: ControllerBinding(),
      transitionDuration: Duration(seconds: 1),
    ),
    GetPage(
        name: _Paths.SEARCH_PARTNER_TO_MESSAGE,
        page: () => SearchPartnerToMessage(),
        transition: Transition.rightToLeftWithFade),
    GetPage(
      name: _Paths.PRIVATE_MESSAGE,
      page: () => PrivateMessage(),
      transition: Transition.fade,
    ),
    GetPage(
        name: _Paths.MEETING_ROOM,
        page: () => MeetingRoom(),
        transition: Transition.zoom),
    GetPage(
        name: _Paths.TEST_PUSH_FCM,
        page: () => TestPushNotification(),
        transition: Transition.zoom),
    GetPage(
        name: _Paths.GROUP_CREATOR,
        page: () => GroupCreator(),
        transition: Transition.zoom),
    GetPage(
      name: _Paths.USER,
      page: () => Users(),
      binding: ControllerBinding(),
      transition: Transition.zoom,
    ),
  ];
}
