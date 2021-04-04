import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pks_mobile/controllers/auth_controller.dart';
import 'package:pks_mobile/helper/form_validator.dart';
import 'package:pks_mobile/widgets/auth_button.dart';

class LoginForm extends GetWidget<AuthController> {
  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();
  final formValidator = FormValidator();
  final _isSelected = false;

  void _radio() {
    // setState(() {
    //   _isSelected = !_isSelected;
    // });
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

  void signMeIn() {
    // if (formKey.currentState.validate()) {
    //   controller.isLoginLoading.value = true;
    //   controller.login(email.text, password.text);
    // }
  }

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
              Text(
                'Login',
                style: TextStyle(
                    fontSize: ScreenUtil.getInstance().setSp(45),
                    letterSpacing: .6,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: ScreenUtil.getInstance().setHeight(30),
              ),
              Text(
                'Email',
                style: TextStyle(
                  fontSize: ScreenUtil.getInstance().setSp(32),
                ),
              ),
              TextFormField(
                validator: ((email) =>
                    formValidator.emailValidate(email.isEmail)),
                controller: email,
                decoration: InputDecoration(
                    hintText: 'email',
                    hintStyle: TextStyle(fontSize: 14.0, color: Colors.grey)),
              ),
              SizedBox(
                height: ScreenUtil.getInstance().setHeight(30),
              ),
              Text(
                'password',
                style: TextStyle(
                  fontSize: ScreenUtil.getInstance().setSp(32),
                ),
              ),
              TextFormField(
                validator: ((password) =>
                    formValidator.passwordValidate(password)),
                controller: password,
                obscureText: true,
                decoration: InputDecoration(
                    hintText: 'password',
                    hintStyle: TextStyle(fontSize: 14.0, color: Colors.grey)),
              ),
              SizedBox(
                height: ScreenUtil.getInstance().setHeight(35),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    'Forget password?',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: ScreenUtil.getInstance().setSp(28),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: ScreenUtil.getInstance().setHeight(35),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 12.0,
                      ),
                      GestureDetector(
                        onTap: _radio,
                        child: radioButton(_isSelected),
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      Text(
                        'Remember me!',
                        style: TextStyle(
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                  Obx(() => AuthButton(
                        label: 'SIGNIN',
                        loading: controller.isLoginLoading.value,
                        onPressed: signMeIn,
                      ))
                ],
              ),
              SizedBox(
                height: ScreenUtil.getInstance().setHeight(35),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
