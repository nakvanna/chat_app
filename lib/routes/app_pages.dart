import 'package:get/get.dart';
import 'package:pks_mobile/bindings/controller_bindings.dart';
import 'package:pks_mobile/bindings/translation_bindings.dart';
import 'package:pks_mobile/screens/authentication.dart';
import 'package:pks_mobile/screens/notifications.dart';
import 'package:pks_mobile/screens/student_classes.dart';
import 'package:pks_mobile/screens/drawers/settings.dart';
import 'package:pks_mobile/screens/drawers/sub_drawers/languages.dart';
import 'package:pks_mobile/screens/group_creator.dart';
import 'package:pks_mobile/screens/home_screen.dart';
import 'package:pks_mobile/screens/group_message.dart';
import 'package:pks_mobile/screens/meeting_room.dart';
import 'package:pks_mobile/screens/private_message.dart';
import 'package:pks_mobile/screens/search_partner_to_message.dart';
import 'package:pks_mobile/screens/splash.dart';
import 'package:pks_mobile/screens/teacher_classes.dart';
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
      transition: Transition.cupertinoDialog,
    ),
    GetPage(
      name: _Paths.PRIVATE_MESSAGE,
      page: () => PrivateMessage(),
    ),
    GetPage(
      name: _Paths.MEETING_ROOM,
      page: () => MeetingRoom(),
    ),
    GetPage(
      name: _Paths.GROUP_CREATOR,
      page: () => GroupCreator(),
    ),
    GetPage(
      name: _Paths.USER,
      page: () => Users(),
      binding: ControllerBinding(),
    ),
    GetPage(
      name: _Paths.SETTINGS,
      page: () => SettingScreen(),
    ),
    GetPage(
      name: _Paths.LANGUAGES,
      page: () => LanguageSettings(),
      binding: TranslationBinding(),
    ),
    GetPage(
      name: _Paths.STUDENT_CLASSES,
      page: () => StudentClasses(),
    ),
    GetPage(
      name: _Paths.TEACHER_CLASSES,
      page: () => TeacherClasses(),
    ),
    GetPage(
      name: _Paths.NOTIFICATIONS,
      page: () => Notifications(),
    ),
  ];
}
