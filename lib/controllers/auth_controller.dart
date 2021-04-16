import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pks_mobile/controllers/db_controller.dart';
import 'package:pks_mobile/controllers/shared_prefs_controller.dart';
import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pks_mobile/helper/constants.dart';
import 'package:pks_mobile/routes/app_pages.dart';

class AuthController extends GetxController {
  final isLoginLoading = false.obs;
  FirebaseAuth _auth = FirebaseAuth.instance;
  Rx<User> _firebaseUser = Rx<User>();

  final _currentUser = Rx<GoogleSignInAccount>();
  final getUsernameQuerySnapshot = Rx<QuerySnapshot>();

  final sharedPrefs = Get.find<SharedPrefs>();
  final dbController = Get.find<DbController>();

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
  }

  Future<void> googleSignIn() async {
    String deviceToken = await FirebaseMessaging.instance.getToken();
    try {
      var googleSignIn = await _googleSignIn.signIn();

      await dbController.uploadUserInfo(userMap: {
        'uid': googleSignIn.id,
        'email': googleSignIn.email,
        'username': googleSignIn.displayName,
        'photoUrl': googleSignIn.photoUrl,
        'filter': [
          googleSignIn.displayName.toLowerCase(),
          googleSignIn.email.toLowerCase()
        ],
        'deviceToken': deviceToken
      });
      await sharedPrefs.setUserInfo(
        isLogin: true,
        uid: googleSignIn.id,
        username: googleSignIn.displayName,
        email: googleSignIn.email,
        photoUrl: googleSignIn.photoUrl,
      );
      await Get.offNamed(Routes.HOME);
    } catch (error) {
      print('Google sign-in error: $error');
    }
  }

  Future<void> googleSignOut() async {
    await _googleSignIn.signOut();
  }

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
          await Get.offAllNamed(Routes.HOME);
        }
      });
    } catch (onError) {
      Get.snackbar("Can't creating this account", onError,
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
          Get.offAllNamed(Routes.HOME);
        }
      });
    } catch (onError) {
      isLoginLoading.value = false;
      Get.snackbar("Can't login this account", onError,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  logout() async {
    try {
      await _auth.signOut();
    } catch (error) {
      Get.snackbar("Can't sign out this account", error,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  logoutAll() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      print('Where is my doc ID ${Constants.myDocId.value}');
      await dbController.updateUserInfo(
          docId: Constants.myDocId.value, updateField: {'deviceToken': ''});
      await sharedPrefs.setUserInfo(
          isLogin: false, uid: '', username: '', email: '', photoUrl: '');
      await sharedPrefs.setUserDocId(docId: '');
      await Get.offAllNamed(Routes.AUTH);
    } catch (error) {
      print('Log out all error $error');
    }
  }
}
