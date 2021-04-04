import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnJitsiError extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      child: Text(Get.arguments.toString()),
    ));
  }
}
