import 'package:flutter/material.dart';
import 'package:pks_mobile/helper/constants.dart';

class CustomFontStyle {
  TextStyle listTileMenuTextStyle() {
    if (Constants.language.value == 'English') {
      return TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.bold,
      );
    } else {
      return TextStyle(
        fontFamily: 'Battambang',
        fontWeight: FontWeight.bold,
      );
    }
  }

  TextStyle appBarTitleTextStyle() {
    if (Constants.language.value == 'English') {
      return TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.bold,
        fontSize: 24.0,
      );
    } else {
      return TextStyle(
        fontFamily: 'Battambang',
        fontWeight: FontWeight.bold,
        fontSize: 22.0,
      );
    }
  }

  TextStyle labelTextStyle() {
    if (Constants.language.value == 'English') {
      return TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.bold,
        fontSize: 16.0,
      );
    } else {
      return TextStyle(
        fontFamily: 'Battambang',
        fontWeight: FontWeight.bold,
        fontSize: 14.0,
      );
    }
  }

  TextStyle btnSignInSignUpTextStyle() {
    if (Constants.language.value == 'English') {
      return TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.bold,
        fontSize: 18.0,
      );
    } else {
      return TextStyle(
        fontFamily: 'Battambang',
        fontWeight: FontWeight.bold,
        fontSize: 16.0,
      );
    }
  }

  TextStyle linkLabelTextStyle() {
    if (Constants.language.value == 'English') {
      return TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.bold,
        fontSize: 16.0,
        color: Colors.blue,
      );
    } else {
      return TextStyle(
        fontFamily: 'Battambang',
        fontWeight: FontWeight.bold,
        fontSize: 14.0,
        color: Colors.blue,
      );
    }
  }

  TextStyle placeHolderTextStyle() {
    if (Constants.language.value == 'English') {
      return TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.bold,
        fontSize: 12.0,
        color: Colors.grey,
      );
    } else {
      return TextStyle(
        fontFamily: 'Battambang',
        fontWeight: FontWeight.bold,
        fontSize: 10.0,
        color: Colors.grey,
      );
    }
  }

  TextStyle cardTitleTextStyle() {
    if (Constants.language.value == 'English') {
      return TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.bold,
        fontSize: 20.0,
      );
    } else {
      return TextStyle(
        fontFamily: 'Battambang',
        fontWeight: FontWeight.bold,
        fontSize: 18.0,
      );
    }
  }
}
