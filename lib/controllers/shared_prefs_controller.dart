import 'package:get/get.dart';
import 'package:pks_mobile/helper/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs extends GetxController {
  static String loginKey = 'LOGIN';
  static String uidKey = 'UID';
  static String usernameKey = 'USERNAME';
  static String emailKey = 'EMAIL';
  static String photoUrlKey = 'PHOTO_URL';

  Future<void> setUserInfo(
      {bool isLogin: false,
      String uid,
      String username,
      String email,
      String photoUrl}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    /*Set to SharedPreferences*/
    await prefs.setBool(loginKey, isLogin);
    await prefs.setString(uidKey, uid);
    await prefs.setString(usernameKey, username);
    await prefs.setString(emailKey, email);
    await prefs.setString(photoUrlKey, photoUrl);
    /*=====END=====*/
    /*Set to Constants Class*/
    Constants.isLogin.value = isLogin;
    Constants.myUID.value = uid;
    Constants.myUsername.value = username;
    Constants.myEmail.value = email;
    Constants.myPhotoUrl.value = photoUrl;
    /*=====END=====*/
  }

  getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Constants.isLogin.value = prefs.getBool(loginKey) ?? false;
    Constants.myUID.value = prefs.getString(uidKey);
    Constants.myUsername.value = prefs.getString(usernameKey);
    Constants.myEmail.value = prefs.getString(emailKey);
    Constants.myPhotoUrl.value = prefs.getString(photoUrlKey);
  }
}
