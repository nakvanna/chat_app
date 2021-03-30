import 'package:get/get.dart';
import 'package:pks_mobile/controllers/auth_controller.dart';

class AuthBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<AuthController>(() => AuthController()); //Clear instance from memory
    // Get.put<AuthController>(AuthController()); //Available all route
  }
}