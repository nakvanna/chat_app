import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pks_mobile/controllers/auth_controller.dart';
import 'package:pks_mobile/helper/custom_font_style.dart';
import 'package:pks_mobile/helper/form_validator.dart';
import 'package:pks_mobile/routes/app_pages.dart';
import 'package:pks_mobile/widgets/auth_button.dart';

class SignUpForm extends GetWidget<AuthController> {
  final CustomFontStyle customFontStyle = CustomFontStyle();
  final formValidator = FormValidator();
  final formKey = GlobalKey<FormState>();
  final isLoading = false.obs;
  final username = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final rePassword = TextEditingController();
  final _isSelected = false;
  void _radio() {
    // setState(() {
    //   _isSelected = !_isSelected;
    // });
  }

  void signMeUp() {
    // if (formKey.currentState.validate()) {
    //   isLoading.value = true;
    //   controller.createUser(username.text, email.text, password.text);
    // }
  }

  Widget radioButton(bool isSelected) => Container(
      width: 16.0,
      height: 16.0,
      padding: EdgeInsets.all(2.0),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: 2.0, color: Colors.black)),
      child: isSelected
          ? Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
              ),
            )
          : Container());

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white60,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0.0, 15.0),
              blurRadius: 15.0,
            ),
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0.0, -10.0),
              blurRadius: 10.0,
            )
          ]),
      child: Padding(
        padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'sign-up'.tr,
                    style: customFontStyle.cardTitleTextStyle(),
                  ),
                  IconButton(
                    onPressed: () {
                      Get.toNamed(Routes.LANGUAGES,
                          arguments: {'fromAuth': true});
                    },
                    color: Colors.grey[600],
                    icon: Icon(Icons.settings),
                  ),
                ],
              ),
              SizedBox(
                height: ScreenUtil.getInstance().setHeight(30),
              ),
              Text(
                'username'.tr,
                style: customFontStyle.labelTextStyle(),
              ),
              TextFormField(
                validator: ((username) =>
                    formValidator.usernameValidate(username)),
                controller: username,
                decoration: InputDecoration(
                    hintText: 'username'.tr,
                    hintStyle: customFontStyle.placeHolderTextStyle()),
              ),
              SizedBox(
                height: ScreenUtil.getInstance().setHeight(30),
              ),
              Text(
                'email'.tr,
                style: customFontStyle.labelTextStyle(),
              ),
              TextFormField(
                validator: ((email) =>
                    formValidator.emailValidate(email.isEmail)),
                controller: email,
                decoration: InputDecoration(
                    hintText: 'email'.tr,
                    hintStyle: customFontStyle.placeHolderTextStyle()),
              ),
              SizedBox(
                height: ScreenUtil.getInstance().setHeight(30),
              ),
              Text(
                'password'.tr,
                style: customFontStyle.labelTextStyle(),
              ),
              TextFormField(
                validator: ((password) =>
                    formValidator.passwordValidate(password)),
                controller: password,
                obscureText: true,
                decoration: InputDecoration(
                    hintText: 'password'.tr,
                    hintStyle: customFontStyle.placeHolderTextStyle()),
              ),
              SizedBox(
                height: ScreenUtil.getInstance().setHeight(30),
              ),
              Text(
                're-password'.tr,
                style: customFontStyle.labelTextStyle(),
              ),
              TextFormField(
                validator: ((rePassword) => formValidator.rePasswordValidate(
                    password.text, rePassword)),
                controller: rePassword,
                obscureText: true,
                decoration: InputDecoration(
                    hintText: 're-password'.tr,
                    hintStyle: customFontStyle.placeHolderTextStyle()),
              ),
              SizedBox(
                height: ScreenUtil.getInstance().setHeight(20),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Obx(() => AuthButton(
                      loading: isLoading.value,
                      label: 'signup'.tr,
                      onPressed: signMeUp)),
                ],
              ),
              SizedBox(
                height: ScreenUtil.getInstance().setHeight(20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
