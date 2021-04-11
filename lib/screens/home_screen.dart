import 'dart:ui';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:pks_mobile/controllers/auth_controller.dart';
import 'package:pks_mobile/helper/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pks_mobile/routes/app_pages.dart';
import 'package:pks_mobile/widgets/menu_item.dart';
import 'package:badges/badges.dart';

class HomeScreen extends GetWidget<AuthController> {
  logout() async {
    await controller.logoutAll();
  }

  final notificationCount = 0.obs;
  final unSeenMessageCount = 0.obs;
  final _newColor = Rx<Color>(Colors.cyanAccent);
  final onClassStart = false.obs;

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    List _imageSlide = [
      'assets/images/school_area.png',
      'assets/images/school_area.png',
      'assets/images/school_area.png',
      'assets/images/school_area.png',
      'assets/images/school_area.png',
      'assets/images/school_area.png',
      'assets/images/school_area.png',
    ];

    return GetBuilder(
      initState: (_) async {
        Constants.myDeiceToken.value =
            await FirebaseMessaging.instance.getToken();
        Constants.currentRoute.value = ModalRoute.of(context).settings.name;
      },
      builder: (val) => SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.purple, Colors.orange],
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            drawer: _drawer(size: _size),
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
              title: Text('Home Screen'),
            ),
            floatingActionButton: Obx(() => onClassStart.value
                ? TweenAnimationBuilder(
                    tween:
                        ColorTween(begin: Colors.purple, end: _newColor.value),
                    duration: Duration(seconds: 2),
                    onEnd: () {
                      _newColor.value = _newColor.value == Colors.cyanAccent
                          ? Colors.purple
                          : Colors.cyanAccent;
                    },
                    builder: (_, Color color, __) {
                      return FloatingActionButton.extended(
                        elevation: 3,
                        onPressed: () {
                          Get.toNamed(Routes.USER);
                        },
                        backgroundColor: color,
                        icon: Icon(Icons.videocam),
                        label: Text(
                          "Join Online Class",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      );
                    },
                  )
                : FloatingActionButton.extended(
                    elevation: 3,
                    onPressed: () {
                      Get.toNamed(Routes.USER);
                    },
                    backgroundColor: Colors.orange[200],
                    icon: Icon(Icons.videocam),
                    label: Text(
                      "Join Online Class",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  )),
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
                        'MENU',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
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
                      MenuItems(
                        onTab: () {},
                        colorData: Colors.greenAccent,
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
          ),
        ),
      ),
    );
  }

  Widget _bottomNavBar() {
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

  Widget _drawer({Size size}) {
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
                ListTile(
                  leading: Icon(Icons.payment),
                  title: Text("Orders & Payments"),
                ),
                InkWell(
                  onTap: () {
                    logout();
                  },
                  child: ListTile(
                    leading: Icon(Icons.logout),
                    title: Text("Logout"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _horizontalLine({Size size}) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          width: size.width / 3,
          height: 1.0,
          color: Colors.black26.withOpacity(.2),
        ),
      );
}
