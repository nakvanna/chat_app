import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:pks_mobile/controllers/database_controller.dart';
import 'package:pks_mobile/helper/constants.dart';

class Conversation extends StatefulWidget {
  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  DatabaseController databaseController = DatabaseController();
  TextEditingController messageToSend = TextEditingController();

  var conversationStream = Rx<Stream>();
  var userSnapshot = Rx<QuerySnapshot>();
  var fieldSendIsFocusFtString = false.obs;

  sendMessage() async {
    await databaseController.addConversationMessage(Get.arguments, {
      'message': messageToSend.text,
      'sendBy': Constants.myUID.value,
      'timesteam': DateTime.now().microsecondsSinceEpoch,
    });

    messageToSend.text = '';
  }

  @override
  void initState() {
    conversationStream.value =
        databaseController.getConversationMessages(Get.arguments);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(
              'https://www.kindpng.com/picc/m/24-248394_user-icon-hd-png-download.png'),
        ),
        title: Text(Get.arguments != null
            ? Get.arguments
                .toString()
                .replaceAll("_", "")
                .replaceAll(Constants.myUID.value, "")
            : 'Other user'),
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
      body: Obx(() => conversationStream.value != null
          ? StreamBuilder<QuerySnapshot>(
              stream: conversationStream.value,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                return snapshot.hasData
                    ? ListView.builder(
                        padding: EdgeInsets.only(bottom: 50),
                        reverse: true,
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: ((context, index) {
                          return Container(
                              padding: EdgeInsets.fromLTRB(5, 4, 5, 0),
                              width: MediaQuery.of(context).size.width,
                              alignment:
                                  snapshot.data.docs[index].data()['sendBy'] ==
                                          Constants.myUID.value
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: snapshot.data.docs[index]
                                                .data()['sendBy'] ==
                                            Constants.myUID.value
                                        ? Colors.green
                                        : Colors.greenAccent,
                                    borderRadius: snapshot.data.docs[index]
                                                .data()['sendBy'] ==
                                            Constants.myUID.value
                                        ? BorderRadius.only(
                                            topLeft: Radius.circular(8.0),
                                            topRight: Radius.circular(8.0),
                                            bottomLeft: Radius.circular(8.0),
                                            bottomRight: Radius.circular(0))
                                        : BorderRadius.only(
                                            topLeft: Radius.circular(8.0),
                                            topRight: Radius.circular(8.0),
                                            bottomLeft: Radius.circular(0),
                                            bottomRight: Radius.circular(8.0))),
                                child: Text(
                                  snapshot.data.docs[index]
                                      .data()['message']
                                      .toString(),
                                  style: TextStyle(fontSize: 20),
                                ),
                              ));
                        }))
                    : Container(
                        child: Center(
                          child: Text('Nothing...!'),
                        ),
                      );
              })
          : Container()),
      bottomSheet: BottomAppBar(
        color: Colors.black26,
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white54,
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
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
                      sendMessage();
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
    );
  }
}
