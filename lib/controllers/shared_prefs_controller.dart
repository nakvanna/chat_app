import 'package:get/get.dart';
import 'package:pks_mobile/helper/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs extends GetxController {
  static String loginKey = 'LOGIN';
  static String uidKey = 'UID';
  static String usernameKey = 'USERNAME';
  static String emailKey = 'EMAIL';
  static String photoUrlKey = 'PHOTO_URL';
  static String typeKey = 'TYPE';
  static String docIdKey = 'USER_DOC_ID';
  static String languageKey = 'LANGUAGE_KEY';

  Future<void> setType({String type}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(typeKey, type);
    Constants.myType.value = type;
  }

  Future<void> setLanguage({String language}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(languageKey, language);
    Constants.language.value = language;
  }

  Future<void> setUserDocId({String docId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(docIdKey, docId);
    Constants.myDocId.value = docId;
  }

  Future<void> setUserInfo({
    bool isLogin: false,
    String uid,
    String username,
    String email,
    String photoUrl,
  }) async {
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

  Future<void> getType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Constants.myType.value = prefs.getString(typeKey) ?? 'student';
  }

  Future<void> getLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Constants.language.value = prefs.getString(languageKey) ?? 'English';
  }

  Future<void> getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Constants.isLogin.value = prefs.getBool(loginKey) ?? false;
    Constants.myUID.value = prefs.getString(uidKey);
    Constants.myUsername.value = prefs.getString(usernameKey);
    Constants.myEmail.value = prefs.getString(emailKey);
    Constants.myPhotoUrl.value = prefs.getString(photoUrlKey);
    Constants.myDocId.value = prefs.getString(docIdKey);
  }
}
