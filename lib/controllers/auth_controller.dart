import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pks_mobile/controllers/database_controller.dart';
import 'package:pks_mobile/helper/constants.dart';
import 'dart:async';

import 'package:pks_mobile/shared_preferences/store_auth.dart';

class AuthController extends GetxController {
  var isLoginLoading = false.obs;
  FirebaseAuth _auth = FirebaseAuth.instance;
  Rx<User> _firebaseUser = Rx<User>();
  String get user => _firebaseUser.value?.uid;

  DatabaseController _databaseController = DatabaseController();

  var _currentUser = Rx<GoogleSignInAccount>();
  var getUsernameQuerySnapshot = Rx<QuerySnapshot>();

  /*UserModal _userFromFirebaseUser(User user){
    return user != null ? UserModal(userId: user.uid) : null;
  }*/

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _firebaseUser.bindStream(_auth.authStateChanges());
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      _currentUser.value = account;
    });
  }

  Future<void> googleSignIn() async {
    try {
      await _googleSignIn.signIn().then((value) async {
        if (value != null) {
          await _databaseController.uploadUserInfo({
            'uid': value.id,
            'email': value.email,
            'username': value.displayName,
            'photoUrl': value.photoUrl
          });
          await StoreAuth().setIsLogin(isLogin: true);
          Constants.isLogin.value = true;
          await StoreAuth().setUid(uid: value.id);
          Constants.myUID.value = value.id;
          await StoreAuth().setUsername(username: value.displayName);
          Constants.myUsername.value = value.displayName;
          await StoreAuth().setEmail(email: value.email);
          Constants.myEmail.value = value.email;
          await StoreAuth().setPhotoUrl(photoUrl: value.photoUrl);
          Constants.myPhotoUrl.value = value.photoUrl;
          Get.offNamed('/home');
        }
      });
    } catch (error) {
      print(error);
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
          await _databaseController.uploadUserInfo({
            'uid': value.user.uid,
            'email': value.user.email,
            'username': username,
            'photoUrl': ''
          });
          await StoreAuth().setIsLogin(isLogin: true);
          Constants.isLogin.value = true;
          await StoreAuth().setUid(uid: value.user.uid);
          Constants.myUID.value = value.user.uid;
          await StoreAuth().setUsername(username: username);
          Constants.myUsername.value = username;
          await StoreAuth().setEmail(email: value.user.email);
          Constants.myEmail.value = value.user.email;
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
            await _databaseController.getUsernameByEmail(email);
        if (value != null) {
          await StoreAuth().setIsLogin(isLogin: true);
          Constants.isLogin.value = true;
          await StoreAuth().setUid(uid: value.user.uid);
          Constants.myUID.value = value.user.uid;
          await StoreAuth().setUsername(
              username: getUsernameQuerySnapshot.value.docs[0].get('username'));
          Constants.myUsername.value =
              getUsernameQuerySnapshot.value.docs[0].get('username');
          await StoreAuth().setEmail(email: value.user.email);
          Constants.myEmail.value = value.user.email;
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
        StoreAuth().setIsLogin(isLogin: false);
        StoreAuth().setUid(uid: '');
        StoreAuth().setUsername(username: '');
        StoreAuth().setEmail(email: '');
        StoreAuth().setPhotoUrl(photoUrl: '');
        Constants.isLogin.value = false;
        Constants.myUID.value = '';
        Constants.myUsername.value = '';
        Constants.myEmail.value = '';
        Constants.myPhotoUrl.value = '';
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
    await StoreAuth().setIsLogin(isLogin: false);
    await StoreAuth().setUid(uid: '');
    await StoreAuth().setUsername(username: '');
    await StoreAuth().setEmail(email: '');
    await StoreAuth().setPhotoUrl(photoUrl: '');
    Constants.isLogin.value = false;
    Constants.myUID.value = '';
    Constants.myUsername.value = '';
    Constants.myEmail.value = '';
    Constants.myPhotoUrl.value = '';
    Get.offAllNamed('/auth');
  }
}
