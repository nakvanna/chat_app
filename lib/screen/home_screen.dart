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
                      child: CircleAvatar(
                        child: Constants.myPhotoUrl.value != null
                            ? Image.network(
                                Constants.myPhotoUrl.value,
                                fit: BoxFit.cover,
                              )
                            : Text('Nothing'),
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
            icon: Icon(Icons.videocam),
            onPressed: () {
              Get.toNamed('/meeting_room');
            },
          ),
          IconButton(
            icon: Icon(Icons.question_answer),
            onPressed: () {
              Get.toNamed('/group_message');
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
            Obx(() => Text(Constants.myPhotoUrl.value.toString())),
          ],
        ),
      ),
    );
  }
}
