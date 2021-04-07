import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pks_mobile/controllers/db_controller.dart';
import 'package:pks_mobile/helper/constants.dart';
import 'package:http/http.dart' as http;

class PrivateMessage extends GetWidget<DbController> {
  final messageToSend = TextEditingController();
  final fieldSendIsFocusFtString = false.obs;
  final String _myUID = Constants.myUID.value;
  final String _myUsername = Constants.myUsername.value;
  final String _myPhotoUrl = Constants.myPhotoUrl.value;
  final String _docId = Get.arguments['docId'];
  final String _photoUrl = Get.arguments['photoUrl'];
  final String _username = Get.arguments['username'];
  final String _deviceToken = Get.arguments['deviceToken'];
  final showTimeOnThisIndex = 0.obs;
  final toggleThisIndex = false.obs;

  sendMessage(DbController ctrl) async {
    var result = await ctrl.addMessage(docId: _docId, messageMap: {
      'message': messageToSend.text,
      'sentBy': _myUID,
      'isSeen': false,
      'timestamp': DateTime.now().microsecondsSinceEpoch,
    });

    if (result != null) {
      await ctrl.updateRecentlyMessage(docId: _docId, recentlyMapField: {
        'message': messageToSend.text,
        'sentBy': _myUID,
        'sentAt': DateTime.now(),
        'seen': [_myUID],
      });
      sendAndRetrieveMessage(title: _myUsername, body: messageToSend.text);
    }
    fieldSendIsFocusFtString.value = false;
    messageToSend.text = '';
  }

  messageOnTab({int index}) {
    showTimeOnThisIndex.value = index;
    toggleThisIndex.value = !toggleThisIndex.value;
  }

  Future<void> sendAndRetrieveMessage({
    String title,
    String body,
  }) async {
    try {
      String myDeviceToken = await FirebaseMessaging.instance.getToken();
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=${Constants.serverToken}',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{'body': body, 'title': title},
            'priority': 'high',
            'data': <String, dynamic>{
              'to': '/private_message',
              'docId': _docId,
              "username": _myUsername,
              "photoUrl": _myPhotoUrl,
              "deviceToken": myDeviceToken,
            },
            // 'to': myDeviceToken,
            'to': _deviceToken,
          },
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DbController>(
        initState: (_) {
          Constants.currentRoute.value = ModalRoute.of(context).settings.name;
        },
        dispose: (_) {},
        builder: (ctrl) => Scaffold(
              appBar: AppBar(
                leading: CircleAvatar(
                  backgroundImage: _photoUrl == ""
                      ? NetworkImage(Constants.accountImageNetwork)
                      : NetworkImage(_photoUrl),
                ),
                title: Text(_username),
                actions: [
                  IconButton(
                    icon: Icon(Icons.phone),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.videocam),
                    onPressed: () {},
                  ),
                ],
              ),
              body: ctrl.getMessages(docId: _docId) != null
                  ? StreamBuilder<QuerySnapshot>(
                      stream: ctrl.getMessages(docId: _docId),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Something went wrong');
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.active) {
                          ctrl.updateSeenInRecentlyMessage(docId: _docId);
                        }

                        return snapshot.hasData
                            ? ListView.builder(
                                padding: EdgeInsets.only(bottom: 60),
                                reverse: true,
                                itemCount: snapshot.data.docs.length,
                                itemBuilder: ((context, index) {
                                  Map<String, dynamic> _messageInfo =
                                      snapshot.data.docs[index].data();
                                  if (_myUID !=
                                      snapshot.data.docs[0].data()['sentBy']) {
                                    ctrl.updateSeenInsideMessage(
                                        groupMessageDocId: _docId,
                                        messageDocId: snapshot.data.docs[0].id);
                                  }
                                  return Column(
                                    children: [
                                      Obx(() => showTimeOnThisIndex.value ==
                                                  index &&
                                              toggleThisIndex.value
                                          ? Text(DateFormat.jm()
                                              .format(DateTime
                                                  .fromMicrosecondsSinceEpoch(
                                                      _messageInfo[
                                                          'timestamp']))
                                              .toString())
                                          : Container()),
                                      Container(
                                        padding: _messageInfo['sentBy'] ==
                                                _myUID
                                            ? EdgeInsets.fromLTRB(80, 4, 5, 0)
                                            : EdgeInsets.fromLTRB(5, 4, 80, 0),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        alignment:
                                            _messageInfo['sentBy'] == _myUID
                                                ? Alignment.centerRight
                                                : Alignment.centerLeft,
                                        child: InkWell(
                                          onTap: () {
                                            messageOnTab(index: index);
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                color: _messageInfo['sentBy'] ==
                                                        _myUID
                                                    ? Colors.green
                                                    : Colors.greenAccent,
                                                borderRadius: _messageInfo['sentBy'] ==
                                                        _myUID
                                                    ? BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(
                                                                30.0),
                                                        topRight:
                                                            Radius.circular(
                                                                30.0),
                                                        bottomLeft:
                                                            Radius.circular(
                                                                30.0),
                                                        bottomRight:
                                                            Radius.circular(0))
                                                    : BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(30.0),
                                                        topRight: Radius.circular(30.0),
                                                        bottomLeft: Radius.circular(0),
                                                        bottomRight: Radius.circular(30.0))),
                                            child: Text(
                                              _messageInfo['message']
                                                  .toString(),
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Obx(() =>
                                          showTimeOnThisIndex.value == index &&
                                                  toggleThisIndex.value
                                              ? _messageInfo['isSeen']
                                                  ? Text('Seen')
                                                  : Text('Delivered')
                                              : Container()),
                                    ],
                                  );
                                }))
                            : Container();
                      })
                  : Container(),
              bottomSheet: BottomAppBar(
                color: Colors.white,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(10)),
                        child: TextField(
                          maxLines: 5,
                          minLines: 1,
                          controller: messageToSend,
                          onChanged: (val) {
                            val.trim() != ''
                                ? fieldSendIsFocusFtString.value = true
                                : fieldSendIsFocusFtString.value = false;
                          },
                          autofocus: true,
                          decoration: InputDecoration(
                            suffixIcon: Icon(Icons.face),
                          ),
                        ),
                      ),
                    ),
                    Obx(() => fieldSendIsFocusFtString.value == true
                        ? IconButton(
                            onPressed: () {
                              sendMessage(ctrl);
                            },
                            icon: Icon(Icons.send),
                          )
                        : IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.favorite),
                          ))
                  ],
                ),
              ),
            ));
  }
}
