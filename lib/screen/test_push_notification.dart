import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TestPushNotification extends StatelessWidget {
  final _token = ''.obs;
  final _messageCount = 0.obs;
  final api2Token =
      'elMa6xTbQXOk4kbrhvwYRd:APA91bGv1zgvRY-9KrRsHC6PKtePJwgFLN9Z7H_ag71UcZCV-AhL7BSXzdTbT3S9QGyXU6x-8amptG6b_W9LuiGNE4kv4GKhM55Or9-c3R_v0GynQTJydHmBo9MkZnFaGP9clh0oOLqT';
  final api4Token =
      'cwGUq9FrQSCssv1HcRi7ad:APA91bHqLv2fc7lZIrP_OEP3rZL_VV24cemvT_4-q93X0p07jarniXGA_JE5rxgh8Zsyzo1JgV4GcLQEXUTzB6n9OcEAGWo2nkVpXvHe_abSU_iu1ztGa9qkBCMinzGrV0j_RE_YlOSm';
  final String serverKey =
      'AAAApLip_24:APA91bETNmAoDY6PqoQPN1Nx7SCcvenLchmneiWDC23Vr0cgOQLktoSug_GAHIwr0RPio32R_HfoKKtfVyjFp_lhComURyddPrRJPY366ZGGtnBi2h83cSNVYISFN7CTNtifdxkIeZL9';

  Future<void> sendAndRetrieveMessage(String token) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': "Hello the message specific user",
              'title': 'Flutter push notification'
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done',
              'is_private_message': true
            },
            'to': token,
          },
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Test to push'),
      ),
      body: Center(
        child: Container(
          child: Column(
            children: [
              Obx(() => _token.value == ''
                  ? Text('Waiting token...')
                  : Text(_token.value)),
              RaisedButton(
                  onPressed: () async {
                    _token.value = await FirebaseMessaging.instance.getToken();
                    print(_token.value);
                  },
                  child: Text('Click To Get Token')),
              RaisedButton(
                  onPressed: () async {
                    sendAndRetrieveMessage(api4Token);
                  },
                  child: Text('Click To Send')),
            ],
          ),
        ),
      ),
    );
  }
}
