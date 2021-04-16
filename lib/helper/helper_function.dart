import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'constants.dart';
import 'package:http/http.dart' as http;

class HelperFunction {
  static Future<void> sendPushNotificationMessage({
    @required String notificationTitle,
    @required String notificationBody,
    @required Map<String, dynamic> notificationData,
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
            'notification': <String, dynamic>{
              'body': notificationBody,
              'title': notificationTitle
            },
            'priority': 'high',
            'data': notificationData,
            // 'to': myDeviceToken,
            'to': notificationData['partnerDeviceToken'],
          },
        ),
      );
    } catch (e) {
      print(e);
    }
  }
}
