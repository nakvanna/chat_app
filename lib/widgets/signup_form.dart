import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pks_mobile/controllers/auth_controller.dart';
import 'package:pks_mobile/controllers/database_controller.dart';
import 'package:pks_mobile/helper/form_validator.dart';
import 'package:pks_mobile/widgets/auth_button.dart';

class SignUpForm extends GetWidget<AuthController> {
  FormValidator formValidator = FormValidator();
  final formKey = GlobalKey<FormState>();
  var isLoading = false.obs;
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController rePassword = TextEditingController();
  bool _isSelected = false;
  void _radio(){
    // setState(() {
    //   _isSelected = !_isSelected;
    // });
  }
  
  Widget radioButton (bool isSelected) => Container(
      width: 16.0, height: 16.0,
      padding: EdgeInsets.all(2.0),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: 2.0, color: Colors.black)
      ),
      child: isSelected ? Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black,
        ),
      ) : Container()
  );

  void signMeUp(){
    if(formKey.currentState.validate()){
      isLoading.value = true;
      controller.createUser(username.text, email.text, password.text);
    }
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
          ]
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'SIGNUP',
                style: TextStyle(
                    fontSize: ScreenUtil.getInstance().setSp(45),
                    letterSpacing: .6,
                    fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(
                height: ScreenUtil.getInstance().setHeight(30),
              ),
              Text(
                'Username',
                style: TextStyle(fontSize: ScreenUtil.getInstance().setSp(32),),
              ),
              TextFormField(
                validator: ((username) => formValidator.usernameValidate(username)),
                controller: username,
                decoration: InputDecoration(
                    hintText: 'username',
                    hintStyle: TextStyle(fontSize: 14.0, color: Colors.grey)
                ),
              ),
              SizedBox(
                height: ScreenUtil.getInstance().setHeight(30),
              ),
              Text(
                'Email',
                style: TextStyle(fontSize: ScreenUtil.getInstance().setSp(32),),
              ),
              TextFormField(
                validator: ((email) => formValidator.emailValidate(email.isEmail)),
                controller: email,
                decoration: InputDecoration(
                    hintText: 'email',
                    hintStyle: TextStyle(fontSize: 14.0, color: Colors.grey)
                ),
              ),
              SizedBox(
                height: ScreenUtil.getInstance().setHeight(30),
              ),
              Text(
                'password',
                style: TextStyle(fontSize: ScreenUtil.getInstance().setSp(32),),
              ),
              TextFormField(
                validator: ((password) => formValidator.passwordValidate(password)),
                controller: password,
                obscureText: true,
                decoration: InputDecoration(
                    hintText: 'password',
                    hintStyle: TextStyle(fontSize: 14.0, color: Colors.grey)
                ),
              ),
              SizedBox(
                height: ScreenUtil.getInstance().setHeight(30),
              ),
              Text(
                're-password',
                style: TextStyle(fontSize: ScreenUtil.getInstance().setSp(32),),
              ),
              TextFormField(
                validator: ((rePassword) => formValidator.rePasswordValidate(password.text, rePassword)),
                controller: rePassword,
                obscureText: true,
                decoration: InputDecoration(
                    hintText: 're-password',
                    hintStyle: TextStyle(fontSize: 14.0, color: Colors.grey)
                ),
              ),
              SizedBox(
                height: ScreenUtil.getInstance().setHeight(20),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Obx(() =>
                    AuthButton(loading: isLoading.value, label: 'SIGNUP',onPressed: signMeUp)
                  ),
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
