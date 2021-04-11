import 'package:get/get.dart';
import 'package:pks_mobile/controllers/auth_controller.dart';
import 'package:pks_mobile/controllers/db_controller.dart';
import 'package:pks_mobile/controllers/shared_prefs_controller.dart';

class ControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
    Get.putAsync<SharedPrefs>(() async => SharedPrefs());
    Get.lazyPut<DbController>(() => DbController());
  }
}
