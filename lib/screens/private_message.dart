import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pks_mobile/controllers/db_controller.dart';
import 'package:pks_mobile/helper/constants.dart';
import 'package:pks_mobile/routes/app_pages.dart';
import 'package:pks_mobile/helper/helper_function.dart';
import 'package:pks_mobile/widgets/screen_background_color.dart';

class PrivateMessage extends GetWidget<DbController> {
  final messageToSend = TextEditingController();
  final String _myEmail = Constants.myEmail.value;
  final String _myPhotoUrl = Constants.myPhotoUrl.value;
  final String _myUID = Constants.myUID.value;
  final String _myUsername = Constants.myUsername.value;
  final String _docId = Get.arguments['docId'];
  final Map<String, dynamic> _partnerInfo = Get.arguments['partnerInfo'];
  final String _partnerDeviceToken = Get.arguments['partnerDeviceToken'];
  final showTimeOnThisIndex = 0.obs;
  final toggleThisIndex = false.obs;
  final fieldSendIsFocusFtString = false.obs;

  sendMessage({DbController ctrl, String type, String message}) async {
    String result = await ctrl.addMessage(docId: _docId, messageMap: {
      'message': message,
      'sentBy': _myUID,
      'isSeen': false,
      'type': type,
      'timestamp': DateTime.now().microsecondsSinceEpoch,
    });

    Map<String, dynamic> _myInfo = {
      "email": _myEmail,
      "photoUrl": _myPhotoUrl,
      "uid": _myUID,
      "username": _myUsername,
    };

    if (result != null) {
      await ctrl.updateRecentlyMessage(docId: _docId, recentlyMapField: {
        'message': messageToSend.text,
        'sentBy': _myUID,
        'sentAt': DateTime.now(),
        'seen': [_myUID],
      });

      fieldSendIsFocusFtString.value = false;
      messageToSend.text = '';

      HelperFunction.sendPushNotificationMessage(
        notificationTitle: _myUsername,
        notificationBody: message,
        notificationData: {
          "docId": _docId,
          "partnerDeviceToken": _partnerDeviceToken,
          "route": Routes.PRIVATE_MESSAGE,
          "myInfo": _myInfo,
        },
      );
    }
  }

  messageOnTab({int index}) {
    showTimeOnThisIndex.value = index;
    toggleThisIndex.value = !toggleThisIndex.value;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DbController>(
        initState: (_) {
          Constants.currentRoute.value = ModalRoute.of(context).settings.name;
        },
        dispose: (_) {},
        builder: (ctrl) => screenBackgroundColor(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.lightBlueAccent, Colors.purple],
              scaffold: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  leading: CircleAvatar(
                    backgroundImage: _partnerInfo['photoUrl'] == ""
                        ? NetworkImage(Constants.accountImageNetwork)
                        : NetworkImage(_partnerInfo['photoUrl']),
                  ),
                  title: Text(_partnerInfo['username']),
                  actions: [
                    IconButton(
                      icon: Icon(Icons.phone),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.videocam),
                      onPressed: () async {
                        messageToSend.text = 'Video Call';
                        await sendMessage(
                            ctrl: ctrl,
                            type: 'video_call',
                            message: messageToSend.text);
                        await Get.toNamed(Routes.MEETING_ROOM, arguments: {
                          'docId': _docId,
                          'myPhotoUrl': _myPhotoUrl,
                          'myUsername': _myUsername,
                          'title': _myUsername,
                          'toDeviceToken': _partnerDeviceToken
                        });
                      },
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
                                        snapshot.data.docs[0]
                                            .data()['sentBy']) {
                                      ctrl.updateSeenInsideMessage(
                                          groupMessageDocId: _docId,
                                          messageDocId:
                                              snapshot.data.docs[0].id);
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
                                              : EdgeInsets.fromLTRB(
                                                  5, 4, 80, 0),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          alignment:
                                              _messageInfo['sentBy'] == _myUID
                                                  ? Alignment.centerRight
                                                  : Alignment.centerLeft,
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                color: _messageInfo['sentBy'] ==
                                                        _myUID
                                                    ? Colors.white54
                                                    : Colors.greenAccent,
                                                borderRadius:
                                                    _messageInfo['sentBy'] ==
                                                            _myUID
                                                        ? BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                              30.0,
                                                            ),
                                                            topRight:
                                                                Radius.circular(
                                                              30.0,
                                                            ),
                                                            bottomLeft:
                                                                Radius.circular(
                                                              30.0,
                                                            ),
                                                            bottomRight:
                                                                Radius.circular(
                                                              0,
                                                            ),
                                                          )
                                                        : BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                              30.0,
                                                            ),
                                                            topRight:
                                                                Radius.circular(
                                                              30.0,
                                                            ),
                                                            bottomLeft:
                                                                Radius.circular(
                                                              0,
                                                            ),
                                                            bottomRight:
                                                                Radius.circular(
                                                              30.0,
                                                            ))),
                                            child: _messageInfo['type'] ==
                                                    'video_call'
                                                ? InkWell(
                                                    onTap: () async {
                                                      await Get.toNamed(
                                                          Routes.MEETING_ROOM,
                                                          arguments: {
                                                            'docId': _docId,
                                                            'myPhotoUrl':
                                                                _myPhotoUrl,
                                                            'myUsername':
                                                                _myUsername,
                                                            'title':
                                                                _myUsername,
                                                            'toDeviceToken':
                                                                _partnerDeviceToken
                                                          });
                                                    },
                                                    child: ListTile(
                                                      leading: Icon(
                                                        Icons.videocam,
                                                        size: 50,
                                                      ),
                                                      title: Text('Video Call'),
                                                      subtitle: Text(
                                                          'Tab to Join ${DateFormat.jm().format(
                                                                DateTime.fromMicrosecondsSinceEpoch(
                                                                    _messageInfo[
                                                                        'timestamp']),
                                                              ).toString()}'),
                                                    ),
                                                  )
                                                : InkWell(
                                                    onTap: () {
                                                      messageOnTab(
                                                          index: index);
                                                    },
                                                    child: Text(
                                                      _messageInfo['message']
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 20),
                                                    ),
                                                  ),
                                          ),
                                        ),
                                        Obx(
                                          () => showTimeOnThisIndex.value ==
                                                      index &&
                                                  toggleThisIndex.value
                                              ? _messageInfo['isSeen']
                                                  ? Text('Seen')
                                                  : Text('Delivered')
                                              : Container(),
                                        ),
                                      ],
                                    );
                                  }))
                              : Container();
                        })
                    : Container(),
                bottomSheet: BottomAppBar(
                  elevation: 0,
                  color: Colors.purple[200],
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: 8.0),
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(10),
                            ),
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
                        Obx(
                          () => fieldSendIsFocusFtString.value == true
                              ? IconButton(
                                  onPressed: () {
                                    sendMessage(
                                        ctrl: ctrl,
                                        type: 'text',
                                        message: messageToSend.text);
                                  },
                                  icon: Icon(Icons.send),
                                )
                              : IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.favorite),
                                ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }
}
