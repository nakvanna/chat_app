import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pks_mobile/controllers/db_controller.dart';
import 'package:pks_mobile/controllers/shared_prefs_controller.dart';
import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';

class AuthController extends GetxController {
  final isLoginLoading = false.obs;
  FirebaseAuth _auth = FirebaseAuth.instance;
  Rx<User> _firebaseUser = Rx<User>();

  final _currentUser = Rx<GoogleSignInAccount>();
  final getUsernameQuerySnapshot = Rx<QuerySnapshot>();

  final sharedPrefs = Get.find<SharedPrefs>();
  final dbController = Get.find<DbController>();
  final deviceToken = ''.obs;

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  @override
  void onInit() async {
    super.onInit();
    _firebaseUser.bindStream(_auth.authStateChanges());
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      _currentUser.value = account;
    });
    deviceToken.value = await FirebaseMessaging.instance.getToken();
  }

  Future<void> googleSignIn() async {
    try {
      await _googleSignIn.signIn().then((value) async {
        print(deviceToken.value);
        await dbController.uploadUserInfo(userMap: {
          'uid': value.id,
          'email': value.email,
          'username': value.displayName,
          'photoUrl': value.photoUrl,
          'filter': [
            value.displayName.toLowerCase(),
            value.email.toLowerCase()
          ],
          'deviceTokens': [deviceToken.value]
        });
        await sharedPrefs.setUserInfo(
            isLogin: true,
            uid: value.id,
            username: value.displayName,
            email: value.email,
            photoUrl: value.photoUrl);
        Get.offNamed('/home');
      });
      // .then((value) async {
      //   print(value);
      //   if (value != null) {
      //     await dbController.uploadUserInfo(userMap: {
      //       'uid': value.id,
      //       'email': value.email,
      //       'username': value.displayName,
      //       'photoUrl': value.photoUrl,
      //       'filter': [
      //         value.displayName.toLowerCase(),
      //         value.email.toLowerCase()
      //       ]
      //     });
      // sharedPrefs.setUserInfo(
      //     isLogin: true,
      //     uid: value.id,
      //     username: value.displayName,
      //     email: value.email,
      //     photoUrl: value.photoUrl);
      // Get.offNamed('/home');
      // }
      // });
    } catch (error) {
      print('error here');
      print(error);
      print(error.message);
    }
  }

  Future<void> googleSignOut() =>
      _googleSignIn.signOut().then((value) => Get.offNamed('/auth'));

  void createUser(String username, String email, String password) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        if (value != null) {
          await dbController.uploadUserInfo(userMap: {
            'uid': value.user.uid,
            'email': value.user.email,
            'username': username,
            'photoUrl': '',
            'filter': [username.toLowerCase(), value.user.email.toLowerCase()]
          });
          sharedPrefs.setUserInfo(
              isLogin: true,
              uid: value.user.uid,
              username: username,
              email: value.user.email,
              photoUrl: '');
          await Get.offAllNamed('/home');
        }
      });
    } catch (onError) {
      Get.snackbar("Can't creating this account", onError.message,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> login(String email, String password) async {
    try {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        getUsernameQuerySnapshot.value =
            await dbController.getUsernameByEmail(email);
        if (value != null) {
          sharedPrefs.setUserInfo(
              isLogin: true,
              uid: value.user.uid,
              username: getUsernameQuerySnapshot.value.docs[0].get('username'),
              email: value.user.email,
              photoUrl: '');
          Get.offAllNamed('/home');
        }
      });
    } catch (onError) {
      isLoginLoading.value = false;
      Get.snackbar("Can't login this account", onError.message,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  logout() async {
    try {
      await _auth.signOut().then((value) {
        sharedPrefs.setUserInfo(
            isLogin: false, uid: '', username: '', email: '', photoUrl: '');
        Get.offAllNamed('/auth');
      });
    } catch (onError) {
      Get.snackbar("Can't signout this account", onError.message,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  logoutAll() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    sharedPrefs.setUserInfo(
        isLogin: false, uid: '', username: '', email: '', photoUrl: '');
    Get.offAllNamed('/auth');
  }
}
