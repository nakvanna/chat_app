import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pks_mobile/controllers/shared_prefs_controller.dart';
import 'package:pks_mobile/controllers/translation_controller.dart';
import 'package:pks_mobile/helper/constants.dart';
import 'package:pks_mobile/helper/custom_font_style.dart';
import 'package:pks_mobile/routes/app_pages.dart';
import 'package:pks_mobile/widgets/screen_background_color.dart';

class LanguageSettings extends GetView<TranslationController> {
  final CustomFontStyle customFontStyle = CustomFontStyle();
  final List<Map<String, dynamic>> items = [
    {
      'title': 'ភាសាខ្មែរ',
      'secondary': null,
      'langCode': 'kh',
      'countryCode': 'KH',
    },
    {
      'title': 'English',
      'secondary': null,
      'langCode': 'en',
      'countryCode': 'US',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return screenBackgroundColor(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Colors.indigo, Colors.cyan],
      scaffold: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            'language'.tr,
            style: customFontStyle.appBarTitleTextStyle(),
          ),
        ),
        body: ListView.separated(
            itemBuilder: (context, index) {
              return Obx(
                () => CheckboxListTile(
                  value: Constants.language.value == items[index]['title'],
                  onChanged: (value) async {
                    try {
                      await Get.find<SharedPrefs>()
                          .setLanguage(language: items[index]['title']);
                      controller.changeLanguage(items[index]['langCode'],
                          items[index]['countryCode']);
                      if (Get.arguments['fromAuth'] == true) {
                        await Get.offAllNamed(Routes.AUTH);
                      } else {
                        await Get.offAllNamed(Routes.HOME);
                      }
                    } catch (error) {
                      print('Change language error $error');
                    }
                  },
                  secondary: items[index]['secondary'],
                  title: Text(items[index]['title']),
                ),
              );
            },
            separatorBuilder: (_, __) => Divider(height: 0.5),
            itemCount: items.length),
      ),
    );
  }
}
