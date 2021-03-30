import 'package:shared_preferences/shared_preferences.dart';

class StoreAuth {
  static String loginKey = 'LOGIN';
  static String uidKey = 'UID';
  static String usernameKey = 'USERNAME';
  static String emailKey = 'EMAIL';
  static String photoUrlKey = 'PHOTO_URL';

  setIsLogin({bool isLogin: false}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(loginKey, isLogin);
  }

  setUid({String uid: ''}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(uidKey, uid);
  }

  setUsername({String username: ''}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(usernameKey, username);
  }

  setEmail({String email: ''}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(emailKey, email);
  }

  setPhotoUrl({String photoUrl: ''}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(photoUrlKey, photoUrl);
  }

  static Future<bool> getIsLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(loginKey);
  }

  static Future<String> getMyUID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(uidKey);
  }

  static Future<String> getMyUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(usernameKey);
  }

  static Future<String> getMyEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(emailKey);
  }
}
