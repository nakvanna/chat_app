import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pks_mobile/controllers/auth_controller.dart';
import 'package:pks_mobile/helper/constants.dart';

class HomeScreen extends GetWidget<AuthController> {
  logout() async {
    await controller.logoutAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: ListView(
                children: [
                  UserAccountsDrawerHeader(
                    accountName: Obx(() => Text(Constants.myUsername.value)),
                    accountEmail: Obx(() => Text(Constants.myEmail.value)),
                    currentAccountPicture: ClipRRect(
                      borderRadius: BorderRadius.circular(110),
                      child: Image.network(
                        'https://www.kindpng.com/picc/m/24-248394_user-icon-hd-png-download.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                ],
              ),
              decoration: BoxDecoration(color: Colors.blue),
            ),
            RaisedButton(
              onPressed: () {
                logout();
              },
              child: Text('Logout'),
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Home Screen'),
        actions: [
          IconButton(
            icon: Icon(Icons.question_answer),
            onPressed: () {
              Get.toNamed('/chat_room');
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Obx(() => Text(Constants.isLogin.value.toString())),
            Obx(() => Text(Constants.myUID.value.toString())),
            Obx(() => Text(Constants.myUsername.value.toString())),
            Obx(() => Text(Constants.myEmail.value.toString())),
          ],
        ),
      ),
    );
  }
}
