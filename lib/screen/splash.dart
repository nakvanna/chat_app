import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends GetWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
