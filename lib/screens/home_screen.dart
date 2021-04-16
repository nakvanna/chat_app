import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:pks_mobile/controllers/auth_controller.dart';
import 'package:pks_mobile/controllers/translation_controller.dart';
import 'package:pks_mobile/helper/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pks_mobile/routes/app_pages.dart';
import 'package:pks_mobile/widgets/menu_item.dart';
import 'package:badges/badges.dart';
import 'package:pks_mobile/widgets/screen_background_color.dart';
import 'package:pks_mobile/helper/custom_font_style.dart';

class HomeScreen extends GetWidget<AuthController> {
  final String myType = Constants.myType.value;
  final notificationCount = 0.obs;
  final unSeenMessageCount = 0.obs;
  final onClassStart = false.obs;
  final translationController = Get.put(TranslationController());
  final CustomFontStyle customFontStyle = CustomFontStyle();

  Future<void> logout() async {
    await controller.logoutAll();
  }

  _changeLocale({String language}) {
    if (language == 'English') {
      translationController.changeLanguage('en', 'US');
    } else {
      translationController.changeLanguage('kh', 'KH');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    List _imageSlide = [
      'assets/images/school_area.png',
      'assets/images/school_area.png',
    ];

    return GetBuilder(
      initState: (_) async {
        await Future.delayed(Duration(seconds: 1),
            () => _changeLocale(language: Constants.language.value));

        Constants.myDeiceToken.value =
            await FirebaseMessaging.instance.getToken();
        Constants.currentRoute.value = ModalRoute.of(context).settings.name;
      },
      builder: (val) => screenBackgroundColor(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.purple, Colors.orange],
          scaffold: Scaffold(
            backgroundColor: Colors.transparent,
            drawer: _drawer(size: _size, context: context),
            bottomNavigationBar: _bottomNavBar(),
            appBar: AppBar(
              actions: [
                IconButton(
                  onPressed: () {
                    notificationCount.value++;
                  },
                  icon: Obx(() => Badge(
                        elevation: 10,
                        animationDuration: Duration(milliseconds: 1000),
                        animationType: BadgeAnimationType.slide,
                        badgeContent: Text(
                          '${notificationCount.value}',
                          style: TextStyle(fontSize: 12),
                        ),
                        child: Icon(Icons.notifications),
                      )),
                ),
              ],
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              title: Text(
                'ponlok khmer school'.tr,
                style: customFontStyle.appBarTitleTextStyle(),
              ),
            ),
            floatingActionButton: FloatingActionButton.extended(
              elevation: 3,
              onPressed: () {
                if (myType == 'student')
                  Get.toNamed(Routes.STUDENT_CLASSES);
                else
                  Get.toNamed(Routes.TEACHER_CLASSES);
              },
              backgroundColor: Colors.pink[200],
              icon: Icon(Icons.videocam),
              label: Text(
                myType == 'student'
                    ? 'join online class'.tr
                    : 'teacher online class'.tr,
                textAlign: TextAlign.center,
                style: customFontStyle.labelTextStyle(),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            body: ListView(
              children: [
                Card(
                  elevation: 10,
                  child: Container(
                    height: _size.height / 4,
                    child: ListView.builder(
                        primary: true,
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: _imageSlide.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            child: Image.asset(
                              _imageSlide[index],
                              width: _size.width,
                              fit: BoxFit.fitWidth,
                            ),
                          );
                        }),
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _horizontalLine(size: _size),
                      Text(
                        'menu'.tr,
                        style: customFontStyle.labelTextStyle(),
                      ),
                      _horizontalLine(size: _size),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: GridView.count(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    crossAxisCount: 3,
                    children: [
                      Obx(
                        () => MenuItems(
                          onTab: () {},
                          colorData: Colors.greenAccent,
                          imageAsset: 'assets/images/student.png',
                          textLabel: Constants.language.value,
                        ),
                      ),
                      MenuItems(
                        onTab: () {},
                        colorData: Colors.purple,
                        imageAsset: 'assets/images/student.png',
                        textLabel: 'Electronics',
                      ),
                      MenuItems(
                        onTab: () {},
                        colorData: Colors.pink,
                        imageAsset: 'assets/images/student.png',
                        textLabel: 'Electronics',
                      ),
                      MenuItems(
                        onTab: () {},
                        colorData: Colors.purple,
                        imageAsset: 'assets/images/student.png',
                        textLabel: 'Electronics',
                      ),
                      MenuItems(
                        onTab: () {},
                        colorData: Colors.pink,
                        imageAsset: 'assets/images/student.png',
                        textLabel: 'Electronics',
                      ),
                      MenuItems(
                        onTab: () {},
                        colorData: Colors.purple,
                        imageAsset: 'assets/images/student.png',
                        textLabel: 'Electronics',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  BottomAppBar _bottomNavBar() {
    return BottomAppBar(
      notchMargin: 4,
      shape: AutomaticNotchedShape(RoundedRectangleBorder(),
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
      child: Container(
        margin: EdgeInsets.only(left: 50, right: 50),
        decoration: BoxDecoration(
            shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(30)),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {},
            ),
            Obx(
              () => IconButton(
                icon: Badge(
                  elevation: 10,
                  animationDuration: Duration(milliseconds: 1000),
                  animationType: BadgeAnimationType.slide,
                  badgeContent: Text(
                    '${notificationCount.value}',
                    style: TextStyle(fontSize: 12),
                  ),
                  child: Icon(Icons.message),
                ),
                onPressed: () {
                  Get.toNamed('/group_message');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Drawer _drawer({Size size, context}) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            height: size.height / 6,
            padding: EdgeInsets.only(top: size.height / 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange[200], Colors.pinkAccent],
              ),
            ),
            child: ListTile(
              leading: CircleAvatar(
                child: CachedNetworkImage(
                  imageUrl: Constants.myPhotoUrl.value,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CircularProgressIndicator(
                          value: downloadProgress.progress),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
                radius: 30,
                backgroundColor: Colors.white,
              ),
              // title: Text(Constants.myUsername.value),
              title: Text(Constants.myUsername.value),
              subtitle: Text(
                Constants.myEmail.value,
                style: TextStyle(fontSize: 13),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Colors.black,
              ),
            ),
          ),
          Opacity(
            opacity: .75,
            child: Column(
              children: [
                drawerMenu(
                  onTap: () {
                    Get.toNamed(Routes.SETTINGS);
                  },
                  icon: Icon(Icons.settings),
                  label: 'settings'.tr,
                ),
                drawerMenu(
                  onTap: () {
                    logout();
                  },
                  icon: Icon(Icons.logout),
                  label: 'logout'.tr,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  InkWell drawerMenu(
      {@required Function onTap, @required Icon icon, @required String label}) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        leading: icon,
        title: Text(
          label,
          style: customFontStyle.listTileMenuTextStyle(),
        ),
      ),
    );
  }

  Padding _horizontalLine({Size size}) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          width: size.width / 3,
          height: 1.0,
          color: Colors.black26.withOpacity(.2),
        ),
      );
}
