import 'package:get/get.dart';
import 'package:pks_mobile/bindings/AuthBinding.dart';
import 'package:pks_mobile/screen/authentication.dart';
import 'package:pks_mobile/screen/home_screen.dart';
import 'package:pks_mobile/screen/list_group_message.dart';
import 'package:pks_mobile/screen/meeting_room.dart';
import 'package:pks_mobile/screen/private_message.dart';
import 'package:pks_mobile/screen/search_partner_to_message.dart';
import 'package:pks_mobile/screen/splash.dart';

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
      binding: AuthBinding(),
    ),
    GetPage(
        name: _Paths.HOME, page: () => HomeScreen(), binding: AuthBinding()),
    GetPage(
        name: _Paths.LIST_GROUP_MESSAGE,
        page: () => ListGroupMessage(),
        binding: AuthBinding()),
    GetPage(
        name: _Paths.SEARCH_PARTNER_TO_MESSAGE,
        page: () => SearchPartnerToMessage(),
        transition: Transition.zoom),
    GetPage(
        name: _Paths.PRIVATE_MESSAGE,
        page: () => PrivateMessage(),
        transition: Transition.zoom),
    GetPage(
        name: _Paths.MEETING_ROOM,
        page: () => MeetingRoom(),
        transition: Transition.zoom),
  ];
}
